#!/bin/bash

###########################################################################
# Author : Sourabh Patel
# Date : 29/09/2026
#
# This script outputs the Node Health
#
# Version : V1
###########################################################################
set -x
set -e
set -o pipefail

# Check disk space
df -h

# Check available memory in GB
free -g

# Check number of CPU cores
nproc

# List Process IDs for python3
ps -ef | grep python3 | awk '{print $2}' || true
