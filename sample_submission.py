import csv
import os
import datetime

# Example CSV output
submission_file = "submission.csv"

# Simulate some results
data = [
    {"id": 1, "prediction": 0.9},
    {"id": 2, "prediction": 0.1},
    {"id": 3, "prediction": 0.5},
]

# Write CSV
with open(submission_file, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["id", "prediction"])
    writer.writeheader()
    writer.writerows(data)

print("Submission created:", submission_file)

# Simulate log info
print("Batch ID: 14244901")
print("Submission timestamp:", datetime.datetime.now())
