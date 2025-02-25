#!/bin/bash -e

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.


feature_name="${1}"
feature=$(find artifacts -name "*${feature_name}*.slingosgifeature")

if [[ ! -f "${feature}" ]]; then
    echo "[ERROR] Did not find any feature file matching name ${feature_name}. Aborting"
    exit 1
fi

docker_feature=$(find artifacts -name "*docker.slingosgifeature")

echo "[INFO] Selected ${feature} for launching"
echo "[INFO] Automatically appended ${docker_feature}"

feature="${feature},${docker_feature}"

# remove add-opens after SLING-10831 is fixed
export JAVA_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED"
exec org.apache.sling.feature.launcher/bin/launcher \
    -c artifacts \
    -CC "org.apache.sling.commons.log.LogManager=MERGE_LATEST" \
    -f ${feature}
