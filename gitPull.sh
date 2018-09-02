cd /root
mkdir tempdir
cd tempdir
yum -y install sshpass
git clone https://github.com/git-training-repo/Docker.git
cd Docker
for entry in "$PWD"/*
do
  echo "$entry"
  sshpass -p "Qwerty12" scp $entry root@192.168.56.4:/opt/DEVOPS/Docker
done
cd /opt/DEVOPS/Demo
sshpass -p "Qwerty12" scp identityiq.war root@192.168.56.4:/opt/DEVOPS/Docker
echo "Placed Files on Node, Job done"
