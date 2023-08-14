pipeline {
    agent none
     environment {
        AWS_ACCOUNT_ID=sh(returnStdout: true, script: 'aws sts get-caller-identity --query "Account" --output text').trim()
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="presto-repo-test"
        // IMAGE_TAG="${GIT_COMMIT}"
        // CLUSTER_NAME = "segue-om-cluster-dev"
        // SERVICE_NAME = "segue-om-service-dev"
        // TASKDEF_NAME = "segue-om-service-dev"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        TAG_TO_CHECK=sh(returnStdout: true, script:'cat version.txt').trim()
        // TAGS_JSON=sh(script: "aws ecr list-images --repository-name ${IMAGE_REPO_NAME} --region us-east-1 --output json", returnStdout: true).trim()
        // TAG_PRESENT=sh(script: "echo '${tagsJson}' | jq -r '.imageIds[] | select(.imageTag == \"${TAG_TO_CHECK}\")'", returnStatus: true).trim()
             
    }
    stages {
    stage("git Checkout"){
        steps{
        checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sarvesh5012/verify-docker-image.git']])
    }
    }
    
    stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 382904467012.dkr.ecr.us-east-1.amazonaws.com"
                }
                 
            }
        }
    
    stage("test-tags-then build"){
        steps{
        sh '''
               #!/bin/bash
               repository_name=$IMAGE_REPO_NAME
               specific_tag=$TAG_TO_CHECK
               chmod +x test.sh
               set +x
               result=$(. ./test.sh)
               set -x
               echo $result
               if [ $result = true ]; then
                   echo $specific_tag exits in the repo
               else
                   docker build -t ${REPOSITORY_URI}:${TAG_TO_CHECK} -f Dockerfile.dev .
               fi
              '''
        
    }
    }
    
}
}