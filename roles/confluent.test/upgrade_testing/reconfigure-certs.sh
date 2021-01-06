#!/bin/bash

set -e

SCENARIO_NAME=mtls-debian
cd ..

echo "Running molecule converge on $SCENARIO_NAME"
molecule converge -s $SCENARIO_NAME -- --skip-tags package

cd ../..
echo "Reconfigure with New Properties"
ansible-playbook -i ~/.cache/molecule/confluent.test/$SCENARIO_NAME/inventory all.yml --skip-tags package --extra-vars '{"regenerate_keystore_and_truststore":"true"}'

echo "Validate New Properties"
#ansible -i ~/.cache/molecule/confluent.test/$SCENARIO_NAME/inventory zookeeper -m import_role -a "name=confluent.test tasks_from=check_property.yml" --extra-vars '{"file_path": "/etc/kafka/zookeeper.properties", "property": "this", "expected_value": "that"}'
#ansible -i ~/.cache/molecule/confluent.test/$SCENARIO_NAME/inventory kafka_broker -m import_role -a "name=confluent.test tasks_from=check_property.yml" --extra-vars '{"file_path": "/etc/kafka/server.properties", "property": "this", "expected_value": "that"}'
#ansible -i ~/.cache/molecule/confluent.test/$SCENARIO_NAME/inventory schema_registry -m import_role -a "name=confluent.test tasks_from=check_property.yml" --extra-vars '{"file_path": "/etc/schema-registry/schema-registry.properties", "property": "this", "expected_value": "that"}'

echo "Destroy containers"
#cd roles/confluent.test
#molecule destroy -s $SCENARIO_NAME
