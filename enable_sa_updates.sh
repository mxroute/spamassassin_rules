mkdir /root/MX-Scripts
wget https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/update_sa_rules.sh -P /root/MX-Scripts
chmod +x /root/MX-Scripts/update_sa_rules.sh
echo "0 * * * * /bin/bash /root/MX-Scripts/update_sa_rules.sh >/dev/null 2>&1" >> /var/spool/cron/root
