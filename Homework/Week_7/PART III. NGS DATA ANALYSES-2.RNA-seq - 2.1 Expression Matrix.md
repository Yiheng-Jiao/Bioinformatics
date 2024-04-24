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
从结果中可以看到，"1++,1--,2+-,2-+"与"1+-,1-+,2++,2--"的比例几乎相同，有很大的把握认定这个数据是由**非链特异性建库**得到的。

4) tumor-transcriptome-demo.tar.gz提供了结肠癌(COAD)，直肠癌(READ)和食道癌(ESCA)三种癌症各50个样本的bam文件用featureCount计算产生的结果。请大家编写脚本将这些文件中的counts合并到一个矩阵中(行为基因，列为样本), 计算logCPM的Z-score，并用 heatmap 展示，提供代码和heatmap。根据heatmap可视化的结果，你认为这三种癌症中哪两种癌症的转录组是最相似的?



