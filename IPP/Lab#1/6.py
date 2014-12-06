#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 2 1").read())
def expect(n):
  if n == 1:
    return "1 bottle of beer on the wall\nIf that one bottle should happen to fall, what a waste of alcohol!"
  return str(n) + " bottles of beer on the wall\nTake one down, pass it around, " + str(n - 1) + " bottles of beer on the wall"

expected = expect(2) + "\n" + expect(1)

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

