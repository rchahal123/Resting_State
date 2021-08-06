# Script Author: Rajpreet Chahal
# Script Date: 08/05/2021
# Script Description: This script to be invoked in Extract_Seitzman_CorrMats.bash to calculate within- and between-network connectivity of canonical networks based on the Seitzman et al., (2018) ROIs in all ELS data of the SNAP Lab at Stanford

#df<-read.table(file='testing_convert2MNI/matrix.csv', sep=',', header=T) #just to test

df<-read.table(file='matrix.csv', sep=',', header=T) #use this

df <- subset( df, select = -X )
dfmat<-as.matrix(df, rownames.force = NA)
diag(dfmat)<-NA
#dfmat[lower.tri(dfmat)] <- NA
within_CO<-mean(abs(as.matrix(dfmat[13:38, 13:38])), na.rm=T)
within_DMN<-mean(abs(as.matrix(dfmat[39:105, 39:105])), na.rm=T)
within_DAN<-mean(abs(as.matrix(dfmat[106:119, 106:119])), na.rm=T)
within_FPN<-mean(abs(as.matrix(dfmat[120:155, 120:155])), na.rm=T)
within_REW<-mean(abs(as.matrix(dfmat[165:172, 165:172])), na.rm=T)
within_SAL<-mean(abs(as.matrix(dfmat[173:181, 173:181])), na.rm=T)
within_VAN<-mean(abs(as.matrix(dfmat[240:248, 240:248])), na.rm=T)
within_AUD<-mean(abs(as.matrix(dfmat[1:12, 1:12])), na.rm=T)
within_VIS<-mean(abs(as.matrix(dfmat[249:285, 249:285])), na.rm=T)

CO_DMN<-mean(abs(as.matrix(dfmat[13:38, 39:105])), na.rm=T)
CO_DAN<-mean(abs(as.matrix(dfmat[13:38, 106:119])), na.rm=T)
CO_FPN<-mean(abs(as.matrix(dfmat[13:38, 120:155])), na.rm=T)
CO_SAL<-mean(abs(as.matrix(dfmat[13:38, 173:181])), na.rm=T)
CO_VAN<-mean(abs(as.matrix(dfmat[13:38,  240:248])), na.rm=T)

DMN_DAN<-mean(abs(as.matrix(dfmat[39:105, 106:119])), na.rm=T)
DMN_FPN<-mean(abs(as.matrix(dfmat[39:105, 120:155])), na.rm=T)
DMN_SAL<-mean(abs(as.matrix(dfmat[39:105, 173:181])), na.rm=T)
DMN_VAN<-mean(abs(as.matrix(dfmat[39:105, 240:248])), na.rm=T)

FPN_DAN<-mean(abs(as.matrix(dfmat[120:155, 106:119])), na.rm=T)
FPN_REW<-mean(abs(as.matrix(dfmat[120:155, 165:172])), na.rm=T)
FPN_SAL<-mean(abs(as.matrix(dfmat[120:155, 173:181])), na.rm=T)
FPN_VAN<-mean(abs(as.matrix(dfmat[120:155, 240:248])), na.rm=T)

SAL_VAN<-mean(abs(as.matrix(dfmat[173:181, 240:248])), na.rm=T)


allvars<-as.data.frame(cbind(within_CO, within_DMN, within_DAN, within_FPN, within_REW, within_SAL, within_VAN, within_AUD, within_VIS, 
                             CO_DMN, CO_DAN, CO_FPN, CO_SAL, CO_VAN, DMN_DAN, DMN_FPN, DMN_SAL, DMN_VAN, FPN_DAN, FPN_REW, FPN_SAL, FPN_VAN,
                             SAL_VAN))
#just come back here to get column headers, but remove in file to cat easier later across subs
names(allvars) <- NULL  
write.table(allvars, file="Conn_Values.txt", sep=' ', row.names=FALSE, col.names=FALSE)


