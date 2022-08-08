import json


with open('lib/l10n/app_ja.arb','r',encoding="utf-8") as f:
    json_load = json.load(f)

with open('lib/l10n/l10n.txt','r',encoding="utf-8") as f:
    lines = f.read().split("\n")

i = 0
for key in json_load:
    if type(json_load[key]) is str:
        json_load[key] = lines[i]
        i += 1


with open('lib/l10n/l10n.arb', 'w+' ,encoding="utf-8") as f:
    json.dump(json_load, f, indent=4,ensure_ascii=False )