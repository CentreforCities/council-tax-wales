*SCRIPT FOR MODELLING THE WELSH COUNCIL TAX ESTIMATES
		
	* It takes the normal price paid data, cleans it in a normal way, assigns modelled council tax bands after a hypothetical revaluation to each 2022 price. The data is here, but should be in the theme data: https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads 
	
	* It then assigns each price to a 1/1000th ranking within each local authority to generate a price curve for each local authority. This takes ages and should be done overnight.
	
	* This ranking is then exported to a csv and in the R script in this folder merged with a 1/1000th ranking of properties by 2003 council tax bands, aligning each price and its modelled 2022 CT band with a likely 2003 CT band

* 1. Clean the data
	
	* Updated Provisional 2022 data 
	local TimePrefix : display %tdCY-N-D td(`c(current_date)')
	ssc install egenmore
	import delimited "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Housing\Theme Data\House Prices\Processing\Price Paid CSVs\pp-2022.csv"

	*We are only looking at houses- Getting rid of commerical data 
	rename v5 category

	drop if category=="O"

	*Merging with England and Wales postcode data, available from the ONS Open Geography Portal

	rename v4 pcds
	rename v2 price

	merge m:1 pcds using  "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Core Data\Lookups\Postcodes\2023-12-05_Postcodes_England_Wales.dta"

	keep if ctry=="W92000004"
	
	drop pcd pcd2 ctry oa11cd rgn ttwa lsoa11 msoa11 wz11 bua11 lat longitude class

	keep if _merge==3
	drop if price==.

	*check to make sure there are no errors

	sort price
	
	drop if v1=="{E7B085FC-6B33-7E31-E053-6C04A8C0E67F}"
	drop if v1=="{EED73E76-9E45-6AF3-E053-6C04A8C08ABA}"
	drop if v1=="{F3B6C199-30B2-6E40-E053-6C04A8C0B3B4}"
	drop if v1=="{E53EDD2E-C305-83EC-E053-6B04A8C03A59}"
	drop if v1=="{FFA361DB-8404-8A03-E053-4804A8C01F61}"
	drop if v1=="{FFA361DB-7A1D-8A03-E053-4804A8C01F61}"


* 2. 2022 Council Tax Bands

	*Add in the estimates foe 2022 Council Tax Bandss (i.e. 1991 bands uniformly increased by 388%, plus the addition of A+ and I and J bands)

	gen ctband2 = "A" if price<95001
	replace ctband2 = "B" if price >95000 & price <140001
	replace ctband2 = "C" if price >140000 & price <200001
	replace ctband2 = "D" if price >200000 & price <265001
	replace ctband2 = "E" if price >265000 & price <350001
	replace ctband2 = "F" if price >350000 & price <480001
	replace ctband2 = "G" if price >480000 & price <700001
	replace ctband2 = "H" if price >700000 & price <915001
	replace ctband2 = "I" if price >915000 

	table ctband2

* 2.a Export as a collapsed output to build your initial analysis in Excel. Skip this bit if you have already done this.
	
	
	
	*gen n_=1
	
	*collapse (sum) n_, by (laua ctband2)

	
	 *export delimited using "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Blogs and Presentations\Blogs\2024\Data\2024-01-09_Wales_CT\2024-01-09_Council_Tax_Bands_2022_Share_Wales.csv", replace

	 
*2.b Match with 2003 data

	*Add percentiles for the cumulative ranking of each transaction (and thereby each price) by local authority, so we can assign 2003 Council Tax Bands (which are estimated cumulatively)

	egen quant=xtile(price), n(1000) by(laua)

	bysort quant laua (laua): gen percent1000 = price[_N]

	*export as a .dta file and use in R - merging this dataset with the Council Tax 2003 data requires R

	save "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Blogs and Presentations\Blogs\2024\Data\2024-01-09_Wales_CT\2024-01-02_pp2022_Wales.dta"

	clear 
* 3. Improt and collapse the joined 2003-2022-price estimates

	import delimited "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Devolution and Finance\English Devolution Deal\Data\Input\2024-01-11_Council_Tax_Bands_2003_2022_Wales.csv"

	gen n_=1

	collapse (sum) n_, by (lad11cd ctband2022 ctband1991 lad11nm)

	export excel using "C:\Users\\`=c(username)'\Centre for Cities\Centre For Cities POC - Documents\Research\Blogs and Presentations\Blogs\2024\Data\2024-01-15_Council_Tax_Bands_2002_2022_Collapse_Wales.xlsx", firstrow(variables) replace


 
 