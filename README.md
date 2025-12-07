## DevOps Project

### Objective

Devopsify a simple web application written in Python.

### TODO

- [x] Containerize the project - dockerfile
- [x] K8s manifest file
- [x] Setup CI with Github actions
- [ ] Setup CD (GitOps) with ArgoCD
- [x] Setup K8s cluster with Terraform / Use KodeKloud playground
- [x] Setup Helm Chart for K8s deployment
- [x] Ingress Controller configuration
- [ ] DNS mapping
- [ ] Monitoring (future)

#### Adding NGINX controller on Azure

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.1/deploy/static/provider/cloud/deploy.yaml`

#### Installing ArgoCD




#### Connecting to AKS cluster (KodeKloud Playground)

```
az login

az aks get-credentials --resource-group kml_rg_main-a4ff6ffc5d474819 --name devops-project --overwrite-existing

kubelogin convert-kubeconfig -l azurecli
```

### Learnings

#### Multiplatform Docker build 

Error : 

Failed to pull image "niravro/flask-app:1.1": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/niravro/flask-app:1.1": no match for platform in manifest: not found

Reason : 

Kubernetes tried to pull docker.io/niravro/flask-app:1.1 but the image manifest in the registry does not contain a variant for the node architecture. In other words: the cluster node(s) are one CPU architecture (e.g. arm64) and the pushed image only has another (e.g. amd64). Kubernetes reports "no match for platform in manifest: not found".

Troubleshooting : 

```
- Check node architecture(s)

kubectl get nodes -o wide
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.nodeInfo.architecture}{"\n"}{end}'

- Inspect the registry manifest for platforms

docker manifest inspect docker.io/niravro/flask-app:1.1

- Try pulling for a specific platform (diagnostic)

docker pull --platform linux/amd64 docker.io/niravro/flask-app:1.1
docker pull --platform linux/arm64  docker.io/niravro/flask-app:1.1
```
**Image pull failed for linux/amd64 platform. Since we built the image on ARM Mac, AKS node running amd64 could not pull it.**

Solution :

Add target platforms during build, it creates separate manifests and a list pointing to each with different configuration and set of layers.

`docker build -t niravro/flask-app:1.3 --platform=linux/amd64,linux/arm64 .`

---