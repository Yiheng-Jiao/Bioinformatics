对于序列`MSTRSVSSSSYRRMFGGPGTASRPSSSRSYVTTSTRTYSLGSALRPSTSRSLYASSPGGVYATRSSAVRL`:

1）请使用网页版的blastp, 将上面的蛋白序列只与mouse protein database进行比对，设置输出结果最多保留10个，E值最大为0.5。将操作过程和结果截图，并解释一下E value和P value的实际意义。

![alt text](Blast_Setting_1.png "Blast Setting")
![alt text](Blast_Setting_2.png "Blast Setting")
![alt text](Blast_Result.png "Blast Result")

E value的实际意义是在随机的情况下，该数据库中其他序列与目标序列的相似度大于或等于当前序列相似度的可能性，因此E value越低越好。

P value的实际意义是在随机的情况下，任意序列（不限于当前检索的数据库）与目标序列的相似度大于或等于当前序列相似度的可能性。

2）请使用 Bash 脚本编程：将上面的蛋白序列随机打乱生成10个， 然后对这10个序列两两之间进行 blast 比对，输出并解释结果。（请上传bash脚本，注意做好重要code的注释；同时上传一个结果文件用来示例程序输出的结果以及你对这些结果的解释。）

Bash脚本如下：
```
#!/bin/bash
# 随机打乱前的原始序列
raw_seq="MSTRSVSSSSYRRMFGGPGTASRPSSSRSYVTTSTRTYSLGSALRPSTSRSLYASSPGGVYATRSSAVRL"

# 随机打乱并暂存在random_seq_$i
for i in `seq 1 10`
do
	echo $raw_seq | fold -w 1 | shuf > "temp_random_$i"   # 为了使用shuf随机函数，利用fold将序列存成每行一个字符的形式
	cat "temp_random_$i" | awk '{printf $0}' > "random_seq_$i"   # 将每行一个字符的形式转换为所有字符都在一行上
	echo "" >> "random_seq_$i"   # 在序列最后加上一个换行符
	rm "temp_random_$i"   # 删掉临时文件
done

# 将暂存的10个随机打乱序列整理成一个fasta文件以便做blast
echo '' > "random_seq.fasta"   # 将以往运行时的旧文件清空
for i in `seq 1 10`
do
	echo ">random_seq_$i" >> "random_seq.fasta"   # fasta文件格式中用于记录序列id等相关信息的行
	cat "random_seq_$i" >> "random_seq.fasta"   # fasta文件格式中用于记录序列的行
	rm "random_seq_$i"   # 删掉临时文件
done

# 两两blast
blastp -query random_seq.fasta -subject random_seq.fasta -out output/random_seq_blastp
```
输出的结果见random_seq_blastp文件，该次运行的随机序列见random_seq.fasta文件。

以random_seq_1的blast为例，对输出结果作简单的解释：
```
Query= random_seq_1

Length=70
                                                                      Score     E
Sequences producing significant alignments:                          (Bits)  Value

  random_seq_1                                                        123     2e-43   # 当query和subject相同时，E值很小是合理的
  random_seq_4                                                        14.2    1.5     # 随机的序列E值远大于1e-5
  random_seq_7                                                        12.7    4.9  


# 由于query和subject使用的是同一个fasta文件，因此这里会出现随机序列对自身的blast
> random_seq_1
Length=70

 Score = 123 bits (308),  Expect = 2e-43, Method: Compositional matrix adjust.
 Identities = 70/70 (100%), Positives = 70/70 (100%), Gaps = 0/70 (0%)

Query  1   VMLSRTMPTSSGSSYRSTATSSVLRPYTSRRLRGRAAVTSGSRRTGSSLSSASTGRSYYG  60
           VMLSRTMPTSSGSSYRSTATSSVLRPYTSRRLRGRAAVTSGSRRTGSSLSSASTGRSYYG
Sbjct  1   VMLSRTMPTSSGSSYRSTATSSVLRPYTSRRLRGRAAVTSGSRRTGSSLSSASTGRSYYG  60

Query  61  VSSSAFYPSP  70
           VSSSAFYPSP
Sbjct  61  VSSSAFYPSP  70


> random_seq_4
Length=70

 Score = 14.2 bits (25),  Expect = 1.5, Method: Compositional matrix adjust.
 Identities = 6/14 (43%), Positives = 10/14 (71%), Gaps = 0/14 (0%)

Query  46  GSSLSSASTGRSYY  59
           G + S+  +GR+YY
Sbjct  51  GVTSSAVRSGRAYY  64


> random_seq_7
Length=70

 Score = 12.7 bits (21),  Expect = 4.9, Method: Compositional matrix adjust.
 Identities = 5/6 (83%), Positives = 5/6 (83%), Gaps = 0/6 (0%)

Query  4   SRTMPT  9
           SRT PT
Sbjct  59  SRTYPT  64



Lambda      K        H        a         alpha
   0.307    0.116    0.309    0.792     4.96 

Gapped
Lambda      K        H        a         alpha    sigma
   0.267   0.0410    0.140     1.90     42.6     43.6 

Effective search space used: 26010
```

3）解释blast中除了动态规划（dynamic programming）还利用了什么方法来提高速度，为什么可以提高速度。

还利用了Heuristic Methods来提高速度。
因为Heuristic Methods预先计算了一个hash table记录每一个相同的短片段（称为hits或者tuple），在之后的每次extention中就不必再次计算这些短片段的Score，从而节约时间。

4）我们常见的PAM250有如下图所示的两种（一种对称、一种不对称），请阅读一下"Symmetry of the PAM matrices" @ wikipedia，再利用Google/wikipedia等工具查阅更多资料，然后总结和解释一下这两种（对称和不对称）PAM250不一样的原因及其在应用上的不同。

不对称PAM250的存在是因为各类氨基酸本身的化学结构和突变反应的热力学和动力学性质决定了对于特定的一个氨基酸来说由氨基酸i到j和由j到i的突变概率是不同的，回顾系统发生树中各类氨基酸突变发生的频率即可计算得到不对称的PAM250。

对称PAM250的存在是因为在长期进化下，各类氨基酸在自然界中存在的比例已经稳定，由i到j的突变数量和由j到i的突变数量相等，或者说基于现在的氨基酸比例，氨基酸正反突变的发生概率（发生量）是相等的，由此可以计算得到对称的PAM250。

从数据来源的角度看，不对称的PAM250用于计算不同物种间的的蛋白在进化上的同源性；对称的PAM250用于计算同一物种的蛋白的同源性。