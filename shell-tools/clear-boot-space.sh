#! /bin/bash
dpkg --get-selections | grep 'linux-image.*[^de]install'
echo '----------- Run `sudo apt-get remove` on these linux images ----------'
dpkg --get-selections | grep 'linux-image.*[^de]install' | sed -n 's/.*\(linux-image-[0-9\.\-]\+\)-.*/\1/p'
echo '-----------Example----------'
dpkg --get-selections | grep 'linux-image.*[^de]install' | sed -n 's/.*\(linux-image-[0-9\.\-]\+\)-.*/sudo apt-get remove \1/p'
