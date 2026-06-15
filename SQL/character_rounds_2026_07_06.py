import os
import json
import re
import MySQLdb
import argparse
import sys

def parse_special_roles(special_str):
    if not special_str or special_str.strip() == "NONE":
        return []

    roles = []
    if " and " in special_str:
        left_part, right_part = special_str.rsplit(" and ", 1)
        if ", " in left_part:
            roles.extend(left_part.split(", "))
        else:
            roles.append(left_part)
        roles.append(right_part)
    else:
        roles.append(special_str)

    return roles

def get_job_and_roles_from_mysql(cursor, table_name, round_id, character_name, ckey):
    sql_query = f"""
        SELECT job, special
        FROM {table_name}
        WHERE round_id = %s
          AND character_name = %s
          AND ckey = %s
        LIMIT 1
    """
    try:
        cursor.execute(sql_query, (round_id, character_name, ckey))
        result = cursor.fetchone()

        if result:
            job = result[0]
            special_raw = result[1]
            special_roles_formatted = parse_special_roles(special_raw)
            return job, special_roles_formatted

    except Exception as e:
        print(f"SQL Error (Round: {round_id}, Name: {character_name}, Ckey: {ckey}): {e}")

    return "Unknown", []

def convert_single_json(file_path, cursor, table_name, round_id):
    with open(file_path, 'r', encoding='utf-8') as f:
        try:
            input_data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error: {file_path} is not a valid JSON file, skipping.")
            return

    if not isinstance(input_data, dict):
        return

    version = input_data.get("version")
    if version is not None:
        try:
            if float(version) >= 2:
                print(f"Skipping {file_path}: Version is already {version}.")
                return
        except (ValueError, TypeError):
            pass

    print(f"Processing and overwriting: {file_path} (Round ID: {round_id})")

    output_data = {
        "version": 2,
        "indices": {},
        "characters": []
    }

    character_items = {k: v for k, v in input_data.items() if isinstance(v, dict)}

    for index, (key, data) in enumerate(character_items.items()):
        output_data["indices"][key] = index

        char_name = data.get("name", "")
        ckey = data.get("ckey", "")

        job, special_roles = get_job_and_roles_from_mysql(cursor, table_name, round_id, char_name, ckey)

        character_obj = {
            "name": char_name,
            "ckey": ckey,
            "icon": data.get("icon", ""),
            "job": job,
            "special_roles": special_roles
        }

        output_data["characters"].append(character_obj)

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=None)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("address", help="MySQL server address (use localhost for the current computer)")
    parser.add_argument("port", type=int, help="MySQL server port")
    parser.add_argument("username", help="MySQL login username")
    parser.add_argument("password", help="MySQL login password")
    parser.add_argument("database", help="Database name")
    parser.add_argument("manifesttable", help="Name of the manifest table (remember a prefix if you use one)")
    parser.add_argument("rounds_folder", help="Round folder")
    args = parser.parse_args()

    if not os.path.exists(args.rounds_folder):
        print("Error: The specified rounds folder does not exist.")
        sys.exit(1)

    try:
        db = MySQLdb.connect(
            host=args.address,
            port=args.port,
            user=args.username,
            passwd=args.password,
            db=args.database,
            charset='utf8mb4'
        )
        cursor = db.cursor()
    except Exception as e:
        print(f"Failed to connect to database: {e}")
        sys.exit(1)

    for root, dirs, files in os.walk(args.rounds_folder):
        for filename in files:
            if filename.endswith('.json'):
                file_path = os.path.join(root, filename)

                match = re.search(r'round-(\d+)', file_path)
                if not match:
                    continue

                round_id = int(match.group(1))

                convert_single_json(file_path, cursor, args.manifesttable, round_id)

    cursor.close()
    db.close()
    print("Processing complete.")

if __name__ == "__main__":
    main()
