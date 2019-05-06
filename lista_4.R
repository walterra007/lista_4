## Exercícios Lista 4

# 1. Com o RStudio, para o desenvolvimento da lista 4 crie um projeto com versionamento no GitHub.
  #Apresente o link do repositório do projeto como resposta ao exercício. Nele, deverá constar o script de
  #entrega da lista.

# https://github.com/walterra007/lista_4/blob/master/lista_4.R

# 2. O Secretário de Educação do Estado de Pernambuco deseja saber se há correlação entre o número de
  #alunos por docente nos municípios do Estado e o IDH-M. Utilize as bases de dados do Censo Escolar de
  #2016 e do PNUD (com dados de 2010) em sua resposta. Para que o resultado seja aceitável, cumpra os
  #seguintes requisitos:
  
  # • Use a função read_xlsx do pacote readxl para carregar os dados do PNUD;

setwd("c:/dados/dados_encontro_2_ufpe")
# carregando arquivos CENSO ESCOLAR 2016
load("matricula_pe_censo_escolar_2016.RData")
load("docentes_pe_censo_escolar_2016.RData")
load("turmas_pe_censo_escolar_2016.RData")
load("escolas_pe_censo_escolar_2016.RData")


  # • Não deve haver docente com mais de 70 anos ou com menos de 18 anos;
  # • Não deve haver aluno com mais de 25 anos ou com menos de 1 ano;
  # • Apresente estatísticas descritivas do número de alunos por docente nos municípios do Estado;
  # • Apresente o município com maior número de alunos por docente e seu IDHM;
  # • Faça o teste do coeficiente de correlação linear de pearson e apresente sua resposta;
  # • Seu script deve salvar a base de dados criada para o cálculo em formato .RData;

# 3. Usando o pacote ggplot2, apresente o gráfico de dispersão entre as duas variáveis (número de alunos por docente e IDHM).
  