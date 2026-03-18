---
name: volcengine-terraform-k8s
description: 使用 Terraform 在火山引擎（Volcengine）创建 VKE Kubernetes 集群的最短可执行流程，包含前置准备、Terraform 模板、初始化、创建、导出 kubeconfig 与销毁步骤。
---

# Volcengine Terraform K8s

## Overview

当用户要求“使用 Terraform 在火山云/火山引擎创建 K8s 集群”时，优先提供一套可直接执行的 **VKE（容器服务）** 标准流程。

默认目标：先创建一个可用的 VKE 集群（无 ECS 节点），并导出 `kubeconfig` 供后续 `kubectl` 使用。

## Workflow

### 1) 前置确认

先确认以下参数，若用户未提供则按默认值执行：

- `region`: 默认 `cn-beijing`
- `zone`: 默认 `cn-beijing-a`
- `cluster_name`: 默认 `tf-created-vke-serverless`
- `kubernetes_version`: 默认 `1.26`
- `vpc_cidr`: 默认 `172.16.0.0/16`
- `subnet_cidr`: 默认 `172.16.0.0/24`

### 2) 准备认证信息

推荐使用环境变量（避免明文写入 Terraform 文件）：

```bash
export VOLCENGINE_ACCESS_KEY="<your-ak>"
export VOLCENGINE_SECRET_KEY="<your-sk>"
export VOLCENGINE_REGION="cn-beijing"
```

### 3) 使用模板创建 Terraform 工程

复制 `templates/` 下文件到你的 IaC 目录：

- `versions.tf`
- `variables.tf`
- `main.tf`
- `outputs.tf`
- `terraform.tfvars.example`

然后：

1. 将 `terraform.tfvars.example` 复制为 `terraform.tfvars`
2. 按实际地域、可用区、版本修改变量
3. 执行 `terraform init && terraform plan && terraform apply`

### 4) 导出 kubeconfig 并连接集群

```bash
terraform output -raw kubeconfig_public > kubeconfig
export KUBECONFIG=$PWD/kubeconfig
kubectl get nodes
```

说明：无 ECS 节点模式下，`kubectl get nodes` 可能暂时无 Worker 节点，这是预期行为。

### 5) 销毁资源

```bash
terraform destroy
```

## Execution rules

- 优先输出可直接复制执行的命令。
- AK/SK 一律建议使用环境变量，不在代码块中写真实密钥。
- 若用户需要“生产可用”，追加：
  - 私网 API Server + 白名单控制
  - 删除保护策略评估
  - 远端 State（如对象存储）和状态锁
  - 分环境目录（dev/staging/prod）

## Resources

- `templates/versions.tf`：Terraform 与 Provider 版本约束。
- `templates/variables.tf`：关键变量定义。
- `templates/main.tf`：VPC、子网、VKE 集群资源。
- `templates/outputs.tf`：输出 kubeconfig。
- `templates/terraform.tfvars.example`：变量示例值。
