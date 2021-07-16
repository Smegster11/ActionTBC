--#################################
--##### INTRODUCTION DRUID UI #####
--#################################

local TMW											= TMW 
local CNDT											= TMW.CNDT
local Env											= CNDT.Env

local A												= Action
local GetToggle										= A.GetToggle
local InterruptIsValid								= A.InterruptIsValid

local UnitCooldown									= A.UnitCooldown
local Unit											= A.Unit 
local Player										= A.Player 
local Pet											= A.Pet
local LoC											= A.LossOfControl
local MultiUnits									= A.MultiUnits
local EnemyTeam										= A.EnemyTeam
local FriendlyTeam									= A.FriendlyTeam
local TeamCache										= A.TeamCache
local InstanceInfo									= A.InstanceInfo
local select, setmetatable							= select, setmetatable

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v0.1.0",
    -- Class settings
    [2] = {        
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " -----[ GENERAL ]----- ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },             
				{ -- AOE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {},
                },
				{ -- AOE
                    E = "Checkbox", 
                    DB = "PowerShifting",
                    DBV = false,
                    L = { 
                        ANY = "Powershift Cat", 
                    }, 
                    TT = { 
						ANY = "Powershift for Feral DPS",
                    }, 
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },            
			{
				{ -- RECOVERY POTION CONTROLLER
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Healing Potion", value = "HealingPotion" },
						{ text = "Mana Potion", value = "ManaPotion" },
						{ text = "Haste Potion", value = "HastePotion" },						
                    },
                    DB = "PotionController",
                    DBV = "HealingPotion",
                    L = { 
                        ANY = "Potion Usage",
                    }, 
                    TT = { 
                        ANY = "Pick what potion you would like to use. Sliders for HP/MP.", 
                    }, 
                    M = {},
                },						
			},
			{
                {
                    E = "Label",
                    L = {
                        ANY = "Use Healthstone|Healing Potion slider on page 1 for Healing Potion.",
                    },
                },				
                { -- Healthstone
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "HSHealth",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "HP (%) for HealthStone",
                    },
                    TT = { 
                        ANY = "HP (%) to use HealthStone", 
                    },                     
                    M = {},
                },				
			},
			{
                { -- Mana Potion
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "PotionMana",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Mana (%) for Mana Potion",
                    },
                    TT = { 
                        ANY = "Mana (%) to use Mana Potion", 
                    },                     
                    M = {},
                },			
                { -- Demonic Rune
                    E = "Slider",                                                     
                    MIN = 100, 
                    MAX = 100,                            
                    DB = "Runes",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Mana (%) for Demonic Rune",
                    },
                    TT = { 
                        ANY = "Mana (%) for Demonic Rune (THIS HAS BEEN TEMPORARILY FROZEN TO AUTO DUE TO CODING REASONS. THIS WILL BE USED AT 20% MANA).", 
                    },                     
                    M = {},
                },					
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 			
			{
                {
                    E = "Header",
                    L = {
                        ANY = " Rejuvenation ",
                    },
                },
            },            
            {
                { -- Rejuvenation 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RejuvenationHP",
                    DBV = 90,  
                    ONOFF = false,
                    L = { 
                        ANY = "Max Rank (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Max Rank Rejuvenation", 
                    },                     
                    M = {},
                },
            },
            { -- PVE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " Regrowth ",
                    },
                },
            },            
            {
                { -- Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Regrowth4",
                    DBV = 70, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Rank 4 (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Regrowth Rank 4", 
                    },                     
                    M = {},
                },	
                { -- Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Regrowth7",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Rank 7 (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Regrowth Rank 7.", 
                    },                     
                    M = {},
                },
                { -- Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Regrowth9",
                    DBV = 50, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Rank 9 (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Regrowth Rank 9.", 
                    },                     
                    M = {},
                },
                { -- Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RegrowthMax",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Max Rank (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Regrowth Max Rank.", 
                    },                     
                    M = {},
                },
			},
            {
                { -- Trinket 1
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Health", value = "Health" },  
                        { text = "Mana", value = "Mana" },                                                 
                    },
                    DB = "Trinket1Choice",
                    DBV = "Health",
                    L = { 
                        ANY = "Trinket 1 Usage",
                    }, 
                    TT = { 
                        ANY = "Health will trigger on target's HP, Mana will trigger on player mana (%)", 
                    }, 
                    M = {},
                },
                { -- 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Trinket1Value",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Trinket 1 Value",
                    },
                    TT = { 
                        ANY = "(%) to trigger Trinket 1", 
                    },                     
                    M = {},
                },                 
            },
            {
                { -- Trinket 2
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Health", value = "Health" },  
                        { text = "Mana", value = "Mana" },                                                 
                    },
                    DB = "Trinket2Choice",
                    DBV = "Health",
                    L = { 
                        ANY = "Trinket 2 Usage",
                    }, 
                    TT = { 
                        ANY = "Health will trigger on target's HP, Mana will trigger on player mana (%)", 
                    }, 
                    M = {},
                },
                { -- 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Trinket2Value",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Trinket 2 Value",
                    },
                    TT = { 
                        ANY = "(%) to trigger Trinket 2", 
                    },                     
                    M = {},
                },                
            },                                         
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
		},
}