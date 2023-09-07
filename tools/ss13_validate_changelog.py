from __future__ import print_function
import yaml, os, glob, sys, re, time, argparse
from datetime import datetime, date, timedelta
from time import time
from collections import Counter

today = date.today()

fileDateFormat = "%Y-%m"

opt = argparse.ArgumentParser()
opt.add_argument('ymlDir', help='The directory of YAML changelogs we will use.')
opt.add_argument('month', nargs='?', default='')

args = opt.parse_args()
archiveDir = os.path.join(args.ymlDir, 'archive')
ymlFile = os.path.join(archiveDir, args.month + '.yml')

all_changelog_entries = {}

# Do not change the order, add to the bottom of the array if necessary
validPrefixes = [
    'bugfix',
    'wip',
    'qol',
    'soundadd',
    'sounddel',
    'rscadd',
    'rscdel',
    'imageadd',
    'imagedel',
    'spellcheck',
    'experiment',
    'balance',
    'code_imp',
    'refactor',
    'config',
    'admin',
    'server',
    'sound',
    'image',
]

def dictToTuples(inp):
    return [(k, v) for k, v in inp.items()]

def parse_preserving_duplicates(src):
    class PreserveDuplicatesLoader(yaml.loader.Loader):
        pass
    def map_constructor(loader, node, deep=False):
        keys = [loader.construct_object(node, deep=deep) for node, _ in node.value]
        vals = [loader.construct_object(node, deep=deep) for _, node in node.value]
        key_count = Counter(keys)
        data = {}
        for key, val in zip(keys, vals):
            if key_count[key] > 1:
                if key not in data:
                    data[key] = []
                data[key].append(val)
            else:
                data[key] = val
        return data
    PreserveDuplicatesLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, map_constructor)
    return yaml.load(src, PreserveDuplicatesLoader)

def parse_changelog(fileName):
    name, ext = os.path.splitext(os.path.basename(fileName))
    if name.startswith('.'): return
    fileName = os.path.abspath(fileName)
    print(' Reading {}...'.format(fileName))
    changelog = {}
    with open(fileName, 'r',encoding='utf-8') as f:
        changelog = parse_preserving_duplicates(f)
    new_changelog = {}
    changes = 0
    for day in changelog:
        new_changelog[day] = {}
        for author in changelog[day]:
            if isinstance(author, dict):
                for author_ in author:
                    changes += 1
                    new_changelog[day][author_] = author[author_]
            else:
                new_changelog[day][author] = changelog[day][author]
    if changes > 0:
        with open(fileName, 'w', encoding='utf-8') as f:
            yaml.dump(new_changelog, f, default_flow_style=False)
        print('  Fixed {0} changelog entries.'.format(changes))

print('Reading changelogs...')
if os.path.isfile(ymlFile):
    parse_changelog(ymlFile)
else:
    for fileName in glob.glob(os.path.join(archiveDir, '*.yml')):
        parse_changelog(fileName)
