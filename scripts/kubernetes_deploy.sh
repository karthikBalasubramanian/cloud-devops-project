echo "create a persistant volume in cluster\n"
kubectl apply -f ../kubernetes/my_postgres_persistant_volume.yaml

echo "acquire the created persistant volume by using a persistant volume claim\n"
kubectl apply -f ../kubernetes/my_postgres_persistant_volume_claim.yaml

echo "create postgres credentials secret vault\n"
kubectl apply -f ../kubernetes/my_postgres_secret.yaml

echo "create postgres deployment and service"
kubectl apply -f ../kubernetes/my_postgres_deployment.yaml
kubectl apply -f ../kubernetes/my_postgres_service.yaml

echo "Creating the translate deployment and service..."
kubectl apply -f ../kubernetes/my_translate_app_deployment.yaml
kubectl apply -f ../kubernetes/my_translate_app_service.yaml

