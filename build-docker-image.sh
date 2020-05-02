#!/bin/bash
set -x

NAMESPACE="respectablewizard"
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

function build {
  COMPONENT=$1
  VERSION=${2:-3.4.7}
  echo "Building $COMPONENT with version $VERSION"
  docker build --build-arg VERSION=$VERSION -t $NAMESPACE/$COMPONENT -t $NAMESPACE/$COMPONENT:latest -t $NAMESPACE/$COMPONENT:$VERSION .
  # docker push $NAMESPACE/$COMPONENT
  # docker push $NAMESPACE/$COMPONENT:latest
  # docker push $NAMESPACE/$COMPONENT:$VERSION
}

build metrix $1
