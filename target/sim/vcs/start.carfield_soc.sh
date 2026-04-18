#!/bin/bash
# Copyright 2022 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Nicole Narr <narrn@student.ethz.ch>
# Christopher Reinwardt <creinwar@student.ethz.ch>
# Alessandro Ottaviano <aottaviano@iis.ee.ethz.ch>
# Paul Scheffler <paulsc@iis.ee.ethz.ch>
#
# Hubert Guan <hguan@ucsb.edu> (adapted from start.cheshire_soc.sh from Cyril Koenig <cykoenig@iis.ee.ethz.ch>)

TESTBENCH=tb_cheshire_soc

# Set full path to c++ compiler.
if [ -z "${CXX_PATH}" ]; then
    if [ -z "${CXX}" ]; then
        CXX="g++"
    fi
    CXX_PATH=`which ${CXX}`
fi

# Set default VCS binary
[[ -z "${VERDI_VERSION}" ]] && VERDI_VERSION=""
[[ -z "${VCS_VERSION}" ]]   && VCS_VERSION=""
[[ -z "${VCS_BIN}" ]]       && VCS_BIN="${VCS_VERSION} vcs"

# Collect VCS runtime flags
flags=""
if [[ -n "$VCS_RUN_FLAGS" ]]; then
    flags="$VCS_RUN_FLAGS"
fi

# Build string of plusargs
pargs=""
[[ -n "$HYP_USER_PRELOAD" ]] && pargs="${pargs}+HYP_USER_PRELOAD=${HYP_USER_PRELOAD} "
[[ -n "$SECURE_BOOT" ]] && pargs="${pargs}+SECURE_BOOT=${SECURE_BOOT} "
[[ -n "$CHS_BOOTMODE" ]] && pargs="${pargs}+CHS_BOOTMODE=${CHS_BOOTMODE} "
[[ -n "$CHS_PRELMODE" ]] && pargs="${pargs}+CHS_PRELMODE=${CHS_PRELMODE} "
[[ -n "$CHS_BINARY" ]] && pargs="${pargs}+CHS_BINARY=${CHS_BINARY} "
[[ -n "$SECD_BINARY" ]] && pargs="${pargs}+SECD_BINARY=${SECD_BINARY} "
[[ -n "$SECD_BOOTMODE" ]] && pargs="${pargs}+SECD_BOOTMODE=${SECD_BOOTMODE} "
[[ -n "$SECD_IMAGE" ]] && pargs="${pargs}+SECD_IMAGE=${SECD_IMAGE} "
[[ -n "$PULPD_BOOTMODE" ]] && pargs="${pargs}+PULPD_BOOTMODE=${PULPD_BOOTMODE} "
[[ -n "$PULPD_BINARY" ]] && pargs="${pargs}+PULPD_BINARY=${PULPD_BINARY} "
[[ -n "$SAFED_BOOTMODE" ]] && pargs="${pargs}+SAFED_BOOTMODE=${SAFED_BOOTMODE} "
[[ -n "$SAFED_BINARY" ]] && pargs="${pargs}+SAFED_BINARY=${SAFED_BINARY} "
[[ -n "$SPATZD_BOOTMODE" ]] && pargs="${pargs}+SPATZD_BOOTMODE=${SPATZD_BOOTMODE} "
[[ -n "$SPATZD_BINARY" ]] && pargs="${pargs}+SPATZD_BINARY=${SPATZD_BINARY} "
[[ -n "$CHS_IMAGE" ]] && pargs="${pargs}+CHS_IMAGE=${CHS_IMAGE} "

flags+=" -full64 -kdb "
# Set default to fast simulation flags.
if [ -z "${VCSARGS}" ]; then
    # Use -debug_access+all for waveform debugging
    flags+="-O2 -debug_access=r -debug_region=1,${TESTBENCH} "
fi

flags+="-cpp ${CXX_PATH} "
[[ -n "${SELCFG}" ]]   && flags+="-pvalue+SelectedCfg=${SELCFG} "

# DRAMSys
if [ -n "${USE_DRAMSYS}" ]; then
    flags+="-pvalue UseDramSys=${USE_DRAMSYS} "
    if [[ "${USE_DRAMSYS}" == 1 ]]; then
        DRAMSYS_ROOT="../dramsys"
        DRAMSYS_LIB="${DRAMSYS_ROOT}/build/lib"
        pargs+="+DRAMSYS_RES=${DRAMSYS_ROOT}/configs "
        pargs+="-sv_lib ${DRAMSYS_LIB}/libDRAMSys_Simulator "
    fi
fi

COLOR_NC='\e[0m'
COLOR_BLUE='\e[0;34m'

${VCS_BIN} ${flags} ../src/elfloader.cpp ${TESTBENCH} | tee elaborate.log

# Start simulation
printf ${COLOR_BLUE}"${VCS_VERSION} ${VERDI_VERSION} ./simv ${pargs}"${COLOR_NC}"\n"
${VCS_VERSION} ${VERDI_VERSION} ./simv ${pargs} | tee simulate.log