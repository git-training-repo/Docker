#Pushing to docker hub
#specify login credentials here(1)
docker login -u="veboddu" -p="Chinnu@30"
#image name must be iiqpuppet 
imgid=$(docker images -q iiqpuppet)
echo $imgid
#specify login credentials here(2)
docker tag $imgid veboddu/beatles:iiqpuppet
#specify login credentials here(3)
docker push veboddu/beatles
echo "Pushed to docker hub"

