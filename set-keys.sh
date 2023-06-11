#!/bin/bash

ENV=$1

# Clear old key info
rm "$HOME/.config/keys/*.keys" 2>/dev/null
rm "$HOME/.config/keys/*.pem" 2>/dev/null

if [[ ! -d "$HOME/.config/keys/$ENV" ]]; then
  echo -e "\nERROR: Unkown key environment $HOME/.config/keys/$ENV, bailing!"
  exit 1
fi

touch "$HOME/.config/keys/${ENV}.keys"
cp "$HOME/.config/keys/${ENV}"/* "$HOME/.config/keys/"
echo "Setting eyaml keys to $ENV"

