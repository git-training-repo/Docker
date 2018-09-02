#Pushing to docker hub
#specify login credentials here(1)
docker login -u="veboddu" -p="Chinnu@30"
#image name must be iiq
imgid=$(docker images -q iiq)
echo $imgid
#specify login credentials here(2)
docker tag $imgid veboddu/beatles:iiq
#specify login credentials here(3)
docker push veboddu/beatles
echo "Pushed to docker hub"

