#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name petstore-api-stack101 \
  --query "Stacks[0].Outputs[*].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  API_chaining_variables.postman_environment.json > API_chaining_variables.postman_environment.json.tmp \
  && cp API_chaining_variables.postman_environment.json.tmp LML_DATA_TEST_API.postman_collection.json \
  && rm API_chaining_variables.postman_environment.json.tmp

echo "Updated PetStoreAPIEnvironment.postman_environment.json"

cat API_chaining_variables.postman_environment.json