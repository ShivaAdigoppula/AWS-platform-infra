# ---------- Release 1: Argo CD itself (official chart) ----------
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  # Lighter install for small dev nodes: no SSO (dex) and no notifications
  values = [yamlencode({
    dex           = { enabled = false }
    notifications = { enabled = false }
  })]

  wait    = true # wait until all Argo CD pods are ready
  timeout = 600  # seconds
}

# ---------- Release 2: the ROOT Application ("app of apps") ----------
# Separate release: the Application type only exists AFTER release 1 installed its CRDs.
resource "helm_release" "root_app" {
  name      = "argocd-root"
  namespace = "argocd"
  chart     = "${path.module}/root-app-chart" # our own tiny local chart

  values = [yamlencode({
    repoURL        = var.gitops_repo_url
    targetRevision = var.gitops_revision
    path           = var.apps_path
  })]

  depends_on = [helm_release.argocd]
}