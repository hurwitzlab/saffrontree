#!/bin/bash

module load tacc-singularity
#module load launcher

function lc() {
    FILE=$1
    [[ -f "$FILE" ]] && wc -l "$FILE" | cut -d ' ' -f 1
}

#PARAMRUN="$TACC_LAUNCHER_DIR/paramrun"
#export LAUNCHER_PLUGIN_DIR="$TACC_LAUNCHER_DIR/plugins"
#export LAUNCHER_WORKDIR="$PWD"
#export LAUNCHER_RMI="SLURM"
#export LAUNCHER_SCHED="interleaved"

set -u

IMG="saffrontree"
OUT_DIR="$PWD/saffrontree-out"
THREADS=12
ARGS=""
FILES_LIST=$(mktemp)

while (($#)); do
    if [[ $1 == '-q' ]]; then
        QUERY=$2
        if [[ -f "$QUERY" ]]; then
            echo "$QUERY" >> "$FILES_LIST"
        elif [[ -d "$QUERY" ]]; then
            find "$QUERY" -type f >> "$FILES_LIST"
        fi
        shift 2
    elif [[ $1 == '-o' ]]; then
        OUT_DIR=$2
        shift 2
    elif [[ $1 == '-t' ]]; then
        THREADS=$2
        shift 2
    else
        ARGS="$ARGS $1"
        shift
    fi
done

#
# Trust, but verify
#
if [[ ! -f "$IMG" ]]; then
    echo "Cannot find Singularity image \"$IMG\""
    exit 1
fi

NUM_FILES=$(lc "$FILES_LIST")

if [[ $NUM_FILES -lt 1 ]]; then
    echo "No input files"
    exit 1
fi

INPUT_FILES=$(cat "$INPUT_FILES" | xargs echo)

[[ -d "$OUT_DIR" ]] && rm -rf "$OUT_DIR"


echo "ARGS $ARGS"
singularity exec $IMG saffrontree $ARGS $OUT_DIR $INPUT_FILES

echo "Done"
echo "Comments to Ken Youens-Clark kyclark@email.arizona.edu"
