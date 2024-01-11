# frozen_string_literal: true

require_relative 'package_extractor'

# module to upate packages
module Update
  include PackageExtractor
  def update_package(pkg_name)
    puts ":: Update #{pkg_name} from aur..."
    download = URI.open("https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg_name}.tar.gz")
    IO.copy_stream(download, "/tmp/#{pkg}.tar.gz")

    extractor(pkg) # module PackageExtractor

    system('makepkg -csi')

    Dir.chdir '/tmp/'
    FileUtils.rm_r pkg_name.to_s
  end

  def update
    puts ':: Searching updates on official repositories...'
    system('sudo pacman -Syu')
    puts ':: Searching for aur packages updates...'
    aur_pkgs = `pacman -Qm`
    aur_pkg_array = aur_pkgs.split("\n")
    aur_pkg_array.each do |pkg_name|
      name_aur_pkg = pkg_name.to_s.split[0] # get name package
      pkg_local_version = pkg_name.to_s.split[1] # get local packages version

      begin
        url = "https://aur.archlinux.org/rpc/?v=5&type=info&arg=#{name_aur_pkg}"
        buffer = URI.open(url).read
        obj = JSON.parse(buffer)
        packages_name = obj['results']
        version = packages_name.map { |result| result['Version'] }
      rescue SocketError, Net::OpenTimeout
        puts "\n:: Check your internet connection\n"
        exit
      end

      if version[0].nil?
        puts ":: Not found in repositorie #{name_aur_pkg}"
      elsif version[0].to_s > pkg_local_version.to_s
        puts ":: An update was found for #{name_aur_pkg}"
        puts ':: Do the update? [Y/n]'
        update_package(name_aur_pkg) if $stdin.gets.chomp.casecmp('Y').zero?
      else
        puts ' there is nothing to do'
        exit
      end
    end
    puts ':: No updates was found'
  end
end
