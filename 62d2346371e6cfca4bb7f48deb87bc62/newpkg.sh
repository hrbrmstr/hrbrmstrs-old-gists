#!/bin/bash

TODAY=`date +%Y-%m-%d`
TODAY_MD=`date +%B\ %d,\ %Y`
YEAR=`date +%Y`

PACKAGENAME=$1

##
## CHANGE ME!!!
##

DEV_HOME=~/packages

mkdir $DEV_HOME/$PACKAGENAME

cd $DEV_HOME/$PACKAGENAME

mkdir R man tests tests/testthat

cat <<EOF >.Rbuildignore
^.*\.Rproj$
^\.Rproj\.user$
^\.travis\.yml$
^README\.*Rmd$
^README\.*html$
^NOTES\.*Rmd$
^NOTES\.*html$
^\.codecov\.yml$
^README_files$
^doc$
^tmp$
EOF

cat <<EOF >DESCRIPTION
Package: $PACKAGENAME
Type: Package
Title: $PACKAGENAME title goes here otherwise CRAN checks fail
Version: 0.1.0
Date: $TODAY
Authors@R: c(
    person("Bob", "Rudis", email = "bob@rud.is", role = c("aut", "cre"), 
           comment = c(ORCID = "0000-0001-5670-2640"))
  )
Maintainer: Bob Rudis <bob@rud.is>
Description: A good description goes here otherwise CRAN checks fail.
URL: https://github.com/hrbrmstr/$PACKAGENAME
BugReports: https://github.com/hrbrmstr/$PACKAGENAME/issues
Encoding: UTF-8
License: AGPL
Suggests:
    testthat,
    covr
Depends:
    R (>= 3.2.0)
Imports:
    purrr
EOF

cat <<EOF >NEWS.md
0.1.0 
* Initial release
EOF

cat <<EOF >README.Rmd
---
output: rmarkdown::github_document
---

# $PACKAGENAME

## Description

## What's Inside The Tin

The following functions are implemented:

## Installation

\`\`\`{r eval=FALSE}
devtools::install_github("hrbrmstr/$PACKAGENAME")
\`\`\`

\`\`\`{r message=FALSE, warning=FALSE, error=FALSE, include=FALSE}
options(width=120)
\`\`\`

## Usage

\`\`\`{r message=FALSE, warning=FALSE, error=FALSE}
library($PACKAGENAME)

# current verison
packageVersion("$PACKAGENAME")

\`\`\`

EOF

cat <<EOF > tests/test-all.R
library(testthat)
test_check("$PACKAGENAME")
EOF

cat <<EOF >tests/testthat/test-$PACKAGENAME.R
context("minimal package functionality")
test_that("we can do something", {

  #expect_that(some_function(), is_a("data.frame"))

})
EOF

cat <<EOF >R/$PACKAGENAME-package.R
#' ...
#' 
#' @md
#' @name $PACKAGENAME
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr
NULL
EOF

cat <<EOF >$PACKAGENAME.Rproj
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

BuildType: Package
PackageUseDevtools: Yes
PackageInstallArgs: --no-multiarch --with-keep.source
PackageBuildArgs: --resave-data
PackageRoxygenize: rd,collate,namespace
EOF

cat <<EOF >.gitignore
.DS_Store
.Rproj.user
.Rhistory
.RData
.Rproj
src/*.o
src/*.so
src/*.dll
EOF

cat <<EOF >.codecov.yml
comment: false
EOF

cat <<EOF >.travis.yml
language: R
sudo: false
cache: packages

after_success:
- Rscript -e 'covr::codecov()'
EOF

Rscript -e 'devtools::document()'

git init

if [ "$2" == "-no" ] ; then
    exit 0
else
#    open $PACKAGENAME.Rproj
  code .
fi
