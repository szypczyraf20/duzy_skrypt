# Author           : Rafał Szypczyński, s208477@student.pg.edu.pl
# Created On       : 28 IV 2026
# Last Modified On : date 
# Version          : 2
#
# Description      :
# Duży skrypt Rafała Szypczyńskiego. Temat: Analiza plików dziennika
#
# Licensed under Beerware 
# <s208477@student.pg.edu.pl> wrote this file. As long as you retain this notice you can
# do whatever you want with this stuff. If we meet some day, and you think this stuff is
# worth it, you can drink in my name in return Rafał Krystian Szypczyński
# Generative AI statement (keep ONE line below, delete the others):
# * I did NOT use GenAI tools while developing this code.

#!/bin/bash
ANALYZED_LOGS=($@)

# Dodaj plik konkatenujący wyjście kilku poleceń ./concatenation.sh
PATTERN=`cat config.txt`
for ANALYZED_LOG in ${ANALYZED_LOGS[@]}; do
    PARAMETERS=`./log_name_translator.sh $ANALYZED_LOG`
    ./concatenation.sh $PARAMETERS | grep -E "$PATTERN" 
    MATCHED=`./concatenation.sh $PARAMETERS | grep -E "$PATTERN" | wc -l` 
done

echo "Liczba dopasowań: $MATCHED"
