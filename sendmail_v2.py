# -*- coding: utf-8 -*-
'''
发送带附件邮件
'''

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib,sys
  
def send_mail(to_list,sub,content):  
    me="xiaoerzucheops@sina.com" 
    msg = MIMEText(content,_subtype='plain',_charset='gb2312')  
    msg['Subject'] = sub  
    msg['From'] = me  
    msg['To'] = ";".join(to_list)  
    try:  
    	server = smtplib.SMTP()
    	server.connect('smtp.sina.com')
    	server.login('xiaoerzucheops@sina.com','xiaoerops88@')
    	server.sendmail(msg['from'], msg['to'],msg.as_string())
        return True  
    except Exception, e:  
        print str(e)  
        return False  

if __name__ == '__main__':  
    mailto_list = ["345485258@qq.com"]
    file_name = sys.argv[1]
    file_obj = open(file_name,"r")
    content = file_obj.read()
    print content
    file_obj.close()
    if send_mail(mailto_list,"nginx log report",str(content)):  
        print "发送成功"  
    else:  
        print "发送失败"

