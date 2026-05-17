#!/bin/bash
LOG_NAME=$1
FULL_LOG_NAME=""
case $LOG_NAME in 
    wtmp)
        FULL_LOG_NAME="/var/log/$LOG_NAME"
        ;;
    btmp)
        FULL_LOG_NAME="/var/log/$LOG_NAME"
        ;;
    *)
        if grep -qE ".log$" <<< $LOG_NAME; then
            FULL_LOG_NAME=`echo "/var/log/$LOG_NAME"`
        else
            FULL_LOG_NAME=`echo "/var/log/$LOG_NAME.log"`
        fi
        ;;
esac

if file --mime $FULL_LOG_NAME | grep -qE "charset=binary"; then
    case $LOG_NAME in
        wtmp)
            echo "last -f $FULL_LOG_NAME"
            ;;
        btmp)
            echo "lastb -f $FULL_LOG_NAME"
            ;;
    esac
else
    echo "$FULL_LOG_NAME"
fi
