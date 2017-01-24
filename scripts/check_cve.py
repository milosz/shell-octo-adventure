#!/usr/bin/python
# Check security updates in specific distribution for provided CVE status
#
# Source: https://blog.sleeplessbeastie.eu/2017/01/30/how-to-check-debian-cve-status-using-python-script/
#

# imports
import sys, getopt
import urllib2
from bs4 import BeautifulSoup

# help function
def help():
  print 'check security updates in specific distribution for provided CVE status'
  print
  print 'check_cve.py -c <required_cve> -d <optional_distribution>'
  print

def main(argv):
  # cve and distribution
  cve          = ""
  distribution = ""

  try:
    opts, args = getopt.getopt(argv,"hd:c:",["distribution=","cve="])
  except getopt.GetoptError:
    help()
    sys.exit(3)
  for opt, arg in opts:
    if opt == '-h':
      help()
      sys.exit()
    elif opt in ("-d", "--distribution"):
      distribution = arg
    elif opt in ("-c", "--cve"):
      cve = arg

  # exit if cve is not provided
  if len(cve) == 0:
    help()
    sys.exit(2)

  # make request
  uri = "https://security-tracker.debian.org/tracker/" + cve
  request = urllib2.Request(uri)
  try:
    request_handle = urllib2.urlopen(request)
  except urllib2.HTTPError, error:
    print "HTTP error on" + " " + uri + " " + "code" + " " + str(error.code)
    exit(4)
  except urllib2.URLError, error:
    print "URL error on" + " " + uri + " " + "reason" + " " + str(error.reason)
    exit(5)

  # read and parse html
  html   = request_handle.read()
  soup   = BeautifulSoup(html,"html.parser")
  table  = soup.find_all("table")[1] # get second table
  source = (((table.select('tr')[1]).select('td')[0]).getText()).replace(" (PTS)","")
  output = 0
  for row in table:
    columns      = row.select('td')
    parsed_array = []
    for column in columns:
      parsed_array.append(column.text)
    if(len(parsed_array) == 4):  
      if len(distribution) != 0:
	if distribution in parsed_array[1]:
          print "Source package " + source +  " (version " +  parsed_array[2] + ")"  + " is "+ parsed_array[3] + " (" + cve + ")" +" in " + parsed_array[1]
          output = 1
      else:
        print "Source package " + source +  " (version " +  parsed_array[2] + ")" + " is "+ parsed_array[3] + " (" + cve + ")" + " in " + parsed_array[1]
        output = 1
  if output == 0:
    print "matching data not provided"

if __name__ == "__main__":
  main(sys.argv[1:])
