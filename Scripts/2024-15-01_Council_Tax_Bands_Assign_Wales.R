
library(tidyverse)

getwd()
data_folder <- "C://Users/a.breach/Centre for Cities/Centre For Cities POC - Documents/Research/Devolution and Finance/English Devolution Deal/Data/Input"

#import CT data - a cumulative ranking of how many of each 1991 band take up an ascending share of housing stock

council_tax <- read_csv(file.path(data_folder, "2024-01-11_Bands_1991_Percentiles_Wales.csv")) %>%
  select(ladn11nm = ladnm11, lad11cd = ladcd11, ctband1991 = ctband1991, highest_price_quant = percent1000) %>%
  group_by(lad11cd) %>%
  mutate(tax_band_rank = 1:n())

#import pp data - a cumulative ranking of each transaction by price within each local authority, with 2022 bands already assigned 
#this should already have been collapsed into the OG stata script

  
houses <- haven::read_dta(file.path(data_folder, "2024-01-02_pp2022_Wales.dta")) %>%
  select(price, lad11cd = laua, lad11nm, ttwahs11la_cfc, ttwahs11ca_cfc, ctband2022 = ctband2, price_quantile = quant) %>%
  mutate(house_id = 1:n()) 

#join the two data sets - for each transaction, assign it the ct data 2003 band according to its ranking of prices. 
#this makes it possible to see what prices and ct band 2022 today correspond to the ct band 2003 

joined_ct_quantiles <- left_join(houses, council_tax, by = "lad11cd") %>%
  filter(price_quantile < highest_price_quant) %>%
  group_by(house_id) %>%
  filter(tax_band_rank == min(tax_band_rank)) %>%
  select(house_id, lad11cd, lad11nm, ttwahs11la_cfc, ttwahs11ca_cfc, price, price_quantile, ctband2022, ctband1991, highest_price_quant)

#0.2% of properties not alinging - add more decimal points into the quant script??
#quant script may need to be rewritten to genereate percentiles based upon the LAD rather than TTWA-HS

write.csv(joined_ct_quantiles, "C://Users/a.breach/Centre for Cities/Centre For Cities POC - Documents/Research/Devolution and Finance/English Devolution Deal/Data/Input/2024-01-11_Council_Tax_Bands_2003_2022_Wales.csv", row.names=FALSE)

#reimport back into the OG stata script (I know, ideally these would all be one script in R etc etc)