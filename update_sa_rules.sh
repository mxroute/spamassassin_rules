#!/bin/bash
wget https://config.mxroute.com/spam/local.cf -O /etc/mail/spamassassin/local.cf
/scripts/restartsrv_spamd
