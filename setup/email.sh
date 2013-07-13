#!/bin/bash
# Setup email server on Ubuntu 12.04 LTS EC2 instance

# Install postfix server
# https://help.ubuntu.com/community/Postfix
sudo apt-get install postfix

# Configure postfix server
sudo dpkg-reconfigure postfix

sudo postconf -e 'home_mailbox = Maildir/'
sudo postconf -e 'mailbox_command ='

sudo postconf -e 'smtpd_sasl_local_domain ='
sudo postconf -e 'smtpd_sasl_auth_enable = yes'
sudo postconf -e 'smtpd_sasl_security_options = noanonymous'
sudo postconf -e 'broken_sasl_auth_clients = yes'
sudo postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination'
sudo postconf -e 'inet_interfaces = all'

sudo touch /etc/postfix/sasl/smtpd.conf
sudo chmod 666 /etc/postfix/sasl/smtpd.conf
sudo echo "pwcheck_method: saslauthd" >> /etc/postfix/sasl/smtpd.conf
sudo echo "mech_list: plain login" >> /etc/postfix/sasl/smtpd.conf
sudo chmod 644 /etc/postfix/sasl/smtpd.conf


openssl genrsa 1024 > smtpd.key
chmod 600 smtpd.key

openssl req -new -key smtpd.key -x509 -days 3650 -out smtpd.crt # has prompts

openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650 # has prompts

sudo mv smtpd.key /etc/ssl/private/
sudo mv smtpd.crt /etc/ssl/certs/
sudo mv cakey.pem /etc/ssl/private/
sudo mv cacert.pem /etc/ssl/certs/

sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'
sudo postconf -e 'smtpd_tls_auth_only = no'
sudo postconf -e 'smtp_tls_note_starttls_offer = yes'
sudo postconf -e 'smtpd_tls_key_file = /etc/ssl/private/smtpd.key'
sudo postconf -e 'smtpd_tls_cert_file = /etc/ssl/certs/smtpd.crt'
sudo postconf -e 'smtpd_tls_CAfile = /etc/ssl/certs/cacert.pem'
sudo postconf -e 'smtpd_tls_loglevel = 1'
sudo postconf -e 'smtpd_tls_received_header = yes'
sudo postconf -e 'smtpd_tls_session_cache_timeout = 3600s'
sudo postconf -e 'tls_random_source = dev:/dev/urandom'
sudo postconf -e 'myhostname = mail.rechargedialysis.com'

# Restart postfix daemon
sudo /etc/init.d/postfix restart

# Install postfix auth modules
sudo apt-get install -f libsasl2-2
sudo apt-get install -f sasl2-bin
sudo apt-get install -f libsasl2-modules

# Edit /etc/default/saslauthd manually according to 
# https://help.ubuntu.com/community/Postfix

# Update dpkg state
sudo dpkg-statoverride --force --update --add root sasl 755 /var/spool/postfix/var/run/saslauthd

# Start saslauthd
sudo /etc/init.d/saslauthd start

# Install mailx package
sudo apt-get install mailutils

# Install courier pop3 and imp servers
sudo apt-get install courier-pop
sudo apt-get install courier-imap

# Confirm that server is not behind a firewall blocking ports 25, 110, and 143
