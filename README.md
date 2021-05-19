# spamassassin_rules

This is the framework for building local.cf on our cPanel boxes. We're building it out first by the pieces that we've always had at the top, then we're adding in dynamically our rspamd rules from another repo and converting them to SA rules. We're using run.sh to construct our final local.cf for deployment (which our cPanel servers pull over https).

If you copy the project, note that run.sh places local.cf in /var/www/config/spam by default and that may need to be changed to fit your needs.

Want to run our constantly changing anti-spam rules on your SpamAssassin server? Keep in mind that it was made for cPanel boxes and just run "enable_sa_updates.sh" on your system.
