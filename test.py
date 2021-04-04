from selenium import webdriver
from bs4 import BeautifulSoup
import sys
import requests
import os
from PIL import Image
import numpy as np
import cv2 as cv

# путь к драйверу chrome
chrome_options = webdriver.ChromeOptions()
#chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
wd = webdriver.Chrome('chromedriver',options=chrome_options)
Visited = []
def visited(url):
	
	wd.get(url) 
	elems = wd.find_elements_by_xpath("//a[@href]")
	for elem in elems:
		if elem.get_attribute("href") is None:
			continue
		elif elem.get_attribute("href")[:45]=="https://www.lampatron.ru/cat/item/lampholders" or elem.get_attribute("href")[:45] == "https://www.lampatron.ru/cat/item/design-lamps" or elem.get_attribute("href")[:39]=="https://www.lampatron.ru/cat/item/lampa":
			Visited.append(elem.get_attribute("href"))#
		else:
			continue

directory = os.getcwd()
files_in_directory = os.listdir(directory)

if 'content' in files_in_directory:
	#print(files_in_directory)
	os.chdir(directory+'/content')
	files_in_directory = os.listdir(directory+'/content')
	if len(files_in_directory) == 0:
		os.chdir(directory+'/content')
		os.mkdir('empty')
		os.chdir(directory)

else:
	os.mkdir('content')
	os.chdir(directory+'/content')
	os.mkdir('empty')
	os.chdir(directory)

print(directory)

urls = ["design-lamps", "dekorativnielampi", "magnetrack", "lampholders", "constructor", "lampyedisona", "lededison", "xxl", "spider"] 
#берем только ссылки из категорий
HeadURL = "https://www.lampatron.ru/cat/bytype/"
for url in urls:
	ref = HeadURL + url
	visited(ref)

Visited = Visited[:3]

with open("output.csv", 'w', encoding='utf-8') as f:
	sys.stdout = f
	for ref in Visited:
		site = "https://www.lampatron.ru/"
		wd.get(ref)
		requiredHtml = wd.page_source
		soup = BeautifulSoup(requiredHtml, 'html5lib')
		name = soup.find_all(itemprop="name")
		imgs = soup.find_all(class_ = "prod-pix1")
		description = soup.find_all(class_ = 'tab-info')
		try:
			lamp = name[0].text
		except:
			continue

		price = soup.find_all(itemprop="price")
		options = soup.find_all("option")

		lampdir = name[0].text
		if lampdir in os.listdir(directory+'/content'):
			continue
		else:
			os.chdir(directory+'/content')
			os.mkdir(directory+'/content' + '/' + lampdir)
			os.chdir(directory+'/content' + '/' + lampdir) #потом надо вернуться в контент
		
		myimages = []
		for img in imgs:
			if 'data-lazy' in img.attrs:
				myimages.append(img.attrs['data-lazy'])

		for img in myimages:
			imgurl = site + img
			wd.get(imgurl)
			image = Image.open(requests.get(imgurl, stream = True).raw)
			image.save(directory+'/content/' + lampdir + '/' + list(img.split('/'))[-1] )
			#img = cv.imread(directory+'/content/' + lampdir + '/' + list(img.split('/'))[-1] )
			#mask = cv.imread(directory+'/mask.png')	
			#dst = cv.inpaint(img,mask,1,cv.INPAINT_TELEA)
			#cv.imwrite(directory+'/content/' + lampdir + '/' + list(img.split('/'))[-1], dst)
			
		
		myimgs = ','.join(myimages)
		if len(options) != 0:
				for opt in options:
					print(ref, name[0].text, opt.text, str(int(opt.attrs['data-price'].replace(u'\xa0', u''))), str(int(opt.attrs['data-price'].replace(u'\xa0', u''))/2), description[0], myimgs, sep = ';')
		else:
				if len(price) != 0:
					print(ref, name[0].text, "1 вариант", str(int(price[0].text.replace(u'\xa0', u''))), str(int(price[0].text.replace(u'\xa0', u''))/2), description[0], myimgs, sep = ';')
				else:
					continue