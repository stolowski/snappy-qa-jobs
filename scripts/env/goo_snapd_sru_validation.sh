#!/bin/sh

. "$SCRIPTS_DIR/env/common.sh"

export PROJECT=${PROJECT:-"snapd"}
export CHANNEL=${CHANNEL:-"stable"}
export SPREAD_TESTS=${SPREAD_TESTS:-"google-sru"}
export SPREAD_ENV=${SPREAD_ENV:-"SPREAD_MODIFY_CORE_SNAP_FOR_REEXEC=0 SPREAD_TRUST_TEST_KEYS=false SPREAD_SNAP_REEXEC=0 SPREAD_CORE_CHANNEL=stable SPREAD_SRU_VALIDATION=1"}
export SPREAD_PARAMS=${SPREAD_PARAMS:-"-v"}
