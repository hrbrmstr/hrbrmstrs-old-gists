# This makes a feature-complete macOS-centric CRAN mirror that ends up being ~72GB

# for most ops: recurse, preserve mod times, preserve symlinks, ensure compression for xfers and delete extraneous files

# get macOS pkg binaries
rsync -rlptDz --delete cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.2/ /cran/bin/macosx/mavericks/contrib/3.2/
rsync -rlptDz --delete cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.3/ /cran/bin/macosx/mavericks/contrib/3.3/
rsync -rlptDz --delete cran.r-project.org::CRAN/bin/macosx/mavericks/contrib/3.4/ /cran/bin/macosx/mavericks/contrib/3.4/
rsync -rlptDz --delete cran.r-project.org::CRAN/bin/macosx/el-capitan/ /cran/bin/macosx/el-capitan/

# gfortran, tcltk and some other things
rsync -rlptDz --delete cran.r-project.org::CRAN/bin/macosx/tools/ /cran/bin/macosx/tools/

# R and pkg source code
rsync -rlptDz --delete cran.r-project.org::CRAN/src/ /cran/src/

# documentation, web site
rsync -rlptDz --delete cran.r-project.org::CRAN/doc/ /cran/doc/
rsync -rlptDz --delete cran.r-project.org::CRAN/doc/ /cran/help/
rsync -rlptDz --delete cran.r-project.org::CRAN/web/ /cran/web/
rsync -rlptDz --delete cran.r-project.org::CRAN/web/ /cran/html/
rsync -rlptDz --delete --include="NEWS" --include="*.shtml" --include="*.html" --include="*.pkg" --include="*.dmg" --include="*.gz" --exclude="*" cran.r-project.org::CRAN/bin/macosx/ /cran/bin/macosx/

# packages metadata
rsync -rlptDz --delete cran.r-project.org::CRAN/src/contrib/PACKAGES.gz /cran/src/contrib/PACKAGES.gz

# Don't recurse but get the top-level web interface things for the CRAN web site
rsync -lptDz --delete --include="*.css" --include="*.html" --include="*.shtml" --include="*.svg" --include="*.png" --exclude="*" cran.r-project.org::CRAN/ /cran/
