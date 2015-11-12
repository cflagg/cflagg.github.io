---
  title: "megapit_roots_code_transform"
author: "Cody Flagg"
date: "August 14, 2015"
output: pdf_document
---
  
  
  ### **NOTE:** This is an extract of sections 4 and 5, to speed up loading, processing, and knitting the key elements of the ATBD document. 
  
  ```{r set FilePath, echo=FALSE, message=FALSE}
#Set working directory and file paths
options(stringsAsFactors = FALSE) 

if (file.exists(
  '../Documents/GitHub/devTOS/megapit_roots/atbd/megapit_roots')){
  wdir<-'../Documents/GitHub/devTOS/megapit_roots/atbd/megapit_roots'
}

myPathToGraphics <- paste(wdir,'graphics', sep='/')
myPathToData <- paste(wdir,'data', sep='/')
myPathToCIFiles <- paste(myPathToData, 'CI_files', sep='/')

```

```{r libraries, echo=FALSE, message=FALSE}
# set global options
options(digits=4, prompt = ">>> ")

#load libraries
# call all necessary libaries
#if packages listed below are not installed, use install.packages("packageName") before running library(packageName)# 

library(knitr)
library(kfigr)
library(atbdLibrary)
library(plyr) # for rootBiomass and rootDensity calculations
library(dplyr) # for filtering and selection
library(stringr) # for fixing dates and pitIDs
library(tidyr) # for transforming data from wide to long

# install TeX program :  http://miktex.org/2.9/setup (Windows) ; http://tug.org/mactex/ (Mac)
# re-install, update miktex - datetime2 package (called here) was released 3/24/15, all older versions do not have this package pre-loaded.
# documentation for kfigr https://github.com/mkoohafkan/kfigr/blob/master/vignettes/introduction.Rmd

```

## 4.2 Summary of Algorithm

1. Generate __uid__
2. Check for and remove duplicate records (__dupCheckQF__)
3. Check that top and bottom depths are correct i.e. arranged in descending order (__depthCheckQF__)
* Check that no bottom depths exceed 200 cm i.e. the bottom of the pit (__pitDepthCheckQF__)
3. Calculate root biomass for each pitProfileID (__rootBiomass__) using algorithm described below 
4. Calculate root density per each soil depth (__rootDensity__) using algorithm described below
5. Join fields from FIU megapit characterization to records by pitID
* _Fields:_ rootsCollectedByA, rootsCollectedByB, decimalLatitude, decimalLongitude, coordinateUncertainty, elevation, pitDepth. 


## 5 ALGORITHM IMPLEMENTATION

* This is science-grade code, processing is not carried out by the cyberinfrastructure team. 

1. Load Data
2. Transform Data
3. "Seed Errors"
4. Quality Flags
5. Calculate Estimates
6. Export ingest and pub tables

## Steps to run for all 

```{r loadData, echo=FALSE}
# load data
# Personalize these dfs to your mod - the code below works off of example data
inFieldData <- read.csv(paste(myPathToData, 'soil_pit_biomass_cf.csv', sep='/'), stringsAsFactors=FALSE)

# FSU megapit sampling dates
# fieldDates <- read.csv(paste(myPathToData, 'pit_dates.csv', sep = '/'), stringsAsFactors = FALSE)

# View(fieldDates)
```




1. Compile FIU data for joining: dates, rootsCollectedBy, pitDepth




```{r join with FIU}
# munge dates into the NEON format
fieldDates$date <- paste("20", str_sub(fieldDates$dateExcel, start = -2, end = -1), str_sub(fieldDates$dateExcel, 1,2), str_sub(fieldDates$dateExcel, 4,5), sep = "")

# join to inFieldData by siteID
<<<<<<< HEAD
# select the original 14 columns from the FSU data, keep date, lat/long, eleveation, pitdepth, personnel and sampling dates from FIU data
# first strip domainID off the FSU siteID
inFieldData$domainID <- inFieldData$siteID # this is here to generate pitID below
inFieldData$siteID <- paste(str_sub(inFieldData$siteID, -4,-1)) 
fiu_data$siteID <- fiu_data$Site # generate column = siteID to match fiu_data to inFieldData
=======
  inFieldData <- left_join(x = inFieldData, y = fieldDates, by = "siteID") %>% select(-techs,-dateExcel, -FY2015, -FY2016, -dodobase, -Notes)
```
>>>>>>> origin/master

# join to inFieldData by siteID
# select the original 14 columns from the FSU data, keep date, lat/long, eleveation, pitdepth, personnel and sampling dates from FIU data
inFieldData <- plyr::join(x = inFieldData, y = fiu_data, by = "siteID", type = "left", match = "first") 

