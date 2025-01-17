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
"""Data processing production workflow definition.
"""
import datetime

from airflow import models
from airflow.contrib.operators.dataflow_operator import DataFlowJavaOperator

project = models.Variable.get('gcp_project')
region = models.Variable.get('gcp_region')
zone = models.Variable.get('gcp_zone')

dataflow_jar_location = \
    f'gs://{models.Variable.get("dataflow_jar_location_prod")}' \
    f'/{models.Variable.get("dataflow_jar_file_prod")}'
dataflow_staging_bucket = \
    f'gs://{models.Variable.get("dataflow_staging_bucket_prod")}/staging'

input_bucket = f'gs://{models.Variable.get("gcs_input_bucket_prod")}'
output_bucket = f'gs://{models.Variable.get("gcs_output_bucket_prod")}'
output_prefix = 'output'
download_task_prefix = 'download_result'

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

default_args = {
    'owner': 'ricardolsmendes@gmail.com',
    'dataflow_default_options': {
        'project': project,
        'zone': zone,
        'region': region,
        'stagingLocation': dataflow_staging_bucket
    }
}

with models.DAG('wordcount_prod',
                schedule_interval=None,
                default_args=default_args) as dag:

    dataflow_execution = DataFlowJavaOperator(
        task_id='wordcount-run',
        jar=dataflow_jar_location,
        start_date=yesterday,
        options={
            'autoscalingAlgorithm': 'THROUGHPUT_BASED',
            'maxNumWorkers': '3',
            'inputFile': f'{input_bucket}/input.txt',
            'output': f'{output_bucket}/{output_prefix}'
        })
