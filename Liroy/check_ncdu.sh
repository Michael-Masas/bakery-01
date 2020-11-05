#!/usr/bin/env bash

which ncdu &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "ncdu is installed. Goodbye"
  exit 0
fi

read -p "ncdu is not installed on your machine. Would you like to install it? [y/n]" user_answer
if [[ $user_answer == "y" ]]; then
  echo "Installing ncdu..."
  yum install -y ncdu && echo "ncdu installed successfully. Goodbye!"
elif [[ $user_answer == "n" ]]; then
  echo "Goodbye"
else
  echo "Invalid answer was given. Exiting..."
fi

