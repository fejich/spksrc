#!/bin/sh

# Package
PACKAGE="sabnzbd"
DNAME="SABnzbd"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="sabnzbd"
PYTHON="${PYTHON_DIR}/bin/python"
SABNZBD="${INSTALL_DIR}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${INSTALL_DIR}/var/config.ini"
PID_FILE="${INSTALL_DIR}/var/sabnzbd-*.pid"
LOG_FILE="${INSTALL_DIR}/var/logs/sabnzbd.log"


start_daemon ()
{
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${SABNZBD} -f ${CFG_FILE} --pid ${INSTALL_DIR}/var/ -d"
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    rm ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return 0
    fi
    return 1
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

