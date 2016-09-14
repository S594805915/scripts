from prettytable import from_csv 
import sys
f1=sys.argv[1]
f2=sys.argv[2]


fp = open(f1, "r") 
pt = from_csv(fp) 
fp.close()

f2_obj = open(f2,"a")
f2_obj.write(str(pt))
f2_obj.close()