<<<<<<< HEAD
inFieldData <- select(inFieldData, 1:14, Soil.pit.digging.date, Latitude..decimal.degrees., Longitude..decimal.degrees., Elevation..m., Lat.Long.accuracy..m.,Pit.depth..cm., FSU.personnel.A, FSU.personnel.B, domainID)
```



=======
  >>>>>>> origin/master
```{r reshape to long, echo=FALSE}
# This is where the data get transposed to the "long" format
# Also, the two columns :sizeClass and plantStatus need to be created from the sizeStatus field
longData <- gather(inFieldData, sizeStatus, dryMass, fineRootLiveMass:coarseRootDeadMass)

# populate the sizeClass and plantStatus fields: 
# if the string has "fine" in it, make new column "sizeClass" == "fine"
longData$sizeClass <- ifelse(str_detect(longData$sizeStatus, "^fine")==TRUE, "fine", "coarse")

# if the string has "live" in it, make new column "plantStatus" == "live"
longData$plantStatus <- ifelse(str_detect(longData$sizeStatus, "Live")==TRUE,"live","dead")

# Create pitID -- then trim leading zeros
longData$pitID <- paste(str_sub(longData$domainID,2,3),"_",str_sub(longData$siteID, -4,-1),"_Pit1", sep="")
longData$pitID <- ifelse(str_sub(longData$pitID,1,1)==0, str_sub(longData$pitID,2,12),longData$pitID)

# Create sampleID
<<<<<<< HEAD
longData$sampleID <- paste(str_sub(longData$siteID, -4,-1), longData$pitProfileID,longData$topDepth,longData$plantStatus,longData$sizeClass ,sep=".")
```

1. Drop D10CPER for now (9/30/2015), these records are entered in a complex, inconsistent way

```{r}
longData <- filter(longData, siteID != "CPER")
```

=======
  longData$sampleID <- paste(str_sub(longData$siteID, -4,-1), longData$pitProfileID, longData$topDepth,longData$plantStatus,longData$sizeClass ,sep=".")


# regex shortcuts: 
# ^ = starts with; $ = ends with; [p] = contains the letter p; "pine" = contains phrase "pine"
```

>>>>>>> origin/master

1. Fix inconsistent string columns

```{r}


```


1. Standardize formatting of fields


```{r seedErrors, echo=FALSE, eval=FALSE}
# # Potential errors, however unlikely
# # three rows added: 
# 
# # duplicates error
# longData <- rbind(longData[1,],longData)
# 
# # introduce reversed depth values 
# longData <-rbind(longData[4,], longData)
# longData[1,3] <- 30 # switch the topDepth
# longData[1,4] <- 20 # switch the bottomDepth
# 
# # introduce incorrect bottomDepth value
# longData <- rbind(longData[15,], longData)
# longData[1,4] <- 203
```


## Processing Steps to Run

* This is science-grade code, processing is not carried out by the cyberinfrastructure team. 

1. Remove extraneous special characters from the __remarks__ field.

* Trim (i.e., remove all leading/trailing line ends, tabs, and spaces) in remarks field
* Replace all non-leading/trailing line ends and tabs in remarks field with a single space
* Replace any non-ASCII characters in remarks field with a single space
* Replace any instances of 2+ adjacent whitespace in remarks field with a single space


```{r remSpecial, echo=FALSE}
#Remove special characters (e.g., extra spaces) from fields with free text (remarks, others)
<<<<<<< HEAD
#pubData <- rem_specialChars(df = longData, cols=c('sampleMethod', 'orientation', 'remarks'))
=======
  pubData <- rem_specialChars(df = longData, cols=c('remarks'))
```
>>>>>>> origin/master

