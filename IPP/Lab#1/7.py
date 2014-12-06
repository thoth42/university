#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 0").read())

expected = "No more bottles of beer on the wall, no more bottles of beer\nGo to the store and buy some more, 99 bottles of beer on the wall..."

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

