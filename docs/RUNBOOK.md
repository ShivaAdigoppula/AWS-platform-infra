# Runbook

## Prerequisites
Terraform ≥ 1.10, AWS CLI v2 (SSO profile `admin`, region eu-central-1), kubectl, Docker.

## Build from zero (order matters)
1. `bootstrap/`: `terraform init && terraform apply` (local state), then add `backend.tf`
   and `terraform init -migrate-state`.
2. `global/`: create `admin.auto.tfvars` with your IP, then `terraform apply`
   (ECR, tools VPC, Jenkins + SonarQube).
3. Configure Jenkins (plugins, credentials, multibranch jobs, webhooks), SonarQube (project,
   token, webhook), GitHub rulesets.
4. Merge any PR (or `main` → Build Now): the pipeline applies dev, incl. Argo CD and demo-app.

## Daily start / stop
- Start: `aws sso login --profile admin` → start the Jenkins instance → check your IP (below).
- Stop: dev is destroyed nightly by `dev-nightly-destroy` (21:xx) **if Jenkins runs**;
  otherwise run it manually. Then stop the Jenkins instance.

## My IP changed
Update it in: `global/admin.auto.tfvars` (+ `terraform -chdir=global apply`),
`envs/*/terraform.tfvars` → `eks_public_access_cidrs` (PR), and the gitops
`service.yaml` → `loadBalancerSourceRanges` (push).

## Destroy dev manually
`kubectl delete application root -n argocd --wait=true --timeout=5m` → wait until
`kubectl get svc -A` shows no LoadBalancer → `terraform -chdir=envs/dev destroy`.

## Troubleshooting
| Symptom | Fix |
|---|---|
| `Token has expired` | `aws sso login --profile admin` |
| `Backend configuration changed` | Check `key` in backend.tf, then `terraform init -reconfigure` |
| `Error acquiring the state lock` | Wait for the other run; `terraform force-unlock <ID>` only if nothing runs |
| kubectl `no such host` | Cluster was rebuilt: `aws eks update-kubeconfig --name dev-eks` |
| kubectl timeout | Your IP isn't in `eks_public_access_cidrs` |
| Quality gate timeout | SonarQube webhook URL/secret mismatch |
| Destroy: `DependencyViolation` | A Kubernetes load balancer still exists: delete the Argo CD apps first |

## Token rotation (every 90 days)
GitHub fine-grained tokens `jenkins-aws-platform`, `jenkins-gitops-writer`; the SonarQube
project token; the webhook secrets. Update the matching Jenkins credentials.