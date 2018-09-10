#!/usr/bin/env ruby

require 'open-uri'
require 'json'

# #[TODOS]#################
# funcionar depois refatorar
# associar o package com o numero para q, em vez de passar o numero, passe o pacote correspondente.
# Usar variaveis globais
# Colocar variavel de ambiente do editor de texto para editar o pkgbuild
# Adicionar mais extenções como .deb .zip para baixar um pacote e ele tera que verificar
# um por um analisando a resposta 200 da url e baixar =D

class Main
  def initialize
    raise 'Requires ruby >= 2.4.0' if RUBY_VERSION < '2.4.0' # temp

    case ARGV[0]
    when '-S'
      install_pkg

    when '-Ss'
      search

    when '-h'
      help

    when '--help'
      help

    else
      puts 'Invalid Input! Try again...'
    end
  end

  def install_pkg()

    pkg = ARGV[1]
    editor = ENV['EDITOR']

    raise "EDITOR environment variable is not set" if editor.nil?

    download_dir = '/tmp/'
    base_download_url = "https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg}.tar.gz"
    pkgbuild_url = "https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=#{pkg}"

    raise 'Specify the AUR package you want to build\nUsage: archpkg -S [package]' if pkg.nil?

    puts ":: Installing #{pkg} from aur"
    #TODO tratar tudo isso abaixo com ruby
    puts `curl -o /tmp/#{pkg}.tar.gz #{base_download_url}`

    Dir.chdir '/tmp/'

    puts `tar zxvf #{pkg}.tar.gz`
    puts `rm #{pkg}.tar.gz`

    Dir.chdir "/tmp/#{pkg}"

    puts ":: Edit #{pkg} PKGBUILD? [Y/n]"
    system("#{editor} PKGBUILD") unless STDIN.gets.chomp.upcase == 'N'
    puts `makepkg -csi && rm -r #{pkg}`


  end

  def search
    pacman_local_dir = '/var/lib/pacman/local/' # to read all packges installed
    packages_local = Dir.children(pacman_local_dir) # get only packages names

    pkg = ARGV[1]

    puts ":: Seaching #{pkg} on aur..."
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=#{pkg}"
    buffer = open(url).read
    obj = JSON.parse(buffer)
    packages = obj['resultcount']
    packages_name = obj['results']

    names = packages_name.map { |result| result['Name'] }
    version = packages_name.map { |result| result['Version'] }
    description = packages_name.map { |result| result['Description'] }

    puts ":: Found #{packages} packages"
    count = 1
    exit unless packages > 0
    while count < packages
      name_and_version = "#{names[count]}-#{version[count]}"
      check = print("\e[1;34mInstalled\e[0m ") if packages_local.include?(name_and_version)
      puts ":: \e[1;32m#{count}\e[0m aur/#{names[count]} \e[0;32m#{version[count]}\e[0m #{check}"
      puts "  #{description[count]}"
      count += 1
    end
    # range = (0..count).to_a
    # input_packages = STDIN.gets.chomp.to_i
    # install_pkg(input_packages) if range.include?(input_packages)
  end

  def help
    puts <<-HEREDOC

  Usage:
    -Ss <package>   Find a package
    -S  <package>   Install a package ( IN DEVELOPMENT )
    HEREDOC
  end
end

main = Main.new
