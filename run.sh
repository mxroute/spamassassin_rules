#!/bin/bash

# Build the top
# https://github.com/mxroute/spamassassin_rules

rm -f local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/header >> local.cf
echo "" >> local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/trusted_networks >> local.cf
echo "" >> local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/blacklist_from >> local.cf
echo "" >> local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/whitelist_from >> local.cf
echo "" >> local.cf
curl https://raw.githubusercontent.com/mxroute/spamassassin_rules/main/score >> local.cf

# Blacklisted Senders
# https://github.com/mxroute/rspamd_rules/blob/master/lists/blacklisted-sender-strings.map

echo -n "\nheader SPAMDOMAINS From =~ /" >> local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/blacklisted-sender-strings.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> local.cf
echo "describe SPAMDOMAINS Spammers" >> local.cf
echo "score SPAMDOMAINS 10" >> local.cf

# Body Spam
# https://github.com/mxroute/rspamd_rules/blob/master/lists/body-spam.map

echo -n "\nheader GENSPAMBODY From =~ /" >> local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/body-spam.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> local.cf
echo "describe GENSPAMBODY Email contained known spam string" >> local.cf
echo "score GENSPAMBODY 10" >> local.cf

# Subject Spam
# https://github.com/mxroute/rspamd_rules/blob/master/lists/subject-spam.map

echo -n "\nheader GENSPAMSUBJ Subject =~ /" >> local.cf &&
curl https://raw.githubusercontent.com/mxroute/rspamd_rules/master/lists/subject-spam.map | sed 's/\///' | sed 's/\/i//' | sed 's/(//' | sed 's/)//' |
while IFS= read -r line
do
	echo -n "$line|"
done | rev | cut -c 2- | rev | sed '1s/^/(/' | sed 's/$/)\/i/' >> local.cf
echo "describe GENSPAMSUBJ Subject contained known spam string" >> local.cf
echo "score GENSPAMSUBJ 10" >> local.cf
echo "" >> local.cf
echo "# Last edited $(date)" >> local.cf
