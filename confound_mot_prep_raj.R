#Prepare confound file of rest data
library('qlcMatrix')
library('dplyr')
library('plyr')
df<-read.table(file='r_rest_confounds.tsv', sep='\t', header=T)
# 
#regs<-as.data.frame(cbind (df$framewise_displacement, df$a_comp_cor_00, df$a_comp_cor_01, df$a_comp_cor_02, df$a_comp_cor_03, df$a_comp_cor_04, df$a_comp_cor_05,
#                           df$trans_x, df$trans_x_derivative1, df$trans_x_derivative1_power2, df$trans_x_power2,
#                           df$trans_y, df$trans_y_derivative1, df$trans_y_derivative1_power2, df$trans_y_power2,
#                           df$trans_z, df$trans_z_derivative1, df$trans_z_derivative1_power2, df$trans_z_power2,
#                           df$rot_x, df$rot_x_derivative1, df$rot_x_derivative1_power2, df$rot_x_power2,
#                           df$rot_y, df$rot_y_derivative1, df$rot_y_derivative1_power2, df$rot_y_power2,
#                           df$rot_z, df$rot_z_derivative1, df$rot_z_derivative1_power2, df$rot_z_power2 ))

#regs<-as.data.frame(cbind.data.frame (df$framewise_displacement, df$a_comp_cor_00, df$a_comp_cor_01, df$a_comp_cor_02, df$a_comp_cor_03, df$a_comp_cor_04, df$a_comp_cor_05,
#                           df$trans_x, df$trans_x_derivative1, df$trans_x_power2,
#                           df$trans_y, df$trans_y_derivative1, df$trans_y_power2,
#                           df$trans_z, df$trans_z_derivative1,  df$trans_z_power2,
#                           df$rot_x, df$rot_x_derivative1, df$rot_x_power2,
#                           df$rot_y, df$rot_y_derivative1, df$rot_y_power2,
#                           df$rot_z, df$rot_z_derivative1,  df$rot_z_power2 ))
#On Aug 6, realized we are using 32 regressors (no acompcors but WM and CSF separately)
regs<-as.data.frame(cbind.data.frame (df$csf, df$csf_derivative1, df$csf_derivative1_power2, df$csf_power2,
                                      df$white_matter, df$white_matter_derivative1, df$white_matter_derivative1_power2, df$white_matter_power2,
                           df$trans_x, df$trans_x_derivative1, df$trans_x_power2, df$trans_x_derivative1_power2 ,
                           df$trans_y, df$trans_y_derivative1, df$trans_y_power2, df$trans_y_derivative1_power2 ,
                           df$trans_z, df$trans_z_derivative1,  df$trans_z_power2, df$trans_z_derivative1_power2 ,
                           df$rot_x, df$rot_x_derivative1, df$rot_x_power2, df$rot_x_derivative1_power2 ,
                           df$rot_y, df$rot_y_derivative1, df$rot_y_power2, df$rot_y_derivative1_power2 ,
                           df$rot_z, df$rot_z_derivative1,  df$rot_z_power2, df$rot_z_derivative1_power2 ))

regs$`df$white_matter_derivative1`<-as.numeric(as.character(regs$`df$white_matter_derivative1`))
regs$`df$white_matter_derivative1_power2`<-as.numeric(as.character(regs$`df$white_matter_derivative1_power2`))
regs$`df$csf_derivative1`<-as.numeric(as.character(regs$`df$csf_derivative1`))
regs$`df$csf_derivative1_power2`<-as.numeric(as.character(regs$`df$csf_derivative1_power2`))
regs$`df$trans_x_derivative1`<-as.numeric(as.character(regs$`df$trans_x_derivative1`))
regs$`df$trans_y_derivative1`<-as.numeric(as.character(regs$`df$trans_y_derivative1`))
regs$`df$trans_z_derivative1`<-as.numeric(as.character(regs$`df$trans_z_derivative1`))
regs$`df$trans_x_derivative1_power2`<-as.numeric(as.character(regs$`df$trans_x_derivative1_power2`))
regs$`df$trans_y_derivative1_power2`<-as.numeric(as.character(regs$`df$trans_y_derivative1_power2`))
regs$`df$trans_z_derivative1_power2`<-as.numeric(as.character(regs$`df$trans_z_derivative1_power2`))
regs$`df$rot_x_derivative1`<-as.numeric(as.character(regs$`df$rot_x_derivative1`))
regs$`df$rot_y_derivative1`<-as.numeric(as.character(regs$`df$rot_y_derivative1`))
regs$`df$rot_z_derivative1`<-as.numeric(as.character(regs$`df$rot_z_derivative1`))
regs$`df$rot_x_derivative1_power2`<-as.numeric(as.character(regs$`df$rot_x_derivative1_power2`))
regs$`df$rot_y_derivative1_power2`<-as.numeric(as.character(regs$`df$rot_y_derivative1_power2`))
regs$`df$rot_z_derivative1_power2`<-as.numeric(as.character(regs$`df$rot_z_derivative1_power2`))

regs[is.na(regs)] <- 0
rownames(regs) <- NULL
names(regs) <- NULL  
regs<-as.data.frame(regs[7:180,])
write.table(regs, file="rest_regressors.tsv", sep='\t', row.names=FALSE, col.names=FALSE)


#Rscript to prepare motion outlier file of rest data for motion censoring
library('qlcMatrix')
library('dplyr')
library('plyr')
df<-read.table(file='r_rest_confounds.tsv', sep='\t', header=T)
df2<- df %>% dplyr :: select(starts_with("motion_outlier"))
df2mat<-as.matrix(df2)
max<-rowMax(df2mat)
mot<-as.data.frame(array(max))
mot<-as.data.frame(mot[7:180,])
write.table(mot, file="rest_motion_out.tsv", sep='\t', row.names=FALSE)


#df$csf, df$csf_derivative1, df$csf_derivative1_power2, df$csf_power2,
#df$white_matter, df$white_matter_derivative1, df$white_matter_derivative1_power2, df$white_matter_power2,