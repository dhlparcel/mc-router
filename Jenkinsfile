#!groovy

node {
  stage('Checkout') {
    checkout scm
  }

  stage('Create docker image') {
    docker.build("dhlparcel/mc-router:${createTag()}", 'target/docker/stage')
  }

  if (env.BRANCH_NAME == 'master') {
    docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-login') {
      stage('Push docker images') {
        docker.image("dhlparcel/mc-router:${createTag()}").push()
        docker.image("dhlparcel/mc-router:${createTag()}").push('latest')
      }

      stage('Deployment to accept') {
        triggerDeploy(createTag(), 'accept')
      }
    }
  } else {
    echo "Not pushing /deploying image for branch: $env.BRANCH_NAME"
  }
}

private String createTag() {
  readFile('version.txt')
}

private void triggerDeploy(String tag, String environment) {
  echo "Deploy to $environment, with tag $tag"
  build job: "DHL Parcel/dhl-parcel-deploy/master", wait: true, parameters: [
          [$class: 'StringParameterValue', name: 'ENVIRONMENT', value: environment],
          [$class: 'StringParameterValue', name: 'DOCKER_TAG', value: tag],
          [$class: 'StringParameterValue', name: 'PLAYBOOK', value: 'mc-router']
  ]
}
