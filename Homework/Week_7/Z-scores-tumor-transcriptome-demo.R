# 设置工作目录
setwd("~/tumor-transcriptome-demo/")

# 读取所有样本文件的名称
file_list_COAD <- list.files(path = "~/tumor-transcriptome-demo/COAD/")
file_list_ESCA <- list.files(path = "~/tumor-transcriptome-demo/ESCA/")
file_list_READ <- list.files(path = "~/tumor-transcriptome-demo/READ/")

# 获取样本名称，便于确定heatmap各列对应的样本
sample_list_COAD <- substr(file_list_COAD, 1, 28)
sample_list_ESCA <- substr(file_list_ESCA, 1, 28)
sample_list_READ <- substr(file_list_READ, 1, 28)

# 通过第一个样本文件获取Gene id，便于确定heatmap各行对应的基因
file_1_COAD <- read.delim(paste("~/tumor-transcriptome-demo/COAD/", file_list_COAD[1], sep = ""), comment.char = "#")

Geneid=file_1_COAD[[1]]

# 初始化matrix
counts.matrix=matrix(nrow = 2000, ncol = 150)

# 合并各个样本的featureCount
for (i in seq_along(file_list_COAD)){
  current_file <- read.delim(paste("~/tumor-transcriptome-demo/COAD/", file_list_COAD[i], sep = ""), comment.char = "#")
  current_matrix=as.matrix(current_file[7])
  counts.matrix[(2000 * i - 1999):(2000 * i)]=as.matrix(current_file[7])
}
for (i in seq_along(file_list_ESCA)){
  current_file <- read.delim(paste("~/tumor-transcriptome-demo/ESCA/", file_list_ESCA[i], sep = ""), comment.char = "#")
  current_matrix=as.matrix(current_file[7])
  counts.matrix[(2000 * 50 + 2000 * i - 1999):(2000 * 50 + 2000 * i)]=as.matrix(current_file[7])
}
for (i in seq_along(file_list_READ)){
  current_file <- read.delim(paste("~/tumor-transcriptome-demo/READ/", file_list_READ[i], sep = ""), comment.char = "#")
  current_matrix=as.matrix(current_file[7])
  counts.matrix[(2000 * 100 + 2000 * i - 1999):(2000 * 100 + 2000 * i)]=as.matrix(current_file[7])
}

# 设置matrix的colnames，便于在heatmap中确定各样本名称
colnames(counts.matrix) = c(sample_list_COAD, sample_list_ESCA, sample_list_READ)
rownames(counts.matrix) = Geneid

# 计算CPM
CPM.matrix <- t(1000000*t(counts.matrix)/colSums(counts.matrix))
log10.CPM.matrix <- log10(CPM.matrix+1)

# 计算z-scores
z.scores <- (log10.CPM.matrix - rowMeans(log10.CPM.matrix))/apply(log10.CPM.matrix,1,sd)

# 在可视化前，将>2的z-score clip到2，<-2的z-score类似的clip到-2，避免展示出个别outlier的数值，导致绝大部分样本看起来颜色差异不明显的情况
for (i in seq_along(z.scores)){
  if(z.scores[i]!="NaN"){
    if(z.scores[i]>2){
      z.scores[i]=2
    }
    if(z.scores[i]<(-2)){
      z.scores[i]=(-2)
    }
  }
  else{
    z.scores[i]=0
  }
}

# 加载pheatmap包
library(pheatmap)

# 列注释（共150列的matrix中，前、中、后50列分别对应COAD、ESCA、READ）
annotation_col = data.frame(CellType = factor(rep(c("COAD", "ESCA", "READ"), c(50, 50, 50))))

# 列注释与matrix列的对应关系
rownames(annotation_col) = colnames(z.scores)

# heatmap中注释的颜色
ann_colors = list(CellType = c(COAD = "#996600", ESCA = "#FFCC33", READ = "#FFFFCC"))

# 绘制heatmap图（不聚类和按行聚类）
pheatmap(z.scores, # 数据来源 
         cluster_rows=FALSE,  cluster_cols=FALSE, # 是否按行/列聚类（不聚类）
         show_rownames=FALSE,show_colnames = FALSE, # 是否展示各行/列名称（此处由于数据量过大，无法展示各样本名和各基因名）
         annotation_col = annotation_col, annotation_colors = ann_colors) # 注释样本所对应的癌症

pheatmap(z.scores, # 数据来源 
         cluster_rows=FALSE,  cluster_cols=FALSE, # 是否按行/列聚类（按行聚类）
         show_rownames=FALSE,show_colnames = FALSE, # 是否展示各行/列名称（此处由于数据量过大，无法展示各样本名和各基因名）
         annotation_col = annotation_col, annotation_colors = ann_colors) # 注释样本所对应的癌症