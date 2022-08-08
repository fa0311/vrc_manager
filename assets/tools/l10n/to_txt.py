import json
from tokenize import String

with open('lib/l10n/app_ja.arb','r',encoding="utf-8") as f:
    json_load = json.load(f)



output = ""
for key in json_load:
    if type(json_load[key]) is str:
        output += json_load[key] + "\n"


with open('lib/l10n/l10n_base.txt', mode='w+',encoding="utf-8") as f:
    f.write(output)