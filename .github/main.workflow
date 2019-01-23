workflow "Validate manifests" {
  on = "push"
  resolves = ["helm-lint"]
}

action "yaml-lint" {
  uses = "stefanprodan/gh-actions/yamllint@master"
  args = ["-d '{extends: relaxed, rules: {line-length: {max: 120}}}' -f parsable ./releases/*"]
}

action "kube-lint" {
  needs = ["yaml-lint"]
  uses = "stefanprodan/gh-actions/kubeval@master"
  args = "workloads/*"
}

action "helm-lint" {
  needs = ["kube-lint"]
  uses = "stefanprodan/gh-actions/helm@master"
  args = ["lint charts/*"]
}
