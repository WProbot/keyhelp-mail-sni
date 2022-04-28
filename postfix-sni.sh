#!/bin/bash

  cd /etc/postfix

  ls /etc/ssl/keyhelp/letsencrypt/*/mail.*/private.pem | gawk '

    /mail[.]/ {
      p = f = $1;
      gsub("private[.]pem", "fullchain.pem", f);
      gsub("/private[.]pem", "");
      gsub("^.*/", "");
      print $0, p, f;
    }

  ' > 00-postfix-sni.conf

  postmap -F hash:00-postfix-sni.conf

  systemctl restart postfix
