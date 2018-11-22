module Help
  def help
    puts <<-HEREDOC
  YAAH! Yet Another Aur Helper.
  Usage:
    -Ss <package>   Find a package
    -S  <package>   Install a package ( IN TESTING )
    HEREDOC
  end
end