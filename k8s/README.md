# NextDNS CLI for Kubernetes

NOTE: This is a WIP. The docker-compose example was converted to Kubernetes using [kompose](https://kompose.io/).

0. Obtain your NextDNS Profile ID(s) from the [NextDNS web interface](https://my.nextdns.io)

1. Create a k8s secret with your NextDNS Profile configuration

    ```bash
    kubectl create secret generic nextdns-profile --from-literal=profile1=1a2s3d4f --from-literal=profile2=a1s2d3f4
    ```

2. Deploy the NextDNS docker image from Github Container Registry

    ```bash
    kubectl apply -f nextdns-deployment.yaml
    # view and inspect the deployment
    kubectl describe deployments nextdns

    # view and inspect the pods in deployment
    kubectl get pods | grep nextdns
    kubectl describe pods nextdns-<pod-id>
    kubectl logs -f nextdns-<pod-id>
    ```

3. Expose the NextDNS service ports using your k8s LoadBalancer or Ingress controller

    ```bash
    kubectl apply -f nextdns-service.yaml
    # view and inspect the service
    k get services | grep nextdns
    kubectl describe services nextdns
    ```

4. Verify the service is working by querying the service using `nslookup` 

    ```bash
    # using the `EXTERNAL-IP` from the service inspection from step 3
    nslookup twitch.tv <EXTERNAL-IP>
    ```

![](./nslookup-nextdns-logs.png)


# Restarting

Delete the services first, then the reapply deployment

```bash
kubectl delete -f nextdns-service.yaml
kubectl apply -f nextdns-deployment.yaml
```
