
x <- 4 * 9
is.vector(x) #will say "TRUE" if it is a vector
##is. tab it, and will see what kind of question functions there are
length(x) #is this why I couldn't use ncols in some of the things I was doing before?
x[2] <- 56 #put value 56 in 2nd position in x
x

x[5] <- 44
x    #so since position 3 and 4 don't have anything, comes up as "NA" for them

x[11] #NA because we didn't assign anything

x[0] #says   numeric(0)     <-- I think this depends on what you are doing this on (string, dataframe, matrix... something something)
#important: R starts with 1


y <- x^2  #power of 2 for each element separately   (principle is called "vectorization") <---- apparently, some languages can't do this
y


##does that mean I could've done the normalization SHORTER in my R script?
z <- vector(mode = mode(x), length = length(x))
for(i in seq_along(x)) {
  z[i] <- x[i]^2
}
z                      #a way to do it if you can't vectorize

x <- 1:5  
y <- 3:7
x+y

z <-y[-5]  #removing (value in) position 5
x + z
#you CAN add them even though they don't have same dimension (but you will get a warning) --- it will just loop back when one of 
#them has less dimensions
#its called "recycling"... but.. uh.. not sure if it loops back (google?)


##recycling is necessary for vectorization to work

z^x #so that works too.. but with warning


#so doing anything with missing value (NA) results in a missing value (e.g. 3 + NA = NA    0 * NA = NA)




#c()  #this is called "coercion"
bla <- c("Hello", "workshop", "participants!")
bla[0] #now it sais character(0)
str(c("Hello", "workshop", "participants!")) #this means check the structure

c(9:11, 200, x) #x is vector x.. so just adds it

str(c("something", pi, 2:4, pi > 3)) #is a "character"       
#removing "something" makes it "numeric" b/c pi>3 is a logical statement (can be represented as 0 or 1)...
#so depending on vector type, pi > 3 will show either 1 or TRUE

#2L   4L          forces a value to be an integer

#you can have an "integer" type
#numeric means it can have decimals

w <- rnorm(10)     #picking  x random numbers in a normal distribution
seq_along(w) #shows the indexing sequence... 1 2 3 4 ... 10
which(w < 0) #cool.. saying you only want negative numbers (gives the positions of these)
w[w < 0] #gives you the VALUES that are less than 0
#w[which(w <0)] #the same as above
w < 0    #will say FALSE, TRUE where w < 0 for each element

w[-c(2, 5)] #removes position 2 and 5.. so 2 less

#if you want to have the "original" type for each point (e.g. "bla" 1) then you have to mae a list
str(list("something", pi, 2:4, pi > 3)) #will show what type each element (or groups of elements) are

#i.e. vectors, will become one type... lists can have several types

#can have character vector, numeric vector.. etc...
#vector =/= list

x<- list(vegetable = "cabbage",
     number = pi,
     series = 2:4,
     telling = pi > 3)
str(x)
x$vegetable   #only show vegetable
x[3] #will give you series, ALL of series

#[] returns it the same way it was (this is list.. becomes a list)
#$ will return it as a vector.. or something

#think of it as [] showing you something WITH the package
#and $ taking it OUT of the package



x<- list(vegetable = list("cabbage", "carrot", "spinach"), #list in a list
         number = list(c(pi, 0, 2.14, NA)), #list in a list containing a vector
         series = list(list(2:4, 3:5)), #why list list?
         telling = pi > 3)

str(x$vegetable)
str(x[1])


mod <- lm(lifeExp ~ gdpPercap, data=gapminder_plus)   #linear model.... y = lifeExp, x = gdpPercap (or other way round if I misunderstood...)
str(mod)
str(mod[["df.residual"]]) #returns the value of the variable "df.residual" in mod ##when putting double [[]], you unpackage it 
#str(mod[[8]]) #does the same thing.. since it is position 8


str(mod$qr$qr)

#mod$qr$qr[1] #first position in the final list qr
#mod$qr$qr[1,1] #since its two columns, value of row1xcolumn1

#summarize life expectancy for each continent
#in the background, it does a for loop for each continent..
gapminder_plus %>% group_by(continent) %>% 
  summarize(mean_life=mean(lifeExp),
            min_life=min(lifeExp),
            max_life=max(lifeExp))

#life expectancy by year for all countries (plot)
gapminder_plus %>% 
  ggplot()+
    geom_line(mapping = aes (x=year, y=lifeExp, color=continent, group=country))+ #if you don't do group=country, will have one line per continent connecting to each other (or something)
    facet_wrap(~ continent)+
    geom_smooth(method ="lm", color="black", mapping = aes (x=year, y=lifeExp))
#facet by continent

by_country <- gapminder_plus %>% group_by(continent, country) %>%  #if you don't add continent here, then it will NOT be in the subsequent data.frame
  nest()
#so this gives a datafrae, where every row is a continent x country containing a tibble within it (showing years for that specific country)

by_country$data[[1]]

#map(list, function)
map(1:3, sqrt)  

by_country

#library(purrr) #part of tidyverse..
by_country %>%                #on line below, you are doing a linear modle for each country (right?) that gets stored in dataframe
     mutate(newmodel=purrr::map(data, ~lm(lifeExp~year, data=.x))) %>%   #data (the first one) is the last column in the by_country dataframe
     mutate(summr=map(newmodel, broom::glance)) %>% 
     unnest(summr) %>% arrange(r.squared) %>% filter(r.squared<0.3) %>%    #r.squared came from "summr".... just arrange in numerical order
     select(country) %>% left_join(gapminder_plus) %>%  #adds it back to gapdminder_plus... 
     ggplot()+
       geom_line(mapping=aes(x=year, y=lifeExp, color=country, group=country))


#unnest(summr) #this "unrwaps" the summr stuff (separates each of the thingies from the summr sub-table) (so instead of just summr, you get sigma, t, p, blabla)
#model_by_country$summr[[1]] #shows the 1st pos in "summr" (which is summary of linear model) # ONLY if it has NOT been unnested



#lifeexp regressed on gdp
#gapminder_plus %>%  ggplot()+
#  geom_line(mapping=aes(x=log(gdpPercap), y=lifeExp, color=continent, group=country))

#mod <- lm(lifeExp ~ gdpPercap, data=gapminder_plus)
#basically looking at the outliers (right?)
yada <- by_country %>%                
  mutate(newmodel=purrr::map(data, ~lm(lifeExp~log(gdpPercap), data=.x))) %>%   
  mutate(summr=map(newmodel, broom::glance)) %>% 
  unnest(summr) %>% arrange(r.squared) %>% filter(r.squared<0.1) %>%    
  select(country) %>% left_join(gapminder_plus) %>%  
  ggplot()+
  geom_point(mapping=aes(x=log(gdpPercap), y=lifeExp, 
                        color=country))
saveRDS(yada, "plottingsuff.rds")

wakka <- readRDS("plottingsuff.rds") #onlyreadable in R

#from tidyverse
write_csv(gapminder_plus, "gapminder_plus_for_prof.csv")
