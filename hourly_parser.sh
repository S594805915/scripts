#!/bin/bash

cd /opt/shell_app/caffrey/tmp

awk '{if($2==200) {print $0} }' hourly.log  > hourly_200.log
awk '{if($2==404) {print $0} }' hourly.log  > hourly_404.log
awk '{if($2==502) {print $0} }' hourly.log  > hourly_502.log
awk '{if($2==504) {print $0} }' hourly.log  > hourly_504.log
awk '{if($2==500) {print $0} }' hourly.log  > hourly_500.log


if [ -s hourly_500.log ];then
   cat hourly_500.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,500}' > hourly_500.txt
fi


if [ -s hourly_502.log ];then
   cat hourly_502.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,502}' > hourly_502.txt
fi

if [ -s hourly_504.log ];then
   cat hourly_504.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,504}' > hourly_504.txt
fi

if [ -s hourly_404.log ];then
   cat hourly_404.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,404}' > hourly_404.txt
fi

if [ -s hourly_200.log ];then
   cat hourly_200.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,200}' > hourly_200.txt
fi

rm -rf hourly_*.log

if [ -s hourly_200.txt ];then
	cat hourly_200.txt |awk '{print $2}' > hourly_200_tmp.txt
	rm -f hourly_200.txt
	touch hourly_200.txt
	cat hourly_200_tmp.txt | while read LINE
	do
		count=`cat hourly.log | grep $LINE|wc -l`
		time_avg=`cat hourly.log | grep $LINE | awk '{total+=$3}END{printf("%d", total*1000)}'`
		python /opt/shell_app/caffrey/hourly_t.py $count $LINE $time_avg
	done
	rm -f hourly_200_tmp.txt
fi

rm -f hourly_report.txt
touch hourly_report.txt
echo "hourly nginx log report" >> hourly_report.txt
echo " " >> hourly_report.txt
echo "web status 200:" >> hourly_report.txt
if [ -s hourly_200.txt ];then
	cat hourly_200.txt |awk ' BEGIN { print "count,uri,avg_time"} {print $1","$2","$3}' > hourly_200.csv
	rm -f hourly_200.txt
	python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/hourly_200.csv /opt/shell_app/caffrey/tmp/hourly_report.txt
	rm -f hourly_200.csv
fi


echo " " >> hourly_report.txt
echo "web status 404:" >> hourly_report.txt
if [ -s hourly_404.txt ];then
        cat hourly_404.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > hourly_404.csv
        rm -f hourly_404.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/hourly_404.csv /opt/shell_app/caffrey/tmp/hourly_report.txt
        rm -f hourly_404.csv
fi

echo " " >> hourly_report.txt
echo "web status 504:" >> hourly_report.txt
if [ -s hourly_504.txt ];then
        cat hourly_504.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > hourly_504.csv
        rm -f hourly_504.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/hourly_504.csv /opt/shell_app/caffrey/tmp/hourly_report.txt
        rm -f hourly_504.csv
fi

echo " " >> hourly_report.txt
echo "web status 502:" >> hourly_report.txt
if [ -s hourly_502.txt ];then
        cat hourly_502.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > hourly_502.csv
        rm -f hourly_502.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/hourly_502.csv /opt/shell_app/caffrey/tmp/hourly_report.txt
        rm -f hourly_502.csv
fi

echo " " >> hourly_report.txt
echo "web status 500:" >> hourly_report.txt
if [ -s hourly_500.txt ];then
        cat hourly_500.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > hourly_500.csv
        rm -f hourly_500.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/hourly_500.csv /opt/shell_app/caffrey/tmp/hourly_report.txt
        rm -f hourly_500.csv
fi

rm -f hourly.log
cd -
