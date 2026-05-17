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
PATTERN=`cat config.txt`
PARAMETERS="last -f /var/log/wtmp"
./concatenation.sh $PARAMETERS | grep "$PATTERN" 
./concatenation.sh $PARAMETERS | grep "$PATTERN" | wc -l | sed -E "s#(.*)#Liczba dopasowań: \1#"
