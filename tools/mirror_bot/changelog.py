import sys
import yaml
from typing import Literal, TypeAlias

changelog_day: TypeAlias = dict[str, list[dict[str, str]]]
changelog: TypeAlias = dict[str, changelog_day]

def split_conflict(path: str) -> tuple[str, str]:
    head: list[str] = []
    incoming: list[str] = []
    within: Literal[0, 1, 2] = 0

    with open(path, "r", encoding="utf-8") as file:
        for line in file:
            line = line.rstrip("\n")
            if line.startswith("<<<<<<<"):
                within = 1
                continue
            elif line.startswith("=======") and within == 1:
                within = 2
                continue
            elif line.startswith(">>>>>>>") and within == 2:
                within = 0
                continue

            if within != 2:
                head.append(line)
            if within != 1:
                incoming.append(line)

    return "\n".join(head), "\n".join(incoming)


def merge_changelogs(our_yaml: changelog, their_yaml: changelog) -> changelog:
    all_dates = sorted(set(list(our_yaml.keys()) + list(their_yaml.keys())))
    merged: changelog = {}

    for date in all_dates:
        in_ours = date in our_yaml
        in_theirs = date in their_yaml

        if in_ours and not in_theirs:
            merged[date] = our_yaml[date]
        elif in_theirs and not in_ours:
            merged[date] = their_yaml[date]
        else:
            merged_date: changelog_day = {}
            all_authors = set(list(our_yaml[date].keys()) + list(their_yaml[date].keys()))

            for author in all_authors:
                in_ours = author in our_yaml[date]
                in_theirs = author in their_yaml[date]

                if in_ours and not in_theirs:
                    merged_date[author] = our_yaml[date][author]
                elif in_theirs and not in_ours:
                    merged_date[author] = their_yaml[date][author]
                else:
                    our_changes = our_yaml[date][author] or []
                    their_changes = their_yaml[date][author] or []
                    merged_changes = list(our_changes)

                    for change in their_changes:
                        key = next(iter(change))
                        value = change[key]
                        is_duplicate = any(
                            next(iter(ex)) == key and ex[next(iter(ex))] == value
                            for ex in merged_changes
                        )
                        if not is_duplicate:
                            merged_changes.append(change)

                    merged_date[author] = merged_changes

            merged[date] = merged_date

    return merged

def process_file(path: str) -> None:
    head, incoming = split_conflict(path)

    our_yaml: changelog = yaml.safe_load(head) or {}
    their_yaml: changelog = yaml.safe_load(incoming) or {}

    merged = merge_changelogs(our_yaml, their_yaml)

    with open(path, "w", encoding="utf-8") as file:
        yaml.dump(merged, file, default_flow_style=False, sort_keys=True)

    print(f"Merged: {path}")


def main() -> None:
    if len(sys.argv) > 1:
        paths = sys.argv[1:]
    else:
        print("Usage:", file=sys.stderr)
        print("  tools/bootstrap/python -m mirror_bot.changelog 2026-06.yml 2026-05.yml ...", file=sys.stderr)
        sys.exit(1)

    errors: list[str] = []
    for path in paths:
        try:
            process_file(path)
        except Exception as e:
            print(f"Error ({path}): {e}", file=sys.stderr)
            errors.append(path)

    if errors:
        sys.exit(1)

if __name__ == "__main__":
    main()
