###########################################
###    TECHNIKI WIZUALIZACJI DANYCH     ###
###           LABORATORIUM 5            ###
########################################### 

library(ggplot2)
library(dplyr)
library(SmarterPoland)


## Zadanie 1
# Zadania są zamieszczone w pliku .pdf w folderze lab5.
# Dane potrzebne do odtworzenia wizualizacji wczytujemy następująco:

df <- read.csv(file = "https://raw.githubusercontent.com/MI2-Education/2023Z-DataVisualizationTechniques/main/homeworks/hw1/house_data.csv", 
               encoding = "UTF-8")

df <- df %>% mutate(price_per_sq_ft = price/1000) %>% 
  mutate(area_cat = case_when(
    sqft_living<=2000 ~ '(0,2000]',
    sqft_living<=4000 ~ '(2000,4000]',
    sqft_living>4000 ~ '(4000,inf]',
  )) %>% mutate(price_in_k = price/1000)

p1 <- df %>% ggplot(aes(x = price_in_k, y = area_cat, col = as.factor(waterfront))) + 
  geom_boxplot(orientation = "y") + #, col = c("navyblue", "darkred")
  scale_y_discrete(labels=c(0, 3000, 5000)) +
  labs(  #Dopisywanie tytulow osi
    x = "Price [1k $]",
    y = "Living area [sqft]"
  ) + 
  scale_color_manual(values = c("darkred", "navyblue"))
  theme_bw() +
  theme(legend.position = "top") # Powinno byc ostatnim elem. dodanym do wykresu, bo nadpisuje def. theme
  
df
  


## Zadanie 2
# Posługując się danymi z *Zadania 1* należy odwzorować poniższy wykres.

p2 <- df %>% group_by(zipcode) %>% summarise(n = n()) %>% 
  filter(n > quantile(n, 0.95)) %>% 
  left_join(df) %>% 
  filter(yr_built == 2013 | yr_built == 2014, grade == 8 | grade == 9) %>% 
  ggplot(aes(x = as.factor(zipcode), y = price/1000)) + 
  geom_boxplot() +
  facet_grid(grade~yr_built) + # czy tylda przed czy po ma znaczenie - ktore na x ktore na y
  theme_bw() +
  theme(
    plot.subtitle = element_text(face = "italic"),
    strip.background = element_rect(fill = "navy"),
    strip.text =element_text(color = "white"),
    axis.title.x = element_text(size = 12)
  )



 ## patchwork

install.packages("patchwork")
install.packages("grid")
install.packages("gridExtra")


library(patchwork)

p1 + p2

p1/p2

(pi+p2)/p2

p1 + grid::textGrob("Jakis tekst")

(p1 + p2) & coord_flip()

## Zadanie 3
# Przygotuj tabelę z podsumowaniem ile nieruchomości znajduje się dla poszczególnych kodów pocztowych i lat z wykresu.

tab <- df %>% group_by(zipcode) %>% summarise(n = n()) %>% 
  filter(n > quantile(n, 0.95)) %>% 
  left_join(df) %>%  
  filter(yr_built == 2013 | yr_built == 2014, grade == 8 | grade == 9) %>% 
  group_by(zipcode, yr_built) %>%
  summarise(n = n()) %>% 
  tidyr::pivot_wider(names_from = "yr_built", values_from = "n") %>% 
  as.data.frame()

row.names(tab) <- tab$zipcode

p2 + gridExtra::tableGrob(tab[, c(2,3)]) / p1

## Zadanie 4
# Utwórz nową zmienną `is_renovated`, która będzie przyjmować wartość TRUE jeżeli była renowacja i FALSE gdy jej nie było. 
# Przygotuj wykres ukazujący rozkład piwerzchni mieszkanel dla domów w podziale na liczbę pięter i status renowacji.



p1

## Zadanie 5 - stworzyć wykres gęstości brzegowych:
# a) wykres punktowy dwóch wskaźników + kolor
# b) dodać po lewej rozkład zmiennej death.rate
# c) dodać na dole rozkład zmiennej birth.rate

library(SmarterPoland)
main_plot <- ggplot(data = countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

main_plot

density_birth <- ggplot(data = countries, aes(x = birth.rate, fill = continent)) +
  geom_density(alpha = 0.2)

density_birth

density_death <- ggplot(data = countries, aes(x = death.rate, fill = continent)) +
  geom_density(alpha = 0.2) +
  coord_flip() +
  scale_y_reverse() + 
  theme(legend.position = "none")

density_death

(density_death + main_plot) / (plot_spacer() + density_birth) +
  plot_layout(heights = c(0.7, 0.3),
              widths = c(0.3, 0.7),
              guides = "collect" # zbiera legende 
              )

## ggrepel
# https://ggrepel.slowkow.com/articles/examples.html

install.packages("ggrepel")

library(ggrepel)




## Zadanie 6
# Narysuj wykres punktowy zależności między wskaźnikiem urodzeń a wskaźnikiem śmierci 
# oraz podpisz punkty o najniższym i najwyższym wskaźniku śmiertelności (nazwą kraju).




