# CI/CD for data processing workflow

This repository contains source code based a guide on how to use Cloud Build
and Cloud Composer to create a CI/CD pipeline for building, testing, and
deploying a data processing workflow. Please refer to [Setting up a CI/CD
pipeline for your data-processing workflow](https://cloud.google.com/architecture/cicd-pipeline-for-data-processing)
for the overall steps to run the code.

> **DISCLAIMER**: the present repo is a work in progress, and some commands may
> fail. Feel free to file an issue if you find any errors while using it!  

Bear in mind the `source-code/workflow` folder structure in this fork is
different from the [original](https://github.com/GoogleCloudPlatform/ci-cd-for-data-processing-workflow/tree/master/source-code/workflow-dag)
`source-code/workflow-dag`. The changes were inspired by additional thoughts
from the below [examples](#useful-links--examples).

## Useful Links & Examples

1. Setting up a CI/CD pipeline for your data-processing workflow, [forked repo
   with more examples](https://github.com/jaketf/ci-cd-for-data-processing-workflow)
   
1. [Building CI/CD with Airflow, GitLab and Terraform in
   GCP](https://engineering.ripple.com/building-ci-cd-with-airflow-gitlab-and-terraform-in-gcp)

1. [Developing a CI/CD Practice for Google Cloud
   Composer](https://www.springml.com/blog/developing-continuous-integration-for-google-cloud-composer)
   
1. Testing in Airflow
   - Part 1: [DAG Validation Tests, DAG Definition Tests and Unit
     Tests](https://blog.usejournal.com/testing-in-airflow-part-1-dag-validation-tests-dag-definition-tests-and-unit-tests-2aa94970570c)
   - Part 2: [Integration Tests and End-To-End Pipeline
     Tests](https://medium.com/@chandukavar/testing-in-airflow-part-2-integration-tests-and-end-to-end-pipeline-tests-af0555cd1a82)
