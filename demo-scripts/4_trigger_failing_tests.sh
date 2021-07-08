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

cd ./data-pipeline-source


vim ./data-processing-code/src/main/java/org/apache/beam/examples/WordCount.java
# Delete the "!" operator in line 110: "if (word.isEmpty()) {"
# Save, commit, and push the change (make sure the Cloud Build trigger has been
# properly set up).


# Revert the change
vim ./data-processing-code/src/main/java/org/apache/beam/examples/WordCount.java
# Restore the "!" operator in line 110: "if (!word.isEmpty()) {"
# Save, commit, and push the change (make sure the Cloud Build trigger has been
# properly set up).


cd ..
