#!/bin/bash -l

set -exo pipefail

CWDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR=${CWDIR}/../../../

source "${TOP_DIR}/gpdb_src/concourse/scripts/common.bash"
function pkg() {
    [ -f /opt/gcc_env.sh ] && source /opt/gcc_env.sh
    source /usr/local/greenplum-db-devel/greenplum_path.sh

    pushd /home/gpadmin/ip4r_src
    make clean
    make install
    popd

    mkdir -p $TOP_DIR/bin_ip4r

    CURRENT_VERSION=$(cat /home/gpadmin/ip4r_src/VERSION)
    $CWDIR/pack.sh -p /usr/local/greenplum-db-devel/ -f "$TOP_DIR/bin_ip4r/ip4r-${CURRENT_VERSION}-${OS_NAME}_x86_64.tar.gz"
    cp "$TOP_DIR/bin_ip4r/ip4r-${CURRENT_VERSION}-${OS_NAME}_x86_64.tar.gz" "$TOP_DIR/bin_ip4r/ip4r.tar.gz"
}

function _main() {
    time pkg
}

_main "$@"
