#!/bin/bash

# Function to check for errors after each command
function check_error {
  if [ $? -ne 0 ]; then
    echo -e "\033[1;31m[ERROR]\033[0m An error occurred while executing: $1"
    exit 1
  fi
}

# Directory configuration
REPO_DIR="/home/pedro/Games/rocket-league/drive_c/Program Files/Epic Games/rocketleague/TAGame/CookedPCConsole/mods/synchronized/"

if [ -z "$REPO_DIR" ]; then
  echo -e "\033[1;31m[ERROR]\033[0m The REPO_DIR variable is not set. Please set the repository path."
  exit 1
fi

if [ ! -d "$REPO_DIR" ]; then
  echo -e "\033[1;31m[ERROR]\033[0m The directory $REPO_DIR does not exist. Please check the path."
  exit 1
fi

# Verify if Git is installed
if ! command -v git &> /dev/null; then
  echo -e "\033[1;31m[ERROR]\033[0m Git is not installed or not in PATH."
  exit 1
fi

# Verify if Git LFS is installed
if ! command -v git-lfs &> /dev/null; then
  echo -e "\033[1;33m[INFO]\033[0m Git LFS is not installed. Installing Git LFS..."
  git lfs install
  check_error "git lfs install"
  echo -e "\033[1;32m[SUCCESS]\033[0m Git LFS installed successfully."
else
  echo -e "\033[1;32m[INFO]\033[0m Git LFS is already installed."
fi

# Navigate to the repository directory
cd "$REPO_DIR" || {
  echo -e "\033[1;31m[ERROR]\033[0m Failed to access directory: $REPO_DIR"
  exit 1
}

# Set up Git LFS to track large files
echo -e "\033[1;33m[INFO]\033[0m Configuring Git LFS to track large files..."
for ext in bin psd png jpg mp4 zip upk; do
  git lfs track "*.${ext}"
done
check_error "git lfs track"

echo -e "\033[1;32m[SUCCESS]\033[0m Git LFS setup completed successfully!"

# Display menu to user
while true; do
  echo -e "\033[1;34m===================================\033[0m"
  echo -e "\033[1;34m     GIT REPOSITORY MANAGEMENT     \033[0m"
  echo -e "\033[1;34m===================================\033[0m"
  echo "1. Upload: git add ., git commit -m \"message\", git push"
  echo "2. Download: git pull"
  echo "3. Exit"
  read -p "Choose an option (1, 2, 3): " choice

  case $choice in
    1)
      echo -e "\033[1;33m[INFO]\033[0m Uploading changes..."
      git add .
      check_error "git add ."

      read -p "Enter commit message: " commit_msg
      git commit -m "$commit_msg"
      check_error "git commit -m \"$commit_msg\""

      git push
      check_error "git push"

      echo -e "\033[1;32m[SUCCESS]\033[0m Upload completed successfully!"
      ;;
    2)
      echo -e "\033[1;33m[INFO]\033[0m Downloading updates..."
      git pull
      check_error "git pull"

      echo -e "\033[1;32m[SUCCESS]\033[0m Download completed successfully!"
      ;;
    3)
      echo -e "\033[1;34m[INFO]\033[0m Exiting script. Goodbye! :)"
      exit 0
      ;;
    *)
      echo -e "\033[1;33m[WARNING]\033[0m Invalid option. Please try again."
      ;;
  esac
done
