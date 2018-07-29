#!/bin/bash
set -e # exit with nonzero exit code if anything fails

if [ ! -f .env ]; then
	export $(egrep -v '^#' .env | xargs)
fi

if [ "${TRAVIS_PULL_REQUEST}"  != "false" ]; then
  # Exit if we're running a pull request
  echo "Pull request - not running script"
  exit 0;
fi

# inside this git repo we'll pretend to be a new user
git config user.name "OLKB Bot"
git config user.email "hello@olkb.com"

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add README.md
git commit -m "Update order statuses"

# Force push from the current repo's dev branch to the remote github.io
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
git push --quiet "https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}" master > /dev/null 2>&1