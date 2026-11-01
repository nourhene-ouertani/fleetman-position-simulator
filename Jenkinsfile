pipeline {
  agent any
  environment {
    IMAGE = "nourheneouertani/fleetman-position-simulator"
  }
  stages {
    stage('Compile') {
      steps { sh 'mvn -B clean package -DskipTests' }
    }
    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
          sh '''
            mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
              -Dsonar.projectKey=fleetman-position-simulator \
              -Dsonar.host.url=http://192.168.56.10:9000 \
              -Dsonar.token=$SONAR_TOKEN
          '''
        }
      }
    }
    stage('Build') {
      steps { sh 'docker build -t $IMAGE:$BUILD_NUMBER .' }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh 'echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin'
          sh 'docker push $IMAGE:$BUILD_NUMBER'
        }
      }
    }
    stage('Deploy') {
      steps {
        sh 'kubectl set image deployment/position-simulator position-simulator=$IMAGE:$BUILD_NUMBER'
        sh 'kubectl rollout status deployment/position-simulator --timeout=300s'
      }
    }
  }
  post {
    always { sh 'docker image prune -f' }
  }
}
