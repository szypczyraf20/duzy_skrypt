#!/bin/bash
# Stara część skryptu
VERBOSE="OFF"
while getopts "vhs" OPCJE; do
  case $OPCJE in
    v) 
        VERBOSE="ON"
        ;;
    h)
        echo "SPOSÓB UŻYCIA: " 
        echo "./skrypt.sh [OPCJE] [POLECENIE]"
        echo
        echo "OPCJE"
        echo "-h  Wypisz tą wiadomość"
        echo "-v  Tryb gadatliwy (verbose)"
        echo
        echo "POLECENIA"
        echo "n [x] Najdłuższe x sesji"
        echo "u     Liczba aplikacji powodujących zdarzenia w pliku syslog"
        echo "z     Obecnie zalogowani użytkownicy"
        echo "f     Nieudane logowania"
        exit
        ;;
    s)
        continue
        ;;
  esac
done

if [[ $VERBOSE == "ON" ]]; then
    COMMAND=$2
    COMMAND2=$3
else
    COMMAND=$1
    COMMAND2=$2
    if [ "$COMMAND2" = "" ]; then
        COMMAND2=0
    fi
fi

case $COMMAND in
n)
    SESSION_TIMES=(`last -f /var/log/wtmp.1 | tail -n +3 | head -n -2 | grep rafal | tr -s " " | cut -d " " -f 10 | sed -E "s#\((.*)\)#\1#" | sort | tac`)
    if [ "$VERBOSE" = "ON" ]; then

    echo "Najdłuższe x sesji (w kolejności wystąpienia, sytuacje ex aquo nie rozstrzygane):"

    FOR_GREP=""
    for (( I=0; I<$COMMAND2; I++ ));
    do
        FOR_GREP="${FOR_GREP}`printf "%s|" ${SESSION_TIMES[$I]}`"
    done
    FOR_GREP=`echo ${FOR_GREP::-1}`

    last -f /var/log/wtmp.1 | grep rafal | tac | grep -E $FOR_GREP | tr -s " " | cut -d " " -f "1,4,5,6,7,8,9,10"
    else
        echo "Najdłuższe x sesji (gg:mm):"
        for (( I=0; I<${COMMAND2}; I++ ));
        do
            printf "%s\n" ${SESSION_TIMES[$I]}
        done
    fi
    ;;

u)
    if [ "$VERBOSE" = "ON" ]; then
        echo "Liczba aplikacji powodującycj zdarzenia w pliku syslog"
        cat /var/log/syslog | cut -d " " -f 3 | sed "s#:\$##g" | sed "s#\[.*\]##" | sort | uniq -c | sed -E "s#(.*) (.*)#\2 \1#" | tr -s " "
        printf "Łącznie: "
        cat /var/log/syslog | cut -d " " -f 3 | sed "s#:\$##g" | sed "s#\[.*\]##" | uniq | wc -l
    else
        echo "Liczba aplikacji powodującycj zdarzenia w pliku syslog"
        cat /var/log/syslog | cut -d " " -f 3 | sed "s#:\$##g" | sed "s#\[.*\]##" | uniq | wc -l
    fi
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
