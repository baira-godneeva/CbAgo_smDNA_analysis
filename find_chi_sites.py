#!/usr/bin/env python3

data = []

with open("genome.fasta", "r", encoding="utf-8") as inf:
    for line in inf:
        line = line.strip()
        data += [line]

genome = str()
for i in range(1, len(data)):
    genome += data[i]

genome_subset = genome[0:88362]

plus_strand = []

for i in range(len(genome_subset) - 8):
    if str.upper(genome_subset[i:(i + 8)]) == "GCTGGTGG":
        plus_strand += [str(i + 0)]

minus_strand = []

for i in range(8, len(genome_subset)):
    if str.upper(genome_subset[(i-8):i]) == "CCACCAGC":
        minus_strand += [str(i + 0)]

plus_strand_new = []
for i in plus_strand:
    coord = int(i)
    coord_new = coord / 1000
    plus_strand_new.append(coord_new)

with open("plus_chi.txt", "w", encoding="utf-8") as file:
    file.writelines(f"{i}\n" for i in plus_strand)

with open("minus_chi.txt", "w", encoding="utf-8") as file:
    file.writelines(f"{i}\n" for i in minus_strand)
