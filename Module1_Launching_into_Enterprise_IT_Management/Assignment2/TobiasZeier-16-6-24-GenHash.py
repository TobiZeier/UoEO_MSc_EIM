#Tobias Zeier - 16/06/2024 - 12696372

import hashlib


def sha3_hash_file(filename):
    sha3 = hashlib.sha3_256()
    with open(filename, "rb") as f:
        while True:
            data = f.read(65536)  # Read data in chunks
            if not data:
                break
            sha3.update(data)

    return sha3.hexdigest()


# Example usage
filename = "/Users/tobiaszeier/Downloads/pidata.txt"
sha3_hash = sha3_hash_file(filename)
print(f"SHA-3 hash of {filename}: {sha3_hash}")
