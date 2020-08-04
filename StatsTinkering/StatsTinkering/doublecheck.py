# john jozwiak on 2020 July 4 (saturday) to check calculcations i did in Swift5 for Apple Health homework.

import glob,os,os.path,stat,sys
import locale # for atoi and atof
import math   # for sqrt

##############################################

def parsenumber( s ):
  ok = True
  try:
    n = int(s)
    return n
  except:
    ok = False
  if ok:
    return n
  ok = True # if this far, it was not parseable as an int.
  try:
    n = float(s)
    return n
  except:
    pass
  print("What the heck is ",s)
  return "nan" # float("nan") # s # "nan"

##############################################

def parsefields( line ):
  return [ parsenumber(f) for f in line ]

##############################################

def simplestats( indexedrawnumbers ):  #  a sequence of pairs (index, doublevalue)
  justindexandnumber = [ (i,x) for (i,x) in indexedrawnumbers if x not in ["nan" , float("nan") ] ]
  N                  = len(justindexandnumber)
  mean               = sum( [ x for (i,x) in justindexandnumber ] ) / N
  print( "mean   = " , mean   )
  variance           = sum( [ (x-mean)*(x-mean) for (i,x) in justindexandnumber ] ) / float(N-1)
  stddev             = math.sqrt(variance)
  print( "stddev = " , stddev )
  stddevsfrommean    = [ (i,abs(x - mean)/stddev) for (i,x) in justindexandnumber ]
  stddevsfrommean2   = [ (i,x) for (i,x) in stddevsfrommean if x > 2 ]
  print( "stddevs2+ = ",stddevsfrommean2 )
  
  
##############################################

datalines = []

with open("SampleDataset.csv","r") as f:

  headers = f.readline().strip()
  # print(headers, " ... followed by ")

  line = f.readline().strip()
  while line != "":
    fields = line.split(",")
    if len(fields) != 4:
      print("what on earth? skipping",line)
      break
    numericfields = parsefields(fields)
    datalines.append(numericfields)
#   print(numericfields)
    line = f.readline().strip()

  print("\ncol A")
  simplestats( [ (i,a) for (i,a,b,c) in datalines ] )

  print("\ncol B")
  simplestats( [ (i,b) for (i,a,b,c) in datalines ] )

  print("\ncol C")
  simplestats( [ (i,c) for (i,a,b,c) in datalines ] )
