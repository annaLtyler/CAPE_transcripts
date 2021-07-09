library(oposSOM)

tissue.expr <- matched.expr[[1]]

env <- opossom.new(list(dataset.name="DO_Overview"))
env$indata <- t(tissue.expr)
env$group.labels <- rownames(tissue.expr)

opossom.run(env)
