Role Name
=========
https://discourse.haproxy.org/t/acl-based-on-client-cn-in-tcp-mode-version-1-7-10/3302

frontend Frontend_server
  mode tcp
  option tcplog
  log global
  bind X.X.X.X:8000 ssl crt /etc/certs/server.pem ca-file /etc/certs/ca.crt verify required
  acl ACL_SRV1 ssl_c_s_dn(cn) -m str -f /etc/SRV1/cn.list
  acl ACL_SRV2 ssl_c_s_dn(cn) -m str -f /etc/SRV2/cn.list  
  log-format %ci:%cp\ [%t]\ %ft\ %b/%s\ %ST\ %B\ %tsc\ %ac/%fc/%bc/%sc\ %sq/%bq\ {%[ssl_c_verify],%{+Q}[ssl_c_s_dn],%{+Q}[ssl_c_i_dn]

  use_backend SRV1 if ACL_SRV1
  use_backend SRV2 if ACL_SRV2

backend SRV1
  mode tcp
  option tcplog
  option tcp-check
  server MY_SRV1 X.X.X.X:22 check  inter 1000 port 22 maxconn 1000
backend SRV2
  mode tcp
  option tcplog
  option tcp-check
  server MY_SRV2 X.X.X.X:22 check  inter 1000 port 22 maxconn 1000

Requirements
------------

Role Variables
--------------

Dependencies
------------

Example Playbook
----------------

License
-------

Author Information
------------------

