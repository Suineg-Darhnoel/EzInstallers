sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common
sudo rm -rf /usr/local/share/vim /usr/bin/vim

git clone https://github.com/vim/vim/ ~/vimtemp
cd ~/vimtemp
git pull

./configure \
--enable-multibyte \
--enable-perlinterp=dynamic \
--enable-rubyinterp=dynamic \
--with-ruby-command=/usr/bin/ruby \
--enable-pythoninterp=dynamic \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="rathnak" \
--enable-fail-if-missing

make && sudo make install
