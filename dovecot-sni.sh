#!/bin/bash

  cd /etc/dovecot

  ls /etc/ssl/keyhelp/letsencrypt/*/mail.*/private.pem | gawk '

    /mail[.]/ {
      p = f = $1;
      gsub("private[.]pem", "fullchain.pem", f);
      gsub("/private[.]pem", "");
      gsub("^.*/", "");
      print "local_name", $0, "{";
      print "  ssl_key = <"  p;
      print "  ssl_cert = <" f;
      print "}";
    }

  ' > 00-dovecot-sni.conf

  systemctl restart dovecot



