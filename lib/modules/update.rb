#!/usr/bin/env ruby

module Update
  def update_package(pkg_name)
    base_url = "https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg_name}"
    puts ":: Update #{pkg} from aur..."
    system(`curl -o /tmp/#{pkg}.tar.gz #{base_url}`) # TODO get package with ruby, not curl
    Dir.chdir '/tmp/'

    tar_longlink = '././@LongLink'
    tar_gz_archive = "#{pkg}.tar.gz"
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

    File.delete("#{pkg}.tar.gz")

    Dir.chdir "/tmp/#{pkg}"

    system('makepkg -csi')

    Dir.chdir '/tmp/'
    FileUtils.rm_r pkg.to_s
  end

  def update
    puts ':: Searching updates on official repositories...'
    system('sudo pacman -Syyu')
    puts ':: Searching for aur packages updates...'
    aur_pkgs = `sudo pacman -Qm`
    aur_pkg_array = aur_pkgs.split("\n")
    puts aur_pkg_array
    aur_pkg_array.each do |pkg_name|
      name_aur_pkg = "#{pkg_name}".split[0] # get name package
      pkg_local_version = "#{pkg_name}".split[1] # get local packages version

      url = "https://aur.archlinux.org/rpc/?v=5&type=info&arg=#{name_aur_pkg}"
      buffer = open(url).read
      obj = JSON.parse(buffer)
      packages_name = obj['results']
      name = packages_name.map { |result| result['Name'] }
      version = packages_name.map { |result| result['Version'] }
      #name_and_version = "#{name} #{version}"
      #puts name_and_version
      #puts pkg_local_version

      if version != pkg_local_version
        pkg_update = "#{name}-#{version}"
        puts ":: An update was found for #{pkg_update}"
        # update_package(aur_pkg_array)
      end
    end
  end
end