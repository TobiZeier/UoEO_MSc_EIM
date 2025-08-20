#!/bin/bash

# ==============================================================================
# This script automates the creation of a private cloud environment, including:
# 1. Network setup (public and private networks, router)
# 2. Security group rules (allowing SSH and ICMP traffic)
# 3. Keypair creation for SSH access
# 4. Instance provisioning using a cloud image
# Key features:
# - All commands are idempotent and can be re-run safely.
# - Efficiently waits for instance readiness using a manual polling loop.
# - Reuses existing floating IPs to conserve resources by parsing JSON with jq.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Change these variables to customize your setup.
INSTANCE_NAME="lab-ubuntu-instance"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_NAME="Ubuntu-22.04"
FLAVOR_NAME="m1.small"
KEY_NAME="lab-microstack-key"
PRIVATE_NETWORK_NAME="private-network"
PRIVATE_SUBNET_NAME="private-subnet"
PRIVATE_SUBNET_CIDR="192.168.100.0/24"
ROUTER_NAME="private-router"
SECURITY_GROUP_NAME="lab-sec-group"

echo "================================================="
echo "Starting MicroStack Cloud Provisioning"
echo "================================================="

# --- Pre-flight check: Verify microstack.openstack and jq commands are available ---
if ! command -v microstack.openstack &> /dev/null || ! command -v jq &> /dev/null; then
    echo "Error: 'microstack.openstack' or 'jq' command not found." >&2
    echo "Please ensure MicroStack is correctly installed and jq is installed (sudo apt-get install jq)." >&2
    exit 1
fi

# --- 1. Keypair Creation ---
echo "1. Creating or showing keypair for SSH access..."
# Use '--or-show' to create the keypair only if it doesn't exist, and save the private key.
microstack.openstack keypair show "$KEY_NAME" > /dev/null 2>&1 || microstack.openstack keypair create "$KEY_NAME" > "$KEY_NAME.pem"
chmod 600 "$KEY_NAME.pem"
echo "  - Keypair '$KEY_NAME' is ready. Private key is at $KEY_NAME.pem"

# --- 2. Network and Router Setup ---
echo "2. Setting up network and router..."
# Create network, subnet, and router if they don't exist.
microstack.openstack network create "$PRIVATE_NETWORK_NAME" || true
echo "  - Private network '$PRIVATE_NETWORK_NAME' is ready."

microstack.openstack subnet create \
  --network "$PRIVATE_NETWORK_NAME" \
  --subnet-range "$PRIVATE_SUBNET_CIDR" \
  "$PRIVATE_SUBNET_NAME" || true
echo "  - Private subnet '$PRIVATE_SUBNET_NAME' is ready."

microstack.openstack router create "$ROUTER_NAME" || true
echo "  - Router '$ROUTER_NAME' is ready."

# Add subnet to router if not already added
microstack.openstack router show "$ROUTER_NAME" -f json | grep "$PRIVATE_SUBNET_NAME" > /dev/null || \
  microstack.openstack router add subnet "$ROUTER_NAME" "$PRIVATE_SUBNET_NAME"
echo "  - Subnet '$PRIVATE_SUBNET_NAME' added to router."

# Connect router to the external public network (ext-net is MicroStack default)
microstack.openstack router set "$ROUTER_NAME" --external-gateway ext-net || true
echo "  - Router connected to external network."

# --- 3. Security Group Configuration ---
echo "3. Configuring security group rules..."
# Create security group if it doesn't exist.
microstack.openstack security group create "$SECURITY_GROUP_NAME" || true
echo "  - Security group '$SECURITY_GROUP_NAME' is ready."

# Add rules for SSH and ICMP (ping) traffic, ignoring duplicates.
# The security group name is the final positional argument.
microstack.openstack security group rule create \
  --proto tcp "$SECURITY_GROUP_NAME" || true
microstack.openstack security group rule create \
  --proto icmp "$SECURITY_GROUP_NAME" || true
echo "  - Added SSH and ICMP rules to the security group."

# --- 4. Image Upload ---
echo "4. Uploading cloud image if it doesn't exist..."
if ! microstack.openstack image show "$IMAGE_NAME" > /dev/null 2>&1; then
  # The --progress flag was removed as it is not supported by the command.
  curl -L "$IMAGE_URL" | microstack.openstack image create \
    --container-format bare \
    --disk-format qcow2 \
    --public \
    "$IMAGE_NAME"
  echo "  - Image '$IMAGE_NAME' uploaded successfully."
else
  echo "  - Image '$IMAGE_NAME' already exists. Skipping upload."
fi

# --- 5. Instance Provisioning ---
echo "5. Launching a new instance..."
if ! microstack.openstack server show "$INSTANCE_NAME" > /dev/null 2>&1; then
  microstack.openstack server create \
    --flavor "$FLAVOR_NAME" \
    --image "$IMAGE_NAME" \
    --network "$PRIVATE_NETWORK_NAME" \
    --security-group "$SECURITY_GROUP_NAME" \
    --key-name "$KEY_NAME" \
    "$INSTANCE_NAME"
  echo "  - Instance '$INSTANCE_NAME' is being created..."
else
  echo "  - Instance '$INSTANCE_NAME' already exists. Skipping creation."
fi

# --- 6. Manual wait for the instance to become active ---
echo "6. Waiting for instance '$INSTANCE_NAME' to reach ACTIVE status..."
MAX_RETRIES=60
SLEEP_TIME=5
RETRY_COUNT=0

while [[ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]]; do
  STATUS=$(microstack.openstack server show "$INSTANCE_NAME" -f value -c status)
  if [[ "$STATUS" == "ACTIVE" ]]; then
    echo "  - Instance is now active!"
    break
  fi
  echo "  - Current status: $STATUS. Retrying in $SLEEP_TIME seconds..."
  sleep "$SLEEP_TIME"
  RETRY_COUNT=$((RETRY_COUNT + 1))
done

if [[ "$STATUS" != "ACTIVE" ]]; then
  echo "Error: Instance did not become active within the timeout period." >&2
  exit 1
fi

# --- 7. Floating IP Assignment (Corrected with jq) ---
echo "7. Assigning a floating IP..."
# Get a list of all unassigned floating IPs in JSON format
UNASSIGNED_IPS=$(microstack.openstack floating ip list --status DOWN -f json)

# Use jq to extract the first unassigned IP address.
FLOATING_IP=$(echo "$UNASSIGNED_IPS" | jq -r '.[0]."Floating IP Address"')

# If no floating IP is available, create a new one
if [ -z "$FLOATING_IP" ]; then
  echo "  - No unassigned floating IP found. Creating a new one..."
  FLOATING_IP=$(microstack.openstack floating ip create ext-net -f value -c floating_ip_address)
else
  echo "  - Reusing existing floating IP: $FLOATING_IP"
fi

# Associate the floating IP with the instance
microstack.openstack server add floating ip "$INSTANCE_NAME" "$FLOATING_IP" || true
echo "  - Floating IP '$FLOATING_IP' assigned to the instance."

echo "================================================="
echo "Provisioning complete! You can now SSH to your instance:"
echo "ssh -i $KEY_NAME.pem ubuntu@$FLOATING_IP"
echo "================================================="


