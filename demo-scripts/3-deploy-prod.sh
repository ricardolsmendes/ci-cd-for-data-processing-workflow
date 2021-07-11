#!/bin/bash
#
# Copyright 2021 Ricardo Mendes.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export DATAFLOW_JAR_FILE_LATEST=$(gcloud composer environments run $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION variables -- \
    --get dataflow_jar_file_test 2>&1 | grep -i '.jar')


# Checkpoint
# Display the required environment variables:
echo "
SOURCE_CODE_REPO          : ${SOURCE_CODE_REPO}
_DATAFLOW_JAR_BUCKET_TEST : ${DATAFLOW_JAR_BUCKET_TEST}
_DATAFLOW_JAR_FILE_LATEST : ${DATAFLOW_JAR_FILE_LATEST}
_DATAFLOW_JAR_BUCKET_PROD : ${DATAFLOW_JAR_BUCKET_PROD}
_COMPOSER_INPUT_BUCKET    : ${INPUT_BUCKET_PROD}
_COMPOSER_ENV_NAME        : ${COMPOSER_ENV_NAME}
_COMPOSER_REGION          : ${COMPOSER_REGION}
_COMPOSER_DAG_BUCKET      : ${COMPOSER_DAG_BUCKET}
_COMPOSER_DAG_NAME_PROD   : ${COMPOSER_DAG_NAME_PROD}
"


cd ./data-pipeline-source/build-pipeline

gcloud builds submit --config=deploy-prod.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_DATAFLOW_JAR_BUCKET_TEST=$DATAFLOW_JAR_BUCKET_TEST,\
_DATAFLOW_JAR_FILE_LATEST=$DATAFLOW_JAR_FILE_LATEST,\
_DATAFLOW_JAR_BUCKET_PROD=$DATAFLOW_JAR_BUCKET_PROD,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_PROD,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_DAG_NAME_PROD=$COMPOSER_DAG_NAME_PROD

cd ../..


# List the result files in the Cloud Storage bucket after the data-processing
# workflow runs.
gsutil ls gs://$RESULT_BUCKET_PROD
