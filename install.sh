#!/bin/bash

function main() {
  echo 'Installing yogurt aur helper!'
  sudo mkdir -p -v /opt/yogurt/
  sudo git clone https://github.com/JAugusto42/yogurt.git /opt/yogurt
  cd /opt/yogurt

  sudo ln -s yogurt /bin

  # this line remove this script =D
  # rm -- "$0"
}

main;
