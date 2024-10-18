#!/usr/bin/env bash

echo 'Building the Maven project...'

set -x
mvn clean install
set +x

echo 'Extracting project name and version from the "pom.xml" file...'

# Extract and clean project name
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | tr -d '\n' | tr -d '\r')
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | tr -d '\n' | tr -d '\r')
set +x

echo "Project Name: $NAME"
echo "Project Version: $VERSION"

# Check the content of the target directory
echo "Listing files in the target directory:"
ls target/

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

