#!/bin/bash

function main() {
  echo 'Installing yogurt aur helper!'
  # TODO verify if already exists and removes...

  sudo mkdir -p -v /opt/yogurt/
  sudo git clone https://github.com/JAugusto42/yogurt.git /opt/yogurt
  cd /opt/yogurt

  sudo ln -s $PWD/yogurt /bin

  # this line remove this script =D
  # rm -- "$0"
}

main;
