# [imports]-------
import requests
import os


def search(package):
    print(':: Search ' + '\x1b[6;30;42m' + package + '\x1b[0m' + ' on aur...')
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=" + package
    url_json = requests.get(url).json()
    number_of_packages = url_json['resultcount']
    packages = url_json['results']
    if number_of_packages == 0:
        print(":: Package " + package + " not found.")
        return
    else:
        print(":: Found " + str(number_of_packages) + " packages")

    #local_packages = os.system('pacman -Qm')

    count = 0
    option = 1
    while number_of_packages > count:
        name = packages[count]['Name']
        version = packages[count]['Version']
        description = packages[count]['Description']
        print(name, version)
        print(str(option) + '\033[94m' + ' aur/' + name + '\033[0m' + ' ' + version)
        print('   ' + description)
        option += 1
        count += 1
