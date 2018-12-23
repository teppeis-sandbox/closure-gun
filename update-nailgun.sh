#!/bin/bash -eu

url=https://github.com/facebook/nailgun/releases/download
tag=nailgun-all-v1.0.0

mkdir -p nailgun

echo 'Downloading nailgun/server.jar'
curl -L -o nailgun/server.jar "$url/$tag/nailgun-server-1.0.0-SNAPSHOT.jar"

echo 'Downloading nailgun/ng'
curl -L -o nailgun/ng "$url/$tag/ng.py"

echo 'Changing permission of nailgun/ng'
chmod +x nailgun/ng

echo 'Complete'
