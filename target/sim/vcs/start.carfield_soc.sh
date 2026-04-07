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
# Hubert Guan <hguan@ucsb.edu>

# VCS Equivalent Shell Script

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

# Execute VCS simulation
./simv ${flags} ${pargs}
