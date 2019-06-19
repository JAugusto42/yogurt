#!/bin/bash

function main() {
  echo 'Installing yogurt aur helper!'
  git clone https://github.com/JAugusto42/yogurt.git
  cd yogurt
  mkdir -p -v /opt/yogurt/
  cp -r modules /opt/yogurt/
  cp yogurt /opt/yogurt/
  cp README.md /opt/yogurt/
  cp LICENSE /opt/yogurt/

  cd /opt/yogurt/

  ln -s yogurt /usr/bin

  rm -- "$0"
}

main;
