
###select, filter, mutate etc. are from diplyr (you don't have to load the library.. for some reason)
##other than using stuff from tidyverse, this illustrates how to use pipe in R, %>% 
library(tidyverse)
gapminder <- read_csv("Data/gapminder-FiveYearData.csv")

rep("This is an example",times=3)    #this and below lines does the same thing
"This is an example" %>% rep(times=3)    #so this is pipe in R... in bash, "|", in R, " %>% "

#if you do "ctrl + m" it writes %>% (very cool)"

#just picking out the variables you want
year_country_gdp <- select(gapminder,year,country,gdpPercap)  
head(year_country_gdp)  #like bash head I guess

year_country_gdp <- gapminder %>% 
  select(year,country,gdpPercap)
head(year_country_gdp)


gapminder %>%
  filter(year==2002) %>%
  ggplot(mapping = aes(x=continent,y=pop))+
  geom_boxplot()
  
###This is important: first i make a new variable, which then gets filtered, and then specific subvariables are attached to it (I guess
#you don't need to "assign" it again...)
year_country_gdp_euro <- gapminder %>%
  filter(continent=="Europe") %>%
  select(year,country,gdpPercap)
  
country_lifeExp_Norway <- gapminder %>% 
  filter(country=="Norway") %>% 
  select(year,lifeExp,gdpPercap)

#this is like the above code, but for all countries
#if you take away group_by, you just get one summary for absolutely everything
gapminder %>% 
  group_by(continent) %>% 
  summarize(mean_gdpPercap=mean(gdpPercap))

gapminder %>% 
  group_by(continent) %>% 
  summarize(mean_gdpPercap=mean(gdpPercap)) %>% 
  ggplot(mapping = aes(x=continent,y=mean_gdpPercap))+
  geom_point()

#average life expectancy per country in asia
#what has the highest life expectancy?
#this shows the minimum AND the maximum
gapminder %>% 
  filter(continent=="Asia") %>% 
  group_by(country) %>% 
  summarize(mean_lifeExp=mean(lifeExp)) %>%
  filter(mean_lifeExp==min(mean_lifeExp)|mean_lifeExp==max(mean_lifeExp))       #the "vertical bar" means "for" or "and" here (confusing...)

#does the same as the above, but you can "visually" see what has the highest life expectancy
gapminder %>% 
  filter(continent=="Asia") %>% 
  group_by(country) %>% 
  summarize(mean_lifeExp=mean(lifeExp)) %>%
  ggplot(mapping = aes(x=country,y=mean_lifeExp))+
  geom_point()+
  coord_flip()

#why do you need the function mutate to "transform" values? is it b/c every point?
gapminder %>%
  mutate(gdp_billion=gdpPercap*pop/10^9) %>% #transforms EVERY point in gdpPercap...
  group_by(continent,year) %>% 
  summarize(mean_gdp_billion=mean(gdp_billion))

gapminder_country_summary <- gapminder %>% 
  group_by(country) %>% 
  summarize(mean_lifeExp = mean(lifeExp))

library(maps)
#here, country is region... when trying to combine dataframes, variables should have the same name
#USA has a different name in gapminder vs. map_data, which means that the result for USA is not shown
map_data("world") %>% 
  rename(country=region) %>% 
  left_join(gapminder_country_summary, by="country") %>%  #what does this do? 
  ggplot()+
  geom_polygon(aes(x=long,y=lat,group=group, fill = mean_lifeExp))+
  scale_fill_gradient(low="blue",high="red")+
  coord_equal()
