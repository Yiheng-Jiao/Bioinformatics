ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin(aes(fill = Species), trim = FALSE) + # 绘制violin图并按Species填充不同颜色
  scale_fill_manual(values = c("#C44E52", "#55A868", "#4C72B0")) + # 设置填充颜色
  labs(title = "Sepal Length Distribution") + # 设置标题
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) + # 将标题加粗居中
  scale_y_continuous(limits = c(0.5, 7), breaks = seq(0.5, 7, by = 0.5)) #设置y轴范围为0.5到7