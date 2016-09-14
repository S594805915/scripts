#!/bin/bash

cd /opt/shell_app/caffrey/tmp

awk '{if($2==200) {print $0} }' charge.log  > charge_200.log
awk '{if($2==404) {print $0} }' charge.log  > charge_404.log
awk '{if($2==502) {print $0} }' charge.log  > charge_502.log
awk '{if($2==504) {print $0} }' charge.log  > charge_504.log
awk '{if($2==500) {print $0} }' charge.log  > charge_500.log


if [ -s charge_500.log ];then
   cat charge_500.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,500}' > charge_500.txt
fi


if [ -s charge_502.log ];then
   cat charge_502.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,502}' > charge_502.txt
fi

if [ -s charge_504.log ];then
   cat charge_504.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,504}' > charge_504.txt
fi

if [ -s charge_404.log ];then
   cat charge_404.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,404}' > charge_404.txt
fi

if [ -s charge_200.log ];then
   cat charge_200.log | awk '{print $1}' | sort |uniq -c|sort -nr|head -n 20| awk '{print $0,200}' > charge_200.txt
fi

rm -rf charge_*.log

if [ -s charge_200.txt ];then
	cat charge_200.txt |awk '{print $2}' > charge_200_tmp.txt
	rm -f charge_200.txt
	touch charge_200.txt
	cat charge_200_tmp.txt | while read LINE
	do
		count=`cat charge.log | grep $LINE|wc -l`
		time_avg=`cat charge.log | grep $LINE | awk '{total+=$3}END{printf("%d", total*1000)}'`
		python /opt/shell_app/caffrey/charge_t.py $count $LINE $time_avg
	done
	rm -f charge_200_tmp.txt
fi

rm -f charge_report.txt
touch charge_report.txt
echo "charge nginx log report" >> charge_report.txt
echo " " >> charge_report.txt
echo "web status 200:" >> charge_report.txt
if [ -s charge_200.txt ];then
	cat charge_200.txt |awk ' BEGIN { print "count,uri,avg_time"} {print $1","$2","$3}' > charge_200.csv
	rm -f charge_200.txt
	python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/charge_200.csv /opt/shell_app/caffrey/tmp/charge_report.txt
	rm -f charge_200.csv
fi


echo " " >> charge_report.txt
echo "web status 404:" >> charge_report.txt
if [ -s charge_404.txt ];then
        cat charge_404.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > charge_404.csv
        rm -f charge_404.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/charge_404.csv /opt/shell_app/caffrey/tmp/charge_report.txt
        rm -f charge_404.csv
fi

echo " " >> charge_report.txt
echo "web status 504:" >> charge_report.txt
if [ -s charge_504.txt ];then
        cat charge_504.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > charge_504.csv
        rm -f charge_504.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/charge_504.csv /opt/shell_app/caffrey/tmp/charge_report.txt
        rm -f charge_504.csv
fi

echo " " >> charge_report.txt
echo "web status 502:" >> charge_report.txt
if [ -s charge_502.txt ];then
        cat charge_502.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > charge_502.csv
        rm -f charge_502.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/charge_502.csv /opt/shell_app/caffrey/tmp/charge_report.txt
        rm -f charge_502.csv
fi

echo " " >> charge_report.txt
echo "web status 500:" >> charge_report.txt
if [ -s charge_500.txt ];then
        cat charge_500.txt |awk ' BEGIN { print "count,uri,http_code"} {print $1","$2","$3}' > charge_500.csv
        rm -f charge_500.txt
        python /opt/shell_app/caffrey/test.py /opt/shell_app/caffrey/tmp/charge_500.csv /opt/shell_app/caffrey/tmp/charge_report.txt
        rm -f charge_500.csv
fi

rm -f charge.log
cd -
