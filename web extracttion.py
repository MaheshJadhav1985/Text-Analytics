from google import search
import pandas as pd
from bs4 import BeautifulSoup
from urllib.request import Request,  urlopen
from urllib.error import HTTPError, URLError
import ssl 
import re

#%%
search_terms = ['GST']

for sterm in search_terms:
    urllist = []
    for url in search(sterm, tld='co.in', lang='en', stop=50):
        url = re.sub("#.*$","",url)
        url = re.sub(".*.pdf$","https://www.google.co.in/",url) # remove pdf links
        urllist.append(url)

# drop duplicate URL        
    urllist = list(set(urllist))

    text3 = []
    for url in urllist:
        req = Request(url, headers={'User-Agent': 'Mozilla/43.0.4'}) 
        # Some website doesn't allow automated requested so we are using Mozilla ;
        # Mozilla Firefox need not be the default browser. It only needs to be installed in the system
        # Further your System antivirus might kill python process because of continuous request so disable antivirus for some time
        try:
            gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1)  #@Rajiv: the ssl package imported is called here with the named protocol
            page = urlopen(req,context=gcontext).read()   #@Rajiv: reading the page with the ssl protocol
#            page = urlopen(req).read()
            soup = BeautifulSoup(page)
            [s.extract( ) for s in soup('script')] # remove all scripts from page source
            [s.extract( ) for s in soup('style')]  # remove all css styles from page source
            temp3 = soup.get_text(' ')
            temp3 = re.sub('\n',' ',temp3)
            temp3 = re.sub('\s+',' ',temp3)
            text3.append(temp3)
            
        except HTTPError:
            print('IDK1')
            text3.append('NA')
        except URLError:        #@Rajiv: For 2-4 brands my program was abruptly stopping due to this error, so i took the liberty of adding an except block and bypassing the error.
            print('IDK2')
            text3.append('NA')
        
    out = pd.DataFrame({'url':urllist,
                        'text':text3
                        })
    
    out_text = pd.DataFrame({'text':out.text})
    
    out_xls = pd.DataFrame({'url':out.url})
    
    out_text.to_csv("F:\\GST_google_search.csv")
    
    out_xls.to_csv("F:\\GST_google_search_list.csv")
    