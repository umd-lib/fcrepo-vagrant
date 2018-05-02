#!/bin/bash

function get_artifact {
    # reset for parsing new arguments
    unset -v REPOSITORY GROUP ARTIFACT VERSION PACKAGING FILENAME
    OPTIND=1

    while getopts "r:g:a:v:p:o:" opt; do
        case $opt in
            r)
                REPOSITORY=$OPTARG
                ;;
            g)
                GROUP=$OPTARG
                ;;
            a)
                ARTIFACT=$OPTARG
                ;;
            v)
                VERSION=$OPTARG
                ;;
            p)
                PACKAGING=$OPTARG
                ;;
            o)
                FILENAME=$OPTARG
                ;;
        esac
    done

    # use defaults for anything that wasn't explicitly set
    GROUP=${GROUP:-edu.umd.lib}
    if [ -z "$REPOSITORY" ]; then
        if grep "SNAPSHOT" <<<"$VERSION"; then
            REPOSITORY=snapshots
        else
            REPOSITORY=releases
        fi
    fi
    FILENAME=${FILENAME:-${ARTIFACT}-${VERSION}.${PACKAGING}}

    # now retrieve from Nexus
    NEXUS_BASE_URL=https://maven.lib.umd.edu/nexus/repository
    GROUP_PATH=$(tr '.' '/' <<<"$GROUP")
    NEXUS_URL="$NEXUS_BASE_URL/$REPOSITORY/$GROUP_PATH/$ARTIFACT/$VERSION/$ARTIFACT-$VERSION.$PACKAGING"

    if [ ! -e "$FILENAME" ]; then
        curl -Lso "$FILENAME" "$NEXUS_URL"
    fi
}

TOMCAT_LIB_DIR=/apps/fedora/tomcat/lib
mkdir -p "$TOMCAT_LIB_DIR"
cd "$TOMCAT_LIB_DIR"
get_artifact -a optional-authn-valve -v 1.0.0 -p jar
get_artifact -a header-to-cert-valve -v 1.0.1 -p jar

WEBAPP_DIR=/apps/fedora/webapps
mkdir -p "$WEBAPP_DIR"
cd "$WEBAPP_DIR"
get_artifact -a fcrepo-user-webapp -v 1.1.0 -p war
get_artifact -a umd-fcrepo-webapp -v 2.1.0 -p war
