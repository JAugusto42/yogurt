#!/usr/bin/env ruby

require 'open-uri'
require 'json'

# #[TODOS]#################
# funcionar depois refatorar
# associar o package com o numero para q, em vez de passar o numero, passe o pacote correspondente.


class Main
  def initialize
    puts 'arch pkg'
    input = ARGV

    case ARGV[0]
    when '-S'
      install_pkg

    when '-Ss'
      search

    when '-h'
      help

    else
      puts input.class
      puts 'Invalid Input! Try again...'
    end
  end

  def install_pkg(packages)
    # TODO
  end

  def search
    pkg = ARGV[1]
    puts ":: Seaching #{pkg} on aur..."
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=#{pkg}"
    buffer = open(url).read
    obj = JSON.parse(buffer)
    packages = obj['resultcount']
    names = obj['results'].map { |result| result['Name'] }
    version = obj['results'].map { |result| result['Version'] }
    puts ":: Found #{packages} packages"
    count = 0
    while count < packages
      puts ":: aur/ #{count} #{names[count]} -> #{version[count]}"
      count += 1
    end
    range = (0..count).to_a
    input_packages = STDIN.gets.chomp.to_i

    install_pkg(input_packages) if range.include?(input_packages)
  end

  def help
    puts <<-HEREDOC

  Usage:
    -Ss <package>   Find a package
    -S  <package>   Install a package
    HEREDOC
  end
end

main = Main.new
