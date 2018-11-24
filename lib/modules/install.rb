#!/usr/bin/env ruby

module Install
  def install_pkg
    pkg = ARGV[2].nil? ? ARGV[1] : "#{ARGV[1]}-#{ARGV[2]}"

    editor = 'nano'

    raise 'EDITOR environment variable is not set' if editor.nil?

    base_download_url = "https://aur.archlinux.org/cgit/aur.git/snapshot/#{pkg}.tar.gz"
    # pkgbuild_url = "https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=#{pkg}"

    raise 'Specify the AUR package you want to build\nUsage: archpkg -S [package]' if pkg.nil?

    puts ":: Installing #{pkg} from aur"

    puts `curl -o /tmp/#{pkg}.tar.gz #{base_download_url}`

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

    # puts `rm #{pkg}.tar.gz`
    File.delete("#{pkg}.tar.gz")

    Dir.chdir "/tmp/#{pkg}"

    puts ":: Edit #{pkg} PKGBUILD? [Y/n]"
    system("#{editor} PKGBUILD") unless STDIN.gets.chomp.casecmp('N').zero?
    puts `makepkg -csi`

    Dir.chdir '/tmp/'
    File.delete(pkg.to_s)
    # puts `rm -r #{pkg}`

  end
end