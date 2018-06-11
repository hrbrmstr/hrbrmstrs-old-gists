basic httr idiom for splunk things tho it gets uglier with the saved searches

setup 3 variables in your `.Renviron` (the obvious ones from the code)

sample run:

    > tmp <- search_now("host=vagrant sourcetype=syslog session closed")
    > head(tmp)
    
      X_serial                      X_time            source sourcetype    host index splunk_server
    1        0 2015-07-29 21:17:01.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
    2        1 2015-07-29 20:17:01.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
    3        2 2015-07-29 19:17:01.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
    4        3 2015-07-29 19:08:06.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
    5        4 2015-07-29 19:07:21.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
    6        5 2015-07-29 19:07:21.000 UTC /var/log/auth.log     syslog vagrant  main       vagrant
                                                                                            X_raw
    1    Jul 29 21:17:01 vagrant CRON[4389]: pam_unix(cron:session): session closed for user root
    2    Jul 29 20:17:01 vagrant CRON[2962]: pam_unix(cron:session): session closed for user root
    3    Jul 29 19:17:01 vagrant CRON[1704]: pam_unix(cron:session): session closed for user root
    4          Jul 29 19:08:06 vagrant sudo: pam_unix(sudo:session): session closed for user root
    5 Jul 29 19:07:21 vagrant sshd[1167]: pam_unix(sshd:session): session closed for user vagrant
    6          Jul 29 19:07:21 vagrant sudo: pam_unix(sudo:session): session closed for user root