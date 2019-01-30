# [imports]-------
import requests
import json


def search(package):
    print(":: Search " + package + " on aur...")
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=" + package
    url_json = requests.get(url).json()
    number_of_packages = url_json['resultcount']
    packages = url_json['results']
    if number_of_packages == 0:
        print(":: Package " + package + " not found.")
    else:
        print(":: Found " + str(number_of_packages) + " packages")
        count = 0
        option = 1
        while number_of_packages > count:
            name = packages[count]['Name']
            version = packages[count]['Version']
            description = packages[count]['Description']
            print(str(option) + ' ' + name + ' ' + version)
            print('   ' + description)
            option += 1
            count += 1
