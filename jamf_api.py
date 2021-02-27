import requests
import os


class JamfApi:
    def __init__(self):
        self.BASEURL = "https://upstart.jamfcloud.com/JSSResource"
        self.client = requests.Session()
        self.client.headers = {
                'accept':'application/json',
                'content-type':'application/json'
                }
        self.client.auth = (os.environ["JAMF_USERNAME"], os.environ["JAMF_PASSWORD"])

    def jamf_get(self, path, json=None, params=None):
        response = self.client.get(
            url=f"{self.BASEURL}{path}",
            json=json,
            params=params
        )

        return response
