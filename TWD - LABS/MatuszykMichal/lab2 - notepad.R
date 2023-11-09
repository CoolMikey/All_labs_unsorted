###########################################
###    TECHNIKI WIZUALIZACJI DANYCH     ###
###           LABORATORIUM 2            ###
###########################################

library(dplyr) # https://dplyr.tidyverse.org/

# Dane
starwars
starwars_new <- starwars[, c(1, 2, 3, 4, 5, 7, 8)]

# Informacje o zbiorze danych
str(starwars_new) # Structure
?data.frame


# Podgląd tabeli
head(starwars)

# Określamy typy zmiennych:
# name - jakościowa, nominalna
# height - ilościowa, ilorazowa
# mass - ilościowa, ilorazowa
# hair_color - jakościowa, nominalna (nieuporządkowana)
# skin_color - jakościowa, nominalna
# birth_year - ilościowa, przedziałowa
# sex - jakościowa, binarna (przypadek nominalnej)

# 1) Wybór wierszy i kolumn w dplyr


# a) wybór kolumn ---> select()
?select
select(starwars, name) # wybieramy z dataset starwars kolumne name
select(starwars, name, gender)
select(starwars, -name, -hair_color) # wybiera wszystko poza name 
select(starwars, -c(name, hair_color, gender))
wybrane_kolumny <- c("name", "hair_color")
select(starwars, all_of(wybrane_kolumny))
?all_of
select(starwars, 1:4)
all_of() # wymagamy, aby kazda kolumna byla

# b) wybór wierszy ---> filter()
filter(starwars, eye_color == "blue" & hair_color == "none")

# 2) pipes %>% (skrót Ctrl + Shift + m)
# alt-minus - stawia strzałkę do przypisania
starwars %>% filter(eye_color = "blue") 



# Zadanie 1
# Używając funkcji z pakietu dplyr() wybierz te postacie, których gatunek to Droid, 
# a ich wysokość jest większa niż 100.

starwars %>% select(species == "droid", height > 100)

# Zadanie 2 
# Używając funkcji z pakietu dplyr() wybierz te postacie, które nie mają określonego koloru włosów.
starwars %>% filter(is.na(hair_color))

# c) sortowanie wierszy ---> arrange()


# Zadanie 3
# Używając funkcji z pakietu dplyr() wybierz postać o największej masie.
starwars %>% top_n(1, mass)

# d) transformacja zmiennych ---> mutate()
starwars %>% mutate(height_m = height/100) %>% head(1) %>% select(13:15)



# e) transformacja zmiennych ---> transmute()
starwars %>% transmute(height_m = height/100, height_km = height_m/1000)


# Zadanie 4
# Używając funkcji z pakietu dplyr() wylicz wskaźnik BMI (kg/m^2) i wskaż postać, która ma największy wskaźnik.
starwars %>% mutate(bmi = mass/(height^2)) %>% top_n(1, bmi) %>% select(name, height, mass, bmi)

# f) kolejność kolumn ---> relocate()


# g) dyskretyzacja ---> ifelse(), case_when()


# h) funkcje agregujące ---> summarise(), n(), mean, median, min, max, sum, sd, quantile


# i) grupowanie ---> group_by() + summarise()


# 3) Przekształcenie ramki danych w tidyr
library(tidyr) # https://tidyr.tidyverse.org

# j) pivot_longer()

?relig_income

# k) pivot_wider()

?fish_encounters

# 4) Praca z faktorami (szczególnie w wizualizacji)
library(forcats) # https://forcats.tidyverse.org
library(ggplot2) # https://ggplot2.tidyverse.org


# l) kolejność poziomów ---> fct_infreq()


# m) scalanie poziomów ---> fct_lump()


# n) kolejność poziomów na podstawie innej zmiennej ---> fct_reorder()


# 4) Praca z stringami
# Zaawansowane: https://stringi.gagolewski.com
library(stringr) # https://stringr.tidyverse.org

x <- paste0(letters[1:5], "=", 1:5, "__", letters[6:10], "=", 6:10)

# o) podział stringów ---> str_split()


# p) usunięcie/zastąpienie znaków ---> str_remove(), str_replace()


# 5) https://www.tidyverse.org/packages
# Bezpieczne wczytywanie danych w R https://readr.tidyverse.org
