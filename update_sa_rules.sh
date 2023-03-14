#!/bin/bash
wget https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/local.cf -O /etc/mail/spamassassin/local.cf
/scripts/restartsrv_spamd
