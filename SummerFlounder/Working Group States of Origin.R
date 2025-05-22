setwd("C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Documents/GitHub/UMassD/SummerFlounder")

pplData <- read.csv("Fluke2024WorkingGroup.csv")
RDMData <- read.csv("FlukeRDM_Data.csv")

library(ggplot2)


# The following graphs are from the Summer Flounder Fishery Information Document from the Mod-Atlantic Fishery Management Council: https://static1.squarespace.com/static/511cdc7fe4b00307a2628ac6/t/668c660208b1a378bc4b312c/1720477187008/Fluke+AP+FPR+Info+Doc_2024.pdf
# Commercial only
plot(pplData$PercentQuota ~ pplData$WG_Reps)
text(pplData$WG_Reps, pplData$PercentQuota, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$NoDealersPerState ~ pplData$WG_)
text(pplData$WG_Reps, pplData$NoDealersPerState, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$TotalLandingsMajorCities ~ pplData$WG_Reps)
text(pplData$WG_Reps, pplData$TotalLandingsMajorCities, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$LandingsperVesselMajorCities ~ pplData$WG_Reps)
text(pplData$WG_Reps, pplData$LandingsperVesselMajorCities, labels=pplData$State, cex= 0.7, pos = 3)

# Recreational
# The following info is from: https://static1.squarespace.com/static/511cdc7fe4b00307a2628ac6/t/62fbf883d2b94a149e6b3892/1660680337803/fluke+RDM+overview+-+final+report.pdf

plot(pplData$RDM_harvest ~ pplData$WG_Reps)
text(pplData$WG_Reps, pplData$RDM_harvest, labels=pplData$State, cex= 0.7, pos = 3)


dev.off()
ggplot(RDMData, aes(x = Region, y = MRIP, fill = Type)) + 
  geom_bar(stat = "identity")

# From NOAA (I think overall quotas but each one is the same proportion of quota?)
# Site: https://www.fisheries.noaa.gov/bulletin/noaa-fisheries-approves-2023-summer-flounder-scup-and-black-sea-bass-specifications
# "Using baseline data from 1980 to 1989, the current plan allocates the summer flounder quota on a 55/45 percent basis to commercial and recreational fisheries, respectively." - https://asmfc.org/species/summer-flounder/

plot(pplData$NOAA_Quota ~ pplData$WG_Reps)
text(pplData$WG_Reps, pplData$NOAA_Quota, labels=pplData$State, cex= 0.7, pos = 3)















