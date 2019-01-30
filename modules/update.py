# [imports] ------
import os


def update_all():
    os.system('sudo pacman -Syu')
    update_aur()


def update_aur():
    print("Update packages from aur...")
    aur_packages = "pacman -Qm"
    os.system(aur_packages)
