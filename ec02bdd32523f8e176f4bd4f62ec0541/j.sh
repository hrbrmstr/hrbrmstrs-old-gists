R_HOME=/Library/Frameworks/R.framework/Resources
export R_HOME
R_SHARE_DIR=/Library/Frameworks/R.framework/Resources/share
export R_SHARE_DIR
R_INCLUDE_DIR=/Library/Frameworks/R.framework/Resources/include
export R_INCLUDE_DIR
R_DOC_DIR=/Library/Frameworks/R.framework/Resources/doc
export R_DOC_DIR

javac -cp $R_HOME/library/rJava/jri/JRI.jar RScriptConnection.java && \
  java -Djava.library.path=$R_HOME/library/rJava/jri -cp `pwd`:$R_HOME/library/rJava/jri/JRI.jar RScriptConnection
  