FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip && \
    apt-get clean

# Copy requirements file and install dependencies
COPY requirements.txt /app
RUN pip3 install --no-cache-dir -r requirements.txt
# Copy application source code
COPY devops /app

# FROM gcr.io/distroless/python3

# # Set working directory
# WORKDIR /app

# # Copy application and dependencies from the build stage
# COPY --from=build /usr/local/lib/python3.10/dist-packages /usr/local/lib/python3.10/dist-packages
# COPY --from=build /app /app
# #set python path
# ENV PYTHONPATH=/app

# Set the entry point to Python
ENTRYPOINT ["python3"]

# Default command to start the application
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
