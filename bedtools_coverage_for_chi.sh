#!/bin/bash

bedtools coverage -a plus_intervals.bed  -b plus.bam  -counts > plus_plus.tsv
bedtools coverage -a plus_intervals.bed  -b minus.bam -counts > minus_plus.tsv

bedtools coverage -a minus_intervals.bed -b minus.bam -counts > minus_minus.tsv
bedtools coverage -a minus_intervals.bed -b plus.bam  -counts > plus_minus.tsv
