from jamf_api import JamfApi
from pprint import pprint as pp

import pickle
import os


client = JamfApi()
policies = None
if os.path.exists("policies.pickle"):
    policies = pickle.load(open("policies.pickle", 'rb'))
else:
    response = client.jamf_call(
        method='get',
        path='/policies'
    )

    policy_ids = []
    for policy in response.json().get('policies', {}):
        policy_ids.append(policy.get('id', {}))

    policies = []
    for policy_id in policy_ids:
        print(f"Getting policy {policy_id} ...")
        response = client.jamf_call(
            method='get',
            path=f'/policies/id/{policy_id}'
        )
        policies.append(response.json())

        pickle.dump(policies, open('policies.pickle', 'wb'))

count = 0
for policy in policies:
    if not policy.get('policy', {}).get('reboot', {}).get('file_vault_2_reboot', {}):
        print(f"{policy['policy']['general']['id']},{policy['policy']['general']['name']}")
        count += 1

print(count)
