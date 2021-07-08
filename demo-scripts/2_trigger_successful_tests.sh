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

# Checkpoint
# Display the required environment variables:
echo "
_DATAFLOW_JAR_BUCKET    : ${DATAFLOW_JAR_BUCKET_TEST}
_COMPOSER_INPUT_BUCKET  : ${INPUT_BUCKET_TEST}
_COMPOSER_REF_BUCKET    : ${REF_BUCKET_TEST}
_COMPOSER_DAG_BUCKET    : ${COMPOSER_DAG_BUCKET}
_COMPOSER_ENV_NAME      : ${COMPOSER_ENV_NAME}
_COMPOSER_REGION        : ${COMPOSER_REGION}
_COMPOSER_DAG_NAME_TEST : ${COMPOSER_DAG_NAME_TEST}
"

cd ./data-pipeline-source/build-pipeline

gcloud builds submit --config=build_deploy_test.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_DATAFLOW_JAR_BUCKET=$DATAFLOW_JAR_BUCKET_TEST,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_TEST,\
_COMPOSER_REF_BUCKET=$REF_BUCKET_TEST,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_NAME_TEST=$COMPOSER_DAG_NAME_TEST

cd ../..

# Verify that the WordCount sample JAR file was copied into the correct bucket.
# Please notice $BUILD_ID is appended to the filename.
gsutil ls gs://$DATAFLOW_JAR_BUCKET_TEST/dataflow_deployment*.jar
