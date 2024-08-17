#Tobias Zeier - 16/06/2024 - 12696372

import time

def sort_values_from_file(file_path):
    # Read values from text file
    with open(file_path, 'r') as file:
        values = file.read().split()

    # Convert values to integers
    values = [int(value) for value in values]

    # Sort values in ascending order
    sorted_values = sorted(values)

    return sorted_values

# Specify the file path
file_path = '/Users/tobiaszeier/Downloads/pidata.txt'

#  Start timer
start_time = time.time()

# Sort values from the file
sorted_values = sort_values_from_file(file_path)

# Write sorted values to output file
output_file = '/Users/tobiaszeier/Downloads/pythonsort.txt'
with open(output_file, 'w') as file:
    for value in sorted_values:
        file.write(f'{value}\n')

# End timer
end_time = time.time()

# Determine execution time
execution_time = end_time - start_time

print(f"Execution time: {execution_time:.4f} seconds.")