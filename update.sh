#!/usr/bin/env bash

set -e

SLUG="jaredsburrows/project-sea-turtle"
BRANCH="gh-pages"

# Setup environment
git config --global user.email "action@github.com"
git config --global user.name "Github Actions"
git remote add upstream "https://$GH_TOKEN@github.com/$SLUG"
git checkout gh-pages

# Clear posts for now
find _posts/ -type f -delete

# Add new posts here
thor jekyll:new

# Push the new files up to GitHub
git add .
git commit -m "Updated news at $(date)"
git push -fq upstream gh-pages

echo -e "Published new posts to gh-pages.\n"
