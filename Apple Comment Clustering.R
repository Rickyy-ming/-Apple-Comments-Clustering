# Load necessary libraries
library(tm)      # For text mining and preprocessing
library(textclean) # For text cleaning and normalization
library(cluster) # For hierarchical clustering
library(slam)
library(ggplot2)
library(dendextend)
library(proxy)



AppCorp = Corpus(VectorSource(Apple$comment))
AppCorp=tm_map(AppCorp,content_transformer(tolower))
AppCorp=tm_map(AppCorp,removeWords,stopwords('english'))
AppCorp=tm_map(AppCorp,removePunctuation)
AppCorp=tm_map(AppCorp,stemDocument)
Appcorpus= tm_map(AppCorp, stripWhitespace)
AppDTM =DocumentTermMatrix(AppCorp)
AppTDM=TermDocumentMatrix(AppCorp)
AppDTM =removeSparseTerms(AppDTM,0.95)
AppTDM =removeSparseTerms(AppTDM,0.90)

# Remove empty documents from the DTM
AppDTM = AppDTM[rowSums(as.matrix(AppDTM)) > 0, ]
AppTDM = AppTDM[rowSums(as.matrix(AppDTM)) > 0, ]

inspect(AppDTM)
tfidf <- weightTfIdf(AppDTM)
inspect(AppTDM)

# Perform hierarchical clustering
AppDist = dist(as.matrix(AppTDM),method = 'euclidean')
AppClust=hclust(d=AppDist, method='ward.D')
plot(AppClust)
AppTopics=cutree(AppClust,k=5)
hclust_result = hclust(d=AppDist, method = "ward.D2")
AppTopics=cutree(hclust_result,k=4)
AppTopics
plot(hclust_result, hang = -1, main = "Hierarchical Clustering Dendrogram", xlab = "Comment ID")

similarity <- 1 - proxy::dist(t(as.matrix(AppDTM)), method = "cosine")
hclust_result <- hclust(as.dist(similarity), method = "ward.D2")
num_clusters <- 3
clusters <- cutree(hclust_result, k = num_clusters)
clusters
dend <- as.dendrogram(hclust_result)
cluster_df <- data.frame(Labels = labels(dend), Cluster = clusters)

cluster_df
