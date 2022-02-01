#!/bin/bash

if [ $# -eq 0 ]
   then
      echo "Build requires a version number (e.g. 0.1.0) !"
      exit
fi

VERSION=$1

echo "Pretty UCI Registrar Build ver. ${VERSION}"
echo "====================================="
echo
echo "Creating temporary directory & copying source..."

mkdir temp
mkdir temp/firefox
mkdir temp/chrome

cp -r ./src/* ./temp/firefox
cp -r ./src/* ./temp/chrome

echo 
echo "Adjusting manifest version and PUR version for firefox..."
node -p "JSON.stringify({...require('./temp/firefox/manifest.json'), manifest_version: 2, version: '$VERSION'}, null, 2)" > ./temp/firefox/new_manifest.json
mv ./temp/firefox/new_manifest.json ./temp/firefox/manifest.json

echo "Adjusting manifest version and PUR version for chrome..."
node -p "JSON.stringify({...require('./temp/chrome/manifest.json'), manifest_version: 3, version: '$VERSION'}, null, 2)" > ./temp/chrome/new_manifest.json
mv ./temp/chrome/new_manifest.json ./temp/chrome/manifest.json

echo
echo "Creating release directory..."

mkdir releases/$VERSION

echo
echo "Creating firefox release..."
cd ./temp/firefox/
zip -r "../../releases/$VERSION/pur_${VERSION}_firefox.zip" ./*
cd ../..

echo "Creating chrome release..."
cd ./temp/chrome/
zip -r "../../releases/$VERSION/pur_${VERSION}_chrome.zip" ./*
cd ../..

echo
echo "Removing temporary directory..."
rm -rf ./temp

echo
echo "Done."