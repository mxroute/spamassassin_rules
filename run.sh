#!/bin/bash

# Build the top
# https://github.com/mxroute/spamassassin_rules

rm -f /var/www/config/spam/local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/header >> /var/www/config/spam/local.cf
echo "" >> /var/www/config/spam/local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/trusted_networks >> /var/www/config/spam/local.cf
echo "" >> /var/www/config/spam/local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/blacklist_from >> /var/www/config/spam/local.cf
echo "" >> /var/www/config/spam/local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/whitelist_from >> /var/www/config/spam/local.cf
echo "" >> /var/www/config/spam/local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/score >> /var/www/config/spam/local.cf

# Blacklisted Senders
# https://github.com/mxroute/rspamd_rules/blob/master/lists/blacklisted-sender-strings.map

echo -n "\nheader SPAMDOMAINS From =~ /" >> /var/www/config/spam/local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/blacklisted-sender-strings.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> /var/www/config/spam/local.cf
echo "describe SPAMDOMAINS Spammers" >> /var/www/config/spam/local.cf
echo "score SPAMDOMAINS 10" >> /var/www/config/spam/local.cf

# Body Spam
# https://github.com/mxroute/rspamd_rules/blob/master/lists/body-spam.map

echo -n "\nheader GENSPAMBODY /" >> /var/www/config/spam/local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/body-spam.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> /var/www/config/spam/local.cf
echo "describe GENSPAMBODY Email contained known spam string" >> /var/www/config/spam/local.cf
echo "score GENSPAMBODY 10" >> /var/www/config/spam/local.cf

# Subject Spam
# https://github.com/mxroute/rspamd_rules/blob/master/lists/subject-spam.map

echo -n "\nheader GENSPAMSUBJ Subject =~ /" >> /var/www/config/spam/local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/subject-spam.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> /var/www/config/spam/local.cf
echo "describe GENSPAMSUBJ Subject contained known spam string" >> /var/www/config/spam/local.cf
echo "score GENSPAMSUBJ 10" >> /var/www/config/spam/local.cf
echo "" >> /var/www/config/spam/local.cf
echo "# Last edited $(date)" >> /var/www/config/spam/local.cf
