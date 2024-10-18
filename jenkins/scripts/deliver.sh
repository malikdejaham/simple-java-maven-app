#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'

set -x
# Simplified Maven build command
mvn clean install
set +x

echo 'Extracting project name and version from the "pom.xml" file...'

# Extract and clean project name
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | tr -d '\n' | tr -d '\r')
# Extract and clean project version
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | tr -d '\n' | tr -d '\r')
set +x

echo "Project Name: $NAME"
echo "Project Version: $VERSION"

# Verify if the JAR file exists and run it
if [[ -f target/${NAME}-${VERSION}.jar ]]; then
    echo "Running the application..."
    set -x
    java -jar target/${NAME}-${VERSION}.jar
    set +x
else
    echo "Error: JAR file not found: target/${NAME}-${VERSION}.jar"
    exit 1
fi
