
if [[ -z "$WEST_ROOT" ]]; then
    echo "Please set the environment variable WEST_ROOT"
    exit
fi

if [[ -z "$WEST_SIM_ROOT" ]]; then
    export WEST_SIM_ROOT="$PWD"
fi
export SIM_NAME=$(basename $WEST_SIM_ROOT)
echo "simulation $SIM_NAME root is $WEST_SIM_ROOT"


