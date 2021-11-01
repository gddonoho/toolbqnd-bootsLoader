#!/usr/bin/env python
import requests
from requests import get
import json
from halo import Halo
bootList = []
spinner = Halo(text='Scrapping tooldriveproject.net', spinner='dots')
spinner.start()
for x in range(1,3000):
    headers = {"Accept-Language": "en-US, en;q=0.5"}
    url = "https://tooldriveproject.net/Details/?ID=" + str(x)
    results = requests.get(url, headers=headers)
    html = results.text
    url = 'https://drive.google.com/open?id='
    if (html.find(url) < 0):
        continue
    start = (html.find(url) + len(url))
    end = (html.find('\'', start))
    link = url + html[start:end]
    start = html.find('<!-- Body Parts')
    start = html.find('<h3>',start) + 4
    end = html.find(' - ', start)
    cdate = html[start:end]
    start = html.find('Version: ', start) + 9
    end = html.find("<", start)
    version = html[start:end]
    url = "https://tooldriveproject.net/player/?ID=" + str(x)
    results = requests.get(url, headers=headers)
    html = results.text
    start = 1
    songs = 0
    songList = []
    while (html.find("mp3:", start)>0):
        start = html.find("mp3:\"", start) + 1
        end = html.find("\"", start+4)
        songList.append({str(songs+1): "https://tooldriveproject.net" + html[start+4:end]})
        songs += 1
    jsonSet = {'link': link, 'date': cdate, 'version': version, 'songs': songList}
    bootList.append(jsonSet)
boots = json.dumps(bootList, indent=4)
f = open("boots.json", "w")
f.write(boots)
f.close()
spinner.stop()

