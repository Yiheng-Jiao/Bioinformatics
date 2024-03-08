1. 对于示例文件(test_command.gtf)，尝试使用相关命令或命令组合分别统计文件的行数以及字符数。

统计文件的行数:
```
wc -l test_command.gtf
```

统计文件的字符数:
```
wc -c test_command.gtf
```

2. 利用`grep`等命令尝试筛选并输出示例文件中以chr_起始，并且基因id为YDL248W的行。
```
# 注意^和-w 'gene_id'
grep '^chr_' test_command.gtf | grep -w 'gene_id "YDL248W"'

```


3. 利用`sed`等命令将示例文件中的chr_替换为chromosome_并输出每行的第1，3，4，5列。（无需改动原文件，只输出结果）
```
sed -e '/s/chr_/chromosome_/g' test_command.gtf | cut -f 1,3,4,5
```

4. 通过`man`命令以及更多的资料学习简单的`awk`命令，尝试互换示例文件的第2列和第3列，并且对输出结果利用`sort`命令依照第4和第5列数字大小排序，将最终结果输出到result.gtf文件中。
```
awk '{print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12}' test_command.gtf | sort -k 4 -k 5 -n >> result.gtf
```

5. 更改示例文件的权限，使得文件所有者及所在用户组用户可读、写、执行而其他用户只可读，展示权限修改前后的权限变化。
```
ls -hl
chmod ug=rwx,o=r test_command.gtf
#如果当前用户不是文件所有者，需要在PowerShell中更改所有者
#通常来说，直接通过Windows文件管理器复制到share文件夹中的文件所有者默认为root
#docker exec -u root jiaoyiheng_bioinfo_tsinghua chown -R test:test /home/test/share
ls -hl
```