#!/bin/bash

# Example taken from 
#   https://github.com/ReadyTalk/swt-bling/blob/master/.utility/push-javadoc-to-gh-pages.sh
#   http://benlimmer.com/2013/12/26/automatically-publish-javadoc-to-gh-pages-with-travis-ci/

# Running 3 builds - save javadoc only for one of them. Chose scala 2.11.7.

#echo -e "Travis scala version is: $TRAVIS_SCALA_VERSION"
#echo -e "$TRAVIS_REPO_SLUG"
#echo -e "$TRAVIS_PULL_REQUEST"
#echo -e "$TRAVIS_BRANCH"
#echo -e "$TRAVIS_BUILD_TYPE"

if [ "$TRAVIS_REPO_SLUG" == "tncytop/top-roaddetection" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_BUILD_TYPE" == "Release" ] &&  [[ "$TRAVIS_SCALA_VERSION" == 2.11.* ]]; then

    echo -e "Publishing scaladoc. \n"

    cd $PROJ_ROOT
    cp -R doc $HOME/doc-latest

    cd $HOME
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "travis-ci"
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/joernano/top-roaddetection gh-pages > /dev/null

    cd gh-pages
    git rm -rf doc
    cp -Rf $HOME/doc-latest ./doc
    git add -f .
    git commit -m "[GH-PAGES] [DOC] Updated scaladoc on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
    git push -fq origin gh-pages

    echo -e "Published scaladoc to gh-pages. \n"

else
    echo -e "Won't publish built documentation. \n"
fi
