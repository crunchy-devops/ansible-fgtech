# Python3 install 

## on Centos7
```shell
yum install centos-release-scl
sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/*.repo   \
    && sed -i 's/^#.*baseurl=http/baseurl=http/g' /etc/yum.repos.d/*.repo \
    && sed -i 's/^mirrorlist=http/#mirrorlist=http/g' /etc/yum.repos.d/*.repo
yum install  rh-python38
ln -s /opt/rh/rh-python38/root/usr/bin/python3 /usr/bin/python3
python3 -V


## from sources
```shell
sudo dnf groupinstall -y "Development tools"
sudo dnf install libffi-devel
cd /tmp/
wget https://www.python.org/ftp/python/3.13.10/Python-3.13.10.tgz
tar xzf Python-3.13.10.tgz
cd Python-3.13.10

./configure --prefix=/opt/python31310/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi 
make -j "$(nproc)"
sudo make altinstall
sudo -s
cd /opt
ln -s python31310 python3
vi ~/.bash_profile
# add or modify
export PATH=/opt/python3/bin:.....$PATH



```