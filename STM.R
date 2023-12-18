

#```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)


### 0. Environments

#{r environments, results='hide'}
library(stm)
library(textir)

# 显示中文
library(showtext)
font_files()
showtext_auto(enable = TRUE, record = TRUE)
#font_add('Songti', 'Songti.ttc')


### 1. 读取数据

#```{r import_data}
# load(.Rdata)
# data<-read.csv(file.choose(),sep = ',', quote = '',
#               header = TRUE, fileEncoding = 'utf-8')
data <- read.csv('D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英 preprocess 1212 重转utf-8.csv',fileEncoding = 'utf-8')


### 2. 提取数据

#利用textProcessor算法提取数据,将data文本列和data作为参数 textProcessor暂不支持中文，需要自行预处理 wordLength=c(3,Inf)表示移除短于3，长于inf的词语：中文调为1以免单字被删

#```{r processor}
processed <- textProcessor(data$Segmented_Content,metadata=data,wordLengths=c(1,Inf))


### 3. 数据预处理

#查看不同阈值删除doc,words,token情况

#```{r pre}
#pdf('D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\plotRemoved1212（3）.pdf') # 生成结果文件用的
plotRemoved(processed$documents, lower.thresh=seq(from = 1, to = 100, by =1))
dev.off() # 生成结果文件用的


#根据结果确定lower.thresh取值 preDocuments默认值为1 在此例中，我们决定将lower.thresh设为10

#**建立完整文档-协变量数据**
  
#  ```{r prepDocuments}
out <- prepDocuments(
  documents = processed$documents, #包含索引词的计数及文档列表
  vocab = processed$vocab, # 索引词的关联单词
  meta = processed$meta, #包含文档协变量
  lower.thresh = 10)


###似乎有错
# 创建日期协变量
Date <- as.Date(out$meta$Date)  # 假设日期存储在名为Date的列中

# 将日期转换为数值型变量
Date_numeric <- as.numeric(Date)

# 计算日期的最小值和最大值，并用于定义自然样条的节点
date_min <- min(Date_numeric)
date_max <- max(Date_numeric)
knots <- seq(date_min, date_max, length.out = 14)  # 根据需求设置节点数量

# 使用自然样条建模日期协变量
date_spline <- bs(Date_numeric, knots = knots, degree = 3, intercept = TRUE)
###



### 4. 确定主题数 (非必需)

#(如果定好生成几个Topic了，就跳过这一步)

#```{r searchK, results='hide'}
storage <- searchK(
  out$documents, out$vocab, 
  K = 5:20, # 生成5～20个topic比较
  #prevalence = ~classified_province+s(Date), #比如我们想查看版次之间语义区别
  data = out$meta
)


#**可视化结果**
  
#  ```{r plotSearchK}
# 自定义 plot.searchK()
plt_searchK<-function(x, ...){
  oldpar <- par(no.readonly=TRUE)
  g <- x$results
  par(mfrow=c(3,2),mar=c(4,4,2,2),oma=c(1,1,1,1))
  
  plot(g$K,g$heldout,type="p", main="Held-Out Likelihood", xlab="", ylab="")
  lines(g$K,g$heldout,lty=1,col=1)
  
  plot(g$K,g$residual,type="p", main="Residuals", xlab="", ylab="")
  lines(g$K,g$residual,lty=1,col=1 )
  
  if(!is.null(g$semcoh)){
    plot(g$K,g$semcoh,type="p", main="Semantic Coherence", xlab="", ylab="")
    lines(g$K,g$semcoh,lty=1,col=1 ) 
  }
  
  plot(g$K,g$exclus,type="p", main="Exclusivity", xlab="", ylab="")
  lines(g$K,g$exclus,lty=1,col=1 )  
  
  plot(g$K,g$bound,type="p", main="Bound", xlab="Number of Topics (K)", ylab="")
  lines(g$K,g$bound,lty=1,col=1 ) 
  
  plot(g$K,g$lbound,type="p", main="Lower Bound", xlab="Number of Topics (K)", ylab="")
  lines(g$K,g$lbound,lty=1,col=1 ) 
  
  title("Diagnostic Values by Number of Topics", outer=TRUE)  
  par(oldpar)
}

# 可视化结果
pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\plot_ntopics1217.pdf")
plt_searchK(storage)
dev.off()


#结果部分主要看Coherence和Exclusivity，需要这两个值都比较高。 严格来说，需要多次模拟，然后决定，但是基本上还是个人评估为主

#```{r stats_searchK, eval=FALSE}
# 获取具体统计结果
te <- storage$results[[2]] # exclusivity
tc <- storage$results[[3]] # coherence
# 将变量t保存为CSV文件
write.csv(t, file = "D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\t.csv", row.names = FALSE)

#这里为了演示，选取Topic = 5

### 5. 指定主题数模型选择

#```{r selectModel, results='hide'}
poliblogSelect <- selectModel(
  out$documents, out$vocab, K = 13, 
#  prevalence = ~版次, #协变量 # 处理day这个连续变量: 用s(day), 引入spline解决自由度损失问题
  #prevalence = ~classified_province,
  max.em.its = 200, data = out$meta, 
  runs = 20, #20 models
  seed = 20231202
)

#可视化结果，通过语义coherence和exclusivity选择模型(靠右上)
#```{r plotSelectModel}
#pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\stm_plotmodels(k=11).pdf")
plotModels(poliblogSelect, pch = c(1,2,3,4), legend.position = 'bottomright')
dev.off()

