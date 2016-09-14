__author__ = 'caffreyzheng'

import os,sys


if __name__ == "__main__":
	file_name = sys.argv[1]
	file_name2 = sys.argv[2]
	file_obj = open(file_name,'r')
	n_c = ''
	for c in file_obj:
		count=c.find('?')
		if count > -1:
			c1=c[0:count]
			c2=c[count:]
			c2_list=c2.split(' ')
			n_c += c1 + ' ' + c2_list[1] + ' '+ c2_list[2]
		else:
			n_c += c
			
	
	file_object = open(file_name2, 'w')
	file_object.write(n_c)
	file_object.close()
	
