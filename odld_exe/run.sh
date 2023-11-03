#!/bin/bash

# Make sure environment is set
source env.sh

# Clean up
rm -f west.log

w_run --work-manager=processes "$@"  &> west.log
