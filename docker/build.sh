#!/usr/bin/env bash

AWS_DEFAULT_REGION=eu-west-1
AWS_ACCOUNT={replacewithyourawsaccount}
AWS_ECR_REPO=keycloak
COMMIT_HASH="21.1.1"

# You can alter these values, but the defaults will work for any environment

IMAGE_TAG=${COMMIT_HASH:=latest}
AMD_TAG=${COMMIT_HASH}-amd64
DOCKER_CLI_EXPERIMENTAL=enabled
REPOSITORY_URI=$AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$AWS_ECR_REPO

# Login to ECR

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

# create AWS ECR Repo

if (aws ecr describe-repositories --repository-names $AWS_ECR_REPO ) then
	echo "Skipping the create repo as already exists"
else
	echo "Creating repos as it does not exists"
	aws ecr create-repository --region $AWS_DEFAULT_REGION --repository-name $AWS_ECR_REPO
fi

# Build initial image and upload to ECR Repo

docker build -t $REPOSITORY_URI:latest .
docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$AMD_TAG
docker push $REPOSITORY_URI:$AMD_TAG

# Create the image manifests and upload to ECR

docker manifest create $REPOSITORY_URI:$COMMIT_HASH $REPOSITORY_URI:$AMD_TAG
docker manifest annotate --arch amd64 $REPOSITORY_URI:$COMMIT_HASH $REPOSITORY_URI:$AMD_TAG
docker manifest inspect $REPOSITORY_URI:$COMMIT_HASH
docker manifest push $REPOSITORY_URI:$COMMIT_HASH