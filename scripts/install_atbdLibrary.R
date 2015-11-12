# update atbdLibrary
library(devtools)

# #install_github("NEONInc/devTOS",
#                subdir="atbdLibrary",
#                auth_user="cflagg",
#                auth_token = "8bb50ead577face7e6648c3103a66960670c47d7")

## will install local version of library
devtools::install("C:/Users/cflagg/Documents/GitHub/devTOS/atbdLibrary")

# ## Grab libraries from old library folder, ife
# myPath <- 'C:/Users/cflagg/Documents/R/win-library/3.2'
# 
# for (i in list.files(myPath)){
#   fileToCheck <- paste('C:/Program Files/R/R-3.2.1/library',i,sep='/')
#   #print (fileToCheck)
#   if (file.exists(fileToCheck)){
#     print (paste (i, ' is already in the library', sep=''))
#   }else{
#     install.packages(i)
#   }
# }
# 

library(atbdLibrary)

example(flag_inconsistent)
example(flag_dups)
example(flag_incomplete)
example(flag_outOfOrder)
example("gen_concatenatedVal")
example("gen_exampleTable")
example("gen_fuzzedTaxonIDs") # fails -- loop fails at if (status %in% c("STATE","FEDERAL")) [not fixed]
example("gen_incrementedVal")
example("gen_newSciNameAndIDQFlag") # fails -- df$taxonRank[i] fails [not fixed]
example("gen_outputFiles") # fails -- deprecated [not fixed]
example("gen_taxonInfo")
example("rem_allButGreatest") # fails -- extra closing parenthesis [fixed]
example("rem_dups") # fails -- missing comma and parentheses for c() [fixed]
example(rem_specialChars) # fails -- field that does not exist referenced (trapID) [fixed]
example("rem_TandE") # fails -- taxoNIDs do not match between data [not fixed]


flag_inconsistent(mam_field,cols=c("sex","tagID","taxonID"), key = "sex")

rem_dups(bet_field, colsToConcatenate=c('remarks'),colsToIgnore='uid',qfColName='duplicateSitePlotTrapDateQF')
rem_specialChars(df=mam_field,cols=c('tagID','recordedBy','remarks'))
rem_TandE(df=bet_pinning, taxonTable=bet_taxTable)
rem_allButGreatest(mam_field,cols=c('plotID','trapID','collectDate'),
                   orderBy='trapsSet')
gen_newSciNameAndIDQFlag(df = bet_pinning, taxonTable = bet_taxTable)

gen_fuzzedTaxonIDs(df = bet_pinning, taxonTable = bet_taxTable)
