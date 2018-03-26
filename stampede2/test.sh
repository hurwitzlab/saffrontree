#!/bin/bash

#SBATCH -A iPlant-Collabs
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J mashtest
#SBATCH -p development
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user kyclark@email.arizona.edu

set -u

#FASTA_DIR="$WORK/data/dolphin/fasta"
#OUT_DIR="$WORK/data/dolphin/saffrontree-out"

FASTA_DIR="$WORK/data/mock_communities/fasta"
OUT_DIR="$WORK/data/mock_communities/saffrontree-out"
MER_SIZE="21"

./run.sh -q $FASTA_DIR -o $OUT_DIR -k $MER_SIZE
