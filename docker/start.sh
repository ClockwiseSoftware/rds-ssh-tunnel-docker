#!/bin/bash

if [ -z $BASTION_SSH_KEY ]
  then
      echo "Set BASTION_SSH_KEY variable"
      exit 1
fi

if [ -z $BASTION_USER ]
  then
      echo "Set BASTION_USER variable"
      exit 1
fi

if [ -z $BASTION_IP ]
  then
      echo "Set BASTION_IP variable"
      exit 1
fi

if [ -z $CONTAINER_PORT ]
  then
      echo "Set CONTAINER_PORT variable"
      exit 1
fi


if [ -z $SOURCE_DOMAIN_OR_IP ]
  then
      echo "Set SOURCE_DOMAIN_OR_IP variable"
      exit 1
fi

if [ -z $SOURCE_PORT ]
  then
      echo "Set SOURCE_PORT variable"
      exit 1
fi

if [ -z $ALIVE_INTERVAL ]
  then
      ALIVE_INTERVAL=60
fi

if [ -z $ALIVE_COUNT_MAX ]
  then
      ALIVE_COUNT_MAX=10
fi

ssh -i /home/node/.ssh/$BASTION_SSH_KEY -fNT -o ServerAliveInterval=$ALIVE_INTERVAL -o ServerAliveCountMax=$ALIVE_COUNT_MAX -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -L 0.0.0.0:$CONTAINER_PORT:$SOURCE_DOMAIN_OR_IP:$SOURCE_PORT $BASTION_USER@$BASTION_IP
/bin/bash