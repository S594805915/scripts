__author__ = 'caffreyzheng'

import os,sys


if __name__ == "__main__":
	count = sys.argv[1]
	line = sys.argv[2]
	total_time = sys.argv[3]
	avg_time = int(float(total_time)/float(count))
	
	n = count +' '+ line + ' ' + str(avg_time)+'ms\n'
			
	
	file_object = open('/opt/shell_app/caffrey/tmp/www_200.txt', 'a')
	file_object.write(n)
	file_object.close()
	
