#three formats for a data frame:
#tidy(?), wide, and long
#tidy... rows = observations, each colum = separate variable, first colun = ID or some identfieier --- this is what you want for R
#wide --- each row is a site/patient and multiple observation variables containing the same type of data (?) -- so if variable is money, another country, then its not wide...
#long --- one column for the observed variable and the other columns are different ID variables.. so only one column with ALL observations?






###this should've downloaded both files at the same time, but it isn't working: further below to do them separately
#download.file(url = c("http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0TAlJeCEzcGQ&output=xlsx", 
#                      "http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0NpF2PTov2Cw&output=xlsx"), 
#              destfile = c("Data/indicator undata total_fertility.xlsx", 
#                           "Data/indicator gapminder infant_mortality.xlsx"))



###there is a problem on windows.....
#had to manually download the first file from the gapminder.org/data/
#download.file(url = c("http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0TAlJeCEzcGQ&output=xlsx"), 
#              destfile = c("Data/indicator undata total_fertility.xlsx"))


#download.file(url = c("http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0NpF2PTov2Cw&output=xlsx"), 
#              destfile = c("Data/indicator gapminder infant_mortality.xlsx"))

#but R has an "in-built" function to read excel files
library("readxl")

raw_fert <- read_excel(path = "Data/indicator undata total_fertility.xlsx", sheet = "Data") #one column for each year (its in wide format)
raw_infantMort <- read_excel(path = "Data/indicator gapminder infant_mortality.xlsx")

gapminder

raw_fert

#I think I understand result, but don't get the "gather" part....
#so "fert" is just a label to specificy that is what the values are? (YES)
#how does it know what year is?? its not in the datafile?? writing something else for key messes it up
fert <- raw_fert %>%                            #had to use `` (backticks) b/c thats how it was in the raw file
  rename(country=`Total fertility rate`) %>%    #this is the row with all the different years that we want to make into one column
  gather(key=year, value=bla, -country) %>%   #key ....value is a label for the data values (so can be anything)-country means you don't want country (or something)
  mutate(year=as.integer(year))               #removing decimals


# GAPMINDER PLUS 
download.file(url = "https://raw.githubusercontent.com/dmi3kno/SWC-tidyverse/master/data/gapminder_plus.csv", 
              destfile = "Data/gapminder_plus.csv")

library("tidyverse")
gapminder_plus <- read_csv(file = "Data/gapminder_plus.csv")


####one gigantic line to plot something
####first of all, want a bunch values for countries that had over 2million babies dead in 2007
####and from this, plot fertility, gdp_bin, gdpPercap, infantMort, lifeExp and pop_min for these countries
gapminder_plus %>%
  filter(continent=="Africa", year==2007) %>% 
  mutate(babiesDead=infantMort*pop/1000) %>%     #1e3   e = number of 0s... so 1e3 1000, 1e4 10000
  filter(babiesDead>2e6) %>% 
  select(country) %>%   #picking out the variables you want
  left_join(gapminder_plus) %>% 
  mutate(babiesDead=infantMort*pop/10^3,   #without this, then babiesDead will ONLY be for 2007; now it will be for the year specified in data
         gdp_bln=gdpPercap*pop/1e9,
         pop_mln=pop/1e6) %>%  
  ####select(year) %>% 
  ####gather(key=variables, value=something) so instead of header = year, and cells below is the values for year, now one column called year, another with the actual values
  ##select(year, country) %>%  #one column for year, one column for country
  ##gather(key=variables, value=something) %>% View #in this case, one column IN TOTAL with all the years THEN country after
  select(-continent, -babiesDead, -pop) %>%  #removing these variables (don't want them in the plot)
# select(-c(continent, pop, babiesDead) #same as above line, but -c instead of - in front of everything
  gather(key= variables, value= values, -c(country, year)) %>%
#  ggplot(mapping = aes(x=year, y=values, color=country))+   #could've done this..... IF I want it for all layers
   ggplot()+
#  ggplot(data=.)+ # same as above # "." is a placeholder for %>%  i.e. what you have (or something)
     geom_text(data=. %>% filter(year==2007) group_by(variables) %>% 
               mutate(max_value=max(value)) %>% 
               filter(values==max(values)), #only want the maximum value of 2007
               aes(x=year, y=values, label=country, color=country))+
     geom_line(mapping = aes(x=year, y=values, color=country))+
     facet_wrap(~ variables, scales = "free_y")+ #scales = yadayada   free, fix, scales for specific subplots
     labs(title="Final Project",
        subtitle="07 June 2017",
        caption="sdf",
        y=NULL,
        x="Year")+
    theme_bw()+
    theme(legend.position = "none") #removes the legend
#so in ggplot, the ggplot(data=.) is passed on to every subsequent function -- but you COULD specifiy DIFFERENT inputs (right?)

#theme_yada is a plot scheme... so theme_dark, theme_grey --- write theme and see th elist
#theme()  can change stuff


#so can do -c(a b)  #takes away a and b, keeps everything else
#or c(c d e)  #KEEPS c d and variable e
        
#"View" is a way to see what you did in a spreadsheet
  
##so mutate is a way to transform a variable and create a NEW one
    
#YOU specify the names of key and value (can be anything)
#so the way it works is that key is a column SHOWING what variable it is (can be 1, 2, however many) and
#another column "value" which shows the value connected to that specific variable
#summarized: column value with a column explaining meaning of the value
#x and y datasets
#inner join will only merge things that are present in both (overlap)
# full join will merge everything --- so "new" variables will get new columns
#left join will merge overlap and x... in this case, x is the 6 countries, y is the gapminder_plus (something like that)
#right join will merge overlap and y ##not used that much

###so if I knew the countries, could do
#gapminder_plus %>% 
# filter(countr=="Dep.Prejb" | country=="Nigeria" | country=="sudan".... etc) 












