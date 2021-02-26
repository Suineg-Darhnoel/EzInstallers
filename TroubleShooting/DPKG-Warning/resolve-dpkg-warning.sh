for package in $(cat dpkg-warning.txt | grep "warning: files list file" | sed "s/'//g" | sed "s/\`//g"|awk '{print $8}'); do sudo apt-get purge "$package" -y; sudo apt-get install "$package" -y;done
