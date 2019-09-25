module Help
  def help
      puts <<-HEREDOC
Usage:
    yogurt
    yogurt <operation> [...]
    yogurt <package>

operations:
    yogurt {-h --help}
    yogurt {-V --version}
    yogurt {-S --sync}        [package(s)]
    yogurt {-U --upgrade}

If no arguments are provided 'yogurt -Syu' will be performed.
HEREDOC
  end
end
