#!/bin/sh

set -eo pipefail

set +e

# Script trace mode
if [ "${DEBUG_MODE}" == "true" ]; then
    set -o xtrace
fi

echo "******************************************************************"
echo -n " - creating incoming spooler directory "
if [ ! -d "/var/spool/sms/incoming" ]; then
  mkdir -p /var/spool/sms/incoming
  echo "... created"
else
  echo "... ok"
fi

echo -n " - creating outgoing spooler directory "
if [ ! -d "/var/spool/sms/outgoing" ]; then
  mkdir -p /var/spool/sms/outgoing
  echo "... created"
else
  echo "... ok"
fi

echo -n " - creating sent spooler directory     "
if [ ! -d "/var/spool/sms/sent" ]; then
  mkdir -p /var/spool/sms/sent
  echo "... created"
else
  echo "... ok"
fi

echo -n " - creating failed spooler directory   "
if [ ! -d "/var/spool/sms/failed" ]; then
  mkdir -p /var/spool/sms/failed
  echo "... created"
else
  echo "... ok"
fi

echo -n " - creating checked spooler directory  "
if [ ! -d "/var/spool/sms/checked" ]; then
  mkdir -p /var/spool/sms/checked
  echo "... created"
else
  echo "... ok"
fi
echo "******************************************************************"
smsd -V
echo "******************************************************************"

exec "$@"