pubData <- longData
```

1. Remove Complete Duplicate Records.

* Remove extra copies of records that are complete duplicates (excluding __uid__ and __remarks__) from the input table. If all fields are complete duplicates except for the __remarks__ field, then remove all but one instance of the record. A quality flag field indicating duplication should be made for mpr_sampleIn and named "**duplicateSampleIDQF**". 

* If there are no duplicates of a record, `duplicateSampleIDQF` == 0
* If the record was not checked, `duplicateSampleIDQF` == -1
* If the record was duplicated, `duplicateSampleIDQF` == 1


```{r inputDupes, anchor = "dupeTableIn", echo=FALSE}
# show duplicate problem example
gen_exampleTable(pubData, 3,7, cols = c("siteID", "pitProfileID", "topDepth", "sizeClass","plantStatus", "dryMass"),cap="Input duplicate records, rows 1 & 2 are duplicates")
```


```{r duplicateCheck, echo=FALSE}
# remove imputed duplicate
pubData <-  rem_dups(pubData, colsToConcatenate =  c("remarks"), qfColName = "duplicateSampleIDQF")
```

```{r outputDupes, anchor = "dupeTableOut", echo=FALSE}
# generate example
gen_exampleTable(pubData, 3,7, cols = c("siteID", "pitProfileID", "topDepth", "sizeClass","plantStatus", "dryMass", "duplicateSampleIDQF"), cap="Output duplicate records check")
```

1. Check that the topDepth is less than the bottomDepth; create a column named `depthIncQF`. 
* If the topDepth is less than the bottom depth, `depthIncQF` == 0. 
* If the topDepth is greater than the top depth, `depthIncQF` == 1; return data to FSU for data checking. 


```{r inputDepthError, anchor = "depthIncQFTableIn", echo=FALSE}
gen_exampleTable(pubData, 2,6, cols = c("siteID", "pitProfileID", "topDepth","bottomDepth" , "dryMass"),cap="Input depth records, row 4 has a the bottom and top depths reversed")
```

```{r depthCheck, echo = FALSE, echo=FALSE}
# depth increment check, topDepth should always be less than bottomDepth
pubData$depthIncQF <- ifelse(pubData$topDepth < pubData$bottomDepth, 0,1) 
```

```{r inputDepthError2, anchor = "depthIncQFTableOut", echo=FALSE}
gen_exampleTable(pubData, 2,6, cols = c("siteID", "pitProfileID", "topDepth","bottomDepth" , "dryMass", "depthIncQF"),cap="The incorrect row has been flagged")
```

1. Check that bottomDepth does not exceed 200 cm; create a column named `pitdepthIncQF`
* If the bottomDepth is greater than 200 cm, `pitdepthIncQF` == 1.
* If the bottomDepth is less than or equal to 200 cm, `pitdepthIncQF` == 0

```{r pitDepthError, anchor = "depthIncQFTableIn", echo=FALSE}
gen_exampleTable(pubData, 1,5, cols = c("siteID", "pitProfileID", "topDepth","bottomDepth" , "dryMass"),cap="Row 1 has a bottom depth that exceeds 200 cm, indicating an error in data entry")
```

```{r pitDepthCheck, anchor = "pitdepthIncQFflag", echo=FALSE}
# if the bottom depth is greater than 200 cm, flag the record as sampling should not occur below 200 cm
pubData$pitdepthIncQF <- ifelse(pubData$bottomDepth > 200, 1, 0)
```

```{r pitDepthError2, anchor = "depthIncQFTableIn", echo=FALSE}
# pit depth flagging example
gen_exampleTable(pubData, 1,5, cols = c("siteID", "pitProfileID", "topDepth","bottomDepth" , "pitdepthIncQF"),cap="The record has been checked and flagged")
```



1. Check for NAs in dryMass

```{r}
table(is.na(pubData[,c("sampleArea","sampleVolume","dryMass")]))
```

1. Check for zeros in sampleArea and sampleVolume

```{r}
table(pubData[,c("sampleArea","sampleVolume")]==0)
```

1. Range test for dryMass, sampleArea, sampleVolume (non-zero)






1. Calculate total root biomass (i.e. dryMass/sampleArea) for each unique pitProfileID, sizeClass, and plantStatus combination e.g. for fine, live roots : 
  
  * Divide mg/cm^2 result by 100 to convert to kg/m^2 units 

```{r rootBiomassCalc_liveFine, echo=FALSE, message=FALSE,warning=FALSE}
# this outputs a data frame with 12 rows per siteID
# calculate rootBiomass: the sum of dryMass divided by sampleArea for each pitProfileID (i.e. one rootBiomass value per pitProfileID 
# per sizeClass per status)
<<<<<<< HEAD
# exception handling test - if there are NAs, zeroes, or blanks
pubData_perPit <- if (any(is.na(pubData$sampleArea))){
  # NAs generate more NAs as result
  print("There are NA values in the sampleArea field, please check the data. rootBiomass not calculated.")
}else if (any(pubData$sampleArea <= 0)){
  # zeroes generate "Inf" values as a result
  warning("There are zeroes in the sampleArea field (values should be non-zero). rootBiomass not calculated.")
}else if (any(pubData$sampleArea == " " | any(longData$sampleArea == ""))){
  warning("There are blank values in the sampleArea field. rootBiomass not calculated.")
  # carry out the operation if there are no NAs, zeroes, or blanks
}else{plyr::ddply(pubData, .(siteID, pitProfileID, sizeClass,plantStatus), transform, rootBiomass = signif(sum((dryMass/100)/newSampleArea)),3)}

## return only the unique combinations of siteID, pitProfileID, sizeClass, plantStatus
# nrow(unique(pubData_perPit[,c("siteID", "pitProfileID", "sizeClass","plantStatus", "rootBiomass")]))
pubData_perPit <- unique(pubData_perPit[,c("siteID", "pitProfileID","pitID" ,"sizeClass","plantStatus", "rootBiomass", "Latitude..decimal.degrees.", "Longitude..decimal.degrees.","Lat.Long.accuracy..m.","Soil.pit.digging.date","Pit.depth..cm.", "Elevation..m.","FSU.personnel.A","FSU.personnel.B","duplicateSampleIDQF")])


