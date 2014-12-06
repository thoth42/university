#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 98 96").read())
def expect(n):
  return str(n) + " bottles of beer on the wall\nTake one down, pass it around, " + str(n - 1) + " bottles of beer on the wall"

expected = expect(98) + "\n" + expect(97) + "\n" + expect(96)

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

