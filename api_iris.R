# Carregar pacotes necessários
library(plumber)
library(caret)
library(jsonlite)

# Carregar o dataset iris
data("iris")

# Criar um modelo de regressão logística para classificar entre "versicolor" e "setosa"
iris_binario <- subset(iris, Species != "virginica") # Mantemos apenas duas classes
iris_binario$Species <- as.factor(ifelse(iris_binario$Species == "versicolor", 1, 0))

modelo_log <- train(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
                    data = iris_binario, 
                    method = "glm", 
                    family = "binomial")

# Salvar o modelo treinado para uso posterior
saveRDS(modelo_log, "modelo_logistico_iris.rds")

# Criar a API com Plumber
#* @apiTitle API de Classificação com Regressão Logística - Dataset Iris

#* Realiza a previsão da espécie com base nas características da flor
#* @param Sepal.Length O comprimento da sépala
#* @param Sepal.Width A largura da sépala
#* @param Petal.Length O comprimento da pétala
#* @param Petal.Width A largura da pétala
#* @get /prever
function(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) {
  
  # Converter os parâmetros de entrada para numérico
  Sepal.Length <- as.numeric(Sepal.Length)
  Sepal.Width <- as.numeric(Sepal.Width)
  Petal.Length <- as.numeric(Petal.Length)
  Petal.Width <- as.numeric(Petal.Width)
  
  # Verificar se os parâmetros são válidos
  if (any(is.na(c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)))) {
    return(list(error = "Parâmetros inválidos"))
  }
  
  # Carregar o modelo treinado
  modelo_log <- readRDS("modelo_logistico_iris.rds")
  
  # Criar o dataframe de entrada para previsão
  dados <- data.frame(Sepal.Length = Sepal.Length,
                      Sepal.Width = Sepal.Width,
                      Petal.Length = Petal.Length,
                      Petal.Width = Petal.Width)
  
  # Realizar a previsão
  prob <- predict(modelo_log, newdata = dados, type = "prob")[,2] # Probabilidade de ser "versicolor"
  classe_prevista <- ifelse(prob > 0.5, "versicolor", "setosa")
  
  # Retornar a previsão
  return(list(
    Sepal.Length = Sepal.Length,
    Sepal.Width = Sepal.Width,
    Petal.Length = Petal.Length,
    Petal.Width = Petal.Width,
    probabilidade_versicolor = prob,
    classe_prevista = classe_prevista
  ))
}

