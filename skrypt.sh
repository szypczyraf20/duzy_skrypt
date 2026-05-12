# Author           : Rafał Szypczyński, s208477@student.pg.edu.pl
# Created On       : 28 IV 2026
# Last Modified On : date 
# Version          : 1
#
# Description      :
# Duży skrypt Rafała Szypczyńskiego. Temat: Analiza plików dziennika
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)
# 
# Generative AI statement (keep ONE line below, delete the others):
# * I did NOT use GenAI tools while developing this code.

#!/bin/bash
while getopts "vh" OPCJE; do
VERBOSE="OFF"
  case $OPCJE in
    v) 
        VERBOSE="ON"
        ;;
    h) echo "Usage: " 
        exit
        ;;
  esac
done

if [[ $VERBOSE == "ON" ]]; then
    COMMAND=$2
    COMMAND2=$3
else
    COMMAND=$1
    COMMAND2=$2
fi

case $COMMAND in
n)
    SESSION_TIMES=(`last -f /var/log/wtmp.1 | tail -n +3 | head -n -2 | grep rafal | tr -s " " | cut -d " " -f 10 | sed -E "s#\((.*)\)#\1#" | sort | tac`)
    if [ "$VERBOSE" = "ON" ]; then

    echo "Najdłuższe sesje (w kolejności wystąpienia, sytuacje ex aquo nie rozstrzygane):"

    FOR_GREP=""
    for (( I=0; I<$COMMAND2; I++ ));
    do
        FOR_GREP="${FOR_GREP}`printf "%s|" ${SESSION_TIMES[$I]}`"
    done
    FOR_GREP=`echo ${FOR_GREP::-1}`

    last -f /var/log/wtmp.1 | grep rafal | tac | grep -E $FOR_GREP | tr -s " " | cut -d " " -f "1,4,5,6,7,8,9,10"
    else
        echo "Najdłuższe sesje (gg:mm):"
        for (( I=0; I<$COMMAND2; I++ ));
        do
            printf "%s\n" ${SESSION_TIMES[$I]}
        done
    fi
    ;;

u)
    echo "Liczba aplikacji powodującycj zdarzenia w pliku syslog"
    cat /var/log/syslog | cut -d " " -f 3 | sed "s#:\$##g" | sed "s#\[.*\]##" | sort | uniq -c | sed -E "s#(.*) (.*)#\2 \1#" | tr -s " "
    ;;

z)
    if [ "$VERBOSE" = "ON" ]; then
    echo "Obecnie zalogowani użytkownicy:"
    who | tr -s " " | cut -d " " -f "1,3,4" | sed -E "s#(.*) (.*) (.*)#\1, początek sesji: \2 \3#"
    else
        echo "Obecnie zalogowani użytkownicy:"
        who | tr -s " " | cut -d " " -f "1"
    fi
    ;;
f)
    if [ "$VERBOSE" = "ON" ]; then
        echo "Nieudane logowania:"
        sudo lastb -f /var/log/btmp.1 | head -n -2 | tr -s " " | cut -d " " -f "1,4,5,6,7"
    else
        echo "Nieudane logowania:"
        sudo lastb -f /var/log/btmp.1 | head -n -2 | tr -s " " | cut -d " " -f "5,6,7"
    fi
    ;;
esac
