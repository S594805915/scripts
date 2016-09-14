#!/bin/bash

cd /opt/shell_app/caffrey/tmp

awk '{if($2==200) {print $0} }' www.log  > www_200.log
awk '{if($2==404) {print $0} }' www.log  > www_404.log
awk '{if($2==502) {print $0} }' www.log  > www_502.log
awk '{if($2==504) {print $0} }' www.log  > www_504.log
awk '{if($2==500) {print $0} }' www.log  > www_500.log


if [ -s www_500.log ];then
   cat www_500.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,500}' > www_500.txt
fi


if [ -s www_502.log ];then
   cat www_502.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,502}' > www_502.txt
fi

if [ -s www_504.log ];then
   cat www_504.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,504}' > www_504.txt
fi

if [ -s www_404.log ];then
   cat www_404.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,404}' > www_404.txt
fi

if [ -s www_200.log ];then
   cat www_200.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,200}' > www_200.txt
fi

rm -rf www_*.log

if [ -s www_200.txt ];then
	cat www_200.txt |awk '{print $2}' > www_200_tmp.txt
	rm -f www_200.txt
	touch www_200.txt
	cat www_200_tmp.txt | while read LINE
	do
		count=`cat www.log | grep $LINE|wc -l`
		time_avg=`cat www.log | grep $LINE | awk '{total+=$3}END{printf("%d", total*1000)}'`
		python /opt/shell_app/caffrey/www_t.py $count $LINE $time_avg
	done
	rm -f www_200_tmp.txt
fi

rm -f www_report.txt
touch www_report.txt
echo "www nginx log report" >> www_report.txt
echo " " >> www_report.txt
echo "web status 200:" >> www_report.txt
if [ -s www_200.txt ];then
	cat www_200.txt |awk ' BEGIN { print "count,uri,avg_time"} {print $1","$2","$3}' > www_200.csv
	rm -f www_200.txt
	python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/www_200.csv /opt/shell_app/caffrey/tmp/www_report.txt
	rm -f www_200.csv
fi


echo " " >> www_report.txt
echo "web status 404:" >> www_report.txt
if [ -s www_404.txt ];then
        cat www_404.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > www_404.csv
        rm -f www_404.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/www_404.csv /opt/shell_app/caffrey/tmp/www_report.txt
        rm -f www_404.csv
fi

echo " " >> www_report.txt
echo "web status 504:" >> www_report.txt
if [ -s www_504.txt ];then
        cat www_504.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > www_504.csv
        rm -f www_504.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/www_504.csv /opt/shell_app/caffrey/tmp/www_report.txt
        rm -f www_504.csv
fi

echo " " >> www_report.txt
echo "web status 502:" >> www_report.txt
if [ -s www_502.txt ];then
        cat www_502.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > www_502.csv
        rm -f www_502.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/www_502.csv /opt/shell_app/caffrey/tmp/www_report.txt
        rm -f www_502.csv
fi

echo " " >> www_report.txt
echo "web status 500:" >> www_report.txt
if [ -s www_500.txt ];then
        cat www_500.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > www_500.csv
        rm -f www_500.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/www_500.csv /opt/shell_app/caffrey/tmp/www_report.txt
        rm -f www_500.csv
fi

rm -f www.log
cd -
