#!/bin/bash
# Konkatenacja kilku plików logów, by analizować wszystkie na raz
COMMAND=$1
FILE=${@: -1}
case $COMMAND in
    last)
        $COMMAND -f $FILE | head -n -2
        $COMMAND -f $FILE.* | head -n -2
        ;;
    who)
        $COMMAND $FILE
        $COMMAND $FILE.*
        ;;
    *)
        cat $FILE
        ALL=($FILE.*)
        # cat $FILE.*
        
        NON_GZ=""
        for ITEM in ${ALL[@]}; do
            NON_GZ+=(`echo "$ITEM" | grep -v "\.gz"`)
        done
        cat `echo ${NON_GZ[@]}`
        ;;
esac
