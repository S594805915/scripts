#!/bin/bash

cd /opt/shell_app/caffrey
rm -rf tmp/*

/bin/bash www.sh
/bin/bash m.sh
/bin/bash www_parser.sh
/bin/bash n_parser.sh
/bin/bash hourly_parser.sh
/bin/bash charge_parser.sh

cd /opt/shell_app/caffrey
if [ -s tmp/www_report.txt ] && [ -s tmp/newenergy_report.txt ] && [ -s tmp/hourly_report.txt ] && [ -s tmp/charge_report.txt ] ;then
python sendmail.py chuang.zheng@hnair.com
python sendmail.py chen-chen11@hnair.com
python sendmail.py dingl.li@hnair.com
#python sendmail.py jl-zhang6@hnair.com
fi

cd -