# generate the table
gen_exampleTable(pubData_perPit, 46,60, cols = c("siteID", "pitProfileID", "topDepth", "dryMass", "sampleArea","sizeClass", "plantStatus", "rootBiomass"),cap="Output table with calculated root biomass per pit profile; note that each row receives the same value, as it is the sum of all mass per status and size class within a pit profile ID.")
=======
  pubData <- plyr::ddply(pubData, .(siteID, pitProfileID, sizeClass,plantStatus), transform, rootBiomass = signif(sum((dryMass/100)/sampleArea)),3)

# generate the table
gen_exampleTable(pubData, 39,55, cols = c("siteID", "pitProfileID", "topDepth", "dryMass", "sampleArea","sizeClass", "plantStatus", "rootBiomass"),cap="Output table with calculated root biomass per pit profile; note that each row receives the same value, as it is the sum of all mass per status and size class within a pit profile ID.")
>>>>>>> origin/master
```

1. Calculate root density (i.e. drymass/sampleVolume) per depth increment e.g. (units = mg/cm^3)


```{r rootDensityCalc_liveFine, echo=FALSE, message=FALSE, warning=FALSE}
# calculate root density: drymass divided by sampleVolume for each depth increment per pitProfileID (i.e. one rootDensity value per depth value)
# per sizeClass per plantStatus
pubData <- plyr::ddply(pubData, .(siteID, pitProfileID, sizeClass, plantStatus), transform, rootDensity = signif((dryMass)/sampleVolume),5)

gen_exampleTable(pubData_perDepth, 42,54, cols = c("siteID", "pitProfileID", "topDepth", "dryMass", "sizeClass", "plantStatus", "sampleVolume", "rootDensity"),cap="Output table with root density calculated per depth increment.")
```



1. Check rootBiomass and rootDensity values for NAs or Inf

1. Split data into two tables, one per pit (rootBiomass) and one perDepthIncrement (rootDensity)

1. Spit out a unique value report to manually check for errors



```{r}
<<<<<<< HEAD
# This example takes the combined file above and splits it into separate files for each unique domainID
fileSuffix = as.character("perPit")
d_ply(pubData_perPit,.(siteID), function(input) 
  write.csv(input, file = paste0(myPathToCIFiles,"/",unique(input$siteID),"_",fileSuffix, ".csv", sep="")))
```

```{r}
## Cleaned Data - per depth increment - only pass selected columns
pubDataToCI_perDepth <- select(pubData_perDepth, siteID, pitID, sampleID, topDepth,bottomDepth, pitProfileID, plantStatus, sizeClass, sampleArea,sampleVolume, dryMass, rootDensity, duplicateSampleIDQF, remarks)

# This example takes the combined file above and splits it into separate files for each unique domainID
fileSuffix = as.character("perDepthIncrement")
d_ply(pubDataToCI_perDepth,.(siteID), function(input) 
  write.csv(input, file = paste0(myPathToCIFiles,"/",unique(input$siteID),"_",fileSuffix, ".csv", sep="")))
=======
  uniqueReport <- sapply(pubData, unique,1)
erer::write.list(uniqueReport, file = (paste(myPathToCIFiles, "megapit_roots_output_report.csv", sep ="/")), t.name = names(uniqueReport))
```

```{r outputPubTableEx, echo=FALSE}
# these are the fields we would provide to CI
# remove any row that has a one in a quality flag field that is NOT duplicates (as these are already removed)
pubDataToCI <- pubData %>% dplyr::filter(depthIncQF == 0, pitdepthIncQF == 0) %>% dplyr::select(domain, siteID, pitID, sampleID, topDepth,bottomDepth, pitProfileID, plantStatus, sizeClass, sampleArea,sampleVolume, dryMass, rootBiomass, rootDensity, duplicateSampleIDQF, depthIncQF, pitdepthIncQF) %>% dplyr::rename(status = plantStatus) 


## Cleaned Data - write to folder
write.csv(pubDataToCI, file =  paste(myPathToCIFiles, "megapit_roots_pub.csv", sep = "/"))

## Planted Errors Data
# write.csv(longData, file =  paste(myPathToCIFiles, "megapit_roots_errors.csv", sep = "/"))
>>>>>>> origin/master

```

1. Join FIU megapit soil characterization fields to megapit roots data by pitID for each row: 
  
  * from MGP.L1.decimalLatitude = MPR.L1.decimalLatitude
* from MGP.L1.decimalLongitude = MPR.L1.decimalLongitude
* from MGP.L1.coordinateUncertainty = MPR.L1.coordinateUncertainty
* from MGP.L1.elevation = MPR.L1.elevation





