

## 1.

my.geocoder <- function(address='Stanford, CA') {
    url.base <- 'http://maps.google.com/maps/api/geocode/xml?address='
    address <- gsub(' ','%20',address)
    url <- paste0(url.base,address)
    xml <- scan(url,what='',sep='\n',quiet=T)

    ##check status OK
    status.idx <- grep('<status>',xml)
    if(regexpr('OK',xml[status.idx])==-1) {
        print('Error returned.')
        print(xml[status.idx])
        return()
    }

    address.idx <- grep('<formatted_address>',xml)
    lat.idx <- grep('<lat>',xml)[1]
    lon.idx <- grep('<lng>',xml)[1]

    print(gsub('<[^>]+>','',xml[address.idx]))
    print(gsub('<[^>]+>','',xml[lat.idx]))
    print(gsub('<[^>]+>','',xml[lon.idx]))

}











## 2.

income <- read.csv('http://www.irs.gov/file_source/pub/irs-soi/12cyallnoagi.csv',header=T)

#geo <-
#    read.csv('http://notebook.gaslampmedia.com/wp-content/uploads/2013/08/zip_codes_states.csv')
geo <- read.csv('zip_codes_states.csv')


geo.latlon <- geo[,c('latitude','longitude')]
county.latlon <- aggregate(geo.latlon,
                           by=list(state=geo$state,county=geo$county),
                           mean,na.rm=T)

## > county.latlon[1:20,]

##    state    county latitude  longitude
## 1     AA                NaN        NaN
## 2     AE                NaN        NaN
## 3     AP                NaN        NaN
## 4     NC                NaN        NaN
## 5     OH                NaN        NaN
## 6     PA                NaN        NaN
## 7     SC Abbeville 34.25719  -82.46718
## 8     LA    Acadia 30.24547  -92.41720
## 9     VA  Accomack 37.79235  -75.65539
## 10    ID       Ada 43.51502 -116.24935
## 11    IA     Adair 41.30279  -94.54563
## 12    KY     Adair 37.08428  -85.33527
## 13    MO     Adair 40.20655  -92.54654
## 14    OK     Adair 35.95497  -94.60586
## 15    CO     Adams 39.84552 -104.72649
## 16    IA     Adams 41.02796  -94.75888
## 17    ID     Adams 44.78880 -116.43882
## 18    IL     Adams 40.01315  -91.18345
## 19    IN     Adams 40.73357  -84.94410
## 20    MS     Adams 31.48203  -91.38493

## > income[1:20,c('STATE','COUNTYNAME')]
##    STATE      COUNTYNAME
## 1     AL         Alabama
## 2     AL  Autauga County
## 3     AL  Baldwin County
## 4     AL  Barbour County
## 5     AL     Bibb County
## 6     AL   Blount County
## 7     AL  Bullock County
## 8     AL   Butler County
## 9     AL  Calhoun County
## 10    AL Chambers County
## 11    AL Cherokee County
## 12    AL  Chilton County
## 13    AL  Choctaw County
## 14    AL   Clarke County
## 15    AL     Clay County
## 16    AL Cleburne County
## 17    AL   Coffee County
## 18    AL  Colbert County
## 19    AL  Conecuh County
## 20    AL    Coosa County

income$COUNTYNAME <- sub(' County','',income$COUNTYNAME)


dat <- merge(county.latlon,income,by.x=c('state','county'),
             by.y=c('STATE','COUNTYNAME'),all=F)
dat$lagi <- log(dat$A00100)
dat <- dat[,c('state','county','latitude','longitude',
              'lagi')]

## > head(dat)
##   state  county latitude longitude     lagi
## 1    AL Autauga 32.52479 -86.63771 14.00287
## 2    AL Baldwin 30.58720 -87.71906 15.40468
## 3    AL Barbour 31.81617 -85.41807 12.82622
## 4    AL    Bibb 33.03273 -87.08073 12.74923
## 5    AL  Blount 33.95194 -86.58293 13.81317
## 6    AL Bullock 32.10515 -85.71409 11.64747

n.bins <- 10
cuts <- cut(dat$lagi,n.bins)
colors <- topo.colors(n.bins,alpha=.5)
with(dat,
     plot(longitude,latitude,
          col=colors[as.numeric(cuts)],
          pch=16,
          main='County Aggregate AGI, 2012',
          yaxt='n',yaxt='n',xlab='',ylab='')
     )
legend('topleft',col=colors,legend=levels(cuts),pch=16,
       title='log aggregate AGI')

require(ggplot2)
qplot(longitude,latitude,data=dat,color=lagi,alpha=I(.8),
      size=I(3),main='County Aggregate AGI, 2012')









