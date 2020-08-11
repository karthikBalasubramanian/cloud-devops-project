# echo "start a minikube in virtual-box"
minikube stop
minikube delete
minikube start

sleep 10

echo "create a persistant volume in cluster\n"
kubectl apply -f ../kubernetes/my_postgres_persistant_volume.yaml

sleep 10

echo "acquire the created persistant volume by using a persistant volume claim\n"
kubectl apply -f ../kubernetes/my_postgres_persistant_volume_claim.yaml

sleep 10

echo "create postgres credentials secret vault\n"
kubectl apply -f ../kubernetes/my_postgres_secret.yaml

sleep 10

echo "create postgres deployment and service"
kubectl apply -f ../kubernetes/my_postgres_deployment.yaml
kubectl apply -f ../kubernetes/my_postgres_service.yaml

sleep 10

echo "Creating the translate deployment and service..."
kubectl apply -f ../kubernetes/my_translate_app_deployment.yaml
sleep 50
kubectl apply -f ../kubernetes/my_translate_app_service.yaml

