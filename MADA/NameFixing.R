#MAY NEED TO CHANGE /USED IN THE 
#pregit <- 'C:/Users/swulfing/Documents/GitHub/'
pregit <- 'C:/Users/SophieWulfing/Documents/GitHub/'

library(tidyverse)
library(readr)

setwd(paste0(pregit,'UMassD/MADA/2010-2022 Filled_vetted_separated_logbook catch data-20251230T162744Z-3-001/CleanedData'))

Salary <- read.csv('CPUEData_Salary.csv')

# Remove special characters
for(i in 1:ncol(Salary)){
  Salary[,i] <- iconv(Salary[,i], to = "UTF-8", sub = "byte")
}

Salary$Product.type <- toupper(Salary$Product.type)
Salary$Product.type <- trimws(Salary$Product.type)
# Remove special characters except spaces
Salary$Product.type <- gsub("[^[:alnum:] ]", "", Salary$Product.type)

NA_List <- c('ND' , '0' , 'n', 'NA')

for(i in 1:nrow(Salary)){
  if(Salary$Product.type[i] %in% NA_List){Salary$Product.type[i] <- NA}
    
}

Names_Anira <- read.csv(paste0(pregit,'UMassD/MADA/FishNames.csv'))

# TESTING QUOTE ISSUE
# Names_Anira <- read.csv('C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Desktop/New folder/FishNames.csv')

# Remove special characters except quotes and spaces
for(i in 1:ncol(Names_Anira)){
  Names_Anira[,i] <- iconv(Names_Anira[,i], to = "UTF-8", sub = "byte")
}

Names_Anira$In.data.examples <- gsub("[^,a-zA-Z\\s]" , "" , Names_Anira$In.data.examples, perl = TRUE)
Names_Anira$Possible.Local.Name <- gsub("[^,a-zA-Z\\s]" , "" , Names_Anira$Possible.Local.Name, perl = TRUE)

# Make rows per in data example entry
Names_Anira <- Names_Anira %>%
  separate_rows(In.data.examples, sep = ",\\s*") %>%
  filter(In.data.examples != "")  # drop empty strings from trailing commas, if any

# Make upper case, remove spaces before and after
Names_Anira$In.data.examples <- toupper(Names_Anira$In.data.examples)
Names_Anira$In.data.examples <- trimws(Names_Anira$In.data.examples)

Names_Anira$Possible.Local.Name <- toupper(Names_Anira$Possible.Local.Name)
Names_Anira$Possible.Local.Name <- trimws(Names_Anira$Possible.Local.Name)

#Species_names <- read.csv('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/LocalNames/Namelist.csv')

# Compile species names from folder
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

# # Each row, pull out the product.type
# for(i in 1:nrow(Salary)){
#   Name_first <- Salary$Product.type[i]
#   
# # Look for match in Anira's list. THERE WILL BE A PROBLEM HERE BECAUSE THINGS WEREN'T CARRIED OVER IN A STANDARD WAY. ADDRESS LATER
#   for(j in 1:nrow(Names_Anira)){
#     newlist <- Names_Anira$In.data.examples[j]
#  
# # If no local name was ID'd
#     if(is.na(newlist)){
#       # Check for a malagasy name and put into namelist
#       newlist <- Names_Anira$Word..MG.[j]
#       Salary$MalagasyName[i] <- newlist
#       
#       if(is.na(newlist)){
#         # If no malagasy name is found, we use the inglish group (if exists)
#         newlist <- Names_Anira$Word..ENG.[j]
#         Salary$EnglishName[i] <- newlist
#       }
#     } else if (Name_first %in% newlist){# | grepl(Name_first, newlist)){# If there is an ID, put in Anira's local name (this could have multiple!)    
#       Salary$LocalName[i] <- Names_Anira$Possible.Local.Name[j]
#     }
#   }
# }

Salary$LocalName    <- NA
Salary$MalagasyName <- NA
Salary$EnglishName  <- NA
Salary$ScientificName <- NA

for (i in 1:nrow(Salary)) {
  Name_first <- Salary$Product.type[i]
  if (is.na(Name_first)) next
  
  for (j in 1:nrow(Names_Anira)) {
    newlist <- Names_Anira$In.data.examples[j]
    
    if (is.na(newlist) || newlist == "") next  # skip rows with nothing to match
    
    if (Name_first == newlist) {   # EXACT match only, no grepl
      Salary$LocalName[i]    <- Names_Anira$Possible.Local.Name[j]
      Salary$MalagasyName[i] <- Names_Anira$Word..MG.[j]
      Salary$EnglishName[i]  <- Names_Anira$Word..ENG.[j]
      break                        # stop at first (and should be only) match
    }
  }
}

Salary$FinalName <- ifelse(!is.na(Salary$LocalName) & Salary$LocalName != "",
                           Salary$LocalName,
                           ifelse(!is.na(Salary$MalagasyName) & Salary$MalagasyName != "",
                                  Salary$MalagasyName, Salary$EnglishName))
datacheck <- Salary %>%
  filter(!is.na(LocalName)) %>%
  select(Product.type, LocalName, MalagasyName, EnglishName)


# Now dataset should have a local name if there was a match. We need to put in the sci name now
for(i in 1:nrow(Salary)){
  Name_standard <- Salary$LocalName[i]
  
  if(!is.na(Name_standard)){
    
    sciList <- c()
    
    # Find all local names with a match and make a list
    for(j in 1:nrow(Species_names)){
      if(Species_names$LocalName[j] %in% Name_standard | grepl(Species_names$LocalName[j], Name_standard)){
        sciList <- append(Species_names$SpeciesName[j], sciList)
        sciList <- unique(sciList) # This will need further cleaning as there are some misspellings
      }
    }
    
    # Add this list of sci names to Salary Data
    Salary$ScientificName[i] <- paste(sciList, collapse = ", ") #Species_names$SpeciesName[j]
  }}




















