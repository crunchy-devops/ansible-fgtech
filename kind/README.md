# Install kind port-forwarding as a Service 

```shell
cd  ansible-fgtech/kind 
cp kind-port-forward.service /etc/systemd/system/ 
sudo systemctl start kind-port-forward.service 
sudo systemctl status kind-port-forward.service 
```