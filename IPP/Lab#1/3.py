#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 98 97").read())
expected = "98 bottles of beer on the wall\nTake one down, pass it around, 97 bottles of beer on the wall\n97 bottles of beer on the wall\nTake one down, pass it around, 96 bottles of beer on the wall"

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

