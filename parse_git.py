#!/usr/bin/python

#Very quick and crude BeantifulSoup job to webscrape repo table into a json array and output
#all repos older than 30 days. (note in Github < 30 days = 1 month) 

from BeautifulSoup import BeautifulSoup

#Read data from repositories table into json array "data" using tbody and tr delims
data = []
soup = BeautifulSoup(open("git.html"))
table = soup.find("table", { "class" : "repositories" })
table_body = table.find('tbody')
rows = table_body.findAll('tr')
for row in rows:
    cols = row.findAll('td')
    cols = [ele.text.strip() for ele in cols]
    data.append(cols)

# Iterate over json data array and only output if "since modifed does not contain string days" 
#
# info[0] = repo name
# info[4] = last modified

for info in data: 
    if ("days" not in info[4]):
         print "Repo %s has not changed in the past 30 days. Last modified %s" % (info[0].replace("&nbsp;",""),info[4])
