# frozen_string_literal: true

require 'fileutils'
require 'open-uri'
require 'socket'
require_relative 'package_extractor'

# module do install packages
module Install
  include PackageExtractor
  def install_pkg
    if ARGV[1].nil?
      puts 'You have to specify a package from aur repository. Usage: yogurt -S package'
      exit
    elsif ARGV[2]
      puts 'You must specify the exact name of the package, use yogurt -Ss [package] or yogurt package name'
      exit
    else
      pkg = ARGV[1]
    end

    editor = 'vim' # TODO: ask for what editor want to use.

    raise 'EDITOR environment variable is not set' if editor.nil?

    begin
      download = URI.open("https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg}.tar.gz")
      IO.copy_stream(download, "/tmp/#{pkg}.tar.gz")
      puts ":: Installing #{pkg} from aur"
    rescue SocketError
      puts "\n:: Check your internet Connection\n"
      exit
    rescue StandardError
      puts 'Package not found'
      exit
    end

    extractor(pkg) # module PackageExtractor

    print ":: Edit #{pkg} PKGBUILD? [Y/n]"
    system("#{editor} PKGBUILD") unless $stdin.gets.chomp.casecmp('N').zero?
    system('makepkg -csi')

    Dir.chdir '/tmp/'
    FileUtils.rm_r pkg.to_s
  end
end
