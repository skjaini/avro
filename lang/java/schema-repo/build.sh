#!/bin/bash
# ----------------------------------------------------------------------------
# Build script for Avro Schema Repo REST service
# ----------------------------------------------------------------------------

set -e						  # exit on error

cd `dirname "$0"`				  # connect to root

DEPLOY_DIR="/var/www"

function usage {
  echo "Usage: $0 {test|package|deploy|start|clean}"
  exit 1
}

if [ $# -eq 0 ]
then
  usage
fi

set -x						  # echo commands

for target in "$@"
do

case "$target" in

    test)
	    # run tests
        (mvn test)
	;;

    package)
        # Compile and generate jars for each submodule.
        # Build tar.gz from the bundle with configs and
        # scripts to start the schema repo service.
        (mvn package -DskipTests)
	;;

    deploy)
		# Unpack the tarball with the required jars, configs
		# and scripts to deploy directory.
		mkdir -p $DEPLOY_DIR
		tar xvzf bundle/target/avro-schema-repo-bundle-1.7.5-1124-SNAPSHOT.tar.gz -C $DEPLOY_DIR
	;;

    start)
		(cd "$DEPLOY_DIR"/avro-schema-repo; nohup ./avro_schema_repo.sh config/config.properties > /var/log/avro_schema_repo.log &)
	;;

    clean)
		# clean the generated builds
        (mvn clean)
    ;;
        
    *)
        usage
        ;;
esac

done

exit 0