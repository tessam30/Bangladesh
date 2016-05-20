
# Import in the water modules for Bangladesh PBS --------------------------


library(llamar)
loadPkgs()

modR = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/036_mod_r_male.CSV')


water = modR %>% 
  select(hhID = a01, latrine = r01,
         drinkingSource = r05, AsTested = r07,
         AsContamin = r08, stillUse = r09)
