import requests
import json
import re

f = open('images_url.json', 'rb')
  
# returns JSON object as 
# a dictionary
dataRec = json.load(f)
       
for item in dataRec:

    try:
        img_data = requests.get(item["imageUrl"]).content
        with open(f'C:/flutterProjects/tudo_em_casa/tudo_em_casa_receitas/assets/images/{item["id"]}.png', 'wb') as handler:
            handler.write(img_data)
    except:
        try:
            with open(f'C:/flutterProjects/tudo_em_casa/tudo_em_casa_receitas/assets/images/{item["id"]}.jpg', 'wb') as handler:
                handler.write(img_data)
        except:
            print(f'falha ao obter imagem {item["id"]}')    