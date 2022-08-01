import json
import glob


def in_dart(key1,key2):
    for file in glob.glob("lib/*.dart"):
        with open(file,'r',encoding="utf-8") as f:
            code = f.read()
            count = code.count(key1) - code.count(key2)
            if count != 0:
                print(f"{key1} is {count} more in {file}")

    for file in glob.glob("lib/*/*.dart"):
        with open(file,'r',encoding="utf-8") as f:
            code = f.read()
            count = code.count(key1) - code.count(key2)
            if count != 0:
                print(f"{key1} is {count} more in {file}")

    for file in glob.glob("lib/*/*/*.dart"):
        with open(file,'r',encoding="utf-8") as f:
            code = f.read()
            count = code.count(key1) - code.count(key2)
            if count != 0:
                print(f"{key1} is {count} more in {file}")

in_dart("VRChatAPI(cookie","apiError")