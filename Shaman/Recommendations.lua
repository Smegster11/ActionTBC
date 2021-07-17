--#############################################
--##### TRIP'S TBC SHAMAN RECOMMENDATIONS #####
--#############################################

local _G, select, setmetatable                            = _G, select, setmetatable

local TMW                                                 = _G.TMW

local A                                                 = _G.Action

--local Unit                                                = A.Unit
local GameLocale                                        = A.FormatGameLocale(_G.GetLocale())
local StdUi                                                = A.StdUi
local math_random                                        = math.random


WindfuryActive = {
["Windfury Totem"] = true,
["Windfury Totem II"] = true,
["Windfury Totem III"] = true,
["Windfury Totem VI"] = true,
["Windfury Totem V"] = true,
}

FireNovaActive = {
["Fire Nova Totem"] = true,
["Fire Nova Totem II"] = true,
["Fire Nova Totem III"] = true,
["Fire Nova Totem IV"] = true,
["Fire Nova Totem V"] = true,
["Fire Nova Totem VI"] = true,
["Fire Nova Totem VII"] = true,
} 

StoneclawActive = {
["Stoneclaw Totem"] = true,
["Stoneclaw Totem II"] = true,
["Stoneclaw Totem III"] = true,
["Stoneclaw Totem IV"] = true,
["Stoneclaw Totem V"] = true,
["Stoneclaw Totem VI"] = true,
} 

FireResistanceActive = {
["Fire Resistance Totem"] = true,
["Fire Resistance Totem II"] = true,
["Fire Resistance Totem III"] = true,
} 

FrostResistanceActive = {
["Frost Resistance Totem"] = true,
["Frost Resistance Totem II"] = true,
["Frost Resistance Totem III"] = true,
} 

NatureResistanceActive = {
["Nature Resistance Totem"] = true,
["Nature Resistance Totem II"] = true,
["Nature Resistance Totem III"] = true,
} 

StoneskinActive = {
["Stoneskin Totem"] = true,
["Stoneskin Totem II"] = true,
["Stoneskin Totem III"] = true,
["Stoneskin Totem IV"] = true,
["Stoneskin Totem V"] = true,
["Stoneskin Totem VI"] = true,
} 

WindwallActive = {
["Windwall Totem"] = true,
["Windwall Totem II"] = true,
["Windwall Totem III"] = true,
} 
		

EarthbindRecommendation = {

}

StoneclawRecommendation = {

}

FireResistanceRecommendation = {

}

FrostResistanceRecommendation = {
[17991] = true, -- Rockmar the Crackler
}

GroundingRecommendation = {
[18835] = true, -- Kiggler the Crazed in High King fight, block Lightning Bolt (spellID 36152)
[35325] = true,
}

NatureResistanceRecommendation = {

}

StoneskinRecommendation = {

}

WindwallRecommendation = {

}

DiseaseCleansingRecommendation = {
[17817] = true, -- Greater Bogstrok
[17816] = true, -- Bogstrok
}

HealingStreamRecommendation = {

}

PoisonCleansingRecommendation = {
[17942] = true, -- Quagmirran
}

TremorRecommendation = {
[18831] = true, -- High King Maulgar when below 50% HP.
[21350] = true, -- Gronn-Priest, Gruul's Lair trash mob
[17225] = true, -- Nightbane, Karazhan - Bellowing Roar (spellID 36922)
[21128] = true, -- Coilfang Ray
[17957] = true, -- Coilfang Champion
}

FireElementalRecommendation = {

}

EarthElementalRecommendation = {

}
