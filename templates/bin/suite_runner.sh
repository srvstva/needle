#!/usr/bin/env bash
source ../lib/coreutils.sh 
source ../lib/utilities.sh 


function run(){
    # Rotate previous trace log file
    resetTraceLog 
    suite=$1
    cd $NS_WDIR
    $TS_RUN -n ${suite} | tee $TEMP_FILE 
}

function bootstrap(){
    TS_RUN="$NS_WDIR/bin/ts_run"
    TEMP_FILE="/tmp/nd_ts_run.$$"
    RESULTS_DIR="${HOME}/workspace/results/$(get_major)/$(get_minor)"
    if [ ! -d $RESULTS_DIR ]; then
        echo "Creating $RESULTS_DIR"
        mkdir -p $RESULTS_DIR
    fi
    
    BASE_RESULT_FILE="result.$(get_cycleno)"
    R_FILE="${RESULTS_DIR}/${BASE_RESULT_FILE}.txt"
    XML_FILE="${RESULTS_DIR}/${BASE_RESULT_FILE}.xml"
    CURRENT_RESULT_FILE="$RESULTS_DIR/.current"
    
    export R_FILE
    export TEMP_FILE
}

function post_process(){
    if [ ! -f $R_FILE ]; then
        echo "Result file is not created"
        exit 1
    fi
    echo "Result File: $R_FILE"
    # TODO Convert to XML and upload to DB
    failures=$(grep -c ",fail," $R_FILE)
    success=$(grep -c ",pass," $R_FILE)
    total=$((failures + success))

    echo "Total: $total, Success: $success, Failures: $failures"
    #echo "Processing result file and formatting to XML"

    # Moving back to current directory. 
    cd - >/dev/null

    # ruby ../bin/xml_writer.rb -i $R_FILE -o $XML_FILE -n $(basename $suite) -f $failures -s $success -t $total >/dev/null 
    #RC=$?

    # if [ $RC -gt 0 ];then
    #    echo "Error in processing input file"
    #    exit 1
    # fi
    # echo $XML_FILE > $CURRENT_RESULT_FILE
    if [ $failures -gt 0 ]; then 
        echo "Automation failed"
        exit 1
    fi
}


function main(){
    suite=$1
    bootstrap
    run $suite
    post_process
}

main "$1"
