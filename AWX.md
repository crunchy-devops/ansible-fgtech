# Differents set up of AWX

## install on kubernetes kind
```shell
sudo dnf install -y  wget git 
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.30.0/kind-linux-amd64
mv kind-linux-amd64 kind
chmod +x kind
sudo mv kind /usr/local/bin/kind
kind version # should be  version 0.30.0
```
## install kubectl
```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
# add in .bashrc
alias ks='kubectl'
source <(kubectl completion bash | sed s/kubectl/ks/g)
# check 
kubectl version
# should be version 1.34.2
```

## Create a cluster
```shell
cd /home/alma/ansible-fgtech/kind
kind create cluster --name awx --config kind-config-cluster.yml
ks version # should be version  v1.34.1+
ks get nodes # see one controle-plane and 3 workers
kubectl cluster-info --context kind-awx
# kind delete cluster --name awx
```

## install AWX
```shell
cd
git clone https://github.com/ansible/awx-operator.git
cd awx-operator/
git checkout tags/2.19.1
git log --oneline  # HEAD should be on tag 2.19.1 #hash dd37ebd

```
## Create s namespace
```shell
kubectl create namespace awx
```
### Check the file kustomization.yaml in awx directory
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=2.19.1
  - awx-demo.yaml
# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.19.1
# Specify a custom namespace in which to install AWX
namespace: awx
```
##  Deploy awx-demo.ym; AWX Instance 
```yaml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
  namespace: awx
spec:
  service_type: nodeport
```

## or copy file kustomization.yaml
```shell
cp ../ansible-fgtech/kind/kustomization.yaml .
cp ../ansible-fgtech/kind/awx-demo.yaml .
```

## run
```shell
ks apply -k . 
ks get pod -A
```  # 


wait nearly 10 minutes


## User AWX
username admin
Password uses the command below
```shell
kubectl get secret -n awx  awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode ; echo
```

## Web access
```
# example
kubectl port-forward -n awx service/awx-demo-service 30600:80  &
```
access to AWX with http://<ip>:30600

## Apply a systemctl service 
```shell
cd  ansible-fgtech/kind 
sudo cp kind-port-forward.service /etc/systemd/system/ 
sudo systemctl start kind-port-forward.service 
sudo systemctl status kind-port-forward.service 
```

## Caveats
```shell
# Check AWX web pod 
ks exec --stdin --tty -n awx  awx-demo-web-66587ff4b-hvzsf -- /bin/bash
```

## Troubleshooting to prevent job template failure in AWX
```shell
echo fs.inotify.max_user_watches=655360 | sudo tee -a /etc/sysctl.conf
echo fs.inotify.max_user_instances=1280 | sudo tee -a /etc/sysctl.conf
echo fs.file-max = 2097152 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Go to the directory nginx for setting up https access and reverse proxy for AWX