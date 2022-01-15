#!/bin/bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT

function main() {
  pushd "${ROOT}" > /dev/null || true
    ln -sf /carla/PythonAPI/carla/dependencies libcarla-install
    ln -sf /usr/lib/x86_64-linux-gnu/libboost_numpy38.a libcarla-install/lib/libboost_numpy38.a

    rm -rf "${ROOT}/build"
    mkdir -p "${ROOT}/build"

    pushd "${ROOT}/build" > /dev/null || true
      cmake .. && make
    popd > /dev/null || true
  popd > /dev/null || true
}

main "${@:-}"
