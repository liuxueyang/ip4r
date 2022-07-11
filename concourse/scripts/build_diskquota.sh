#!/bin/bash -l

set -exo pipefail

function pkg() {
    [ -f /opt/gcc_env.sh ] && source /opt/gcc_env.sh
    source /usr/local/greenplum-db-devel/greenplum_path.sh

    if [ "${IP4R_OS}" = "rhel6" ]; then
        export CC="$(which gcc)"
    fi

    pushd /home/gpadmin/ip4r_artifacts
    local last_release_path
    last_release_path=$(readlink -e /home/gpadmin/last_released_ip4r_bin/ip4r-*.tar.gz)
    cmake /home/gpadmin/ip4r_src \
        -DIP4R_LAST_RELEASE_PATH="${last_release_path}" \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
    cmake --build . --target create_artifact
    popd
}

function _main() {
    time pkg
}

_main "$@"
