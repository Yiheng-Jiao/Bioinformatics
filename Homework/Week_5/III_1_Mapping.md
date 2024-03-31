(1) 请阐述bowtie中利用了BWT的什么性质提高了运算速度？并通过哪些策略优化了对内存的需求？

利用了BWT的Last First Mapping性质（即最后一列L中出现某字符出现的顺序与第一列F某字符出现的次序是一致的）提高了运算速度。

通过BWT、Milestones、Checkpoints策略优化了内存需求。

(2) 用bowtie将`THA2.fa`mapping到`BowtieIndex/YeastGenome`上，得到`THA2.sam`，统计mapping到不同染色体上的reads数量(即统计每条染色体都map上了多少条reads)。

首先完成mapping，
```
test@bioinfo_docker:~/mapping$ bowtie -v 2 -m 10 --best --strata BowtieIndex/YeastGenome -f THA2.fa -S THA2.sam
# reads processed: 1250
# reads with at least one reported alignment: 1158 (92.64%)
# reads that failed to align: 77 (6.16%)
# reads with alignments suppressed due to -m: 15 (1.20%)
Reported 1158 alignments to 1 output stream(s)
```
然后统计THA2.sam文件中每条染色体都map上了多少条reads：
```
test@bioinfo_docker:~/mapping$ grep -v '^@' THA2.sam | awk '{print $3}' | sort | uniq -c | sort -n
     12 chrmt
     15 chrIII
     17 chrVI
     18 chrI
     25 chrIX
     33 chrV
     51 chrII
     56 chrXI
     58 chrXIV
     67 chrXIII
     68 chrVIII
     71 chrX
     78 chrXVI
     92 *
    101 chrXV
    125 chrVII
    169 chrXII
    194 chrIV
```

(3.1) 什么是sam/bam文件中的"CIGAR string"？ 它包含了什么信息？

