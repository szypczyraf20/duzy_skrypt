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
SESSION_TIMES=`last -f /var/log/wtmp.1 | tail -n +3 | head -n -2 | grep rafal | tr -s " " | cut -d " " -f 10 | sed -E "     s#\((.*)\)#\1#" | sort`
echo "Najdłuższe sesje:"
printf '%s\n' "${SESSION_TIMES[@]}" | tail | tac
# Dodaj informacje kiedy miała miejsce ta sesja i jaki użytkownik ją miał.
# last | grep `last | tail -n +1 | grep "rafal" | tr -s " " | cut -d " " -f "10" | sed -E "s#\((.*)\)#\1#" | sort | tail -1`
