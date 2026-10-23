// Infrastructure pipeline for aws-platform-infra
//   PR builds:   fmt -> validate -> Trivy -> plan (dev, stage, prod)
//   main builds: fmt -> validate -> Trivy -> apply dev -> approve -> stage -> approve -> prod

def ENVS = ['dev', 'stage', 'prod']

pipeline {
    agent any

    options {
        disableConcurrentBuilds()                       // never two builds of the same branch at once
        timestamps()                                    // time on every log line
        buildDiscarder(logRotator(numToKeepStr: '20'))  // keep only the last 20 builds
    }

    environment {
        TF_IN_AUTOMATION    = 'true'                    // Terraform: "no human is watching"
        TF_INPUT            = '0'                       // never wait for keyboard input
        AWS_REGION          = 'eu-central-1'
        TF_PLUGIN_CACHE_DIR = '/var/lib/jenkins/.terraform.d/plugin-cache'
    }

    stages {

        // ---------- 1. Checks: run on EVERY build ----------
        stage('Format check') {
            steps {
                sh 'terraform fmt -check -recursive -diff'
            }
        }

        stage('Validate') {
            steps {
                sh 'mkdir -p "$TF_PLUGIN_CACHE_DIR"'
                script {
                    for (e in ENVS) {
                        sh "terraform -chdir=envs/${e} init -input=false -reconfigure -no-color"
                        sh "terraform -chdir=envs/${e} validate -no-color"
                    }
                }
            }
        }

        stage('Security scan (Trivy)') {
            steps {
                // REPORT MODE: lists findings but does not fail (we enforce in Block 15)
                sh 'trivy config --severity HIGH,CRITICAL --exit-code 1 --format table --output trivy-report.txt .'
                sh 'cat trivy-report.txt'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-report.txt', allowEmptyArchive: true
                }
            }
        }

        // ---------- 2. PR builds: plan only, nothing changes in AWS ----------
        stage('Plan all environments') {
            when { changeRequest() }
            steps {
                script {
                    for (e in ENVS) {
                        sh "terraform -chdir=envs/${e} plan -lock-timeout=5m -no-color -out=tfplan"
                        sh "terraform -chdir=envs/${e} show -no-color tfplan > plan-${e}.txt"
                    }
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'plan-*.txt', allowEmptyArchive: true
                }
            }
        }

        // ---------- 3. main builds: promote dev -> stage -> prod ----------
        stage('Apply dev') {
            when { branch 'main' }
            steps {
                sh 'terraform -chdir=envs/dev plan -lock-timeout=5m -no-color -out=tfplan'
                sh 'terraform -chdir=envs/dev apply -lock-timeout=5m -no-color tfplan'
            }
        }

        stage('Plan stage') {
            when { branch 'main' }
            steps {
                sh 'terraform -chdir=envs/stage plan -lock-timeout=5m -no-color -out=tfplan'
            }
        }

        stage('Approve stage') {
            when { branch 'main' }
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Read the "Plan stage" log. Apply this plan to STAGE?', ok: 'Apply to stage'
                }
            }
        }

        stage('Apply stage') {
            when { branch 'main' }
            steps {
                sh 'terraform -chdir=envs/stage apply -lock-timeout=5m -no-color tfplan'
            }
        }

        stage('Plan prod') {
            when { branch 'main' }
            steps {
                sh 'terraform -chdir=envs/prod plan -lock-timeout=5m -no-color -out=tfplan'
            }
        }

        stage('Approve prod') {
            when { branch 'main' }
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Read the "Plan prod" log. Apply this plan to PROD?', ok: 'Apply to prod'
                }
            }
        }

        stage('Apply prod') {
            when { branch 'main' }
            steps {
                sh 'terraform -chdir=envs/prod apply -lock-timeout=5m -no-color tfplan'
            }
        }
    }

    post {
        success { echo 'Pipeline finished successfully.' }
        failure { echo 'Pipeline FAILED - read the red stage log above.' }
        aborted { echo 'Pipeline aborted (e.g. approval declined or timed out).' }
    }
}
