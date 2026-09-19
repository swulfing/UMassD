pregit <- 'C:/Users/SophieWulfing/Documents/GitHub/'

library(tidyverse)
library(readr)

setwd(paste0(pregit,'UMassD/MADA'))
      
FishNames <- read.csv('FishNames.csv')

# Remove special characters
for(i in 1:ncol(FishNames)){
  FishNames[,i] <- iconv(FishNames[,i], to = "UTF-8", sub = "byte")
}

FishNames$WORDS_INDATA <- gsub("[^,a-zA-Z\\s]" , "" , FishNames$WORDS_INDATA, perl = TRUE)
FishNames$LOCAL_ANIRA <- gsub("[^,a-zA-Z\\s]" , "" , FishNames$LOCAL_ANIRA, perl = TRUE)

# # Make rows per in data example entry
# FishNames <- FishNames %>%
#   separate_rows(WORDS_INDATA, sep = ",\\s*") %>%
#   filter(WORDS_INDATA != "")  # drop empty strings from trailing commas, if any

# Make upper case, remove spaces before and after
FishNames$WORDS_INDATA <- toupper(FishNames$WORDS_INDATA)
FishNames$WORDS_INDATA <- trimws(FishNames$WORDS_INDATA)

FishNames$LOCAL_ANIRA <- toupper(FishNames$LOCAL_ANIRA)
FishNames$LOCAL_ANIRA <- trimws(FishNames$LOCAL_ANIRA)


###### First compile the list of local names we have matched to species #####

locallist <- c()
specieslist <- c()

for(i in 1:7){
  dataset <- read.csv(paste0(pregit,'UMassD/MADA/LocalNames/LN',i,'.csv'))
  colnames(dataset)
  locallist <- append(locallist, dataset$LocalName) # SCIENTIFIC.NAME
  specieslist <- append(specieslist, dataset$ScientificName)
}

Species_names <- data.frame(
  LocalName = locallist,
  SpeciesName = specieslist
)

Species_names <- Species_names %>%
  mutate(across(everything(), ~ na_if(.x, ""))) %>%
  drop_na()

# Make rows per in data example entry
Species_names <- Species_names %>%
  separate_rows(LocalName, sep = ",\\s*") %>%
  filter(LocalName != "")  # drop empty strings from trailing commas, if any

# Make upper case, remove spaces before and after
Species_names$LocalName <- toupper(Species_names$LocalName)
Species_names$LocalName <- trimws(Species_names$LocalName)

Species_names$SpeciesName <- iconv(Species_names$SpeciesName, to = "UTF-8", sub = "byte")
Species_names$SpeciesName <- toupper(Species_names$SpeciesName)
Species_names$SpeciesName <- trimws(Species_names$SpeciesName)

##### MAKING DATASET FOR ID'D SPECIES ######

HAVES <- FishNames %>%
  filter(LOCAL_ANIRA != '' | NAME_OTHER != '') %>%
  select(WORDS_INDATA, NAME_OTHER, LOCAL_ANIRA)

HAVES$SCI_NAME <- NA

for(i in 1: nrow(HAVES)) {
  if(HAVES$LOCAL_ANIRA[i] != ''){
    # need to pull out the individual possibilities in local names
    localNames <- HAVES$LOCAL_ANIRA[i]
    localNamesList <- unlist(strsplit(localNames, split = ",")) # list of local names we've ID'd that apply to this grouping
    matchedNames <- c()
  
    for(j in 1:length(localNamesList))
      for(k in 1:nrow(Species_names)){
        if(localNamesList[j] == Species_names$LocalName[k]){
          matchedNames <- append(matchedNames, Species_names$SpeciesName[k])
        }
      
      }
    HAVES$SCI_NAME[i] <- paste(unique(matchedNames), collapse = ', ')

}}

write.csv(HAVES, 'Names_ID.csv')

##### MAKING DATASET FOR NON ID'D SPECIES ######

HAVENOTS <- FishNames %>%
  filter(LOCAL_ANIRA == '' & NAME_OTHER == '') %>%
  select(WORDS_INDATA, ENGLISH_SOPHIE, MALAGASY_SOPHIE, SOURCE, LOCAL_ANIRA, NAME_OTHER)

write.csv(HAVENOTS, 'Names_NOID.csv')












