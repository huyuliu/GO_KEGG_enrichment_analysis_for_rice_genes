
##Step 2: GO enrichment analysis using annotations from AnnotationHub package


library(AnnotationHub) 
library(clusterProfiler)

# find rice orgDb
hub <- AnnotationHub()
query(hub, c("Oryza sativa","orgdb")) #output changed
# output:
# AH96211 | org.Oryza_sativa_(japonica_cultivar-group).eg.sqlite
# AH96212 | org.Oryza_sativa_Japonica_Group.eg.sqlite           
# AH96213 | org.Oryza_sativa_subsp._japonica.eg.sqlite

# select the first one (as all three are very similar)
rice <- hub[["AH96211"]] #changed based on new output
# checked keys in the database
# keyTypes(rice) 

## read input gene lists and convert IDs
# genes of interest
genes <- read.table("input/genes.txt", header=T)
genes <- genes[[1]]
# ID conversion table
IDtable <- read.csv("input/riceIDtable.csv")
# convert rapdb IDs into entrez IDs
genes_eid <- IDtable[match(genes, IDtable$rapdb), "entrezgene"]
# remove NAs
genes_eid <- as.character(genes_eid[!is.na(genes_eid)])

## run enrichGO function
library(clusterProfiler) #library
go2 <- enrichGO(gene = genes_eid, # a vector of gene id
                OrgDb = rice, # OrgDb object
                ont = "BP", # One of "MF", "BP", and "CC" subontologies
                pvalueCutoff = 0.05, # p-value cutoff (default)
                pAdjustMethod = "BH", # multiple testing correction method to calculate adjusted p-value (default)
                qvalueCutoff = 0.2, # q-value cutoff (default). q value: local FDR corrected p-value.
                minGSSize = 10, # minimal size of genes annotated for testing (default)
                maxGSSize = 500  # maximal size of genes annotated for testing (default)
                )
go2_df <- as.data.frame(go2) 
# result：no enriched GO terms
