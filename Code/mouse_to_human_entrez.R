mouse_to_human_entrez  <- function(mouse_ensembl){
    hum.mus.ortho <- as.matrix(read.delim("~/Documents/Data/Mice/human.mouse.orthologs.txt", stringsAsFactors = FALSE))
    id.locale <- match(mouse_ensembl, hum.mus.ortho[,"Mouse.Ortholog.Ensembl"])
    hum.entrez <- hum.mus.ortho[id.locale,]
    return(hum.entrez)
}