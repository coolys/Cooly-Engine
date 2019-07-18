# cooly-engine

- Full lifecycle distributed crawler engine
- What's make it's better solution for web scrapping

# Gateway Board
  - Web UI for manage all expose APIs in engine as functionalities 
  - Design Rules
  - Dashboard
  - Mornitoring
  - Manage Scheduling
  - Manage fetch engine
  - Manage feeds/data
  - Manage media
  
# Scheduler Engine
  + Distributed scheduling using Quartz with quartz-mongodb
# Fetching Engine
  + Selenium engine
  + HTTP Engine
  + RSS Engine
  + API engine (fb, twitter..)
  
# Parser Engine
  + Parse web html base on semantic data using schema.org 
  + Rule base engine free design how to parse data base on JSON and DOM, CSS, and jquery-like methods.
  + Distributed and share rules cross engine base on domain of the web
  
# Downloading Engine
 + Download image/video 
 + Parsing image/video meta data infomration
# Indexing Engine
 + MongoDB and Elastic Search
 + Searching data, index ..
# Uploading Engine
 + S3 Uploader 
 + More provider comming
# Centralize Logging Engine base on ELK
  + Logtash, Kibna, Elastic Search
  + Prometheus comming soon
  + Datadog agent comming soon
# Data Export format (json, csv)
 + Crawed data as Files (html, csv, json)
 + Can be downloaded from S3
# Authenticate Service using Oauth and JWT for Security
# Micro Services architect base on NETFLIX OSS
# Proxy Engine




#cooly-kubernetes



## Preparation

You will need to push your image to a registry. If you have not done so, use the following commands to tag and push the images:

```
$ docker push authservice
$ docker push configurer
$ docker push fetcher
$ docker push indexer
$ docker push parser
$ docker push scheduler
```

## Deployment

You can deploy all your apps by running the below bash command:

```
./kubectl-apply.sh
```

## Exploring your services

```

## Scaling your deployments

You can scale your apps using

```

\$ kubectl scale deployment <app-name> --replicas <replica-count> -n cooly-crawler

```

## zero-downtime deployments

The default way to update a running app in kubernetes, is to deploy a new image tag to your docker registry and then deploy it using

```

\$ kubectl set image deployment/<app-name>-app <app-name>=<new-image> -n cooly-crawler

```

Using livenessProbes and readinessProbe allow you to tell Kubernetes about the state of your applications, in order to ensure availablity of your services. You will need minimum 2 replicas for every application deployment if you want to have zero-downtime deployed. This is because the rolling upgrade strategy first kills a running replica in order to place a new. Running only one replica, will cause a short downtime during upgrades.

## Monitoring tools

### Crawler console

Your application logs can be found in Crawler console (powered by Kibana). You can find its service details by
```

\$ kubectl get svc crawler-console -n cooly-crawler

```

* If you have chosen *Ingress*, then you should be able to access Kibana using the given ingress domain.
* If you have chosen *NodePort*, then point your browser to an IP of any of your nodes and use the node port described in the output.
* If you have chosen *LoadBalancer*, then use the IaaS provided LB IP

## Crawler registry

The registry is deployed using a headless service in kubernetes, so the primary service has no IP address, and cannot get a node port. You can create a secondary service for any type, using:

```

\$ kubectl expose service crawler-registry --type=NodePort --name=exposed-registry -n cooly-crawler

```

and explore the details using

```

\$ kubectl get svc exposed-registry -n cooly-crawler

```

For scaling the Crawler registry, use

```

\$ kubectl scale statefulset crawler-registry --replicas 3 -n cooly-crawler

```


## Troubleshooting

> my apps doesn't get pulled, because of 'imagePullBackof'

Check the registry your Kubernetes cluster is accessing. If you are using a private registry, you should add it to your namespace by `kubectl create secret docker-registry` (check the [docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for more info)

> my applications get killed, before they can boot up

This can occur if your cluster has low resource (e.g. Minikube). Increase the `initialDelySeconds` value of livenessProbe of your deployments

> my applications are starting very slow, despite I have a cluster with many resources

The default setting are optimized for middle-scale clusters. You are free to increase the JAVA_OPTS environment variable, and resource requests and limits to improve the performance. Be careful!


> my SQL-based microservice is stuck during Liquibase initialization when running multiple replicas

Sometimes the database changelog lock gets corrupted. You will need to connect to the database using `kubectl exec -it` and remove all lines of liquibases `databasechangeloglock` table.
```
