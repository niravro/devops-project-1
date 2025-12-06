# Multi-Stage Dockerfile
# Stage 1 : Build Stage
FROM python:3.14-slim as base

WORKDIR /app

COPY src/ /app

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN rm requirements.txt

# Stage 2 : Application Stage
FROM python:3.14-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=base /usr/local/lib/python3.14/site-packages /usr/local/lib/python3.14/site-packages
COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=base /app /app

EXPOSE 8080

CMD [ "python3", "main.py" ]

## Single Stage Dockerfile

# # Use an official Python runtime as a parent image
# FROM python:3.14-slim

# # Set the working directory to /app
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY src/ /app

# # Install any needed packages specified in requirements.txt
# RUN pip install -r requirements.txt

# # Make port 5000 available to the world outside this container
# EXPOSE 8080

# # Define environment variable
# ENV FLASK_APP=app.py

# # Run app.py when the container launches
# CMD [ "python", "main.py" ]