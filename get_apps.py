import pickle
import os
from jamf_api import JamfApi
from pprint import pprint as pp
from collections import Counter


client = JamfApi()

# for app in response.json()['computer']['software']['applications']:
#     print(app['name'])

computer_apps = None
if os.path.exists("apps.pickle"):
    computer_apps = pickle.load(open("apps.pickle", "rb"))
else:
    response = client.jamf_get("/computers")
    computer_ids = []
    for computer in response.json()['computers']:
        computer_ids.append(computer['id'])

    computer_apps = []
    for id in computer_ids:
        response = client.jamf_get(f"/computers/id/{id}")
        for app in response.json()['computer']['software']['applications']:
            computer_apps.append(app['name'])

    pickle.dump(computer_apps, open("apps.pickle", "wb"))

print("app,count")
for app in Counter(computer_apps):
    print(f"{app},{Counter(computer_apps)[app]}")
