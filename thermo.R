# transform proteins table to fit in TPP standard pipeline
# Savitski et al., Science, 2014

quant_pattern   <- "_tmt10plex_"
channel_pattern <- "1[23][016789][NC]?$"
quant_prefix    <- "rel_fc_"

proteins.sub.tidy <- proteins.sub %>%
  select(`Protein accession`,
         matches(paste0(quant_pattern, channel_pattern))) %>%
  mutate(qssm = as.integer(10), qupm = as.integer(10))

quant_cols <- colnames(proteins.sub.tidy)[grepl(paste0(quant_pattern, channel_pattern), colnames(proteins.sub.tidy))]
experiments <- unique(gsub(pattern = paste0(quant_pattern, channel_pattern),
                           replacement = "",
                           x = quant_cols))

data <- sapply(X = experiments,
               FUN = function (experiment) {
                 tmp <- proteins.sub.tidy %>%
                   select(gene_name = `Protein accession`,
                          qssm,
                          qupm,
                          matches(paste0(experiment, paste0(quant_pattern, channel_pattern))))
                 colnames(tmp) <- gsub(pattern = paste0("^", experiment, "_tmt10plex_"),
                                       replacement = "",
                                       x = colnames(tmp))
                 return(tmp)
               },
               simplify = FALSE)

saveRDS(object = data,
        file = "output/proteins_TPP_test.RDS")
