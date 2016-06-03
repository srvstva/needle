##
# Library for core automation tasks
# Author: Ankur S
#
##

function get_major(){
   echo "$(cat $NS_WDIR/etc/version|head -1 | awk '{print $2}')"
}

function get_minor(){
   echo "$(cat $NS_WDIR/etc/version|tail -1 | awk '{print $2}')"
}

function get_cycleno(){
    echo "$(date '+%m%d%y.%H%M%S')"
}

function get_testcase_count(){
    suite=$(basename $1)
    pattern=$2
    total=0

    testcases=$(grep -v "#" testsuites/${suite}.conf| sed '/^$/d'|awk '{print $2}')

    for tc in ${testcases}; do
        count=$(grep -c "^${pattern}" testcases/${tc}/iteration.spec)
        total=$((count  + total ))
    done
    echo $total
}

