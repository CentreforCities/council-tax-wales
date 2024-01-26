# council-tax-wales

 Modelling for the Centre for Cities' Welsh Council Tax briefing 

## Description

This repo contains the workbook and scripts used to develop the Centre for Cities model for council tax reforms in Wales in 2022.

This depends on price paid data, available here: https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads 

## Getting Started
### Dependencies

STATA, R, RStudio, Windows 10, Updated Postcode Lookup

Price paid data: https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads

Postcode lookup:https://geoportal.statistics.gov.uk/datasets/ons::national-statistics-postcode-lookup-2011-census-november-2023/about

### Understanding the Workbook


The modelling in this briefing takes the same methodology used to model council tax reform within In Place of Centralisation and adapts it to Welsh circumstances. In essence, the revenues raised by the current council tax system in 2022 are used to set the estimated revenues under a new system where, after revaluation, a hypothetical set of percentage-based tax rates for each council tax band and local authority.

The council tax bills for each band in each local authority in Wales in 2022 (including police precepts but excluding community council precepts) are multiplied by the number of homes in each band to generate an estimate of total revenues in 2022 under the current system.

For simplicity’s sake, the current council tax bands are kept and revalued by 315 per cent, which is how much house prices have increased in Wales by from 2003 to 2022. House price data from transactions is then used to generate an estimate of the number of homes within each Welsh local authority that fall into each revalued band.

The median house price within each band (with conservative estimates for Bands A and I) is then multiplied by the number of houses within each revalued band to estimate the total value of all Welsh residential property by band by local authority. A hypothetical set of percentage tax rates by band is then applied to each local authority to raise a near-equal amount of revenue to the current estimated revenue for council tax.

To estimate for how this then changes bills for households, the model needs to account for how revaluation changes the bands of individual dwellings. It therefore assumes that the current distribution of bands by local authority maps onto the current distribution of prices, such that if 15 per cent of dwellings in Swansea are currently in Band A, then the prices of the 15 per cent cheapest properties in Swansea are the prices of its Band A properties, and so on. 

These current bands are then joined to the revalued bands by price to generate an estimate for how many properties of each current band are in each revalued band. The change in bills is then calculated for each possible combination of current and revalued bands by local authority, which is then used to generate an estimate for how many households see their council tax bills rise and fall after revaluation in the new hypothetical revalued council tax structure.

Council tax reliefs (such as the single adult discount, exemptions for students, and the means tested council tax reduction scheme [CTRS]) are not explicitly taken into account in this model, but can be easily incorporated by policymakers, as discussed later in the paper.

### Understanding the Scripts

There are currently two scripts in this folder

* Wales Script - A STATA script that produces the 2022 revaluation, as well as the collapsed version of the join between 2003 and 2022 bands

* Council Tax Bands Assign - an R script that joins the 2003 bands to the 2022 bands


## Contributions

Any contributions you make are greatly appreciated. Please create a open an issue with the tag "enhancement" before opening a pull request.

