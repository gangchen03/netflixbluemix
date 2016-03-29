#!/usr/bin/env bash

##############################################################################
##
##  Wrapper sript to pull all peer git repositories
##
##############################################################################

BASEREPO="https://github.com/osowski/netflixbluemix"
REPO_CORE="https://github.com/osowski/netflixbluemix-core"
REPO_DB2="https://github.com/osowski/netflixbluemix-db2"
REPO_MYSQL="https://github.com/osowski/netflixbluemix-mysql"
REPO_MQ="https://github.com/osowski/netflixbluemix-mq"
REPO_ES="https://github.com/osowski/netflixbluemix-elasticsearch"

echo 'Cloning peer projects...'

GIT_AVAIL=$(which git)
if [ ${?} -ne 0 ]; then
  echo "git is not available on your local system.  Please install git for your operating system and try again."
  exit 1
fi

DEFAULT_BRANCH=${1:-development}

echo -e '\nClone netflixbluemix-core project'
REPO=${REPO_CORE}
PROJECT=$(echo ${REPO} | cut -d/ -f5)
git clone -b ${DEFAULT_BRANCH} ${REPO} ../${PROJECT}

echo -e '\nClone netflixbluemix-db2 project'
REPO=${REPO_DB2}
PROJECT=$(echo ${REPO} | cut -d/ -f5)
git clone -b ${DEFAULT_BRANCH} ${REPO} ../${PROJECT}

echo -e '\nClone netflixbluemix-mq project'
REPO=${REPO_MQ}
PROJECT=$(echo ${REPO} | cut -d/ -f5)
git clone -b ${DEFAULT_BRANCH} ${REPO} ../${PROJECT}

echo -e '\nClone netflixbluemix-mysql project'
REPO=${REPO_MYSQL}
PROJECT=$(echo ${REPO} | cut -d/ -f5)
git clone -b ${DEFAULT_BRANCH} ${REPO} ../${PROJECT}

echo -e '\nClone netflixbluemix-elasticsearch project'
REPO=${REPO_ES}
PROJECT=$(echo ${REPO} | cut -d/ -f5)
git clone -b ${DEFAULT_BRANCH} ${REPO} ../${PROJECT}

echo -e '\nCloned all peer projects successfully!\n'
ls ../ | grep netflixbluemix
