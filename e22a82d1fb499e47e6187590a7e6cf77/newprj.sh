#!/bin/bash

TODAY=`date +%Y-%m-%d`
TODAY_MD=`date +%B\ %d,\ %Y`
YEAR=`date +%Y`

PROJECT=$1

##
## CHANGE ME!!!
##

## where you want new project dirs to be created under
DEV_HOME=~/Development

## for thr markdown bits
AUTHOR="@hrbrmstr"

##

mkdir $DEV_HOME/$PROJECT

cd $DEV_HOME/$PROJECT

mkdir R data output

cat <<EOF >README.Rmd
---
title: "README"
author: "$AUTHOR"
date: $TODAY_MD
output: rmarkdown::github_document
---

$PROJECT is ...

EOF


cat <<EOF >R/$PROJECT.R
EOF

cat <<EOF >$PROJECT.Rproj
Version: 1.0

RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: Sweave
LaTeX: pdfLaTeX

StripTrailingWhitespace: Yes
EOF

cat <<EOF >.gitignore
.Rproj.user
.Rhistory
.RData
.Rproj
.DS_Store
src/*.o
src/*.so
src/*.dll
EOF

git init

open $PROJECT.Rproj
