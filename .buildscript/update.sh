#!/usr/bin/env bash

set -e

SLUG="jaredsburrows/project-sea-turtle"
BRANCH="gh-pages"

if [ "$TRAVIS_REPO_SLUG" != "$SLUG" ]; then
    echo "Skipping: wrong repository. Expected '$SLUG' but was '$TRAVIS_REPO_SLUG'."
elif [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Skipping: was pull request."
elif [ "$TRAVIS_BRANCH" != "$BRANCH" ]; then
    echo "Skipping: wrong branch. Expected '$BRANCH' but was '$TRAVIS_BRANCH'."
elif [ "$TRAVIS_OS_NAME" != "linux" ]; then
    echo "Skipping: wrong os. Expected 'osx' but was '$TRAVIS_OS_NAME'."
elif [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then
    echo "Skipping: wrong event. Expected 'cron' but was '$TRAVIS_EVENT_TYPE'."
else
    echo -e "Creating new posts...\n"

    # Setup environment
    git config user.name "travis-ci"
    git config user.email "travis@travis-ci.org"
    git remote add upstream "https://$GH_TOKEN@github.com/$SLUG"
    git checkout gh-pages

    # Add new posts here
    thor jekyll:new

    # Push the new files up to GitHub
    git add .
    git commit -m "Updated posts at $(date)"
    git push -fq upstream gh-pages

    echo -e "Published new posts to gh-pages.\n"
fi
