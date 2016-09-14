# -*- coding: utf-8 -*-
'''
发送带附件邮件
'''

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib,sys

#创建一个带附件的实例
msg = MIMEMultipart()

#构造附件1
att1 = MIMEText(open('/opt/shell_app/caffrey/tmp/www_report.txt', 'rb').read(), 'base64', 'gb2312')
att1["Content-Type"] = 'application/octet-stream'
att1["Content-Disposition"] = 'attachment; filename="www_report.txt"'#这里的filename可以任意写，写什么名字，邮件中显示什么名字
msg.attach(att1)

#构造附件2
att2 = MIMEText(open('/opt/shell_app/caffrey/tmp/newenergy_report.txt', 'rb').read(), 'base64', 'gb2312')
att2["Content-Type"] = 'application/octet-stream'
att2["Content-Disposition"] = 'attachment; filename="newenergy_report.txt"'
msg.attach(att2)

#构造附件3
att3 = MIMEText(open('/opt/shell_app/caffrey/tmp/hourly_report.txt', 'rb').read(), 'base64', 'gb2312')
att3["Content-Type"] = 'application/octet-stream'
att3["Content-Disposition"] = 'attachment; filename="hourly_report.txt"'
msg.attach(att3)

#构造附件4
att4 = MIMEText(open('/opt/shell_app/caffrey/tmp/charge_report.txt', 'rb').read(), 'base64', 'gb2312')
att4["Content-Type"] = 'application/octet-stream'
att4["Content-Disposition"] = 'attachment; filename="charge_report.txt"'
msg.attach(att4)


#加邮件头
msg['to'] = sys.argv[1]
msg['from'] = 'xiaoerzucheops@sina.com'
msg['subject'] = 'nginx log report'
#发送邮件
try:
    server = smtplib.SMTP()
    server.connect('smtp.sina.com')
    server.login('xiaoerzucheops@sina.com','xiaoerops88@')
    server.sendmail(msg['from'], msg['to'],msg.as_string())
    server.quit()
    print '发送成功'
except Exception, e:  
    print str(e) 
