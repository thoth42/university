#!/usr/bin/env python

import sys, string, os

data = string.strip(os.popen("./program 99 0").read())

expected = "1 bottle of beer on the wall\nIf that one bottle should happen to fall, what a waste of alcohol!"

def expect(n):
  if n == 1:
    return "1 bottle of beer on the wall\nIf that one bottle should happen to fall, what a waste of alcohol!"
  if n == 0:
    return "No more bottles of beer on the wall, no more bottles of beer\nGo to the store and buy some more, 99 bottles of beer on the wall..."
  return str(n) + " bottles of beer on the wall\nTake one down, pass it around, " + str(n - 1) + " bottles of beer on the wall"

expected = "";
for i in range(99, 0, -1):
  expected += (expect(i) + "\n")

expected += expect(0)

if data == expected:
  print "Passed!, move to the next one!"
  sys.exit()
else:
  sys.exit("Expected '" + expected + "', got '" + data + "' :(")

