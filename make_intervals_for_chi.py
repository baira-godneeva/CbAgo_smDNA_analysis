#!/usr/bin/env python3
import pandas as pd

genome_length = 88362
chr_name = "OP279344.1"
win_half = 5000
bin_size = 100
n_bins = (win_half * 2) // bin_size

# files with Chi positions
chi_plus_file  = "plus_chi.txt"
chi_minus_file = "minus_chi.txt"

chi_plus  = [int(x.strip()) for x in open(chi_plus_file)]
chi_minus = [int(x.strip()) for x in open(chi_minus_file)]

def site_slice(coords, genome_len, win_half):
    return [c for c in coords if (win_half < c < genome_len - win_half)]

chi_plus  = site_slice(chi_plus,  genome_length, win_half)
chi_minus = site_slice(chi_minus, genome_length, win_half)

print("Kept Chi+:", len(chi_plus), "Kept Chi-:", len(chi_minus))

# Plus-strand Chi sites: windows extend left→right
rows = []
for c in chi_plus:
    coordinate = c - win_half
    for i in range(n_bins):
        rows.append([chr_name, coordinate, coordinate + bin_size, i+1])
        coordinate += bin_size

pd.DataFrame(rows).to_csv(
    "plus_intervals.bed",
    sep="\t",
    header=False,
    index=False
)

# Minus-strand Chi sites: windows extend right→left (reversed)
rows = []
for c in chi_minus:
    coordinate = c + (win_half - bin_size)
    for i in range(n_bins):
        rows.append([chr_name, coordinate, coordinate + bin_size, i+1])
        coordinate -= bin_size

pd.DataFrame(rows).to_csv(
    "minus_intervals.bed",
    sep="\t",
    header=False,
    index=False
)

print("Intervals written: plus_intervals.bed and minus_intervals.bed")