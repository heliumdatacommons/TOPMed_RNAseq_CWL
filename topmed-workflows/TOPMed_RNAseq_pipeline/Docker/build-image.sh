#!/bin/bash
imagename="heliumdatacommons/topmed-rnaseq"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
cd $DIR

docker build -t "$imagename" -f Dockerfile .
