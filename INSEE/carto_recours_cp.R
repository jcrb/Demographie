

#============================================================================================
#
# Cartographie des taux de recours
#
#============================================================================================

#' @param dx un dataframe de type RPU
#' @param dx.id colonne de dx qui sert au merging
#' @param spdf un spatialPolygonDataFrame représentant un fond de carte de Codes Postaux (cp67)
#' @param spdf.id n° ou nom de la colonne de spdf qui sert au merging
#' @param cols vecteur des couleurs
#' 
#' @examples 
#' dx <- rpu67
#' dx.id <- "CODE_POSTAL"
#' load("~/Documents/Resural/Stat Resural/RPU_Doc/RPU_Carto-Pop-Alsace/Cartographie/Cartofile/cp67.Rda") # cp67
#' #display.carto.all (5) # échantillinnage de couleur
#' cols <- carto.pal("green.pal", 5)
#' carto.recours.cp(dx, dx.id, cp67, "ID", cols = cols, titre = "test")

carto.recours.cp <- function(dx, dx.id, spdf, spdf.id, cols, titre = "", legende = ""){
    # nb de RPU par code postal
    rpu.finess <- tapply(as.Date(dx$ENTREE), factor(dx$CODE_POSTAL), length)
    
    # transformation en dataframe
    b <- data.frame(names(rpu.finess), rpu.finess)
    names(b) <- c("CP", "Nb")
    
    # Merging du fichier carto et des données complémentaires
    merge.df <- attribJoin(b, spdf, "CP", spdf.id )
    
    # création d'un colonne de pourcentage
    merge.df$p <- merge.df$Nb * 100 / merge.df$POP2010
    # summary(merge.df$p)
    
    # discrétisation du vecteur de pourcentage
    merge.df$cut <- cut(merge.df$p, breaks = c(0,5,10,20,30,40), include.lowest = TRUE)
    
    # transformation en vecteur d'entiers
    merge.df$cut2 <- as.numeric(merge.df$cut)
    
    # dessin de la carte
    # plot(merge.df, col = cols[merge.df$cut2], main = titre, border = "white")
    plot(merge.df, col = cols[merge.df$cut2], main = titre)
    
    # dessin de la légende
    legend("right", 
           legend = levels(merge.df$cut), 
           fill = cols, bty = "n", 
           title = legende, 
           cex = 0.8)
    
}

