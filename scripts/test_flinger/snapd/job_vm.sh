#!/bin/bash

echo "Creating job for snapd using a vm"

HOST=localhost
PORT=8022

cat > job.yaml <<EOF
job_queue: $DEVICE_QUEUE
provision_data:
    distro: xenial
test_data:
    test_cmds: |
        #!/bin/bash
        ssh $DEVICE_USER@{device_ip} "sudo apt update || ps aux | grep apt"
        ssh $DEVICE_USER@{device_ip} "sudo apt install -y git curl jq sshpass"
        ssh $DEVICE_USER@{device_ip} "git clone $JOBS_URL"
        ssh $DEVICE_USER@{device_ip} "(cd $JOBS_PROJECT && git checkout $JOBS_BRANCH)"
        ssh $DEVICE_USER@{device_ip} "git clone $SNAPD_URL $PROJECT"
        ssh $DEVICE_USER@{device_ip} "(cd $PROJECT && git checkout $BRANCH && git checkout $COMMIT)"
        $PRE_HOOK
        ssh $DEVICE_USER@{device_ip} "sudo $JOBS_PROJECT/scripts/utils/create_vm.sh \"$ARCHITECTURE\" \"$CHANNEL\" \"$PORT\" \"$CORE_CHANNEL\" \"./$PROJECT\""
        ssh $DEVICE_USER@{device_ip} ". $JOBS_PROJECT/scripts/utils/register_device.sh \"$HOST\" \"$PORT\" \"$TEST_USER\" \"$TEST_PASS\" \"$REGISTER_EMAIL\""
        ssh $DEVICE_USER@{device_ip} ". $JOBS_PROJECT/scripts/utils/refresh.sh \"$HOST\" \"$PORT\" \"$TEST_USER\" \"$TEST_PASS\" \"$CHANNEL\" \"$CORE_CHANNEL\""
        ssh $DEVICE_USER@{device_ip} ". $JOBS_PROJECT/scripts/utils/run_setup.sh \"$HOST\" \"$PORT\" \"$TEST_USER\" \"$TEST_PASS\" \"$SETUP\""
        ssh $DEVICE_USER@{device_ip} ". $JOBS_PROJECT/scripts/utils/get_spread.sh"
        ssh $DEVICE_USER@{device_ip} ". $JOBS_PROJECT/scripts/utils/run_spread.sh \"$HOST\" \"$PORT\" \"$PROJECT\" \"$SPREAD_TESTS\" \"$SPREAD_ENV\" \"$SKIP_TESTS\" \"$SPREAD_PARAMS\""
        $POST_HOOK
EOF

export TF_JOB=$TF_DATA/job.yaml
sudo mv job.yaml $TF_JOB