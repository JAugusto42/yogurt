#!/usr/bin/env ruby

require 'open-uri'
require 'json'

##[TODOS]#################
# usar variáveis globais, principalmente a url
# refatorar

class Main
  def initialize
    puts 'arch pkg'
    input = ARGV

    case ARGV[0]
    when '-S'
      install_pkg

    when '-Ss'
      search

    else
      puts input.class
      puts 'Invalid Input! Try again...'
    end
  end

  def install_pkg
    package = ARGV[1]
    puts 'Installing package'
    puts "Installing package #{package}"
  end

  def search
    pkg = ARGV[1]
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=#{pkg}"
    buffer = open(url).read
    obj = JSON.parse(buffer)
    puts ":: Found #{obj['resultcount']} packages"
    puts ":: Seaching #{pkg} on aur..."

  end
end

main = Main.new
