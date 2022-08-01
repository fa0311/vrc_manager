import pathlib
import json

svglist = json.load(open('assets/svg/svg.json', 'r'))


for key in svglist.keys():
    pathlib.Path("assets/svg/{0}.svg".format(key)).touch()
    with open("assets/svg/{0}.svg".format(key),'w') as f:
        f.write("""<svg viewBox="16, 15, 32, 32" xmlns="http://www.w3.org/2000/svg">
  <g>
    <path d="{0}"></path>
  </g>
</svg>""".format(svglist[key]["icon"]))