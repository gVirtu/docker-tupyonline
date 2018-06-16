set -e
echo "Build date: $BUILDDATE"
echo "Build rev.: $BUILDREV"

# Build the node:alpine docker image to run webpack and
# generate the most recent build files.

docker build -t tupy-docker \
             -f ./www/Dockerfile ./www/

HOST_UID=`id -u`
HOST_GID=`id -g`

docker run --rm \
            -v "$PWD/www/v5-unity":/opt/app \
            -w /opt/app \
            -t tupy-docker \
            sh -c "yarn install; \
                   ./node_modules/.bin/tsd install; \
                   pip3 install --user -r requirements.txt; \
                   ./node_modules/.bin/webpack --config webpack.config.js --mode production;
                   echo \"Done building. Setting owner to $HOST_UID:$HOST_GID\";
                   chown -R $HOST_UID:$HOST_GID ."

docker build --build-arg VCS_REF=$BUILDREV --build-arg BUILD_DATE=$BUILDDATE -t $REPO .
docker run --rm $REPO python3 -m tupy -h
