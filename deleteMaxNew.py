import os
import requests


SERVER = ''  # eg. 'https://<orgname>.okta.com'
ORG_API_TOKEN = os.environ['OKTA_API_TOKEN'] # or however you'd like to assign this (plain text is fine unless under
                                             # version control
MAC_UDID = ''  


def create_session():
    s = requests.Session()
    s.headers = {
        'Authorization': f"SSWS {ORG_API_TOKEN}",
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
    return s


def get_and_revoke_certs(session):
    url = f"{SERVER}/internal/devices/{MAC_UDID}/credentials/keys"
    print('Getting certs for device: ' + MAC_UDID)
    response = session.get(
        url=url
    )
    print(response.json())
    data = response.json()
    if not data:
        print('No certs found')
        exit(0)
    for key in data:
        if 'kid' not in key:
            print("Error response.")
            exit(1)
        revoke_cert(key['kid'], session)
    print('Finished')


def revoke_cert(kid, session):
    url = f"{SERVER}/internal/devices/{MAC_UDID}/keys/{kid}/lifecycle/revoke"
    print(f"Revoking certificate: {kid}")
    response = session.post(
        url=url
    )
    print(response.json())


def check_params():
    if not SERVER:
        print("SERVER can't be empty, please populate org URL eg. https://&lt;org>.okta.com")
        exit(1)
    if not ORG_API_TOKEN:
        print("ORG_API_TOKEN can't be empty, please assign API token eg. SSWS <API-Token>")
        exit(1)
    if not MAC_UDID:
        print("MAC_UDID can't be empty, please assign macOS UDID")
        exit(1)

s = create_session()
get_and_revoke_certs(s)
