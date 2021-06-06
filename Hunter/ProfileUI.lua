--############################
--##### TRIP'S HUNTER UI #####
--############################

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
    DateTime = "v1.0.1 (06.06.2021)",
    -- Class settings
    [2] = {        
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
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
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
			{ -- PET HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PvE STUFF ><><><l ",
                    },
                },
            },
			{
				{
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Bestial Wrath", value = 1 },
						{ text = "Rapid Fire", value = 2 },
						{ text = "Racial (Orc/Troll)", value = 3 },
                    },
                    MULT = true,
                    DB = "CDController",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                    }, 
                    L = { 
                        ANY = "Cooldown Selection",
                    }, 
                    TT = { 
                        ANY = "Choose which cooldowns you want to use during burst!", 
                    }, 
                    M = {},
                },			
				{ -- AutoSyncCDs
                    E = "Checkbox", 
                    DB = "AutoSyncCDs",
                    DBV = false,
                    L = { 
                        ANY = "Automatically Sync CDs", 
                    }, 
                    TT = { 
                        ANY = "Check this box to automatically use your cooldowns during Bloodlust/Heroism/Drums (I strongly suggest you only turn this on during raid bosses).", 
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
				{ -- FreezingTrapPvE
                    E = "Checkbox", 
                    DB = "FreezingTrapPvE",
                    DBV = true,
                    L = { 
                        ANY = "Freezing Trap Aggro", 
                    }, 
                    TT = { 
                        ANY = "Drop a Freezing Trap if you have aggro on an enemy in melee and in combat with multiple enemies.", 
                    }, 
                    M = {},
                },
				{ -- FreezingTrapPvE
                    E = "Checkbox", 
                    DB = "ProtectFreeze",
                    DBV = true,
                    L = { 
                        ANY = "Untarget Frozen", 
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets if accidentally targeting an enemy with Freezing Trap (only when in combat with mulitple enemies, make sure you're facing the other enemy you want to target).", 
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
				{ -- ConcussiveShotPvE
                    E = "Checkbox", 
                    DB = "ConcussiveShotPvE",
                    DBV = true,
                    L = { 
                        ANY = "Concussive Shot Aggro", 
                    }, 
                    TT = { 
                        ANY = "Use Concussive Shot to slow target if aggro swaps to you.", 
                    }, 
                    M = {},
                },	
				{ -- IntimidatePvE
                    E = "Checkbox", 
                    DB = "IntimidationPvE",
                    DBV = true,
                    L = { 
                        ANY = "Intimidation Aggro", 
                    }, 
                    TT = { 
                        ANY = "Use Intimidation to stun/taunt target if aggro swaps to you.", 
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
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Hawk", value = 1 },
						{ text = "Cheetah", value = 2 },
						{ text = "Viper", value = 3 },
                    },
                    MULT = true,
                    DB = "AspectController",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                    }, 
                    L = { 
                        ANY = "Automatic Aspects",
                    }, 
                    TT = { 
                        ANY = "Automatically use Aspects", 
                    }, 
                    M = {},
                },
			},			
			{
                { -- Mana Viper
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ManaViperStart",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Viper Aspect Mana Start(%)",
                    },
                    TT = { 
                        ANY = "Value (%) to turn on Aspect of the Viper. )", 
                    },                     
                    M = {},
                },	
                { -- Mana Viper
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ManaViperEnd",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Viper Aspect Mana End(%)",
                    },
                    TT = { 
                        ANY = "Value (%) to turn off Aspect of the Viper.)", 
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
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ManaSave",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Save Mana (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to not spend mana (will still use emergency abilities, however.)", 
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
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Rapid Fire", value = "RapidFire" },
						{ text = "Misdirection", value = "Misdirection" },
                    },
                    DB = "ReadinessController",
                    DBV = "RapidFire",
                    L = { 
                        ANY = "Readiness Usage",
                    }, 
                    TT = { 
                        ANY = "Pick the ability that you want to use with Readiness (40 points Survival)", 
                    }, 
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },			
			{ -- PET HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET CARE ><><><l ",
                    },
                },
            },
			{
                { -- MEND PET
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "MendPet",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(13543) .. " HP(%)",
                    },
                    TT = { 
                        ANY = "Set your pet HP % for using " .. GetSpellInfo(13543), 
                    },                     
                    M = {},
                },
			},			
		},
}