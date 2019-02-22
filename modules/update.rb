#!/usr/bin/env ruby

module Update
  def update_package(pkg_name)
    base_url = "https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg_name}.tar.gz"
    puts base_url
    puts ":: Update #{pkg_name} from aur..."
    system(`curl -o /tmp/#{pkg_name}.tar.gz #{base_url}`) # TODO: found a simple way to get the pkg with ruby
    Dir.chdir '/tmp/'

    tar_longlink = '././@LongLink'
    tar_gz_archive = "#{pkg_name}.tar.gz"
    destination = '.'
    begin
      Gem::Package::TarReader.new(Zlib::GzipReader.open(tar_gz_archive)) do |tar|
        dest = nil
        tar.each do |entry|
          if entry.full_name == tar_longlink
            dest = File.join destination, entry.read.strip
            next
          end
          dest ||= File.join destination, entry.full_name
          if entry.directory?
            FileUtils.rm_rf dest unless File.directory? dest
            FileUtils.mkdir_p dest, mode: entry.header.mode, verbose: false
          elsif entry.file?
            FileUtils.rm_rf dest unless File.file? dest
            File.open dest, 'wb' do |f|
              f.print entry.read
            end
            FileUtils.chmod entry.header.mode, dest, verbose: false
          elsif entry.header.typeflag == '2'
            File.symlink entry.header.linkname, dest
          end
          dest = nil
        end
      end
    rescue Zlib::GzipFile::Error => error
      puts "#{error.class}: #{error}"
      exit
    end

    File.delete("#{pkg_name}.tar.gz")

    Dir.chdir "/tmp/#{pkg_name}"

    #c= clear, s= sync dependencies, i= install
    system('makepkg -csi')

    Dir.chdir '/tmp/'
    FileUtils.rm_r pkg_name.to_s
  end

  def update
    puts ':: Searching updates on official repositories...'
    system('sudo pacman -Syu')
    puts ':: Searching for aur packages updates...'
    aur_local_pkgs = `pacman -Qm`
    aur_pkg_array = aur_local_pkgs.split("\n")
    aur_pkg_array.each do |pkg_name|
      name_aur_pkg = pkg_name.to_s.split[0] # get name package
      pkg_local_version = pkg_name.to_s.split[1] # get local packages version

      url = "https://aur.archlinux.org/rpc/?v=5&type=info&arg=#{name_aur_pkg}"
      buffer = open(url).read
      obj = JSON.parse(buffer)
      packages_name = obj['results']
      name = packages_name.map { |result| result['Name'] }
      version = packages_name.map { |result| result['Version'] }
      aur_version = version[0]

      if pkg_local_version != aur_version
        puts ":: An update was found for #{name_aur_pkg}"
        puts 'Continue [Yn]?'
        answer = gets.chomp

        answer == 'Y' || answer == 'y' ? update_package(name) : exit
      else
        puts ':: No updates was found for aur repository.'
        exit
      end
    end
  end
end