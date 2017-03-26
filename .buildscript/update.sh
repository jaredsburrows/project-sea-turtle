#!/usr/bin/env bash

set -e

SLUG="jaredsburrows/project-sea-turtle"
BRANCH="gh-pages"
TRAVIS_USERNAME="travis-ci"
COMMITTER_EMAIL="$(git log -1 --pretty="%aN")"

if [ "$TRAVIS_REPO_SLUG" != "$SLUG" ]; then
    echo "Skipping: wrong repository. Expected '$SLUG' but was '$TRAVIS_REPO_SLUG'."
elif [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Skipping: was pull request."
elif [ "$TRAVIS_BRANCH" != "$BRANCH" ]; then
    echo "Skipping: wrong branch. Expected '$BRANCH' but was '$TRAVIS_BRANCH'."
elif [ "$TRAVIS_OS_NAME" != "linux" ]; then
    echo "Skipping: wrong os. Expected 'osx' but was '$TRAVIS_OS_NAME'."
elif [ "$TRAVIS_USERNAME" == "$COMMITTER_EMAIL" ]; then
    echo "Skipping: was wrong user. Expected a different user but was '$TRAVIS_USERNAME'."
else
    echo -e "Creating new posts...\n"

    # Setup environment
    git config user.name "$TRAVIS_USERNAME"
    git config user.email "travis@travis-ci.org"
    git remote add upstream "https://$GH_TOKEN@github.com/$SLUG"
    git checkout gh-pages

    # Add new posts here
    bundle exec jekyll post "My New Page $(date)"

    # Push the new files up to GitHub
    git add .
    git commit -m "Updated posts at $(date)"
    git push -fq upstream gh-pages

    echo -e "Published new posts to gh-pages.\n"
fi
