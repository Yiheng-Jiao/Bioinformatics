#!/bin/bash
raw_seq="MSTRSVSSSSYRRMFGGPGTASRPSSSRSYVTTSTRTYSLGSALRPSTSRSLYASSPGGVYATRSSAVRL"

for i in `seq 1 10`
do
	echo $raw_seq | fold -w 1 | shuf > "temp_random_$i"
	cat "temp_random_$i" | awk '{printf $0}' > "random_seq_$i"
	echo "" >> "random_seq_$i"
	rm "temp_random_$i"
done

echo '' > "random_seq.fasta"
for i in `seq 1 10`
do
	echo ">random_seq_$i" >> "random_seq.fasta"
	cat "random_seq_$i" >> "random_seq.fasta"
	rm "random_seq_$i"
done

blastp -query random_seq.fasta -subject random_seq.fasta -out output/random_seq_blastp
