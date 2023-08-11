FROM ubuntu:20.04

# Set ARG variables (can be overridden during build)
ARG user_name="admin"
ARG app_version="1.0"

# Set ENV variables
ENV USER_NAME=$user_name
ENV APP_VERSION=$app_version

#working directory
WORKDIR /app

#Installing some packages
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

#Copy a file into the app dir
COPY soalb.txt .

# Display information about the environment
RUN echo "User: $USER_NAME"
RUN echo "App Version: $APP_VERSION"
RUN echo "Contents of working directory:"
RUN ls -la

# Run a command when the container starts
CMD ["echo", "Container is running."]
