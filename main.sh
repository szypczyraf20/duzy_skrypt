# Author           : Rafał Szypczyński, s208477@student.pg.edu.pl
# Created On       : 28 IV 2026
# Last Modified On : 19 V 2026 
# Version          : 2
#
# Description      :
# Duży skrypt Rafała Szypczyńskiego. Temat: Analiza plików dziennika
#
# Licensed under Beerware 
# <s208477@student.pg.edu.pl> wrote this file. As long as you retain this notice you can
# do whatever you want with this stuff. If we meet some day, and you think this stuff is
# worth it, you can drink in my name in return Rafał Krystian Szypczyński
#
# Generative AI statement (keep ONE line below, delete the others):
# * I did NOT use GenAI tools while developing this code.

#!/bin/bash
# Wczytywanie opcji
while getopts "vhs" OPCJE; do
VERBOSE="OFF"
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
        echo "-s  Tryb starych poleceń"
        echo
        echo "POLECENIA"
        echo "n [x] Najdłuższe x sesji"
        echo "u     Liczba aplikacji powodujących zdarzenia w pliku syslog"
        echo "z     Obecnie zalogowani użytkownicy"
        echo "f     Nieudane logowania"
        exit
        ;;
    s)
        # Odczytuje parametry polecenia
        INPUT_PARAMS=($@)

        # Wywołuje starą część skryptu
        ./skrypt.sh ${INPUT_PARAMS[@]}

        exit
        ;;
  esac
done

# Odczytuje parametry polecenia
INPUT_PARAMS=($@)

# Pozbywa się opcji -v -h itp. z parametrów
for PARAM in ${INPUT_PARAMS[@]}; do
    if [ "${PARAM::1}" = "-" ]; then
        continue
    else
        ANALYZED_LOGS+=("$PARAM ")
    fi
done

# Obraca się po kolejnych linijkach pliku config.txt
while IFS= read -r PATTERN; do

# Zeruje licznik dopasowań
MATCHED=0
for ANALYZED_LOG in ${ANALYZED_LOGS[@]}; do
    # Tworzy parametry do funkcji ./concatenation.sh
    PARAMETERS=`./log_name_translator.sh $ANALYZED_LOG`

    # Wypisuje dopasowane linie
    # ./concatenation.sh znajduje wszystkie pliki logów o danej nazwie 
    if [ "$VERBOSE" = "ON" ]; then
        ./concatenation.sh $PARAMETERS | grep -E "$PATTERN" 
    fi

    # Oblicza ilość dopasowań z obecnego logu
    CURRENTLY_MATCHED=`./concatenation.sh $PARAMETERS | grep -E "$PATTERN" | wc -l` 

    # Sumuje ilość dopasowań
    MATCHED=$((MATCHED+CURRENTLY_MATCHED))

# Wypisuje wynik
if [ "$VERBOSE" = "ON" ]; then
    echo -e "\e[1;34m--------------------------\e[0m"
    echo -e "\e[1;34mWzór: $PATTERN\e[0m"
    echo -e "\e[1;34mLiczba dopasowań: $MATCHED\e[0m"
    echo -e "\e[1;34m--------------------------\e[0m"
else
    echo "Liczba dopasowań: $MATCHED"
fi

done
done < "config.txt"
