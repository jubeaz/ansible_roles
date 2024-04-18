Role Name
=========


https://blog.raw.pm/en/archlinux-install-blackarch-without-gnupg-behind-proxy/

$ wget https://blackarch.org/keyring/blackarch-keyring.pkg.tar.xz
$ tar xaf https://blackarch.org/keyring/blackarch-keyring.pkg.tar.xz
# pacman-key --add usr/share/pacman/keyrings/blackarch.gpg
$ pacman-key -f keyid 4345771566D76038C7FEB43863EC0ADBEA87E4E3
# pacman-key --lsign-key 4345771566D76038C7FEB43863EC0ADBEA87E4E3
$ rm -r ./usr
$ rm blackarch-keyring.pkg.tar.xz

$ curl -O  https://blackarch.org/strap.sh  # Run https://blackarch.org/strap.sh as root and follow the instructions.

$ sha1sum strap.sh  # The SHA1 sum should match: 34b1a3698a4c971807fb1fe41463b9d25e1a4a09

$ chmod +x strap.sh # Set execute bit
$ vim strap.sh  # Comment line 157: verify_keyring

$ sudo ./strap.sh # Run strap.sh
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

