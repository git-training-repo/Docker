cd /root
mkdir tempdir
cd tempdir
#cleaning Repo
sshpass -p "Qwerty12" ssh root@192.168.56.4 'bash /opt/DEVOPS/Docker/cleanRepoNode.sh'
echo "Docker Push Job done"
yum -y install sshpass
git clone https://github.com/git-training-repo/Docker.git
cd Docker
for entry in "$PWD"/*
do
  echo "$entry"
  sshpass -p "Qwerty12" scp $entry root@192.168.56.4:/opt/DEVOPS/Docker
done
cd /opt/DEVOPS/Demo/Dev_War
sshpass -p "Qwerty12" scp identityiq.war root@192.168.56.4:/opt/DEVOPS/Docker
echo "Placed Files on Node, Job done"
