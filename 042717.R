## Agenda
## 1. Thematic maps


## 1. Thematic maps -- GIS
## Topics along the way: S4 classes, DB joins, cut, color palettes

## One common plotting task is to overlay some statistic on the
## regions of a geographical map. This is known as a choropleth.

## The most common way of going about this is to use a "shapefile," a
## proprietary format that describes geospatial boundaries and
## features, say provinces in a country or census tracts in a US
## city. The shapefile will typically also contain a data frame with a
## column giving some unique identifier corresponding to the
## geographical units (provinces, tracts, or whatever). This data can
## be augmented with whatever data you you wish to overlay
## on the map. This additional data should have rows corresponding to
## the geographical units and a column with the same unique identifier
## as the shapefile dataframe. You then join the two dataframes on
## this identifier. You can then plot thematic maps using the
## shapefile with a "plot" routine.

## In R we can use the maptools package to read in shapefile
## data.

require(maptools)
setwd('/gdrive/stanford/stats195')

## A google search for "US counties shapefiles" leads to
## https://geonet.esri.com/servlet/JiveServlet/download/183957-26877/UScounties.zip

counties <- readShapeSpatial('UScounties')
plot(counties)

## The data is stored as a class, which we haven't used before. A
## class is an object that bundles data and functions with some
## conceptual similarity; classes form the basis of object-oriented
## programming. R refers to the data and functions contained in a
## class as "slots" (non-standard terminology). You access slots using the
## @ operator.

slotNames(counties)
str(counties)
head(counties@data)

## The data slot is a dataframe containing some information on each of
## the 3141 counties, including the FIPS codes to ID it. The other
## slots contain the graphical information needed to describe the
## geographical shapes and relationships of the corresponding rows of
## the dataframe.

nrow(counties@data)
length(counties@polygons)

## For this type of class, you can access the columns of the @data
## slot directly using the $ operator, conceptually treating the class
## as a dataframe. Moreover, when you subset the dataframe, the
## corresponding geographical information is also subset-ed.

str(counties$FIPS)
counties$FIPS <- as.integer(as.character(counties$FIPS))
plot(counties,col=(counties$FIPS==6071)+4)

plot(counties[counties$STATE_FIPS=='25',])

## EX: Plot only the mainland US.

## Let's read in the data to overlay on our map.

unempl <- read.csv('http://datasets.flowingdata.com/unemployment09.csv',header=F,stringsAsFactor=F)
head(unempl)
colnames(unempl) <- c('id','state.fips','county.fips','name','year','unempl.count','group.1','group.2','unempl')
## Based on the counties$fips values, it seems that, while FIPS
## counties codes are 3 digits and state codes are 2 digits, any
## leading zeros in the state (but not county) codes are removed in
## creating the full FIPS codes.

## EX: Add a new column "fips" to the data frame "unempl" with a 4 or 5 digit integer representing the full, state+county FIPS code.

unempl$fips <- unempl$state.fips*1000 + unempl$county.fips

## see also "sprintf"

## check unempl data frame FIPS matches the counties data frame FIPS
grep('Okanogan',unempl$name,ignore.case=T)
unempl[2975,]

## We next want to augment the spatial data with the unemployment
## data. The spatial data has a FIPS code corresponding to each
## county, and the unemployment data has a FIPS code plus unemployment
## data. We want to match the FIPS codes so that each county in the
## spatial data frame contains the correct unemployment data. This is
## known as a "join" in database management jargon. R's "merge
## function performs joins.
counties <- merge(counties,unempl,by.x='FIPS',by.y='fips',all=F)


## Next we clean up our joined data and process for plotting. This
## mainly uses things we've seen before, but note also "cut" and the
## color palettes.
counties@data <- subset(counties@data,select=c('FIPS','name','unempl'))
## colnames(counties@data) <- c('fips','name','unempl')
counties$unempl <- as.numeric(counties$unempl)

bins <- 10
counties$unempl.fac <- cut(counties$unempl,bins)
colors <- terrain.colors(bins)
plot(counties,col=colors[as.integer(counties$unempl.fac)])
title('US unemployment rate by county, 20??')
legend('bottomright',col=colors,pch=16,legend=levels(counties$unempl.fac))

