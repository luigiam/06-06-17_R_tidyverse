
library("tidyverse")
#so ggplot2 is in the tidyverse library, along with other stuff

#C:/Users/LuigiAngelo/Documents/SoftwareCarpentry/06-06-17_R_tidyverse/
gapminder <- read_csv(file = "Data/gapminder-FiveYearData.csv")

gapminder
####VERY useful plotting stuff.. MUCH nicer than matlab

#aes is aesthetics... whats in aes indicates visual properties from the dataset (e.g. population, continent, etc)
#outside this is stuff NOT part of the data (e.g. color blue, size 5, etc)


#whats the difference with geom_point and geom_jitter?

#so anything inside of aes is a variable?

ggplot(data = gapminder) +                              #this just does a scatterplot
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp,)) #gdpPercap and lifeExp are variables in gapminder (setting to x and y axis)

#at this point, geom_point and geom_jitter do the same thing
ggplot(data = gapminder) +                               
  geom_jitter(mapping = aes(x = gdpPercap, y = lifeExp,
                            color= continent)) #continent is another variable: same as geom_point, but with colour representing different countries 

ggplot(data = gapminder) +                               
  geom_point(mapping = aes(x = log(gdpPercap), y = lifeExp,
                            color= continent, size =pop)) #pop is another variable, now countries (the dots) increase according to population size

ggplot(data = gapminder) +                               
  geom_point(mapping = aes(x = log(gdpPercap), y = lifeExp
                           ),alpha=0.1, size=2, color='blue') #alpha is transparency.

#so, the group assigns a variable that the data will be split into: e.g. country, so one line for every country
ggplot(data = gapminder) +                               
  geom_line(mapping = aes(x = year, y = lifeExp,
                           group=country, color= continent), size=2) #links observations with lines (like a "line graph")
#can put size, alpha (whatever) outside or insdie aes... outside should be for all, inside should be for a specific variable (?)
#there is definitely a difference, but not really sure I understand (size in aes makes everything bigger compared to outside)

ggplot(data = gapminder) +                               
  geom_boxplot(mapping = aes(x = continent, y = lifeExp))

#can combine several plots (the plus sign at end of geom_jitter is needed for this)
#the order of the plots matters - try!
ggplot(data = gapminder) +                              
  geom_jitter(mapping= aes(x = continent, y = lifeExp, color=continent))+
  geom_boxplot(mapping = aes(x = continent, y = lifeExp, color=continent))

#opposite of above -- now dots are on "top of" boxplots (I guess order determines layering:: foreground/background)
#the lower the layer, the more on the front (badly explained)
ggplot(data = gapminder) +                              
  geom_boxplot(mapping = aes(x = continent, y = lifeExp, color=continent))+
  geom_jitter(mapping= aes(x = continent, y = lifeExp, color=continent))

#so this is like the code two steps above, BUT more compact: since the paramaters of geom_jitter and geom_boxplot
#are the same, can do it this way
ggplot(data = gapminder,                               
       mapping= aes(x = continent, y = lifeExp, color=continent))+ #whatever is here will be the same for all "layers" (stuff below)
  geom_jitter()+
  geom_boxplot()
###########I can use this to illustrate synchronicity / metastability??

#so here, have some different paramaters for each layer
ggplot(data = gapminder,                               
       mapping= aes(x = log(gdpPercap), y = lifeExp, color=continent))+ 
  geom_jitter(alpha=0.5)+
  geom_smooth(method = "lm") #draws a line of bets fit for each country (because of the color=continent argument)
#if you just do geom_smooth() it will fit a non-linear model

#same as above, but will now draw one line of best fit, instead of one for each country -- but keeping colour for country
ggplot(data = gapminder,                               
       mapping= aes(x = log(gdpPercap), y = lifeExp))+ 
  geom_jitter(mapping=aes(color= continent), alpha=0.5)+
  geom_smooth(method = "lm")     
####can use this for something too????


#boxplot of life expectancy by year
#so as.character (or as.factor) turns a continous variable into categories (e.g. every year becomes a separate category)
ggplot(data = gapminder) +                              
  geom_boxplot(mapping = aes(x = as.character(year), y = lifeExp))

ggplot(data = gapminder) +                              
  geom_boxplot(mapping = aes(x = as.character(year), y = log(gdpPercap)))

#this is an "elevation map" --- shows clusters (??) and how many things are in one.. thing.. (or something)
ggplot(data = gapminder) +                              
  geom_density2d(mapping = aes(x = lifeExp, y = log(gdpPercap)))

#this makes a sublot for each continent (nice), i.e. what we put in the facet wrap
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()+
  geom_smooth()+
  scale_x_log10()+     #this transforms x axis with log (instead of doing log earlier in the code) #whats the benefit of this way?
  facet_wrap(~ continent) #~ separates ?? doesn't work without it
####can use this to split by group, cluster, whatever

#so lm = linear model (d'uh)

#faceting by year
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()+
  geom_smooth(method = "lm")+     #if you do NOT write method = "lm", it will fit a non-linear model (GOOD!!)
  scale_x_log10()+     
  facet_wrap(~ year)


#filtering to only a certain value (i.e. everything from 2007)
#e.g a snapshot 
#filter(gapminder, year==2007)

#R puts "count" in the y-axis (a default thingy)
ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping = aes(x=continent))

ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping = aes(x=continent, stat = "count")) #stat = "count" is implicit, so I don't have to write it (just to illustrate a point)


#filter(gapminder, year==2007, continent=="Oceania")

ggplot(data=filter(gapminder, year==2007, continent=="Oceania"))+
  geom_bar(mapping = aes(x=country, y=pop), stat= "identity") #stat= "identity" == take at face value (no transformation), i.e. no count

#for geom_col(), stat = "identity" is the default

ggplot(data=filter(gapminder, year==2007, continent=="Asia"))+
  geom_col(mapping = aes(x=country, y=pop))+
  coord_flip() #flips the graph (useful if labels are really long)



###DEFINITELY USE THIS!!!! VERY USEFUL
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, 
                                       color=continent, size=pop/10^6)) +
  geom_point()+
  scale_x_log10()+     
  facet_wrap(~ year)+
  labs(title="Life Expectancy vs. GDP/time",
       subtitle="In the last 50 years, life expectancy has improved in most countries of the world",
       caption="Source: Gapminder foundation, gapminder.com",
       x="GDP per capita, in 000USD",
       y ="Life expectancy in years",
       color="Continent",
       size="Population in millions") 
#subtitle is below title, caption is on the bottom
#nice, you can give labels to each of your variables, instead of having whatever is there from before


ggsave("my_fancy_plot.png") #saves plot: it remembers the last plot that was printed



