rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.2/ /cran/bin/macosx/mavericks/contrib/3.2/
rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.3/ /cran/bin/macosx/mavericks/contrib/3.3/
rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.4/ /cran/bin/macosx/mavericks/contrib/3.4/
rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/contrib/3.3/ /cran/bin/macosx/contrib/3.3/
rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/contrib/3.4/ /cran/bin/macosx/contrib/3.4/
rsync -rtlzv --delete  cran.r-project.org::CRAN/doc/ /cran/doc/
rsync -rtlzv --delete  cran.r-project.org::CRAN/bin/macosx/tools/ /cran/bin/macosx/tools/
rsync -rtlzv --delete  cran.r-project.org::CRAN/web/ /cran/web/
rsync -rtlzv --delete  cran.r-project.org::CRAN/src/ /cran/src/
rsync -tlzv --delete  -a --include="NEWS" --include="*.shtml" --include="*.html" --include="*.pkg" --include="*.dmg" --include="*.gz" --exclude="*" cran.r-project.org::CRAN/bin/macosx/ /cran/bin/macosx/
rsync -tlzv --delete  -a --include="*.html" --include="*.shtml" --include="*.svg" --include="*.png" --exclude="*" cran.r-project.org::CRAN/ /cran/
rsync -rtlzv --delete  cran.r-project.org::CRAN/src/contrib/PACKAGES.gz /cran/src/contrib/PACKAGES.gz