#选择模型 [1,2,3,4]
#```{r selectmodel}
selectmodel <- poliblogSelect$runout[[1]]


### 6.模型结果
#输出每个文本属于每个话题的概率
stm_res_df <- selectmodel$theta
write.csv(stm_res_df, "D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英  topicprob 1217(2).csv")
# 获取每个文档属于每个主题的概率
#topic_probs <- posterior(selectmodel)$mean


#高频词
#```{r topic_keywords}
labelTopicsSel <- labelTopics(selectmodel, c(1:14)) # 输出所有5个主题
#sink("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\labelTopicsSel.txt",append = FALSE, split = TRUE)
print(labelTopicsSel)
# print(sageLabels(selectmodel)) #另一种输出方式
# sink()

# 获取每个文档最可能的主题,暂未解决
#topics <- which.max(selectmodel$theta)
#topics <- which.max(posterior(selectmodel)$mean)
# 将主题赋值给原始数据框
#data$topic <- topics
#write.csv(data, 'D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英 preprocess 1212 results - 副本.csv', row.names = FALSE)






#列出主题典型文档
#```{r topic_example}
shortdoc <- substr(out$meta$Segmented_Content,1,200) #前50个字符
thoughts2 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=2 #展示Topic{k}的n篇文档
)$docs[[1]]
#pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\stm_plotQuote.pdf")
#plotQuote(thoughts2,width = 30, main = 'Topic 2')
#dev.off()



#列出主题典型文档
#```{r topic_examples}
# 多个结果
thoughts1 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=1 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts3 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=3 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts4 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=4 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts5 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=5 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts6 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=6 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts7 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=7 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts8 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=8 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts9 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=9 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts10 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=10 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts11 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=11 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts12 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=12 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts13 <- findThoughts(
  selectmodel, texts = shortdoc, n=30, topics=13 #展示Topic{k}的n篇文档
)$docs[[1]]
thoughts14 <- findThoughts(
  selectmodel, texts = shortdoc, n=10, topics=14 #展示Topic{k}的n篇文档
)$docs[[1]]

# 创建数据框
output_data <- data.frame(thoughts1,thoughts2,thoughts3,thoughts4,thoughts5,
                          thoughts6,thoughts7,thoughts8,thoughts9,thoughts10,
                          thoughts11,thoughts12,thoughts13)#,thoughts14

# 输出到CSV文件
write.csv(output_data, "D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英  topicthoughts 1217(2).csv", row.names = FALSE)
#write.csv(stm_res_df, "D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\日本数据\\日本topicprob 1213(k=14).csv")
print(thoughts1)
print(thoughts2)
print(thoughts3)
print(thoughts4)
print(thoughts5)
print(thoughts6)
print(thoughts7)
print(thoughts8)
print(thoughts9)
print(thoughts10)
print(thoughts11)
print(thoughts12)
print(thoughts13)
print(thoughts14)
# pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\stm_plotQuote.pdf)
#par(mfrow=c(1,2),mar=c(.5,.5,1,.5)) # 2x1的表格
#plotQuote(thoughts2,width = 30, main = 'Topic 2')
#plotQuote(thoughts4,width = 30, main = 'Topic 4')
#dev.off()


#评估协变量对所有主题的影响
#```{r estimateEffect}
out$meta$classified_province <- as.factor(out$meta$classified_province)
prep <- estimateEffect(
  # 对所有主题的影响
  1:10 ~ classified_province, 
  selectmodel, meta=out$meta,
  uncertainty = 'Global' # OR "Local", "None"
  # 考虑全局不确定性，选择None会加速计算时间，获得更窄的置信区间
)

summary(prep, topics=1)
summary(prep, topics=2)
summary(prep, topics=3)
summary(prep, topics=4)
summary(prep, topics=5)
summary(prep, topics=6)
summary(prep, topics=7)
summary(prep, topics=8)
summary(prep, topics=9)
summary(prep, topics=10)




### 7.其他可视化结果
#主题占比条形图
#```{r top_topic}
pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英主题占比（k=13）1217.pdf")
plot(selectmodel,type = 'summary', xlim = c(0,1))
dev.off()

#主题关系对比图
#```{r prevalence}
# pdf("stm-plot-topical-prevalence-contrast.pdf")
#plot(
#  prep, covariate = '版次', topics = c(1,2,3,4,5),
#  model = selectmodel, method = 'difference',
#  cov.value1 = '第2版', cov.value2 = '第4版',
#  xlab = '第2版 ... 第4版',
#  main = 'Effect of 第2版 v.s. 第4版',
#  xlim = c(-.8,.8), # 控制x轴范围
#  labeltype = 'custom',
#  custom.labels = c("主题1", '主题2', "自定义主题名","主题4", '主题5')
#)
#dev.off()

#结果解读：
#Effect不能与0相交，具体数值参考【评估协变量对所有主题的影响】
#结论：
#第2版更喜欢报道主题5，第4版更喜欢报道主题1 (t = 15.592, p<.001)

#主题关系网络图
#```{r topic_network, eval=FALSE}
# require igraph
mod.out.corr <- topicCorr(selectmodel)
pdf("D:\\博士\\course sem3\\Data Mining\\nationalism\\结果文件\\大英数据\\大英主题关系（k=13）1217.pdf")
plot(mod.out.corr)
dev.off()
