# todo

* ufw
* compile haproxy from source to have TCP inspection

need version 3.3

HTX is disabled → no HTTP inspection in TCP mode → no req.proto_http → no HTTP ACL

Without HTX, a TCP frontend sees only raw bytes.
No headers, no HTTP detection — nothing.

in order to route http to nginx

HTX creates an internal, native representation of the HTTP protocol(s). It creates strongly typed, well-delineated header fields and allows for gaps and out-of-order fields.

```
frontend mixed_listener
    bind 10.10.14.6:880
    bind 192.168.10.21:880
    mode tcp

    # Allow TLS/HTTP inspection
    tcp-request inspect-delay 2s
    tcp-request content accept if HTTP
    # tcp-request content capture req.proto_http len 1


    # ACLs
    acl is_http  HTTP
    acl from_10net src 10.0.0.0/8
    acl from_192net src 192.168.0.0/16

    # Routing
    use_backend backend_http if is_http
    use_backend backend_8871 if !is_http from_10net
    use_backend backend_8870 if !is_http from_192net

    default_backend backend_reject 
```

as `root`:
```bash
cd /usr/src
git clone --branch v3.2.0 https://github.com/haproxy/haproxy.git
cd haproxy


make TARGET=linux-glibc  USE_OPENSSL=1 USE_PCRE2=1 USE_ZLIB=1 USE_LUA=0  USE_HTX=1 USE_PCRE2_JIT=1 USE_GETADDRINFO=1 USE_QUIC=1

make install
```


```bash
$ cat /etc/systemd/system/multi-user.target.wants/haproxy.service
[Unit]
Description=HAProxy Load Balancer
After=network-online.target
Wants=network-online.target

[Service]
EnvironmentFile=-/etc/default/haproxy
EnvironmentFile=-/etc/sysconfig/haproxy
Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid" "EXTRAOPTS=-S /run/haproxy-master.sock"
ExecStart=/usr/bin/haproxy -Ws -f $CONFIG -p $PIDFILE $EXTRAOPTS
ExecReload=/usr/bin/haproxy -Ws -f $CONFIG -c $EXTRAOPTS
ExecReload=/bin/kill -USR2 $MAINPID
KillMode=mixed
Restart=always
SuccessExitStatus=143
Type=notify

# The following lines leverage SystemD's sandboxing options to provide
# defense in depth protection at the expense of restricting some flexibility
# in your setup (e.g. placement of your configuration files) or possibly
# reduced performance. See systemd.service(5) and systemd.exec(5) for further
# information.

# NoNewPrivileges=true
# ProtectHome=true
# If you want to use 'ProtectSystem=strict' you should whitelist the PIDFILE,
# any state files and any other files written using 'ReadWritePaths' or
# 'RuntimeDirectory'.
# ProtectSystem=true
# ProtectKernelTunables=true
# ProtectKernelModules=true
# ProtectControlGroups=true
# If your SystemD version supports them, you can add: @reboot, @swap, @sync
# SystemCallFilter=~@cpu-emulation @keyring @module @obsolete @raw-io

[Install]
WantedBy=multi-user.target
```