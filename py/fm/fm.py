#!/usr/local/bin/python3


import imaplib, ssl
import smtplib, email.mime.text
import sys
import os.path
import email
import subprocess
import mailbox

import configparser

import urllib.parse


cfg = configparser.ConfigParser()
#cfg.read(os.path.expanduser("~/.oma_mbox"))
cfg.read(".fmrc")

headers_to_keep = ['from', 'subject', 'to', 'cc', 'bcc', 'in-reply-to', 'message-id', 'date', 'user-agent', 'content-type', 'content-language', 'content-transfer-encoding', 'content-length', 'return-path', 'x-mailer', 'mime-version', 'status', 'lines']

mbox_archive = mailbox.mbox("INBOX.mbox")

mbox_archive.lock()

context = ssl.create_default_context()

conn = imaplib.IMAP4_SSL(host=cfg['default']['server'], port=993, ssl_context=context)
conn.login(cfg['default']['address'], cfg['default']['password'])
conn.select("INBOX", False)
#t, d = conn.search(None, "(UNSEEN)")
t, d = conn.search(None, "ALL")
allcount = len(d[0].split())
for msg_number in d[0].split():
    print(str(msg_number) + "/" + str(allcount))
    #msg_number: bytes
    #print(msg_number)
    msg_t, msg_d = conn.fetch(msg_number, "(RFC822)")
    #msg_t, msg_d = conn.fetch(msg_number, "(UID BODY[TEXT])")
    msg = email.message_from_bytes(msg_d[0][1])
    mbox_archive.add(msg)


    if msg['subject'] == None:
        subject = "None"
    else:
        subject, subject_enc = email.header.decode_header(msg['subject'])[0]
        if not subject_enc == None:
            if subject_enc == "unknown-8bit":
                subject = subject.decode("ISO-8859-13")
            else:
                subject = subject.decode(subject_enc)

    print("'%s'\n" % subject)





#    from_name, from_addr = email.utils.parseaddr(msg['from'])
#    to_name, to_addr = email.utils.parseaddr(msg['to'])
#    subject, subject_enc = email.header.decode_header(msg['subject'])[0]
#    if not subject_enc == None:
#        subject = subject.decode(subject_enc)
#    print("From:    %s" % from_addr)
#    print("Subject: %s" % subject)
#    print("To:      %s" % to_addr)
#    body = ""
#    for part in msg.walk():
#        if part.get_content_type() == "text/html":
#            body += "\n--------------- HTML STRIPPED ----------------\n"
#            body += office_to_normal(part.get_payload(decode=True).decode(part.get_charsets()[0]))
#            body += "\n--------------- HTML STRIPPED -------------END\n\n"
#        if part.get_content_type() == "text/plain":
#            if part.get_charsets()[0] is None:
#                tmp_part = part.get_payload(decode=True)
#                if isinstance(tmp_part, bytes):
#                    tmp_part = tmp_part.decode()
#                body += tmp_part
#            else:
#                body += part.get_payload(decode=True).decode(part.get_charsets()[0])
#    if isinstance(body, bytes):
#        body = body.decode()
#
#    actual_headers = [h for h in msg.keys()]
#    #print(actual_headers)
#    #print(msg._headers)
#    to_del = []
#    for h in msg._headers:
#        if not h[0].lower() in headers_to_keep:
#            to_del.append(h)
#
#    for d in to_del:
#        msg._headers.remove(d)


    # process safelinks

    # process safelinks end





#    msg2 = email.mime.text.MIMEText(safelink_process_body(body))
#    msg2._headers = msg._headers
#    msg2.replace_header("Content-Type", "text/plain")
    msg_t, msg_d = conn.store(msg_number, "+FLAGS", "\\Deleted")
conn.expunge()
conn.close()
conn.logout()

mbox_archive.unlock()
