resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content = <<EOF
apiVersion: v1
clusters:
- cluster:
    server: ${data.aws_eks_cluster.target_cluster.endpoint}
    certificate-authority-data: ${data.aws_eks_cluster.target_cluster.certificate_authority[0].data}
  name: ${data.aws_eks_cluster.target_cluster.name}
contexts:
- context:
    cluster: ${data.aws_eks_cluster.target_cluster.name}
    user: ${data.aws_eks_cluster.target_cluster.name}
  name: ${data.aws_eks_cluster.target_cluster.name}
current-context: ${data.aws_eks_cluster.target_cluster.name}
kind: Config
preferences: {}
users:
- name: ${data.aws_eks_cluster.target_cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${data.aws_eks_cluster.target_cluster.name}"
        - "--region"
        - "${var.region}"
EOF
}

resource "null_resource" "set_kubeconfig" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=${path.module}/kubeconfig"
  }
  depends_on = [local_file.kubeconfig]
}