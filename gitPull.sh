#cd /root
#mkdir tempdir
#cd tempdir
yum -y install sshpass
#git clone https://github.com/git-training-repo/Docker.git
cd Docker

#cleaning Repo
sshpass -p "Qwerty12" scp cleanRepoNode.sh root@192.168.56.4:/opt/DEVOPS/Docker
sshpass -p "Qwerty12" ssh root@192.168.56.4 'bash /opt/DEVOPS/Docker/cleanRepoNode.sh'

for entry in "$PWD"/*
do
  echo "$entry"
  sshpass -p "Qwerty12" scp $entry root@192.168.56.4:/opt/DEVOPS/Docker
done

cd /opt/DEVOPS/Demo/Dev_War
sshpass -p "Qwerty12" scp identityiq.war root@192.168.56.4:/opt/DEVOPS/Docker
echo "Placed Files on Node, Job done"
