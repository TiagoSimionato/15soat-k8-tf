# 15soat Kubernetes Infrastructure

This repository provisions the local Kubernetes infrastructure used by the 15soat technical challenge. It uses Terraform to create a two-node [Kind](https://kind.sigs.k8s.io/) cluster and configure the Kubernetes resources needed to expose and scale the application.

## What it provides

- A Kind cluster named `soat-cluster` with one control-plane node and one worker node.
- The `soat-grupo76` application namespace.
- Traefik as the Kubernetes Ingress controller.
- HTTP routing from `/` to `app-svc-15soat-tech-challenge` on port `3000`.
- Kubernetes Metrics Server for resource metrics.
- A Horizontal Pod Autoscaler that keeps the application between one and three replicas based on 25% average CPU utilization.

The application Deployment and Service are referenced by the Terraform resources but are not defined in this repository. They must exist in the `soat-grupo76` namespace for the Ingress and HPA to route traffic and scale the application.

## Repository layout

```text
infra/  Terraform configuration for the Kind cluster and Kubernetes resources
k8s/    Kubernetes manifests consumed by Terraform, including Metrics Server
```

## Prerequisites

- Docker running locally
- Terraform 1.x
- `kubectl` for inspecting the cluster

## Create the environment

Run Terraform from the `infra` directory:

```bash
cd infra
terraform init
terraform apply
```

Terraform creates the cluster and installs the namespace, Traefik, Metrics Server, Ingress, and HPA. Apply the application Deployment and Service separately, if they are maintained in another repository.

## Access and verify

The Kind node maps these ports to the host:

| Purpose | Host | Cluster |
| --- | ---: | ---: |
| Application ingress | `8000` | `30080` |
| Traefik dashboard | `9000` | `30900` |
| Application port mapping | `3000` | `30000` |

Useful checks:

```bash
kubectl get nodes
kubectl get pods -n soat-grupo76
kubectl get ingress -n soat-grupo76
kubectl top pods -n soat-grupo76
kubectl get hpa -n soat-grupo76
```

The HPA requires Metrics Server to be ready and the application pods to define CPU resource requests.

## Tear down

```bash
cd infra
terraform destroy
```

This removes the Terraform-managed Kubernetes resources and the local Kind cluster.
