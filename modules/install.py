# [imports]------------
import os
import requests
import tarfile


def install(package):
    url_package = "https://aur.archlinux.org/cgit/aur.git/snapshot/{}.tar.gz".format(package)
    try:
        os.mkdir('/tmp/yogurt')
    except FileExistsError:
        os.chdir('/tmp/yogurt')
    else:
        os.chdir('/tmp/yogurt')
    package_from_aur = requests.get(url_package)

    with open("{}.tar.gz".format(package), "wb") as pkg:
        pkg.write(package_from_aur.content)
    package_tar = tarfile.open("{}.tar.gz".format(package), "r:gz")
    package_tar.extractall()
    package_tar.close()
    os.remove("{}.tar.gz".format(package))
    os.chdir("{}".format(package))
    print('Installing package', package)
    os.system('makepkg -csi')
