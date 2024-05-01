docker build -t ghcr.io/emfy0/ph-bitpad . && \
docker push ghcr.io/emfy0/ph-bitpad && \
helm upgrade bitpad-ph .deploy/pheonix --install \
  -f .deploy/pheonix/values.yaml \
  --namespace bitpad-ph

# kubectl create -n crypto-morzh secret generic secret-key-base --from-literal=secret-key-base=
