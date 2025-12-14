#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/core/globals.sh"
source "$BASE_DIR/core/main.sh"
source "$BASE_DIR/core/run_mdl.sh"
source "$BASE_DIR/core/update_fix.sh"
source "$BASE_DIR/core/banner.sh"

banner
t_first_run "${1}"
menu
