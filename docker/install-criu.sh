

cd /tmp
mkdir criu
cd criu
curl -o criu-3.8.1.tar.bz2 https://download.openvz.org/criu/criu-3.8.1.tar.bz2

ls

tar xjf criu-3.8.1.tar.bz2

cd criu-3.8.1
make
