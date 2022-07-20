Official docs: https://www.elastic.co/guide/en/cloud-on-k8s/2.2/k8s-quickstart.html 

Github repo: https://github.com/elastic/cloud-on-k8s/ 

FileBeat example: https://github.com/elastic/cloud-on-k8s/blob/main/config/recipes/beats/filebeat_autodiscover.yaml 

Installation:

kubectl apply -f crds.yaml

kubectl apply -f operator.yaml

kubectl apply -f elasticsearch.yaml -n logging

kubectl apply -f kibana.yaml -n logging

kubectl apply -f filebeat.yaml -n logging

kubectl apply -f kibana-ingress.yaml -n logging