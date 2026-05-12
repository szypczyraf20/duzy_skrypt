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
while getopts "vh" TEST; do
  case $TEST in
    v) echo "Verbose" ;;
    h) echo "Usage: " ;;
  esac
done

SESSION_TIMES=(`last -f /var/log/wtmp.1 | tail -n +3 | head -n -2 | grep rafal | tr -s " " | cut -d " " -f 10 | sed -E "s#\((.*)\)#\1#" | sort | tac`)

echo "Najdłuższe sesje (w kolejności wystąpienia, sytuacje ex aquo nie rozstrzygane):"

FOR_GREP=""
for (( I=0; I<$1; I++ ));
do
    FOR_GREP="${FOR_GREP}`printf "%s|" ${SESSION_TIMES[$I]}`"
done
FOR_GREP=`echo ${FOR_GREP::-1}`

last -f /var/log/wtmp.1 | grep rafal | tac | grep -E $FOR_GREP | tr -s " " | cut -d " " -f "1,4,5,6,7,8,9,10"
echo "--------"

# Dodaj informacje kiedy miała miejsce ta sesja i jaki użytkownik ją miał.
