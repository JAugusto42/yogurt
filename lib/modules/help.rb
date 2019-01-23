module Help
  def help
    puts <<-HEREDOC
  YOUGURT! An simple aur helper for arch linux.
  Usage:
    -Ss <package>   Find a package
    -S  <package>   Install a package
    HEREDOC
  end
end