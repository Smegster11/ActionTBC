--############################
--##### TRIP'S SHAMAN UI #####
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
    DateTime = "v0.5.0 (16 June 2021)",
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
			{
				{ -- SPEC CONTROLLER
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Enhancement", value = "Enhancement" },
						{ text = "Elemental", value = "Elemental" },
						{ text = "Restoration", value = "Restoration" },	
						{ text = "AUTO", value = "AUTO" },						
                    },
                    DB = "SpecOverride",
                    DBV = "AUTO",
                    L = { 
                        ANY = "Shaman Spec Override",
                    }, 
                    TT = { 
                        ANY = "Pick what spec you're playing (AUTO will choose the spec you have invested the most talent points in).", 
                    }, 
                    M = {},
                },	
				{ -- SHIELD CONTROLLER
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Water Shield", value = "Water" },
						{ text = "Lightning Shield", value = "Lightning" },							
                    },
                    DB = "ShieldType",
                    DBV = "Water",
                    L = { 
                        ANY = "Elemental Shield",
                    }, 
                    TT = { 
                        ANY = "Pick what Elemental Shield to keep up on yourself.", 
                    }, 
                    M = {},
                },					
			},            
			{
				{ -- RECOVERY POTION CONTROLLER
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Healing Potion", value = "HealingPotion" },
						{ text = "Mana Potion", value = "ManaPotion" },
						{ text = "Rejuvenation Potion", value = "RejuvenationPotion" },							
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
                { -- HP Potion
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "PotionHealth",
                    DBV = 20,
                    ONOFF = false,
                    L = { 
                        ANY = "HP (%) for Health Potion",
                    },
                    TT = { 
                        ANY = "HP (%) to use Health Potion.", 
                    },                     
                    M = {},
                },	
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
                        ANY = "Mana (%) to use Mana Potion.", 
                    },                     
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
			{ -- TOTEM CONTROLLER HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< TOTEM CONTROLLER ><><><l ",
                    },
                },
            },	
			{ -- TOTEM CONTROLLER LABEL
                {
                    E = "Label",
                    L = {
                        ANY = "These dropdown boxes will set your default totem for each element. Sometimes other totems will be used automatically in reaction to what's happening. Tick the checkbox to add even more reaction totems such as Poison Cleansing and Disease Cleansing (if you think a reaction is missing, please be sure to let me know in Discord as it's possible I don't have it in the list).",
                    },
                },
            },
			{
				{ -- AOE
                    E = "Checkbox", 
                    DB = "ReactionTotem",
                    DBV = true,
                    L = { 
                        ANY = "Use Reaction Totems", 
                    }, 
                    TT = { 
                        ANY = "Use reaction totems such as Poison Cleansing and Disease Cleansing.", 
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
				{ -- FIRE TOTEM
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "AUTO", value = "AUTO" },						
						{ text = "Searing", value = "Searing" },
						{ text = "Fire Nova", value = "FireNova" },
						{ text = "Frost Resistance", value = "FrostResistance" },
						{ text = "Magma", value = "Magma" },
						{ text = "Flametongue", value = "Flametongue" },
						{ text = "None", value = "None" },						
                    },
                    DB = "FireTotem",
                    DBV = "AUTO",
                    L = { 
                        ANY = "Fire Totem",
                    }, 
                    TT = { 
                        ANY = "Pick what Fire Totem you would like to prioritise.", 
                    }, 
                    M = {},
                },
				{ -- EARTH TOTEM
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "AUTO", value = "AUTO" },						
						{ text = "Stoneskin", value = "Stoneskin" },
						{ text = "Earthbind", value = "Earthbind" },
						{ text = "Stoneclaw", value = "Stoneclaw" },
						{ text = "Strength of Earth", value = "StrengthofEarth" },
						{ text = "Tremor", value = "Stoneclaw" },
						{ text = "None", value = "None" },						
                    },
                    DB = "EarthTotem",
                    DBV = "AUTO",
                    L = { 
                        ANY = "Earth Totem",
                    }, 
                    TT = { 
                        ANY = "Pick what Earth Totem you would like to prioritise.", 
                    }, 
                    M = {},
                },				
			},
			{
				{ -- AIR TOTEM
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "AUTO", value = "AUTO" },						
						{ text = "Grounding", value = "Grounding" },
						{ text = "Nature Resistance", value = "NatureResistance" },
						{ text = "Windfury", value = "Windfury" },
						{ text = "Windwall", value = "Windwall" },
						{ text = "Grace of Air", value = "GraceofAir" },
						{ text = "Tranquil Air", value = "TranquilAir" },
						{ text = "Wrath of Air", value = "WrathofAir" },						
						{ text = "None", value = "None" },							
                    },
                    DB = "AirTotem",
                    DBV = "AUTO",
                    L = { 
                        ANY = "Air Totem",
                    }, 
                    TT = { 
                        ANY = "Pick what Air Totem you would like to prioritise.", 
                    }, 
                    M = {},
                },
				{ -- WATER TOTEM
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "AUTO", value = "AUTO" },						
						{ text = "Healing Stream", value = "HealingStream" },
						{ text = "Poison Cleansing", value = "PoisonCleansing" },
						{ text = "Mana Spring", value = "ManaSpring" },
						{ text = "Disease Cleansing", value = "DiseaseCleansing" },
						{ text = "Fire Resistance", value = "FireResistance" },						
						{ text = "None", value = "None" },						
                    },
                    DB = "WaterTotem",
                    DBV = "AUTO",
                    L = { 
                        ANY = "Water Totem",
                    }, 
                    TT = { 
                        ANY = "Pick what Water Totem you would like to prioritise.", 
                    }, 
                    M = {},
                },					
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },			
			{ -- PVE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< ENHANCEMENT SHAMAN ><><><l ",
                    },
                },
            },
			{
				{ -- Main Hand Enchant
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Windfury", value = "Windfury" },						
						{ text = "Flametongue Weapon", value = "FlametongueWeapon" },						
                    },
                    DB = "MainHandEnchant",
                    DBV = "Windfury",
                    L = { 
                        ANY = "Main Hand Enchant (NOT YET WORKING)",
                    }, 
                    TT = { 
                        ANY = "Main Hand Enchant (NOT YET WORKING)", 
                    }, 
                    M = {},
                },
				{ -- Offhand Enchant
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Windfury", value = "Windfury" },						
						{ text = "Flametongue Weapon", value = "FlametongueWeapon" },						
                    },
                    DB = "OffhandEnchant",
                    DBV = "Windfury",
                    L = { 
                        ANY = "Offhand Enchant (NOT YET WORKING)",
                    }, 
                    TT = { 
                        ANY = "Offhand Enchant (NOT YET WORKING)", 
                    }, 
                    M = {},
                },				
			},			
			{
                { -- Shamanistic Rage Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ShamanisticRageMana",
                    DBV = 50, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Shamanistic Rage Mana (%)",
                    },
                    TT = { 
                        ANY = "Value mana (%) to use Shamanistic Rage", 
                    },                     
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{ -- PVE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< RESTORATION SHAMAN ><><><l ",
                    },
                },
            },
			{
                { -- Lesser Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "LesserHealingWaveHP",
                    DBV = 80, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Lesser Healing Wave (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Lesser Healing Wave.", 
                    },                     
                    M = {},
                },
                { -- Healing Wave Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "HealingWaveHP",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Healing Wave (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Healing Wave.", 
                    },                     
                    M = {},
                },				
			},			
			{
                { -- Chain Heal Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ChainHealHP",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Chain Heal (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to use Chain Heal.", 
                    },                     
                    M = {},
                },
                { -- Chain Heal Targets
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 3,                            
                    DB = "ChainHealTargets",
                    DBV = 2, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Chain Heal Targets",
                    },
                    TT = { 
                        ANY = "Number of targets to use Chain Heal.", 
                    },                     
                    M = {},
                },				
			},
			{
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ManaSave",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
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
		},
}