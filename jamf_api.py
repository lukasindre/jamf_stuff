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

    def jamf_get(self, direct: bool, path, json=None, params=None):
        endpoint = ""
        if direct:
            endpoint = self.url(path)
        else:
            endpoint = path

        response = self.client.get(
            url=endpoint,
            json=json,
            params=params
        )

        return response

    def url(self, uri):
        return f"{self.BASEURL}{uri}"
