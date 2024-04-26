1) 请阐述 RNA-seq 中归一化基因表达值的几种基本计算方法。

    对small RNA-seq，由于其长度在18-30 nt，各small RNA之间长度较为接近，且单条read可以完全覆盖整个small RNA，因此无需除以基因长度，通常用CPM/RPM (**C**ounts/**R**eads **P**er **M**illion mapped reads)计算归一化基因表达值；

    对poly-A/total RNA-seq，由于各基因间长度差异较大，而一条transcript产生的reads通常与其长度成正比，因此需要除以基因长度，通常用RPKM (**R**eads **P**er **K**ilobase per **M**illion mapped reads)计算归一化基因表达值；

    对paired-end RNA-seq，由于对应的两个reads可以组成一个fragment，因此常用FPKM (**F**ragments **P**er **K**ilobase per **M**illion mapped reads)计算归一化基因表达值；

    更直观地，还可以用TPM (**T**ranscipt **P**er **M**illion mapped reads)计算归一化基因表达值，直接反映转录本的相对数量，而非测序得到的reads密度；

    对于差异表达的分析(Differential Expression Analysis)，  edgeR使用TMM (Trimmed Mean of M-values)，即选取一个representative gene set (G)（通常选取一些表达水平变化很小的housekeeping gene），并给其中的每个gene一个权重(a weighted M)，对于任意一个样本(sample *j*)，根据其中属于gene set G的基因表达水平计算出TMM，从而实现归一化（**实际上是将representative gene set G作为“一”，这种做法有利于找到每一处变化，即使变化很小，但相对依赖于预设的gene set**）；DEseq2使用RLE (Relative Log Expression)，以各基因的raw counts/reads这一比值除以样本中所有基因raw counts/reads的几何平均值后的中位数作为归一化的系数(**可以认为是将样本基因表达值的对数的中位数作为了“一”，这种做法能凸显处基因表达变化的倍数大的基因，有利于找到最大的差异**)

2) 根据下述图片描述，填出对应选项:
![alt text](Q_2-1.png)

    Standard illummina: E.13

    Ligation methos: D.9

    dUTPs methos: A.4

3) 通过软件计算，判断给出文件shape02数据是来自哪一种sequencing protocols (strand nonspecific, strand specific - forward, strand specific - reverse)，并选择合适的参数计算shape02的read count matrix，给出AT1G09530基因(PIF3基因)上的counts数目。

- 判断给出文件shape02数据是来自哪一种sequencing protocols时，

    使用的代码如下：

```
/usr/local/bin/infer_experiment.py -r GTF/Arabidopsis_thaliana.TAIR10.34.bed -i bam/Shape02.bam
```

    得到的结果：

```
Reading reference gene model GTF/Arabidopsis_thaliana.TAIR10.34.bed ... Done
Loading SAM/BAM file ...  Total 200000 usable reads were sampled


This is PairEnd Data
Fraction of reads failed to determine: 0.0315
Fraction of reads explained by "1++,1--,2+-,2-+": 0.4769
Fraction of reads explained by "1+-,1-+,2++,2--": 0.4916
```

从结果中可以看到，"1++,1--,2+-,2-+"与"1+-,1-+,2++,2--"的比例几乎相同，有很大的把握认定这个数据是由**非链特异性建库**(**strand nonspecific**)得到的。

- 计算shape02的read count matrix和AT1G09530基因(PIF3基因)上的counts数目时，

    使用的代码如下：

```
cd home/test/

/home/software/subread-2.0.3-source/bin/featureCounts \
> -s 0 -p -texon -g gene_id \
> -a GTF/Arabidopsis_thaliana.TAIR10.34.gtf \
> -o result/Shape02.featurecounts.exon.txt bam/Shape02.bam

grep '^AT1G09530' result/Shape02.featurecounts.exon.txt
```

得到如下结果：

```
AT1G09530       1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1   3075768;3075768;3075768;3076401;3076401;3076401;3076459;3076459;3076459;3077173;3077173;3077173;3077173;3077378;3077378;3077378;3077378;3077378;3077378;3078346;3078346;3078346;3078346;3078346;3078346;3078545;3078545;3078545;3078545;3078545;3078545;3078843;3078843;3078843;3078843;3078843;3078843;3078984;3078984;3078984;3078984;3078984;3078984 3075852;3075852;3075852;3077286;3076808;3076748;3076808;3077286;3076748;3077286;3077286;3077286;3077286;3078257;3078257;3078257;3078257;3078257;3078257;3078453;3078453;3078453;3078453;3078453;3078453;3078610;3078610;3078610;3078610;3078610;3078610;3078908;3078908;3078908;3078908;3078908;3078908;3079544;3079544;3079544;3079654;3079654;3079654 +;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+;+   2762    86
```

参照`Shape02.featurecounts.exon.txt`文件第2行：

```
Geneid	Chr	Start	End	Strand	Length	bam/Shape02.bam
```

可知，AT1G09530基因(PIF3基因)上的counts数目为**86**个。

4) `tumor-transcriptome-demo.tar.gz`提供了结肠癌(COAD)，直肠癌(READ)和食道癌(ESCA)三种癌症各50个样本的bam文件用featureCount计算产生的结果。请大家编写脚本将这些文件中的counts合并到一个矩阵中(行为基因，列为样本), 计算logCPM的Z-score，并用 heatmap 展示，提供代码和heatmap。根据heatmap可视化的结果，你认为这三种癌症中哪两种癌症的转录组是最相似的?

将这些文件中的counts合并到一个矩阵中(行为基因，列为样本)的脚本如下：

```
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


annotation_col = data.frame(CellType = factor(rep(c("COAD", "ESCA", "READ"), c(50, 50, 50))))

rownames(annotation_col) = colnames(z.scores)

ann_colors = list(CellType = c(COAD = "#7FBC41", ESCA = "#DE77AE", READ = "#DE77EC"))

pheatmap(z.scores, 
         cutree_col = 3, cutree_row = 1,
         cluster_rows=FALSE, show_rownames=FALSE, cluster_cols=TRUE, show_colnames = FALSE,
         annotation_col = annotation_col, annotation_colors = ann_colors)



```
