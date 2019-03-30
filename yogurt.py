#!/usr/bin/env python

# [imports]----------
import sys
import os

# [local files]------
from modules import install
from modules import search
# from modules import update
# from modules import help


class Main:
    def __init__(self):
        if sys.argv[1:]:
            package = sys.argv[1]
            if package[0] != '-':
                search.search(sys.argv[1])
            else:
                if sys.argv[1] == '-S':
                    if sys.argv[2:]:
                        install.install(sys.argv[2])
                    else:
                        print("You have to specify a package")
                elif sys.argv[1] == '-Ss':
                    if sys.argv[2:]:
                        search.search(sys.argv[2])
                    else:
                        print("You have to specify a package")
                elif sys.argv[1] == '-U':
                    update.update()
                elif sys.argv[1] == '-h' or sys.argv[1] == '--help':
                    help.help()
                else:
                    print('invalid argument:', sys.argv[1])
        else:
            os.system('sudo pacman -Syu')


main = Main()