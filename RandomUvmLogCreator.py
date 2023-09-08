# I made this with ChatGPT
import random

# Define possible message types and keywords
message_weights = {
    "UVM_INFO": 0.7,   # Higher weight for UVM_INFO
    "UVM_ERROR": 0.15,
    "UVM_WARNING": 0.1,
}

keywords = ["foo", "bar", "baz", "qux", "quux", "corge", "grault", "garply", "waldo", "fred", "plugh", "xyzzy", "thud"]

# Initialize variables for simulation time and line number
simulation_time = 0
line_number = 1

# Specify the number of log lines you want to generate (between 70 and 100)
num_lines = random.randint(70, 100)

# Randomly determine if UVM_FATAL will be in the file
include_fatal = random.choice([True, False])

# Open a log file for writing
with open("uvm_log.txt", "w") as log_file:
    for _ in range(num_lines):
        # Randomly select message type based on weights
        message_type = random.choices(list(message_weights.keys()), weights=list(message_weights.values()))[0]
        
        # Generate a random hierarchy with keywords separated by dots
        hierarchy_length = random.randint(1, len(keywords))
        hierarchy_keywords = random.sample(keywords, hierarchy_length)
        hierarchy = '.'.join(hierarchy_keywords)

        path = "/".join(random.sample(keywords, random.randint(1, len(keywords) - 1))) + ".svh"
        id = random.choice(keywords)
        
        # Generate a random message by joining keywords with spaces
        message_length = random.randint(3, 13)  # Adjusted the length to (3, 13)
        message_keywords = random.sample(keywords, message_length)
        message = ' '.join(message_keywords)

        # If UVM_FATAL is included, ensure it's the last line
        if include_fatal and _ == num_lines - 1:
            message_type = "UVM_FATAL"

        # Generate a random simulation time (natural number) greater than the previous line
        simulation_time += random.randint(1, 10)

        # Write the log entry to the file
        log_entry = f"{message_type} /{path}({line_number}) @ {simulation_time} us: uvm_test_top.{hierarchy} [{id}] {message}\n"
        log_file.write(log_entry)

        # Print the log entry to the console
        print(log_entry.strip())

        # Increment the line number
        line_number += 1
