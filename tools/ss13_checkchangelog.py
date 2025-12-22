'''
Usage:
    $ python ss13_checkchangelog.py html/changelogs 2019-01
'''

from __future__ import print_function
import yaml, os, glob, argparse
from collections import Counter

opt = argparse.ArgumentParser()
opt.add_argument('ymlDir', help='The directory of YAML changelogs we will use.')
opt.add_argument('month', nargs='?', default='')
opt.add_argument('--fix', '-f', type=bool, default=False, help='Fix changelog entries.')

args = opt.parse_args()
archiveDir = os.path.join(args.ymlDir, 'archive')
ymlFile = os.path.join(archiveDir, args.month + '.yml')
fix = args.fix

total_issues = 0

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

def parse_changes(changes: list, author: str, day: str):
    new_changes = []
    issues = {}

    for change in changes:
        # default case, {'bugfix': 'fix a runtime when loading ghosts to a mulebot'}
        if isinstance(change, dict):
            new_changes.append(change)
        # invalid case, this happens when there are duplicate author name in a single day
        elif isinstance(change, list):
            msg = '  Duplicate (%s) author "{}" in {}.'.format(author, day)
            issues[msg] = issues.get(msg, 0) + 1
            for change_ in change:
                new_changes.append(change_)

    for issue in issues:
        print(issue % str(issues[issue]))

    return new_changes, len(issues)

def parse_changelog(fileName):
    global total_issues
    name, ext = os.path.splitext(os.path.basename(fileName))
    if name.startswith('.'): return
    fileName = os.path.abspath(fileName)

    print(' Reading {}...'.format(fileName))

    changelog = {}
    with open(fileName, 'r',encoding='utf-8') as f:
        changelog = parse_preserving_duplicates(f)

    new_changelog = {}
    issues_count = 0
    issues = {}

    for day in changelog:
        new_changelog[day] = {}
        for author in changelog[day]:
            # default case
            if isinstance(author, str):
                changes = changelog[day][author]
                new_changes, issues_ = parse_changes(changes, author, day)
                new_changelog[day][author] = new_changes
                issues_count += issues_

            # invalid case, this happens when there are duplicate days in yaml
            # so `author_` is the author name and `author` is the day
            elif isinstance(author, dict):
                msg = '  Duplicate (%s) days {}.'.format(day)
                issues[msg] = issues.get(msg, 0) + 1
                for author_ in author:
                    changes = author[author_]
                    new_changes, issues_ = parse_changes(changes, author_, day)
                    new_changelog[day][author_] = new_changes
                    issues_count += issues_

    issues_count += len(issues)

    for issue in issues:
        print(issue % str(issues[issue]))

    if fix and issues_count > 0:
        with open(fileName, 'w', encoding='utf-8') as f:
            yaml.dump(new_changelog, f, default_flow_style=False)
        print('  Fixed {} changelog entries.'.format(issues_count))

    total_issues += issues_count

print('Reading changelogs...')

if os.path.isfile(ymlFile):
    parse_changelog(ymlFile)
else:
    for fileName in glob.glob(os.path.join(archiveDir, '*.yml')):
        parse_changelog(fileName)

if not fix and total_issues > 0:
    print('Found {} issues. Run with -f to fix.'.format(total_issues))
    exit(1)
