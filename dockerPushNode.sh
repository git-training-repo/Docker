#Pushing to docker hub
#specify login credentials here(1)
docker login -u="akshatjain4" -p="akshatjain4"
#image name must be iiq
imgid=$(docker images -q iiq)
echo $imgid
#specify login credentials here(2)
docker tag $imgid akshatjain4/newtest:iiq
#specify login credentials here(3)
docker push akshatjain4/newtest
echo "Pushed to docker hub"

