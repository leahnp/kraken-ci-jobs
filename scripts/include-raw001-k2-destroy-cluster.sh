max_retries=${DOWNRETRIES}
until docker run -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
  -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
  -e "K2_CLUSTER_NAME=${K2_CLUSTER_NAME}" \
  -e "K2_KEY_LOCATION=${K2_KEY_LOCATION}" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  /kraken/down.sh --output ${WORKSPACE}/${K2_CLUSTER_NAME} --config ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
do
  if [ ${max_retries} -gt 0 ]; then
    max_retries=$((max_retries-1))
    echo "clusterdown failed, retrying..."
    sleep 5
  else
    echo "clusterdown failed after ${DOWNRETRIES} retries!"
    exit 1
  fi
done