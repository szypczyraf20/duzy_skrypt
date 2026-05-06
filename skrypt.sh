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
cat /var/log/syslog | grep "rafal"
