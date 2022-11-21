#!/bin/bash
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service


# try to remove each snap. Keep trying each one until they're all gone.
installed_snaps=$(snap list | grep -v Name | cut -d ' ' -f1)

until [ -z "$installed_snaps" ]; do
 
    for snap_package in $installed_snaps; do
        sudo snap remove --purge $snap_package
    done
    
    installed_snaps=$(snap list | grep -v Name | cut -d ' ' -f1)
done

# uninstall snapd
sudo apt-get autoremove --purge -y snapd

rm -rf ~/snap

# Prevent snap from being reinstalled
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

