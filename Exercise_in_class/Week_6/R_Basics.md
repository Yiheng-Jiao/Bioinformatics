上机任务：

iris是R语言自带的一个数据集，它默认会作为一个数据框加载到R环境中，请对iris数据做如下分析：

1. iris数据集有几列？每列的数据类型是什么?

    有5列，前4列数据类型为numeric，第5列数据类型为factor。
    所用的代码如下：

```
> head(iris)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
> colnames(iris)
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
[5] "Species"     
> class(iris[["Sepal.Length"]])
[1] "numeric"
> class(iris[["Sepal.Width"]])
[1] "numeric"
> class(iris[["Petal.Length"]])
[1] "numeric"
> class(iris[["Petal.Width"]])
[1] "numeric"
> class(iris[["Species"]])
[1] "factor"
```

2. 按Species列将数据分成3组，分别计算Sepal.Length的均值和标准差，保存为一个csv文件，提供代码和csv文件的内容。

对不同Species的Sepal.Width进行One way ANOVA分析，提供代码和输出的结果。