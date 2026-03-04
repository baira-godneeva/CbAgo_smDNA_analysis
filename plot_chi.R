#Normalize coverage to RPKM and plot read density around Chi sites.

library(ggplot2)
#total reads
total_plus        <- as.numeric(readLines("total_plus.txt"))
total_minus       <- as.numeric(readLines("total_minus.txt"))
total_reads_number <- total_plus + total_minus

read_cov <- function(file) {
    df <- read.table(file, header = FALSE)
    colnames(df) <- c("chr", "start", "end", "interval_name", "count")
    df$interval_length <- df$end - df$start
    return(df)
}

df_plus_plus   <- read_cov("plus_plus.tsv")
df_minus_plus  <- read_cov("minus_plus.tsv")
df_minus_minus <- read_cov("minus_minus.tsv")
df_plus_minus  <- read_cov("plus_minus.tsv")

#normalize to rpkm
normalize_rpkm <- function(df) {
    df$RPKM <- df$count / (df$interval_length / 1000 * total_reads_number / 1e6)
    return(df)
}

df_plus_plus   <- normalize_rpkm(df_plus_plus)
df_minus_plus  <- normalize_rpkm(df_minus_plus)
df_minus_minus <- normalize_rpkm(df_minus_minus)
df_plus_minus  <- normalize_rpkm(df_plus_minus)

df_sum_right <- rbind(df_plus_plus,  df_minus_minus)  # co-oriented
df_sum_wrong <- rbind(df_plus_minus, df_minus_plus)   # opposite

agr_right <- aggregate(RPKM ~ interval_name, df_sum_right, mean)
agr_wrong <- aggregate(RPKM ~ interval_name, df_sum_wrong, mean)

agr_df <- data.frame(
    interval    = agr_right$interval_name,
    co_oriented = agr_right$RPKM,
    opposite    = agr_wrong$RPKM
)

p <- ggplot(agr_df, aes(x = interval)) +
    geom_vline(xintercept = 50.5, linetype = "dashed", colour = "black", size = 0.5) +
    geom_line (aes(y = co_oriented, color = "Co-oriented"), size = 0.5) +
    geom_line (aes(y = opposite,    color = "Opposite"),    size = 0.5) +
    geom_point(aes(y = co_oriented, color = "Co-oriented"), size = 1) +
    geom_point(aes(y = opposite,    color = "Opposite"),    size = 1) +
    scale_color_manual(
        values = c("Co-oriented" = "orange", "Opposite" = "gray40"),
        name   = NULL
    ) +
    ylab("RPKM") +
    xlab("Coordinate relative to Chi-site, kb") +
    scale_x_continuous(
        breaks = c(0, 25, 50.5, 75, 100),
        labels = c(-5, -2.5, "Chi", 2.5, 5)
    ) +
    theme_classic() +
    theme(
        text                = element_text(size = 14),
        legend.position     = c(0.8, 0.2),
        legend.background   = element_blank(),
        legend.key.size     = unit(0.5, "lines"),
        legend.spacing.x    = unit(0.2, "lines")
    ) +
    ggtitle("Chi-site analysis")

p
ggsave("chi_plot.pdf", plot = p, width = 4, height = 3, dpi = 1000)
