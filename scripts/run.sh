#!/bin/bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT

function main() {
  pushd "${ROOT}" > /dev/null || true
    if [[ ! -e "${ROOT}/build/cloud_loc" ]]; then
      "${ROOT}/scripts/build.sh"
    fi

    local carla_pid
    chpst -u student "${ROOT}/scripts/carla.sh" &
    carla_pid="${!}"

    sleep 10 # wait for the simulator to start

    "${ROOT}/build/cloud_loc"

    kill "${carla_pid}"
    wait
  popd > /dev/null || true
}

main "${@:-}"
