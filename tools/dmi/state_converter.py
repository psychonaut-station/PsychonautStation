import os
import sys
from dmi import *

def _run():

    dmifile = sys.argv[1]

    output_path = sys.argv[2]

    output_path = output_path + os.sep

    os.makedirs(output_path, exist_ok=True)

    # DMI dosyasını yükle
    dmi_obj = Dmi.from_file(dmifile)

    # Her state'i kaydet
    count = 0
    for state in dmi_obj.states:
        state.to_file(output_path)
        count += 1

    print(f"successfully saved {count} states to {output_path}")
    return True

def _usage():
    print(f"Usage:")
    print(f"    tools{os.sep}bootstrap{os.sep}python -m {__spec__.name} input_file output_folder")
    exit(1)

def _main():
    if len(sys.argv) == 3:
        return _run()

    return _usage()

if __name__ == '__main__':
    _main()
