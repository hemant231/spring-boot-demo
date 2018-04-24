#!/usr/bin/env bash

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
	echo configure_aws_cli
	aws --version
	aws configure set default.region us-east-2
	aws configure set default.output json
}

deploy_cluster() {
    echo deploy_cluster_function
    family="yello-team-mongodb-task"
    
    echo deploy_cluster_function 1
    
   

  SERVICES=`aws ecs describe-services --services yello-team-mongodb-service --cluster test-cluster --region us-east-2 | jq .failures[]`
REVISION=`aws ecs describe-task-definition --task-definition ${family} --region us-east-2 | jq .taskDefinition.revision`


echo $SERVICES
echo $REVISION

 if [ "$SERVICES" == "" ]; then
   echo "entered existing service"
   DESIRED_COUNT=`aws ecs describe-services --services yello-team-mongodb-service --cluster test-cluster --region us-east-2 | jq .services[].desiredCount`
   echo $DESIRED_COUNT;
   if [ ${DESIRED_COUNT} = "0" ]; then
     DESIRED_COUNT="1"
   else
     DESIRED_COUNT="0"
   aws ecs update-service --cluster test-cluster --region us-east-2 --service yello-team-mongodb-service --task-definition ${family}:${REVISION} --desired-count ${DESIRED_COUNT}
    DESIRED_COUNT="1"
   fi
   sleep 20
   aws ecs update-service --cluster test-cluster --region us-east-2 --service yello-team-mongodb-service --task-definition ${family}:${REVISION} --desired-count ${DESIRED_COUNT}
 else
   echo "entered new service"
   aws ecs create-service --service-name yello-team-mongodb-service --desired-count 1 --task-definition ${family} --cluster test-cluster --region us-east-2
 fi
 
}


push_ecr_image(){
	echo push_ecr_image
	eval $(aws ecr get-login --region us-east-2)
	docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-2.amazonaws.com/yello-team-mongodb-repo:$CIRCLE_SHA1
	docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-2.amazonaws.com/yello-team-mongodb-repo:latest

}

configure_aws_cli
push_ecr_image
deploy_cluster
