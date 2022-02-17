#!/bin/bash

if [ $# -eq 0 ]
   then
      echo "Build requires a version number (e.g. 0.1.0) !"
      exit
fi

VERSION=$1

ACCESSIBLE_RESOURCES='"styles/global.css", "styles/prereqs.css", "styles/search-form.css", "styles/search-results.css", "styles/secure-login.css", "styles/webreg-home.css", "styles/webreg-home.css"'
ACCESSIBLE_RESOURCES_URL="*://login.uci.edu/*"

POPUP_TITLE="Pretty UCI Registrar Options"
POPUP_SRC="popup.html"

echo "Building Pretty UCI Registrar v${VERSION}"
echo "====================================="
echo
echo "Creating temporary directory & copying source..."

mkdir temp
mkdir temp/firefox
mkdir temp/chrome

cp -r ./src/* ./temp/firefox
cp -r ./src/* ./temp/chrome

echo
echo "Adjusting manifest version and PUR version for Firefox..."
node -p "JSON.stringify({...require('./temp/firefox/manifest.json'), manifest_version: 2, version: '$VERSION', page_action: { default_title: '$POPUP_TITLE', default_popup: '$POPUP_SRC' }, web_accessible_resources: [ $ACCESSIBLE_RESOURCES ]}, null, 2)" > ./temp/firefox/new_manifest.json
mv ./temp/firefox/new_manifest.json ./temp/firefox/manifest.json

echo "Adjusting manifest version and PUR version for Chrome..."
node -p "JSON.stringify({...require('./temp/chrome/manifest.json'), manifest_version: 3, version: '$VERSION', action: { default_title: '$POPUP_TITLE', default_popup: '$POPUP_SRC' }, web_accessible_resources: [ { resources: [ $ACCESSIBLE_RESOURCES ], matches: [ '$ACCESSIBLE_RESOURCES_URL' ] } ]}, null, 2)" > ./temp/chrome/new_manifest.json
mv ./temp/chrome/new_manifest.json ./temp/chrome/manifest.json

echo
echo "Creating release directory..."

mkdir releases/$VERSION

echo
echo "Creating Firefox release..."
cd ./temp/firefox/
zip -r "../../releases/$VERSION/pur_${VERSION}_firefox.zip" ./*
cd ../..

echo "Creating Chrome release..."
cd ./temp/chrome/
zip -r "../../releases/$VERSION/pur_${VERSION}_chrome.zip" ./*
cd ../..

echo
echo "Removing temporary directory..."
rm -rf ./temp

echo
echo "Done."