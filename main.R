# Aim: reduce all files to be a test set for quick analyses

# dependencies
library(data.table)
library(tidyverse)

# constants
proteins_file <- "data/proteins_table.txt"
peptides_file <- "data/peptides_table.txt"
psms_file     <- "data/target_psmtable.txt"

# load all types of data
proteins <- fread(input = proteins_file,
                  sep = "\t",
                  header = TRUE,
                  stringsAsFactors = FALSE,
                  data.table = FALSE)
dim(proteins)

peptides <- fread(input = peptides_file,
                  sep = "\t",
                  header = TRUE,
                  stringsAsFactors = FALSE,
                  data.table = FALSE)
dim(peptides)

psms <- fread(input = psms_file,
              sep = "\t",
              header = TRUE,
              stringsAsFactors = FALSE,
              data.table = FALSE)
dim(psms)


# subsampling
set.seed(222628)
sample_ratio <- .05

# subsample proteins
proteins.sub <- proteins %>%
  sample_n(floor(sample_ratio * nrow(proteins)))

# select peptides belonging to those proteins
peptides.sub <- peptides %>%
  filter(`Protein(s)` %in% proteins.sub[, "Protein accession"])

# select psms belonging to those peptides
psms.sub <- psms %>%
  filter(Peptide %in% peptides.sub[, "Peptide sequence"])

dim(proteins.sub)
dim(peptides.sub)
dim(psms.sub)


# output new test datasets
testifyFileName <- function (filename) {
  return(gsub(pattern = "data/", 
              replacement = "output/", 
              x = gsub(pattern = ".txt",
                       replacement = "_test.txt",
                       x = filename)))
}

write.table(x = proteins.sub,
            file = testifyFileName(proteins_file),
            sep = "\t",
            row.names = FALSE,
            col.names = TRUE,
            quote = FALSE)

write.table(x = peptides.sub,
            file = testifyFileName(peptides_file),
            sep = "\t",
            row.names = FALSE,
            col.names = TRUE,
            quote = FALSE)

write.table(x = psms.sub,
            file = testifyFileName(psms_file),
            sep = "\t",
            row.names = FALSE,
            col.names = TRUE,
            quote = FALSE)