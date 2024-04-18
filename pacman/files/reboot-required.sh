#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly reboot_file="/var/run/reboot-required"

check_libs() {
    local libs=$(lsof -n +c 0 2> /dev/null | grep 'DEL.*lib' | awk '1 { print $1 ": " $NF }' | sort -u)
    [[ -n "${libs}" ]] &&  echo "${libs}" >> ${reboot_file} || true
}

check_kernel() {
    local active_kernel_version=$(uname -r |sed 's/-[a-z]*$//' | sed 's/^ *//')
    local active_kernel_type=$(uname -r |sed "s/${active_kernel_version}//")

    local installed_kernel=$(pacman -Q linux-lts | sed "s/linux${active_kernel_type}//" | sed 's/^ *//')
#    echo "-${installed_kernel}-"
#    echo "-${active_kernel_version}-"

    [[ $active_kernel_version != $installed_kernel ]] &&  echo "KERNEL: reboot required" >> ${reboot_file} || true
}

main() {
    check_libs
    check_kernel
}


main "${@}"

