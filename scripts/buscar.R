library(tm)
library(FastKNN)

PATH = "~/projeto/shinyApp/Legendas/"

search = function(movie){
  
  
  movie = "Ace Ventura Pet Detective.DVDRip.BugBunny.br.srt"
  file.names <- dir(PATH)
  
  legendas <- c()
  
  for(i in 1:length(file.names)){
    filename <- paste(PATH, file.names[i], sep="")
    doc <- readChar(filename,file.info(filename)$size)
    legendas <- c(legendas, doc)
  }
  
  docs_teste <- c()
  
  filmes_teste <- c(movie)
  docs_teste <- c()
  
  for(i in 1:length(filmes_teste)){
    filmes_teste <- paste(PATH, filmes_teste[i], sep="")
    doc_teste <- readChar(filmes_teste,file.info(filmes_teste)$size)
    docs_teste <- c(docs_teste, doc_teste)
  }
  
  my.treino <- VectorSource(c(legendas, docs_teste))
  
  my.treino.corpus <- Corpus(my.treino)
  my.treino.corpus <- tm_map(my.treino.corpus, removePunctuation)
  #my.treino.corpus <- tm_map(my.treino.corpus, removeWords, stopwords("portuguese"))
  my.treino.corpus <- tm_map(my.treino.corpus, stemDocument)
  my.treino.corpus <- tm_map(my.treino.corpus, removeNumbers)
  my.treino.corpus <- tm_map(my.treino.corpus, stripWhitespace)
  
  matrix.treino.stm <- DocumentTermMatrix(my.treino.corpus)
  
  matrix.treino <- as.matrix(matrix.treino.stm)
  
  tfidf.matrix.treino = weightTfIdf(matrix.treino.stm)
  
  treino <-  tfidf.matrix.treino[1:646, ]
  
  teste1 <- tfidf.matrix.treino[647,]
  
  matriz.distancia1 <-  Distance_for_KNN_test(teste1, treino)
  
  proximos1 <- k.nearest.neighbors(1,matriz.distancia1, k=n)
  
  filmes.proximos1 <- c()
  
  for (j in 1:5){
    filmes.proximos1[j] <- file.names[proximos1[j]]
  }
  
  return(filmes.proximos1)
}