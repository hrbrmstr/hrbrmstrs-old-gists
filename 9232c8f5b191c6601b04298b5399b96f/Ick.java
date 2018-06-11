#!/bin/sh
# This self-executing Java program uses the following /embedded shell script/ to compile & execute itself..

# magic constant holding length of script
SKIP=26

# parse our name..
FILE=`basename $0 .java`

# get some working space, clean up old crud
WORK=/tmp/java-hack
mkdir -p $WORK
find $WORK -mtime 7 |xargs rm -f

# transform ourselves to compilable Java (aka, strip the shell script head), save the timestamp
tail +$SKIP $0 > $WORK/$FILE.java
touch -r $0 $WORK/$FILE.java

# compile if required..
[ -r $WORK/$FILE.class -a $WORK/$FILE.java -ot $WORK/$FILE.class ] || javac -d $WORK $WORK/$FILE.java

# execute..
java -cp $WORK $FILE $*
exit $?
---------- Write some Java dude! ----------

public class Ick {
  public static void main(String[] args) {
    System.out.println("Whoo Hooo!");
  }
}
