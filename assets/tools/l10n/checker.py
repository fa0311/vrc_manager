import json
import glob

with open('lib/l10n/app_en.arb','r',encoding="utf-8") as f:
    json_load = json.load(f)


def in_dart(key):
    for file in glob.glob("lib/*.dart", recursive=True):
        with open(file,'r',encoding="utf-8") as f:
            if(f"AppLocalizations.of(context)!.{key}" in f.read()):
                return False
    for file in glob.glob("lib/**/*.dart", recursive=True):
        with open(file,'r',encoding="utf-8") as f:
            if(f"AppLocalizations.of(context)!.{key}" in f.read()):
                return False
    return True

for key in json_load:
    if key[0] == "@":
        continue

    if in_dart(key):
        print(f"{key} is not found")