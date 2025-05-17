#!/usr/bin/env bash

declare -r ovpn_config_path="/etc/openvpn/client/nord.ovpn"
#declare -r nm_config_path=/etc/NetworkManager/system-connections/nord.nmconnection
declare -r db_path="/etc/openvpn/db.nordvpn"

# usage function
function usage()
{
   cat << HEREDOC

   Usage: $progname command [ command opts] [ command args ]
   Commands:
        start [country_code number] default: de 990
        stop
HEREDOC
}


construct_db() {
  echo "Stat building DB"
  echo "" > $db_path
  for file in $(ls /etc/openvpn/ovpn_tcp); do
    prefix=$(cut -d. -f 1 <<<"$file")
    ip=$(cat /etc/openvpn/ovpn_tcp/${file} |grep "^remote [0-9]" | cut -d' ' -f2)
    port=$(cat /etc/openvpn/ovpn_tcp/${file} |grep "^remote [0-9]" | cut -d' ' -f3)
    #echo "file: ${file} prefixe: ${prefix} ip: $ip"
    echo "${prefix} $ip $port" >> $db_path
  done
  echo "End building DB"
}

get_db_server() {
  server_ip=""
  prefix="${country}${id}"
  server_ip=$(cat $db_path | grep $prefix | cut -d' ' -f 2)
}

#set_nm_server() {
#  get_db_server
#  if [[ ! -z $server_ip ]] ; then
#    echo "Setting new server $prefix with IP $server_ip"
#    sed -i "s/^remote=[0-9].*/remote=${server_ip}:443/" $config_path
#    sed -i "s/^id=*/id=${prefix}/" $config_path
#  else
#    echo "Server not found stay on previous server"
#    get_nm_server
#  fi
#}
#
#get_nm_server() {
#  server_ip=""
#  server_ip=$(cat $config_path |grep "remote=[0-9]" |cut -d'=' -f 2 | cut -d':' -f 1)
#  echo "configured server ip $server_ip"
#}


# SET THE SERVER IP INTO CONFIG
set_openvpn_server() {
  get_db_server
  if [[ ! -z $server_ip ]] ; then
    echo "Setting new server $prefix with IP $server_ip"
    sed -i "s/^remote [0-9].*/remote ${server_ip} 443/" $config_path
    sed -i "s/^verify-x509-name .*/verify-x509-name CN=${prefix}.nordvpn.com/" $config_path

  else
    echo "Server $prefix not found stay on current server"
    get_openvpn_server
  fi
}

# GET THE SERVER IP FROM THE CURRENT CONFIG
get_openvpn_server() {
  server_ip=""
  server_ip=$(cat $config_path |grep "remote [0-9]" |cut -d' ' -f 2)
  echo "configured server ip $server_ip"
}

del_vpn_rule () {
  echo "ip= $server_ip"
  local rules=$(ufw status numbered |grep "$server_ip"  | cut -d']' -f1 | tr -d '\n' | tr -d '[')
  #echo "ufw status numbered |grep "$server_ip"  | cut -d']' -f1 | tr -d '\n' | tr -d '['"
  for rule in $rules ; do
    echo "Removing rule ${rule}"
    ufw --force delete  ${rule}
  done
}

# allow rule for nord server on eth0
add_vpn_rule () {
  ufw allow out on eth0 to ${server_ip} proto tcp port 443
}

set_nord_dns() {
    is_nord_vpn_dns=$(cat /etc/resolv.conf /etc/resolv.conf.nord | wc -l)
    if [[ $is_nord_vpn_dns -gt 0 ]] ; then
        cp /etc/resolv.conf /etc/resolv.conf.save
        cp /etc/resolv.conf.nord /etc/resolv.conf
    fi
}

unset_nord_dns() {
    if [[ -f /etc/resolv.conf.save ]]; then
        cp /etc/resolv.conf.save /etc/resolv.conf
    fi
}

restrict_to_tunnel() {
  ufw default deny outgoing
  sudo ufw allow out on tun0 from any to any
}

close_tunnel() {
  ufw default allow outgoing
  ufw delete allow out on tun0
}


start_openvpn() {
  if [[ ! -f $db_path ]] ; then
    construct_db
  fi
  country=${1:-"de"}
  id=${2:-"990"}
  stop_openvpn
  set_openvpn_server
  add_vpn_rule
  restrict_to_tunnel
  set_nord_dns
  openvpn $config_path
}

stop_openvpn() {
  echo "Stoping"
  get_openvpn_server
  del_vpn_rule
  close_tunnel
  unset_nord_dns
}

main() {
    config_path=$ovpn_config_path
    server_ip=""
    server_port=""
    [[ $# -eq 0 ]] && usage && exit
    case "$1" in
        start)
            shift
            start_openvpn "${@}"
            exit
            ;;
        stop)
            shift
            stop_openvpn
            ;;
        *)
            usage ; exit ; ;;
    esac
}

main "${@}"

#nmcli connection import type openvpn file /etc/openvpn/client/nord.ovpn
#Connection 'nord' (000cec36-989f-468c-8714-2ae5e921c3d9)





