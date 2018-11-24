#!/usr/bin/env ruby

module Search
  def search
    packages_local = Dir.children('/var/lib/pacman/local') # get only packages names

    # Verifica se ARGV[2] existe
    pkg = ARGV[2].nil? ? ARGV[1] : "#{ARGV[1]}-#{ARGV[2]}"

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
    puts
    count = 0
    exit unless packages > count
    while count < packages
      name_and_version = "#{names[count]}-#{version[count]}"
      check = printf("\e[1;34mInstalled\e[0m ") if packages_local.include?(name_and_version)
      puts ":: \e[1;32m#{count}\e[0m aur/#{names[count]} \e[0;32m#{version[count]}\e[0m #{check}"
      puts "  #{description[count]}"
      count += 1
    end
    # range = (0..count).to_a
    # input_packages = STDIN.gets.chomp.to_i
    # install_pkg(input_packages) if range.include?(input_packages)
  end
end