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

# definindo diretório
setwd("/dados/dados_encontro_2_ufpe")

# carregando arquivos CENSO ESCOLAR 2016
load("matricula_pe_censo_escolar_2016.RData")
load("docentes_pe_censo_escolar_2016.RData")
load("turmas_pe_censo_escolar_2016.RData")
load("escolas_pe_censo_escolar_2016.RData")

# carregando dados PNUD
if(require(tidyverse) == F) install.packages('tidyverse'); require(tidyverse)
if(require(readxl) == F) install.packages('readxl'); require(readxl)

setwd("/dados/")
pnud <- read_excel("atlas2013_dadosbrutos_pt.xlsx", sheet = 2)
head(pnud)
unique(pnud$ANO)

# selecionando dados de 2010 e do Estado de Pernambuco
pnud_pe_2010 <- pnud %>% filter(ANO == 2010 & UF == 26)
rm(pnud) # removendo base pnud

  # • Não deve haver docente com mais de 70 anos ou com menos de 18 anos;
  # • Não deve haver aluno com mais de 25 anos ou com menos de 1 ano;

# Processando bases de dados do CENSO ESCOLAR conforme enunciado e adicionando 
# outras variáveis

# Turmas
turmas_pe_sel <- turmas_pe %>% group_by(CO_MUNICIPIO) %>%
  summarise(n_turmas = n(), 
            turmas_disc_prof = sum(IN_DISC_PROFISSIONALIZANTE, na.rm = T),
            turmas_disc_inf = sum(IN_DISC_INFORMATICA_COMPUTACAO, na.rm = T),
            turmas_disc_mat = sum(IN_DISC_MATEMATICA, na.rm = T),
            turmas_disc_pt = sum(IN_DISC_LINGUA_PORTUGUESA, na.rm = T),
            turmas_disc_en = sum(IN_DISC_LINGUA_INGLES, na.rm = T))

# verificacao
dim(turmas_pe_sel)[1] == length(unique(turmas_pe$CO_MUNICIPIO))
summary(turmas_pe_sel)

# Escolas
escolas_pe_sel <- escolas_pe %>% group_by(CO_MUNICIPIO) %>%
  summarise(n_escolas = n(), 
            n_escolas_priv = sum(TP_DEPENDENCIA == 4, na.rm = T),
            escolas_func = sum(TP_SITUACAO_FUNCIONAMENTO == 1, na.rm = T),
            escolas_agua_inex = sum(IN_AGUA_INEXISTENTE, na.rm = T),
            escolas_energia_inex = sum(IN_ENERGIA_INEXISTENTE, na.rm = T),
            escolas_esgoto_inex = sum(IN_ESGOTO_INEXISTENTE, na.rm = T),
            escolas_internet = sum(IN_INTERNET, na.rm = T),
            escolas_alimentacao = sum(IN_ALIMENTACAO, na.rm = T))

# verificacao
dim(escolas_pe_sel)[1] == length(unique(escolas_pe$CO_MUNICIPIO))
summary(escolas_pe_sel)

# Docentes
docentes_pe_sel <- docentes_pe %>% group_by(CO_MUNICIPIO) %>%
  summarise(n_docentes = n(), 
            docentes_media_idade = mean(NU_IDADE),
            docentes_fem_sx = sum(TP_SEXO == 2, na.rm = T),
            docentes_superior = sum(TP_ESCOLARIDADE == 4, na.rm = T),
            docentes_contrato = sum(TP_TIPO_CONTRATACAO %in% c(1, 4), na.rm = T))

docentes_pe_sel <- docentes_pe %>% filter(NU_IDADE>17, NU_IDADE<71)

# verificacao
dim(docentes_pe_sel)[1] == length(unique(docentes_pe$CO_MUNICIPIO))
summary(docentes_pe_sel)

# Matriculas
matriculas_pe_sel <- matricula_pe %>% group_by(CO_MUNICIPIO) %>%
  summarise(n_matriculas = n(), 
            alunos_media_idade = mean(NU_IDADE),
            alunos_fem_sx = sum(TP_SEXO == 2, na.rm = T),
            alunos_negros = sum(TP_COR_RACA %in% c(2, 3), na.rm = T),
            alunos_indigenas = sum(TP_COR_RACA == 5, na.rm = T),
            alunos_cor_nd = sum(TP_COR_RACA == 0, na.rm = T),
            matriculas_educ_inf = sum(TP_ETAPA_ENSINO %in% c(1, 2), na.rm = T),
            matriculas_educ_fund = sum(TP_ETAPA_ENSINO %in% c(4:21, 41), na.rm = T),
            matriculas_educ_medio = sum(TP_ETAPA_ENSINO %in% c(25:38), na.rm = T))

matriculas_pe_sel <- matriculas_pe %>% filter(NU_IDADE>0, NU_IDADE<26)

# verificacao
dim(matriculas_pe_sel)[1] == length(unique(matricula_pe$CO_MUNICIPIO))
summary(matriculas_pe_sel)

# UNINDO BASES CENSO E PNUD

# turmas
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(turmas_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(turmas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# escolas
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(escolas_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(escolas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# docentes
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(docentes_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(docentes_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# matriculas
censo_pnud_pe_sel <- pnud_pe_2010 %>% full_join(matriculas_pe_sel, 
                                                by = c("Codmun7" = "CO_MUNICIPIO"))
dim(pnud_pe_2010)
dim(matriculas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# UNINDO BASES CENSO E PNUD

# turmas
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(turmas_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(turmas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# escolas
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(escolas_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(escolas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# docentes
censo_pnud_pe_sel <- censo_pnud_pe_sel %>% full_join(docentes_pe_sel, 
                                                     by = c("Codmun7" = "CO_MUNICIPIO"))
dim(docentes_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# matriculas
censo_pnud_pe_sel <- pnud_pe_2010 %>% full_join(matriculas_pe_sel, 
                                                by = c("Codmun7" = "CO_MUNICIPIO"))
dim(pnud_pe_2010)
dim(matriculas_pe_sel)
dim(censo_pnud_pe_sel)
names(censo_pnud_pe_sel)

# salvando nova base
setwd("/dados")
save(censo_pnud_pe_sel, file = "2016_censo_pnud_pe_sel.RData")
write.csv2(censo_pnud_pe_sel, file = "2016_censo_pnud_pe_sel.csv",
           row.names = F)

rm(list = ls())  # limpando area de trabalho

# carregando nova base
setwd("/dados")
load("2016_censo_pnud_pe_sel.RData")


  # • Apresente estatísticas descritivas do número de alunos por docente nos municípios do Estado;
  # • Apresente o município com maior número de alunos por docente e seu IDHM;
  # • Faça o teste do coeficiente de correlação linear de pearson e apresente sua resposta;
  # • Seu script deve salvar a base de dados criada para o cálculo em formato .RData;

# 3. Usando o pacote ggplot2, apresente o gráfico de dispersão entre as duas variáveis (número de alunos por docente e IDHM).
