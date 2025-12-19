# Use the official Python image as the base image
FROM tomjfrog.jfrog.io/imagelifecycle-docker/python:3-alpine

# Copy the Python script to the container
COPY script.py .

# Run the script when the container starts
CMD ["python", "script.py"]
