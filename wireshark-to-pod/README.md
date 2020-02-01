### Connect to Pod with Wireshark

### Example

```bash
kubectl get po -n ops | grep list-ing
list-ingress-85b4b876dd-gtfpp             1/1     Running   0          26d
```

```bash
./wireshark_to_pod.sh ops list-ingress-85b4b876dd-gtfpp
```


![Screenshot](https://github.com/Nastradamus/k8s-snippets/raw/master/wireshark-to-pod/wireshark.png)
