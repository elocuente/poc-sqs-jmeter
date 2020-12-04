#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

# Example for using User Defined Variables with JMeter
# These will be substituted in JMX test script
# See also: http://stackoverflow.com/questions/14317715/jmeter-changing-user-defined-variables-from-command-line

export T_NUM_THREAD=$1
export T_LOOP_COUNT=$2
export T_DURATIONS=$3

export T_RAMUP_PERIOD_TIME=$4
export T_STARTUP_DELAY=$5

export T_SERVER_NAME=$6
export T_PATH=$7
export T_PROTOCOL=$8

echo "VAR USER NUM_THREAD:"$1", LOOP_COUNT:"$2", DURATIONS:"$3", RAMUP_PERIOD_TIME:"$4", STARTUP_DELAY:"$5", SERVER_NAME:"$6", PATH:"$7", PROTOCOL:"$8

T_DIR=tests/poc-jmeter

# Reporting dir: start fresh
R_DIR=${T_DIR}/report
sudo rm -rf ${R_DIR} > /dev/null 2>&1
mkdir -p ${R_DIR}

/bin/rm -f ${T_DIR}/test-plan.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

./run.sh -Dlog_level.jmeter=DEBUG \
        -JNUM_THREAD=${T_NUM_THREAD} -JLOOP_COUNT=${T_LOOP_COUNT} \
        -JDURATIONS=${T_DURATIONS} -JRAMUP_PERIOD_TIME=${T_RAMUP_PERIOD_TIME} \
        -JSTARTUP_DELAY=${T_STARTUP_DELAY} -JSERVER_NAME=${T_SERVER_NAME} \
        -JPATH=${T_PATH} -JPROTOCOL=${T_PROTOCOL} \
        -n -t ${T_DIR}/build-web-test-plan.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log \
        -e -o ${R_DIR}

echo "==== jmeter.log ===="
cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
cat ${T_DIR}/test-plan.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"
