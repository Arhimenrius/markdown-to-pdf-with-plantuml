#!/usr/bin/env python3

import glob, os, re

INCLUDE_PREFIX = '!include'
INCLUDE_TYPES_TO_REPLACE_PATH = ('!include', '!include_many', '!include_once', '!includesub')
INCLUDE_REGEX = re.compile(r'!include(|_many|_once|sub) \.')
FILE_EXTENSIONS_TO_AFFECT = ('*.md', '*.puml')
BASE_DIR = os.getcwd()


def find_file_and_replace_path():
    for file_extension in FILE_EXTENSIONS_TO_AFFECT:
        for file_path in glob.glob('**/' + file_extension, recursive=True):
            update_file(file_path, open_file(file_path))


def open_file(file_path):
    with open(file_path) as processed_file:
        return processed_file.readlines()


def update_file(file_path, file_content):
    new_file_content = []
    for line in file_content:
        if INCLUDE_REGEX.search(line):
            line_words = line.split(' ')
            new_file_content.append(line_words[0] + ' ' + os.path.realpath(os.path.join(
                BASE_DIR,
                os.path.dirname(file_path),
                line_words[1]
            )))
        else:
            new_file_content.append(line)

        with open(file_path, 'w') as file_to_save:
            file_to_save.writelines(new_file_content)


find_file_and_replace_path()
