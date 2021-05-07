#trait matrix plotting

				plot.trait.means = FALSE
				if(plot.trait.means){
					if(separate.windows){quartz(width = 10, height = 10)}
					par(mfrow = c(3,3))

					geno.mean.add <- matrix(sapply(1:length(cross.section.add), 
						function(x) median(cross.section.add[[x]], na.rm = TRUE)), 
						nrow = nrow(sub.add.effects[[1]]), 
						ncol = ncol(sub.add.effects[[1]]), byrow = FALSE)
					geno.mean.int <- matrix(sapply(1:length(cross.section.int), 
						function(x) median(cross.section.int[[x]], na.rm = TRUE)), 
						nrow = nrow(sub.int.effects[[1]]), 
						ncol = ncol(sub.int.effects[[1]]), byrow = FALSE)
					geno.mean.actual <- matrix(sapply(1:length(cross.section.actual), 
						function(x) median(cross.section.actual[[x]], na.rm = TRUE)), 
						nrow = nrow(sub.actual.effects[[1]]), 
						ncol = ncol(sub.actual.effects[[1]]), byrow = FALSE)
					dimnames(geno.mean.add) <- dimnames(geno.mean.int) <- dimnames(geno.mean.actual) <- list(geno.text, geno.text)
					
					global.min.val <- min(c(min(geno.mean.add, na.rm = TRUE), 
					min(geno.mean.int, na.rm = TRUE), min(geno.mean.actual, na.rm = TRUE)))
					global.max.val <- max(c(max(geno.mean.add, na.rm = TRUE), 
					max(geno.mean.int, na.rm = TRUE), max(geno.mean.actual, na.rm = TRUE)))

					rot.add <- rotate.mat(rotate.mat(rotate.mat(geno.mean.add)))
					rot.int <- rotate.mat(rotate.mat(rotate.mat(geno.mean.int)))
					rot.act <- rotate.mat(rotate.mat(rotate.mat(geno.mean.actual)))
					text.shift = 0.05

					imageWithText(rot.add, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Trait Mean Across Motifs Additive", global.color.scale = TRUE,
					global.min = global.min.val, global.max = global.max.val, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)
					imageWithText(rot.int, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Trait Mean Across Motifs Interactive", global.color.scale = TRUE,
					global.min = global.min.val, global.max = global.max.val, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)
					imageWithText(rot.act, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Actual Trait Mean Across Motifs", global.color.scale = TRUE,
					global.min = global.min.val, global.max = global.max.val, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)

					geno.var.add <- matrix(sapply(cross.section.add, function(x) var(x, na.rm = TRUE)), 
						nrow = nrow(add.effects[[1]]), ncol = ncol(add.effects[[1]]), 
						byrow = FALSE)
					geno.var.int <- matrix(sapply(cross.section.int, function(x) var(x, na.rm = TRUE)), 
						nrow = nrow(int.effects[[1]]), ncol = ncol(int.effects[[1]]), 
						byrow = FALSE)
					geno.var.actual <- matrix(sapply(cross.section.actual, function(x) var(x, na.rm = TRUE)), 
						nrow = nrow(actual.effects[[1]]), ncol = ncol(actual.effects[[1]]), 
						byrow = FALSE)				
					dimnames(geno.var.add) <- dimnames(geno.var.int) <- dimnames(geno.var.actual) <- list(geno.text, geno.text)

					rot.add.var <- rotate.mat(rotate.mat(rotate.mat(geno.var.add)))
					rot.int.var <- rotate.mat(rotate.mat(rotate.mat(geno.var.int)))
					rot.act.var <- rotate.mat(rotate.mat(rotate.mat(geno.var.actual)))

					global.min.var <- min(c(min(geno.var.add, na.rm = TRUE), 
					min(geno.var.int, na.rm = TRUE), min(geno.var.actual, na.rm = TRUE)))
					global.max.var <- max(c(max(geno.var.add, na.rm = TRUE), 
					max(geno.var.int, na.rm = TRUE), max(geno.var.actual, na.rm = TRUE)))

					imageWithText(rot.add.var, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Trait Variance Across Motifs Additive", global.color.scale = TRUE,
					global.min = global.min.var, global.max = global.max.var, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)
					imageWithText(rot.int.var, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Trait Variance Across Motifs Interactive", global.color.scale = TRUE,
					global.min = global.min.var, global.max = global.max.var, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)
					imageWithText(rot.act.var, show.text = FALSE, use.pheatmap.colors = TRUE,
					main = "Actual Trait Variance Across Motifs", global.color.scale = TRUE,
					global.min = global.min.var, global.max = global.max.var, 
					col.text.rotation = 0, col.text.shift = ncol(geno.mean.actual)*text.shift, 
					row.text.shift = nrow(geno.mean.actual)*text.shift)

					mtext(paste(u_pheno[ph], main, interaction, "with", source.sign, 
					"main effects"), side = 3, outer = TRUE, line = -2)
				}else{
				plot.text("No interactions for these parameters.")	
				}	
			}