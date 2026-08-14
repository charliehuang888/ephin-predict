from bs4 import BeautifulSoup
import requests
import os
import time


def isDirectory(url):
    if len(url) > 1 and not url.startswith("/") and url.endswith('/'):
        return True
    else:
        return False

def isFile(url):
    desired_file_types = [".txt", ".sci", ".pha", ".phr", ".phx", ".sl2", ".pl2", "rl2", ".gz"]
    return any(map(url.endswith, desired_file_types))

def extract_path(baseurl, currentUrl, basePath):
    curlen = len(currentUrl)
    baselen = len(baseurl)
    if curlen > baselen:
        return f"{basePath}/{currentUrl[baselen:]}"
    else:
        return basePath

def extract_parent_dir(path):
    return "/".join(path.split("/")[:-1])


def findLinks(url,basePath):
    linkQueue = [url]
    counter = 0
    seen = set()

    while linkQueue:
        toParseUrl = linkQueue.pop()
        if toParseUrl in seen:
            continue

        seen.add(toParseUrl)
        page = requests.get(toParseUrl).content
        bsObj = BeautifulSoup(page, 'html.parser')
        maybe_directories = bsObj.find_all('a', href=True)


        for link in maybe_directories:
            newUrl = toParseUrl + link['href']
            # print(newUrl)
            if isDirectory(link['href']):
                linkQueue.append(newUrl)
            elif isFile(newUrl):
                fp = extract_path(url, newUrl, basePath)
                if os.path.isfile(fp):
                    continue

                dp = extract_parent_dir(fp)
                if not os.path.isdir(dp):
                    os.makedirs(dp)

                for i in range(10):
                    try:
                        res = requests.get(newUrl)
                        if res.status_code == 200:
                            with open(fp, 'wb') as file:
                                file.write(res.content)
                                # print(f"wrote{fp}")
                    except:
                        time.sleep(10)
                        continue
                    else:
                        break



    print("baibai")


startUrl = "http://ulysses.physik.uni-kiel.de/costep/level1/"
basePath = "/home/chuang/Projects/ephin-predict/og-data/level1"
findLinks(startUrl, basePath)
