#!/bin/bash

# Define an associative array of commands
declare -A commands=(
  # PostgreSQL
  ["postgres"]="docker run -d -p 5432:5432 --name=postgres --restart=always -v ~/.dckr/postgres:/var/lib/postgresql/data -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres0306 -e POSTGRES_DB=postgres postgres:15"

  # MongoDB
  ["mongodb"]="docker run -d -p 27017:27017 --name=mongodb --restart=always -v ~/.dckr/mongodb:/data/db -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=mongo0306 mongo:6.0"
  
  # Nginx
  ["nginx"]="docker run -d -p 80:80 --name=nginx --restart=always -v ~/.dckr/nginx:/etc/nginx nginx:latest"
  # Add more commands as needed
)

# Display available options
echo "=> Available installations:"
options=()
for key in "${!commands[@]}"; do
  options+=("$key")
done

for i in "${!options[@]}"; do
  echo "$((i + 1)). ${options[$i]}"
done

# Prompt the user for selection
read -p "> Select an option (number): " choice

# Validate the user's choice
if [[ "$choice" -gt 0 && "$choice" -le "${#options[@]}" ]]; then
  selected_option="${options[$((choice - 1))]}"
  selected_command="${commands[$selected_option]}"
  
  echo "=> You selected: $selected_option"
  echo "=> Executing: $selected_command"
  
  # Confirm execution
  read -p "=> Do you want to execute this command? (y/n): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    eval "$selected_command"
  else
    echo "=> Command execution canceled."
  fi
else
  echo "> Invalid choice!"
  exit 1
fi
