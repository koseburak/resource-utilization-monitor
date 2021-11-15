# Kubernetes Deployment

Deployment of containerized applications to Kubernetes

<br/>

## Download and Install Minikube
You could download and install the Minikube from the [start page](https://minikube.sigs.k8s.io/docs/start/).

<br/>

## Deploy the applications as a container to Kubernetes using kubectl

Go to the "iac/k8s" directory with the following command and after please run the next commands in this directory;
```local
cd iac/k8s
```

<br/>

### Nginx Ingress Controller Installation Guide

Enable the ingress add-on for Minikube.
 ```console
 minikube addons enable ingress
 ```

<br/>

### Deploy the applications as a container to Kubernetes

1. Create a new Namespace for the project in Kubernetes
    ```console
    kubectl create ns observer
    ```

2. Deploy the Python RestApi Application to Kubernetes
    ```console
    kubectl apply -n observer -f deploy-api.yaml
    ```

3. Deploy the Client Application to Kubernetes
    ```console
    kubectl apply -n observer -f deploy-client.yaml
    ```

4. Delete the deployment resources with the following command;
    ```console
    kubectl delete all --all -n observer
    ```


Note: If you have any version problem to running deployment, please check the api versions of kinds with the following command;
```console
kubectl api-resources | grep deployment
````
