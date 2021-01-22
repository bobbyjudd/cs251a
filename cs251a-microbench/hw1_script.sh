#!/bin/bash

# Global base
BASE="/home/bobby"

# gem5 base directory
G5_BASE="$BASE/projects/ucla/cs251a/gem5"
G5_CMD="$G5_BASE/build/X86/gem5.opt"
G5_SCRIPT_IW2="$G5_BASE/configs/example/se2.py"
G5_SCRIPT_IW8="$G5_BASE/configs/example/se8.py"
LOCAL_BASE="$BASE/projects/ucla/cs251a/cs251a-microbench"

# Output directory
OUTPUT_DIR="$LOCAL_BASE/output"

# CPU Model
cpu_models=("DerivO3CPU" "MinorCPU")

# Issue Width
issue_widths=("2" "8")

# Clock Frequency
cpu_freqs=("1GHz" "2GHz" "3GHz" "4GHz")

# L2 Cache
l2_caches=("no_cache" "256000" "2000000" "16000000")

# Binary directories
comp_settings=("bin" "bin_fast")

# Benchmark Binaries
bm_bins=("lfsr" "merge" "mm" "sieve" "spmv")

[ -d $OUTPUT_DIR ] || mkdir $OUTPUT_DIR
for model in ${cpu_models[@]}; do
    [ -d $OUTPUT_DIR/$model ] || mkdir $OUTPUT_DIR/$model
    [ -d $OUTPUT_DIR/$model/iw_2 ] || mkdir $OUTPUT_DIR/$model/iw_2
    [ -d $OUTPUT_DIR/$model/iw_8 ] || mkdir $OUTPUT_DIR/$model/iw_8
    for freq in ${cpu_freqs[@]}; do
        [ -d $OUTPUT_DIR/$model/iw_2/$freq ] || mkdir $OUTPUT_DIR/$model/iw_2/$freq
        [ -d $OUTPUT_DIR/$model/iw_8/$freq ] || mkdir $OUTPUT_DIR/$model/iw_8/$freq
        for l2c in ${l2_caches[@]}; do
            [ -d $OUTPUT_DIR/$model/iw_2/$freq/$l2c ] || mkdir $OUTPUT_DIR/$model/iw_2/$freq/$l2c
            [ -d $OUTPUT_DIR/$model/iw_8/$freq/$l2c ] || mkdir $OUTPUT_DIR/$model/iw_8/$freq/$l2c
            for cset in ${comp_settings[@]}; do
                [ -d $OUTPUT_DIR/$model/iw_2/$freq/$l2c/$cset ] || mkdir $OUTPUT_DIR/$model/iw_2/$freq/$l2c/$cset
                [ -d $OUTPUT_DIR/$model/iw_8/$freq/$l2c/$cset ] || mkdir $OUTPUT_DIR/$model/iw_8/$freq/$l2c/$cset
                for b in ${bm_bins[@]}; do
                    if [ "$l2c" = "no_cache" ];
                    then
                        $G5_CMD --outdir=$OUTPUT_DIR/$model/iw_2/$freq/no_cache/$cset/$b $G5_SCRIPT_IW2 --cpu-type=$model --sys-clock=$freq --caches --cmd=$LOCAL_BASE/$cset/$b
                        $G5_CMD --outdir=$OUTPUT_DIR/$model/iw_8/$freq/no_cache/$cset/$b $G5_SCRIPT_IW8 --cpu-type=$model --sys-clock=$freq --caches --cmd=$LOCAL_BASE/$cset/$b                        
                    else
                        $G5_CMD --outdir=$OUTPUT_DIR/$model/iw_2/$freq/$l2c/$cset/$b $G5_SCRIPT_IW2 --cpu-type=$model --sys-clock=$freq --caches --l2_size=$l2c --cmd=$LOCAL_BASE/$cset/$b 
                        $G5_CMD --outdir=$OUTPUT_DIR/$model/iw_8/$freq/$l2c/$cset/$b $G5_SCRIPT_IW8 --cpu-type=$model --sys-clock=$freq --caches --l2_size=$l2c --cmd=$LOCAL_BASE/$cset/$b 
                    fi
                done
            done
        done
    done
done
exit 0