mouse_to_human_entrez  <- function(mouse_ensembl, hum.mus.ortho){
    id.locale <- match(mouse_ensembl, hum.mus.ortho[,"Mouse.Ortholog.Ensembl"])
    hum.entrez <- hum.mus.ortho[id.locale,]
    return(hum.entrez)
}