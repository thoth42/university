#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 1").read())

expected = "1 bottle of beer on the wall\nIf that one bottle should happen to fall, what a waste of alcohol!"

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

