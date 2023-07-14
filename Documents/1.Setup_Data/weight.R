source('~/Documents/Projects/Islets/CAPE_transcripts/Code/hist_with_points.R')
source('~/Documents/Projects/Islets/CAPE_transcripts/Code/segment_region.R')
source('~/Documents/Projects/Islets/CAPE_transcripts/Code/segment.region.R')
source('~/Documents/Projects/Islets/CAPE_transcripts/Code/bin.vector.R')
library(igraph)
cols <- categorical_pal(8)

clin.data <- readRDS("~/Documents/Projects/Islets/CAPE_transcripts/Data/Clinical_Phenotypes_V11.RDS")
covar <- clin.data$annot.samples
f.locale <- which(covar[,"Sex"] == "F")
m.locale <- which(covar[,"Sex"] == "M")
sex.col <- rep(cols[2], nrow(covar))
sex.col[m.locale] <- cols[3]

weight.col <- c(paste("weight", 5:24, sep = "_"), "weight_final")
weight <- clin.data$data[,weight.col]
#take out outliers that are obviously mistakes
weight[which(weight > 100)] <- NA 
weight[which(weight < 10)] <- NA 

imp.weight <- bnstruct::knn.impute(weight)

pdf("~/Desktop/weight_trajectory.pdf")
plot.new()
plot.window(xlim = c(5, 25), ylim = c(min(weight, na.rm = TRUE), max(weight, na.rm = TRUE)))
for(i in 1:nrow(weight)){
	points(5:25, weight[i,], col = sex.col[i], type = "l")
}
axis(1);axis(2)
mtext("Weight (g)", side = 2, line = 2.5)
mtext("Weeks", side = 1, line = 2.5)
dev.off()


pdf("~/Desktop/weight_trajectory_sep.pdf", width = 8, height = 4)
par(mfrow = c(1,2))
plot.new()
plot.window(xlim = c(5, 25), ylim = c(min(weight, na.rm = TRUE), max(weight, na.rm = TRUE)))
for(f in f.locale){
	points(5:25, weight[f,], col = cols[2], type = "l")
}
axis(1);axis(2)
mtext("Weight (g)", side = 2, line = 2.5)
mtext("Weeks", side = 1, line = 2.5)

plot.new()
plot.window(xlim = c(5, 25), ylim = c(min(weight, na.rm = TRUE), max(weight, na.rm = TRUE)))
for(m in m.locale){
	points(5:25, weight[m,], col = cols[3], type = "l")
}
axis(1);axis(2)
mtext("Weight (g)", side = 2, line = 2.5)
mtext("Weeks", side = 1, line = 2.5)

dev.off()


sex.order <- order(covar[,"Sex"])
hist_with_points(weight[f.locale,"weight_final"], breaks = 100)
hist_with_points(weight[m.locale,"weight_final"], breaks = 100)

pdf("~/Desktop/weight.pdf", height = 6, width = 5)
hist_with_points(weight[sex.order,"weight_final"], breaks = 100, col = sex.col[sex.order], xlab = "Weight (g)",main = "")
legend("topright", legend = c("Female", "Male"), col = cols[2:3], pch = 16)
dev.off()