## EX: Subset counties to a new data frame "mainland" consisting only of the mainland states. AK and Hawaii state FIPS codes are 02 and 15. You can either rebuild the counties data frame preserving the state FIPS column or use a regex to extract the state FIPS from the full fips column in the current counties data.


bins <- 10
mainland$unempl.fac <- cut(mainland$unempl,bins)
colors <- terrain.colors(bins)
plot(mainland,col=colors[as.integer(mainland$unempl.fac)])
title('Mainland US unemployment rate by county, 20??')
legend('bottomright',col=colors,pch=16,legend=levels(mainland$unempl.fac))


## state-level data

require(stringr)
state.fips <- str_match(as.character(counties$FIPS),'^(.*)...$')
counties$state.fips <- state.fips[,2]

mtcars
aggregate(mtcars,by=list(cyl=mtcars$cyl),mean)
aggregate(. ~ cyl, data=mtcars,mean)
state.df <- aggregate(counties@data,by=list(counties$state.fips),mean)
state.df <- state.df[,c('unempl','state.fips')]

## EX: Join state.df to the counties data frame on state.fips.

## EX: Create choropleth with state-level mean unemployment

## Look into the rgdal package for greater functionality than
## maptools. Shapefiles are available on the internet. For the US,
## visit the Census website to get shapefiles at many different
## resolutions (state, block, etc.), as well as data to join.






## ## SKIPPED 2017
## ## 2. Requested topic--PCA
## ## Topics along the way: eigen, SVD, par, optim

## ## Given a data set, principal components analysis identifies a set of
## ## orthogonal directions that decomposes the variance of the data set
## ## into a largest, second largest, etc. components. Reasons you might
## ## do this include compression/dimensionality reduction, to generate
## ## predictors, or to explain relationships among the covariates. The
## ## directions are given by the eigenvectors of the covariance matrix,
## ## after centering the data.

## judges
## judges <- subset(USJudgeRatings,select=c('DMNR','CFMG'))
## judges.scaled <- scale(judges,scale=F) # always center
## plot(judges.scaled)
## cov.matrix <- t(judges.scaled)%*%judges.scaled
## eigen(cov.matrix)
## pcs <- eigen(cov.matrix)$vectors

## ## compute first PC by optimization routine
## objective <- function(u) {
##     u <- as.matrix(u,ncol=1)
##     -var(as.matrix(judges)%*%u/norm(u,'f')) # optim minimizes by default
## }
## optim(c(0,1),objective)

## plot(judges.scaled,xlab='demeanor',ylab='case flow management',asp=1)
##                                         # asp=1 to see orthogonality
## abline(h=0,v=0,lty=2)
## pc1 <- pcs[,1]; pc2 <- pcs[,2]
## abline(a=0,b=pc1[2]/pc1[1],col='red')
## abline(a=0,b=pc2[2]/pc2[1],col='red')

## ## transform to PC basis
## judges.pc <- judges.scaled %*% pcs
## op <- par(mfrow=c(1,2))
## plot(judges.pc,asp=1)
## abline(h=0,v=0,lty=2)
## loading.dmnr <- pcs[1,]
## loading.cfmg <- pcs[2,]
## abline(a=0,b=loading.dmnr[2]/loading.dmnr[1],col='red')
## abline(a=0,b=loading.cfmg[2]/loading.cfmg[1],col='red')
## abline(a=0,b=pcs[1,2]/pcs[1,1],col='red') ## something like a biplot

## ## (replot on original axes)
## par(op)

## eigenvals <- eigen(cov.matrix)$values
## eigenvals/sum(eigenvals)
## barplot(eigenvals/sum(eigenvals)) # similar to scree plot

## ## Use prcomp or princomp to perform PCA (difference is in the
## ## algorithm; prcomp is usually stabler).
## pca0 <- princomp(judges)
## summary(pca0)
## plot(pca0) # defaults to scree plot
## biplot(pca0)
## loadings(pca0); loading.dmnr; loading.cfmg
## summary(pca0); eigenvals/sum(eigenvals)

## pca1 <- princomp(mtcars)
## plot(pca1)
## biplot(pca1)


