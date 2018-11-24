#!/usr/bin/env ruby

module Update
  def update
    puts ':: Searching for aur packages updates...'
    aur_pkgs = `sudo pacman -Qm`
    aur_pkg_array = aur_pkgs.split("\n")
    count = 1

    aur_pkg_array.each do |pkg_name|
      name_aur_pkg = "#{pkg_name}".split[0] # get name package
      pkg_local_version = "#{pkg_name}".split[1] # get local packages version

      url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=#{name_aur_pkg}"
      buffer = open(url).read
      obj = JSON.parse(buffer)
      packages_name = obj['results']
      names = packages_name.map { |result| result['Name'] }
      version = packages_name.map { |result| result['Version'] }

      name_and_version = "#{names}-#{version}"
      puts name_and_version
    end
  end
end