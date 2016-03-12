#!/bin/bash

set -e

# Variables
ORIGIN_URL=`git config --get remote.origin.url`

echo "Publishing docs..."

# Checkout gh-pages branch.
if [ `git branch | grep gh-pages` ]
then
  git branch -D gh-pages
fi
git checkout -b gh-pages

# Build docs.
npm run docs

# Move generated docs to root and delete everything else.
find . -maxdepth 1 ! -name 'docs' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;
mv docs/* .
rm -R docs/

# Push to gh-pages.
git config user.name "$GITHUB_USERNAME"
git config user.email "$GITHUB_EMAIL"

git add -fA
git commit --allow-empty -m "$(git log -1 --pretty=%B) [ci skip]"
git push -f $ORIGIN_URL gh-pages

echo "Done publishing docs, now publishing to npm..."

git checkout -

if [[ -n "$NPM_AUTH" ]]; then
  echo "//registry.npmjs.org/:_authToken=$NPM_AUTH" >> ~/.npmrc
  run npm publish
else
  echo "'npm publish' was skipped because NPM_AUTH is not set." >&2
fi

echo "Done"

exit 0