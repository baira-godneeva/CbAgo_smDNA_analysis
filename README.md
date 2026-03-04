# Chi-site Analysis Pipeline
Pipeline to identify Chi sites in a phage genome, build coverage intervals,
quantify strand-specific read density with bedtools, and plot RPKM-normalized
coverage relative to each Chi site in R.
## File overview|
| `find_chi_sites.py` | 1. Scan FASTA for Chi sequences; write coordinates |
| `make_intervals_for_chi.py` | 2. Build ±5 kb BED windows around each Chi site |
| `bedtools_coverage_for_chi.sh` | 3. Count reads per interval with bedtools |
| `plot_chi.R` | 4. Normalize to RPKM and produce the Chi-site plot |
## Required inputs
| `genome.fasta` | Phage genome in FASTA format |
| `plus.bam` | Plus-strand reads (sorted + indexed BAM) |
| `minus.bam` | Minus-strand reads (sorted + indexed BAM) |
| `total_plus.txt` | total plus-strand mapped reads |
| `total_minus.txt` | total minus-strand mapped reads |
