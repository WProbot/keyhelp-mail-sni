#!/bin/bash

#
# go-keyhelp-mail-sni.sh
#

  ls -1 /etc/ssl/keyhelp/letsencrypt/*/mail.*/private.pem | gawk '

    BEGIN {
      dov = "/etc/dovecot/conf.keyhelp.d/12-dovecot-sni.conf";
      pfx = "/etc/postfix/00-postfix-sni.conf";
    }

    /mail[.]/ {

      p = f = $1;

      gsub("private[.]pem", "fullchain.pem", f);
      gsub("/private[.]pem", "");
      gsub("^.*/", "");

      print "local_name", $0, "{" > dov;
      print "  ssl_key = <"  p > dov;
      print "  ssl_cert = <" f > dov;
      print "}" > dov;

      print $0, p, f > pfx;

      print $0;

    }

  '

  cd /etc/postfix

  postmap -F hash:00-postfix-sni.conf

  systemctl restart postfix

  systemctl restart dovecot

#
#  postfix main.cf
#
#  # SNI support
#  tls_server_sni_maps = hash:/etc/postfix/00-postfix-sni.conf
ű
