#!/bin/bash
last_d=`date -d "yesterday" +%Y%m%d`
c_d=`date +%Y%m%d`

echo $c_d
echo $last_d

scp -P16891 -pr 10.44.130.36:/opt/nginx/logs/m-access-${last_d}.log.gz /opt/shell_app/caffrey/tmp/
cd /opt/shell_app/caffrey/tmp
gzip -d m-access-${last_d}.log.gz

cat m-access-${last_d}.log | grep -v HEAD | grep /newEnergy/ | grep -v /newEnergy/html/ | grep -v /smalltwo/> n.log
cat m-access-${last_d}.log | grep -v HEAD | grep /charge/ | grep -v /charge/html/ | grep -v /smalltwo/> c.log
cat m-access-${last_d}.log | grep -v HEAD | grep /hourlyRate/ | grep -v /smalltwo/> h.log

cat m-access-${last_d}.log | grep /smalltwo/web > m.log
cat m-access-${last_d}.log | grep /smalltwo/wep  >> m.log
cat m-access-${last_d}.log | grep /smalltwo/pay >> m.log
cat m-access-${last_d}.log | grep /smalltwo/uploadServlet  >> m.log
cat m-access-${last_d}.log | grep /pay/allpaywep/ >> m.log

cat m.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > www_1.log
cat n.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > newenergy_1.log
cat c.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > charge_1.log
cat h.log |awk -F '"' '{print $2,$3,$9}' | awk '{print $2,$4,$6}'| grep -v "/ 200 0.000" > hourly_1.log

rm -f m.log
rm -f n.log
rm -f c.log
rm -f h.log

python /opt/shell_app/caffrey/t.py www_1.log m-www.log
python /opt/shell_app/caffrey/t.py newenergy_1.log m-newenergy.log
python /opt/shell_app/caffrey/t.py charge_1.log m-charge.log
python /opt/shell_app/caffrey/t.py hourly_1.log m-hourly.log
rm -f www_1.log newenergy_1.log charge_1.log hourly_1.log

sed -i 's|//|/|g' m-www.log
sed -i 's/\/smalltwo//g' m-www.log
sed -i 's|//|/|g' m-newenergy.log
sed -i 's|//|/|g' m-charge.log
sed -i 's|//|/|g' m-hourly.log
rm -f m-access-${last_d}.log

cat m-www.log >> www.log
cat m-newenergy.log >> newenergy.log
cat m-charge.log >> charge.log
cat m-hourly.log >> hourly.log
rm -f m-www.log m-newenergy.log m-charge.log m-hourly.log
cd -
