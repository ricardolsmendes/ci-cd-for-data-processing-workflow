#!/bin/bash

# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

PATH=$PATH:/usr/local/airflow/google-cloud-sdk/bin
export AIRFLOW_HOME=/tmp/airflow

# $1 relative path to directory containing Airflow Variables.
# $2 relative path to JSON file containing Airflow Plugins.
function setup_local_airflow() {
  LOCAL_VARIABLES_JSON=$1
  LOCAL_PLUGIN_DIR=$2
  mkdir -p $AIRFLOW_HOME
  echo "setting up local Airflow"
  airflow version
  echo "initialize Airflow database"
  airflow initdb
  if [ -z "$LOCAL_PLUGIN_DIR" ];
  then
    echo "no plugins dir provided; skipping copy to plugins dir"
  else
    echo "copying ${LOCAL_PLUGIN_DIR} to ${AIRFLOW_HOME}"
    cp -r "$LOCAL_PLUGIN_DIR" "$AIRFLOW_HOME/"
  fi

  echo "generating Fernet key..."
  FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; \
  print(Fernet.generate_key().decode('utf-8'))")
  export FERNET_KEY

  echo "uploading connections."
  for conn_id in $AIRFLOW_CONN_LIST; do
    set_local_conn "$conn_id"
  done

  # Import Airflow Variables to local Airflow.
  if [ -z "$LOCAL_VARIABLES_JSON" ]
  then
    echo "not local variables json provided; skipping import."
  else
    echo "import Airflow vaiables"
    airflow variables --import "$LOCAL_VARIABLES_JSON"
    echo "imported Airflow vaiables:"
    airflow variables --export /tmp/AirflowVariables.json.exported
    cat /tmp/AirflowVariables.json.exported
    rm /tmp/AirflowVariables.json.exported
  fi

  echo "setting up DAGs"
  rsync -r dags $AIRFLOW_HOME
}

# Upload custom connections to local Airflow.
# $1 conn_id
function set_local_conn() {
  echo "uploading connection: $conn_id."
  #TODO remove assumption that custom connections are http.
  airflow connections --add --conn_id "$1" --conn_type http || \
  echo "Upload $1 to local Airflow failed"
}

# Run DAG validation tests.
function run_tests() {
  python3 -m unittest
}

function clean_up() {
  echo "cleaning up AIRFLOW_HOME"
  rm -rf $AIRFLOW_HOME
  unset AIRFLOW_HOME
}

# Might be necessary if we chose another image.
function install_airflow() {
  python3 -m venv airflow-env
  # shellcheck disable=SC1091
  source airflow-env/bin/activate
  pip3 install -r requirements-dev.txt
}

# $1 relative path to directory containing Airflow Variables.
# $2 relative path to JSON file containing Airflow Plugins.
main() {
  setup_local_airflow "$1" "$2"
  run_tests
  TEST_STATUS=$?
  clean_up
  exit $TEST_STATUS
}

main "$1" "$2"
