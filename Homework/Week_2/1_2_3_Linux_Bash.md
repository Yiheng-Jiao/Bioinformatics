参考和学习本章内容，写出一个 bash 脚本，可以使它自动读取一个文件夹（例如bash_homework/）的内容，将该文件夹下文件的名字输出到 filenames.txt, 子文件夹的名字输出到 dirname.txt 。

bash脚本内容如下：
```
#!/bin/bash
CUR_DIR=`ls ~/share/bash_homework/`

for val in $CUR_DIR
do
        if [ -f "/home/test/share/bash_homework/$val" ]; then
                echo $val >> filename.txt
        fi
        if [ -d "/home/test/share/bash_homework/$val" ]; then
                echo $val >> dirname.txt
        fi
done

exit 0
```

filename.txt内容如下：
```
a1.txt
a.txt
b1.txt
bam_wig.sh
b.filter_random.pl
c1.txt
chrom.size
c.txt
d1.txt
dir.txt
e1.txt
f1.txt
human_geneExp.txt
if.sh
image
insitiue.txt
mouse_geneExp.txt
name.txt
number.sh
out.bw
random.sh
read.sh
test3.sh
test4.sh
test.sh
test.txt
wigToBigWig

```

dirname.txt内容如下：
```
a-docker
app
backup
bin
biosoft
c1-RBPanno
datatable
db
download
e-annotation
exRNA
genome
git
highcharts
home
hub29
ibme
l-lwl
map2
mljs
module
mogproject
node_modules
perl5
postar2
postar_app
postar.docker
RBP_map
rout
script
script_backup
software
tcga
test
tmp
tmp_script
var
x-rbp

```