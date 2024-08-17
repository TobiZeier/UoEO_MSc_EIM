#Tobias Zeier - 16/06/2024 - 12696372

import time

from typing import List


def timsort(arr: List[int]):
    arr.sort()


def main(input_file: str, sorted_file: str):
    # Read values from the input file
    with open(input_file, 'r') as file:
        values = file.read().split()

    values = [int(value) for value in values]

    # Sort the values using Timsort algorithm
    start_time = time.time()
    timsort(values)
    end_time = time.time()

    # Write the sorted values to the output file
    with open(sorted_file, 'w') as f:
        for value in values:
            f.write(str(value) + '\n')

    # Calculate and print the execution time
    print("Execution time: {:.4f} seconds".format(end_time - start_time))


def addname(output_file: str):
    # Define students name and ID
    names = 'TobiasZeier'
    name = 'Tobias Zeier'
    studentid = '12696372'
    counter = 1

    with open(sorted_file, 'r') as f_in, open(output_file, 'w') as f_out:
        # Write students name and ID as a header of the file
        f_out.write('{0}\n{1}\n\n'.format(name, studentid))

        for i, line in enumerate(f_in):
            # Write the students name in the format of JohnDoe01 on every 80.000th line
            f_out.write(line)
            if (i + 1) % 80000 == 0:
                f_out.write(f"{names}{str(counter).zfill(2)}\n")
                counter += 1

# Define paths for input, sorted and output file
if __name__ == "__main__":
    input_file = "/Users/tobiaszeier/Downloads/pidata.txt"
    sorted_file = "/Users/tobiaszeier/Downloads/timsort.txt"
    output_file = "/Users/tobiaszeier/Downloads/TobiasZeier-16-6-24.txt"
    # Run the functions
    main(input_file, sorted_file)
    addname(output_file)
