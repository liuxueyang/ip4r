#!/bin/bash -l

set -exo pipefail

CWDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR=${CWDIR}/../../../

source "${TOP_DIR}/gpdb_src/concourse/scripts/common.bash"
function pkg() {
    [ -f /opt/gcc_env.sh ] && source /opt/gcc_env.sh
    source /usr/local/greenplum-db-devel/greenplum_path.sh

    if [ "${IP4R_OS}" = "rhel6" ]; then
        export CC="$(which gcc)"
    fi

    pushd /home/gpadmin/ip4r_src
    # local last_release_path
    # last_release_path=$(readlink -e /home/gpadmin/last_released_ip4r_bin/ip4r-*.tar.gz)
    make clean
    make install
    popd

    pushd /usr/local/greenplum-db-devel/
    echo 'cp -r lib share $GPHOME || exit 1'> install_gpdb_component
    chmod a+x install_gpdb_component
    mkdir -p $TOP_DIR/ip4r_artifacts
    tar -czf "$TOP_DIR/ip4r_artifacts/ip4r-${IP4R_OS}_x86_64.tar.gz" \
        "lib/postgresql/ip4r.so" \
        "share/postgresql/extension/ip4r.control" \
        "share/postgresql/extension/ip4r--2.4.sql" \
        "share/postgresql/extension/ip4r--2.2--2.4.sql" \
        "share/postgresql/extension/ip4r--2.1--2.2.sql" \
        "share/postgresql/extension/ip4r--2.0--2.1.sql" \
        "share/postgresql/extension/ip4r--unpackaged2.1--2.1.sql" \
        "share/postgresql/extension/ip4r--unpackaged2.0--2.0.sql" \
        "share/postgresql/extension/ip4r--unpackaged1--2.0.sql" \
        "install_gpdb_component"
    popd
    cp "$TOP_DIR/ip4r_artifacts/ip4r-${IP4R_OS}_x86_64.tar.gz" "$TOP_DIR/ip4r_artifacts/ip4r.tar.gz"
}

function _main() {
    time pkg
}

_main "$@"
