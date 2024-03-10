1. 列出1.gtf文件中XI号染色体上的后10个CDS（按照每个CDS终止位置的基因组坐标进行sort）。

所用命令为：
```
grep -v '^#' 1.gtf | awk '$1 == "XI" && $3 == "CDS" {print $0}' | sort -k 5 -n | tail -10
```

得到的输出如下：
```
test@bioinfo_docker:~/linux$ grep -v '^#' 1.gtf | awk '$1 == "XI" && $3 == "CDS" {print $0}' | sort -k 5 -n | tail -10
XI      ensembl CDS     631152  632798  .       +       0       gene_id "YKR097W"; gene_version "1"; transcript_id "YKR097W"; transcript_version "1"; exon_number "1"; gene_name "PCK1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "PCK1"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR097W"; protein_version "1";
XI      ensembl CDS     633029  635179  .       -       0       gene_id "YKR098C"; gene_version "1"; transcript_id "YKR098C"; transcript_version "1"; exon_number "1"; gene_name "UBP11"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "UBP11"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR098C"; protein_version "1";
XI      ensembl CDS     635851  638283  .       +       0       gene_id "YKR099W"; gene_version "1"; transcript_id "YKR099W"; transcript_version "1"; exon_number "1"; gene_name "BAS1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "BAS1"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR099W"; protein_version "1";
XI      ensembl CDS     638904  639968  .       -       0       gene_id "YKR100C"; gene_version "1"; transcript_id "YKR100C"; transcript_version "1"; exon_number "1"; gene_name "SKG1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "SKG1"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR100C"; protein_version "1";
XI      ensembl CDS     640540  642501  .       +       0       gene_id "YKR101W"; gene_version "1"; transcript_id "YKR101W"; transcript_version "1"; exon_number "1"; gene_name "SIR1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "SIR1"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR101W"; protein_version "1";
XI      ensembl CDS     646356  649862  .       +       0       gene_id "YKR102W"; gene_version "1"; transcript_id "YKR102W"; transcript_version "1"; exon_number "1"; gene_name "FLO10"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "FLO10"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR102W"; protein_version "1";
XI      ensembl CDS     653080  656733  .       +       0       gene_id "YKR103W"; gene_version "1"; transcript_id "YKR103W"; transcript_version "1"; exon_number "1"; gene_name "NFT1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "NFT1"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR103W"; protein_version "1";
XI      ensembl CDS     656836  657753  .       +       0       gene_id "YKR104W"; gene_version "1"; transcript_id "YKR104W"; transcript_version "1"; exon_number "1"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "YKR104W"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR104W"; protein_version "1";
XI      ensembl CDS     658719  660464  .       -       0       gene_id "YKR105C"; gene_version "1"; transcript_id "YKR105C"; transcript_version "1"; exon_number "1"; gene_name "VBA5"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "VBA5"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR105C"; protein_version "1";
XI      ensembl CDS     661442  663286  .       +       0       gene_id "YKR106W"; gene_version "1"; transcript_id "YKR106W"; transcript_version "1"; exon_number "1"; gene_name "GEX2"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "GEX2"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YKR106W"; protein_version "1";
```
2. 统计IV号染色体上各类feature（1.gtf文件的第3列，有些注释文件中还应同时考虑第2列）的数目，并按升序排列。

所用的命令为：
```
grep -v '^#' 1.gtf | awk '$1 == "IV" {print $3}' | sort | uniq -c | sort -n
```

得到的输出如下：
```
test@bioinfo_docker:~/linux$ grep -v '^#' 1.gtf | awk '$1 == "IV" {print $3}' | sort | uniq -c | sort -n
    853 start_codon
    853 stop_codon
    886 gene
    886 transcript
    895 CDS
    933 exon
```
3. 寻找不在IV号染色体上的所有负链上的基因中最长的2条CDS序列，输出他们的长度。
所用的命令为：
```
grep -v '^#' 1.gtf | awk '$1 != "IV" && $7 == "-" && $3 == "CDS" {print $5-$4+1;}' | sort -n -r | head -2
```

得到的输出如下：
```
14730
12276
```
4. 寻找XV号染色体上长度最长的5条基因，并输出基因id及对应的长度。
所用的命令为：
```
grep -v '^#' 1.gtf | awk '$1 == "XV" && $3 =="gene" {split($10,x,";"); name = x[1]; gsub("\"","",name); print name, $5-$4+1}' | sort -r -k 2 -n | head -5
```

得到的输出如下：
```
YOL081W 9240
YOR396W 5391
YOR343W-B 5314
YOR192C-B 5314
YOR142W-B 5269
```
5. 统计1.gtf列数
所用的命令为：
```
# 统计行数
cat 1.gtf | awk '{print NF}' | sort -n | uniq -c

# 输出“第m行有n列”
cat 1.gtf | awk '{print "第", NR, "行有", NF, "列"}'

# 输出(第几行, 列数)
cat 1.gtf | awk '{print NR, NF}'
```

得到的输出如下：
```
# 统计行数情况如下：
test@bioinfo_docker:~/linux$ cat 1.gtf | awk '{print NF}' | sort -n | uniq -c
      5 2
   2116 16
   5010 18
      1 24
   2115 26
   8472 28
   9932 30
   4067 32
  10534 34

# 取前10行和后10行结果如下，由于前5行为注释行，因此只有2列
test@bioinfo_docker:~/linux$ cat 1.gtf | awk '{print "第", NR, "行有", NF, "列"}' | head -10
第 1 行有 2 列
第 2 行有 2 列
第 3 行有 2 列
第 4 行有 2 列
第 5 行有 2 列
第 6 行有 18 列
第 7 行有 28 列
第 8 行有 34 列
第 9 行有 34 列
第 10 行有 30 列
test@bioinfo_docker:~/linux$ cat 1.gtf | awk '{print "第", NR, "行有", NF, "列"}' | tail -10
第 42243 行有 32 列
第 42244 行有 16 列
第 42245 行有 26 列
第 42246 行有 32 列
第 42247 行有 16 列
第 42248 行有 26 列
第 42249 行有 32 列
第 42250 行有 32 列
第 42251 行有 28 列
第 42252 行有 28 列

# 取前10行结果如下，由于前5行为注释行，因此只有2列
test@bioinfo_docker:~/linux$ cat 1.gtf | awk '{print NR, NF}' |head -10
1 2
2 2
3 2
4 2
5 2
6 18
7 28
8 34
9 34
10 30
```