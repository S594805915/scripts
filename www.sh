#!/bin/bash
last_d=`date -d "yesterday" +%Y%m%d`
c_d=`date +%Y%m%d`

echo $c_d
echo $last_d

scp -P16891 -pr 10.44.130.36:/opt/nginx/logs/www-access-${last_d}.log.gz /opt/shell_app/caffrey/tmp/
cd /opt/shell_app/caffrey/tmp
gzip -d www-access-${last_d}.log.gz

cat www-access-${last_d}.log | grep -v /smalltwo | grep /newEnergy | grep -v /newEnergy/admin/ | grep -v /newEnergy/html/ > newenergy.log
cat www-access-${last_d}.log | grep -v /smalltwo | grep /charge | grep -v /charge/admin/ | grep -v /charge/html/ > charge.log
cat www-access-${last_d}.log | grep -v /smalltwo  | grep -v /newEnergy/ | grep -v /images | grep -v /hourlyRate/ |grep -v charge> www.log
cat www-access-${last_d}.log | grep -v /smalltwo  | grep -v /newEnergy/ | grep -v /images | grep  /hourlyRate/ > hourly.log

cat www.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > www_1.log
cat newenergy.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > newenergy_1.log
cat charge.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > charge_1.log
cat hourly.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > hourly_1.log

rm -rf charge.log
rm -f hourly.log
rm -f www.log
rm -f newenergy.log

python /opt/shell_app/caffrey/t.py www_1.log www.log
python /opt/shell_app/caffrey/t.py newenergy_1.log newenergy.log
python /opt/shell_app/caffrey/t.py charge_1.log charge.log
python /opt/shell_app/caffrey/t.py hourly_1.log hourly.log

rm -f www_1.log newenergy_1.log charge_1.log hourly_1.log

sed -i 's|//|/|g' www.log
sed -i 's|//|/|g' newenergy.log
sed -i 's|//|/|g' charge.log
sed -i 's|//|/|g' hourly.log

rm -f www-access-${last_d}.log

cd -
