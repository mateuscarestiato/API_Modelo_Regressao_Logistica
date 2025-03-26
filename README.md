# API de Classificação de Flores (Setosa ou Versicolor)

Este projeto implementa uma API em R para classificar flores da espécie **setosa** ou **versicolor** utilizando um modelo de **regressão logística** treinado com o dataset **iris**.

## Desenvolvedores
- **Mateus Padilha**
- **Ian Esteves**

## Descrição
A API foi construída usando o pacote **Plumber** e é capaz de receber os seguintes parâmetros através de uma requisição GET:

- `Sepal.Length`: Comprimento da sépala
- `Sepal.Width`: Largura da sépala
- `Petal.Length`: Comprimento da pétala
- `Petal.Width`: Largura da pétala

Com esses parâmetros, a API faz uma previsão da classe da flor, retornando se a flor é da espécie **setosa** ou **versicolor**.
