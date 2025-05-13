setwd("C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Documents/GitHub/UMassD/SummerFlounder")

pplData <- read.csv("Fluke2024WorkingGroup.csv")

plot(pplData$PercentQuota ~ pplData$CouncilReps)
text(pplData$CouncilReps, pplData$PercentQuota, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$NoDealersPerState ~ pplData$CouncilReps)
text(pplData$CouncilReps, pplData$NoDealersPerState, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$TotalLandingsMajorCities ~ pplData$CouncilReps)
text(pplData$CouncilReps, pplData$TotalLandingsMajorCities, labels=pplData$State, cex= 0.7, pos = 3)

plot(pplData$LandingsperVesselMajorCities ~ pplData$CouncilReps)
text(pplData$CouncilReps, pplData$LandingsperVesselMajorCities, labels=pplData$State, cex= 0.7, pos = 3)
