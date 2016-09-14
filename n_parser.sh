#!/bin/bash

cd /opt/shell_app/caffrey/tmp

awk '{if($2==200) {print $0} }' newenergy.log  > newenergy_200.log
awk '{if($2==404) {print $0} }' newenergy.log  > newenergy_404.log
awk '{if($2==502) {print $0} }' newenergy.log  > newenergy_502.log
awk '{if($2==504) {print $0} }' newenergy.log  > newenergy_504.log
awk '{if($2==500) {print $0} }' newenergy.log  > newenergy_500.log


if [ -s newenergy_500.log ];then
   cat newenergy_500.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,500}' > newenergy_500.txt
fi


if [ -s newenergy_502.log ];then
   cat newenergy_502.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,502}' > newenergy_502.txt
fi

if [ -s newenergy_504.log ];then
   cat newenergy_504.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,504}' > newenergy_504.txt
fi

if [ -s newenergy_404.log ];then
   cat newenergy_404.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,404}' > newenergy_404.txt
fi

if [ -s newenergy_200.log ];then
   cat newenergy_200.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,200}' > newenergy_200.txt
fi

rm -rf newenergy_*.log

if [ -s newenergy_200.txt ];then
	cat newenergy_200.txt |awk '{print $2}' > newenergy_200_tmp.txt
	rm -f newenergy_200.txt
	touch newenergy_200.txt
	cat newenergy_200_tmp.txt | while read LINE
	do
		count=`cat newenergy.log | grep $LINE|wc -l`
		time_avg=`cat newenergy.log | grep $LINE | awk '{total+=$3}END{printf("%d", total*1000)}'`
		python /opt/shell_app/caffrey/newenergy_t.py $count $LINE $time_avg
	done
	rm -f newenergy_200_tmp.txt
fi

rm -f newenergy_report.txt
touch newenergy_report.txt
echo "newenergy nginx log report" >> newenergy_report.txt
echo " " >> newenergy_report.txt
echo "web status 200:" >> newenergy_report.txt
if [ -s newenergy_200.txt ];then
	cat newenergy_200.txt |awk ' BEGIN { print "count,uri,avg_time"} {print $1","$2","$3}' > newenergy_200.csv
	rm -f newenergy_200.txt
	python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/newenergy_200.csv /opt/shell_app/caffrey/tmp/newenergy_report.txt
	rm -f newenergy_200.csv
fi


echo " " >> newenergy_report.txt
echo "web status 404:" >> newenergy_report.txt
if [ -s newenergy_404.txt ];then
        cat newenergy_404.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > newenergy_404.csv
        rm -f newenergy_404.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/newenergy_404.csv /opt/shell_app/caffrey/tmp/newenergy_report.txt
        rm -f newenergy_404.csv
fi

echo " " >> newenergy_report.txt
echo "web status 504:" >> newenergy_report.txt
if [ -s newenergy_504.txt ];then
        cat newenergy_504.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > newenergy_504.csv
        rm -f newenergy_504.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/newenergy_504.csv /opt/shell_app/caffrey/tmp/newenergy_report.txt
        rm -f newenergy_504.csv
fi

echo " " >> newenergy_report.txt
echo "web status 502:" >> newenergy_report.txt
if [ -s newenergy_502.txt ];then
        cat newenergy_502.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > newenergy_502.csv
        rm -f newenergy_502.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/newenergy_502.csv /opt/shell_app/caffrey/tmp/newenergy_report.txt
        rm -f newenergy_502.csv
fi

echo " " >> newenergy_report.txt
echo "web status 500:" >> newenergy_report.txt
if [ -s newenergy_500.txt ];then
        cat newenergy_500.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > newenergy_500.csv
        rm -f newenergy_500.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/newenergy_500.csv /opt/shell_app/caffrey/tmp/newenergy_report.txt
        rm -f newenergy_500.csv
fi

rm -f newenergy.log
cd -
