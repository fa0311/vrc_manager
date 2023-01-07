import json


with open('lib/l10n/app_ja.arb','r',encoding="utf-8") as f:
    json_load_into = json.load(f)

with open('lib/l10n/app_en.arb','r',encoding="utf-8") as f:
    json_load_from = json.load(f)

output_json = {}

for key in json_load_from:
    if type(json_load_from[key]) is str:
        output_json[key] = json_load_into.get(key,json_load_from[key])


with open('lib/l10n/l10n.arb', 'w+' ,encoding="utf-8") as f:
    json.dump(output_json, f, indent=4,ensure_ascii=False )