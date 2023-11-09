###########################################
###    TECHNIKI WIZUALIZACJI DANYCH     ###
###           LABORATORIUM 4            ###
###########################################


library(dplyr)
library(ggplot2)
library(SmarterPoland)

countries[countries$country == "Niue", ] # https://en.wikipedia.org/wiki/Niue
sum(countries$population) # `population` jest w tysiącach

## Zadanie 1
# 1. Ograniczyć zbiór krajów do tych, których nazwa jest krótsza niż 8 znaków (nchar).
# 2. Stworzyć zmienną logarytm populacji (*1000) 
#    i posortować względem niej poziomy zmiennej kraju (forcats::fct_reorder).
# 3. Zrobić wykres słupkowy pokazujący logarytm populacji w poszczególnych krajach 
#    i zaznaczyć kolorem kontynent (wykres poziomy).

countries %>% filter(nchar(country)<8) # 1.

countries_temp <- countries %>% filter(nchar(country)<8) %>% mutate(log = log(population*1000))

countries_temp %>% 
  ggplot(aes(log, country)) + 
  geom_col()

countries_temp %>% mutate(country = fct_reorder(country, log_populacji)) %>% 
  ggplot(aes(log, country, fill = continent)) + 
  geom_col()



### Skale (scale)

p_col <-  countries_temp %>% mutate(country = fct_reorder(country, log_populacji)) %>% ggplot(aes(log, country, fill = continent)) + 
  geom_col()
p_col + scale_y_discrete(position = "right", guide = guide_axis(n.dodge = 2, angle = -15))
?guide_axis()


## Osie (x & y) 
p_point <- ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()
p_point + scale_x_continuous(position = "top") + scale_y_continuous(expand = expansion(c(1, 0), c(0,1)))

p_point +
  scale_y_log10()

p_point +
  scale_y_sqrt()

p_point + 
  scale_y_reverse()

## Kolor (color & fill)
p_point + scale_color_manual(values = c("blue", "navy", "green", "pink", "#3182BD"))
p_point + scale_color_manual(values = c(Europe = "blue", Asia = "navy", "green", "pink", "#3182BD"))



# color brewer http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
# install.packages("RColorBrewer")
library(RColorBrewer)
RColorBrewer::brewer.pal(n = 5, name = "Blues")

ggplot(countries_temp, aes(log, death.rate, color = birth.rate)) +
  geom_point(size = 3) +
  scale_color_gradient(low = "lightblue", high = "red")

ggplot(countries_temp, aes(log, death.rate, color = birth.rate)) +
  geom_point(size = 3) +
  scale_color_gradient2(low = "lightblue",mid = "white", high = "red", midpoint = 30)


## Zadanie 2
# 1. Ograniczyć zbiór krajów, do tych z Azji i Europy (można wykorzystać dane z Zad1).
# 2. Policzyć stosunek współczynnika zgonów do współczynnika urodzeń.
# 3. Zrobić wykres słupkowy pokazujący logarytm populacji w poszczególnych krajach 
#    i zaznaczyć kolorem wskaźnik.

countries %>% filter(continent %in% c("Asia", "Europe")) %>% mutate(ratio = death.rate/birth.rate) %>% 
  ggplot(aes(population, country, color = ratio)) +
  geom_point(size = 3) +
  scale_color_gradient2(low = "red", high = "green", limits=c(0, 2)) -> p_temp


### Legenda (theme & legend)

p_temp +
  theme_dark()

p_temp +
  theme(legend.text = element_text(color = "red", face = "bold"))

### Koordynaty (coord)


# wykres kołowy (DANGER ZONE)
ggplot2::geom_pie()
tmp <- data.frame(table(countries$continent))
tmp
ggplot(tmp, aes(Freq, "", fill = Var1)) +
  geom_col() +
  coord_polar(start = 0)


## Zadanie 3
# 1. Stworzyć zmienną wielkość kraju, która przyjmuje K wartości w zależności
#    od podziału zmiennej populacji (np. K = 3, można wykorzystać dane z Zad1).
# 2. Zrobić wykres punktowy pokazujący zależność death.rate od birth.rate 
#    i zaznaczyć kolorem wielkość kraju.


### Panele (facet)
 

### How to plot? --->>> https://www.r-graph-gallery.com
