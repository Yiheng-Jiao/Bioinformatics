练习中的部分命令和返回如下：

```
PS C:\Users\Astral> docker exec -it jiaoyiheng_bioinfo_tsinghua bash

test@bioinfo_docker:~$ cd linux

test@bioinfo_docker:~/linux$ ls -lh 1.gtf
-rw-rw-r-- 1 test test 12M Sep 11  2018 1.gtf

test@bioinfo_docker:~/linux$ wc -l 1.gtf
42252 1.gtf

test@bioinfo_docker:~/linux$ grep -v "^#" 1.gtf | grep -v '^$' | wc -l
42247

test@bioinfo_docker:~/linux$ cat 1.gtf | awk '$0!~/^\s*$/{print}' | head -10
#!genome-build R64-1-1
#!genome-version R64-1-1
#!genome-date 2011-09
#!genome-build-accession :GCA_000146045.2
#!genebuild-last-updated 2011-12
IV      ensembl gene    1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding";
IV      ensembl transcript      1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding";
IV      ensembl exon    1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding"; exon_id "YDL248W.1"; exon_version "1";
IV      ensembl CDS     1802    2950    .       +       0       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YDL248W"; protein_version "1";
IV      ensembl start_codon     1802    1804    .       +       0       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding";

test@bioinfo_docker:~/linux$ grep -v '^\s*$' 1.gtf | head -10
#!genome-build R64-1-1
#!genome-version R64-1-1
#!genome-date 2011-09
#!genome-build-accession :GCA_000146045.2
#!genebuild-last-updated 2011-12
IV      ensembl gene    1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding";
IV      ensembl transcript      1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding";
IV      ensembl exon    1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding"; exon_id "YDL248W.1"; exon_version "1";
IV      ensembl CDS     1802    2950    .       +       0       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding"; protein_id "YDL248W"; protein_version "1";
IV      ensembl start_codon     1802    1804    .       +       0       gene_id "YDL248W"; gene_version "1"; transcript_id "YDL248W"; transcript_version "1"; exon_number "1"; gene_name "COS7"; gene_source "ensembl"; gene_biotype "protein_coding"; transcript_name "COS7"; transcript_source "ensembl"; transcript_biotype "protein_coding";

test@bioinfo_docker:~/linux$ awk 'BEGIN  {s = 0;line = 0;}$3 =="CDS" && $1 =="I"{ s += $5-$4+1;line += 1}END {print "mean="s/line}' 1.gtf
mean=1239.52

test@bioinfo_docker:~/linux$ cat 1.gtf | awk '$3 == "gene"{split($10,x,";");name = x[1];gsub("\"", "", name);print name,$5-$4+1}' | head
YDL248W 1152
YDL247W-A 75
YDL247W 1830
YDL246C 1074
YDL245C 1704
YDL244W 1023
YDL243C 990
YDL242W 354
YDL241W 372
YDL240C-A 138

test@bioinfo_docker:~/linux$ grep exon 1.gtf | awk '{print $5-$4+1}' | sort -n | tail -3 > 1.txt

test@bioinfo_docker:~/linux$ cat 1.txt
12279
14730
14733

test@bioinfo_docker:~/linux$ ./run.sh
12279
14730
14733

test@bioinfo_docker:~/linux$ cp 1.txt ~/share
```