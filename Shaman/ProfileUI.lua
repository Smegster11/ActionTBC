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
    DateTime = "v0.8.7 (29 June 2021)",
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
				{ -- Weave WF
                    E = "Checkbox", 
                    DB = "WeaponSync",
                    DBV = false,
                    L = { 
                        ANY = "Weapon Sync", 
                    }, 
                    TT = { 
                        ANY = "Attempt to sync your weapon swing timers to make the most out of flurry procs (might not work correctly with fast weapons)", 
                    }, 
                    M = {},
                },	
				{ -- Shock Interrupt
                    E = "Checkbox", 
                    DB = "ShockInterrupt",
                    DBV = false,
                    L = { 
                        ANY = "Save Shocks for Interrupts", 
                    }, 
                    TT = { 
                        ANY = "Save your shock CD for interrupts only.", 
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
                        ANY = " -----[ TOTEM CONTROLLER ]----- ",
                    },
                },
            },	
			{
				{ -- ReactionTotem
                    E = "Checkbox", 
                    DB = "ReactionTotem",
                    DBV = true,
                    L = { 
                        ANY = "Use Reaction Totems", 
                    }, 
                    TT = { 
                        ANY = "Use reaction totems such as Poison Cleansing and Disease Cleansing (CURRENTLY IN DEVELOPMENT).", 
                    }, 
                    M = {},
                },
				{ -- Weave WF
                    E = "Checkbox", 
                    DB = "WeaveWF",
                    DBV = false,
                    L = { 
                        ANY = "Weave Windfury Totem", 
                    }, 
                    TT = { 
                        ANY = "Weave Windfury Totem with your chosen Air Totem from the dropdown.", 
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
						{ text = "Totem of Wrath", value = "TotemofWrath" },						
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
						{ text = "Tremor", value = "Tremor" },
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
			{
				{ -- Main Hand Enchant
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Windfury", value = "Windfury" },	
						{ text = "Rockbiter", value = "Rockbiter" },						
						{ text = "Flametongue", value = "Flametongue" },
						{ text = "Frostbrand", value = "Frostbrand" },
						{ text = "None", value = "None" },						
                    },
                    DB = "MainHandEnchant",
                    DBV = "None",
                    L = { 
                        ANY = "Main Hand Enchant",
                    }, 
                    TT = { 
                        ANY = "Main Hand Enchant", 
                    }, 
                    M = {},
                },
				{ -- Offhand Enchant
                    E = "Dropdown",                                                         
                    OT = {
						{ text = "Windfury", value = "Windfury" },	
						{ text = "Rockbiter", value = "Rockbiter" },						
						{ text = "Flametongue", value = "Flametongue" },
						{ text = "Frostbrand", value = "Frostbrand" },
						{ text = "None", value = "None" },							
                    },
                    DB = "OffhandEnchant",
                    DBV = "None",
                    L = { 
                        ANY = "Offhand Enchant",
                    }, 
                    TT = { 
                        ANY = "Offhand Enchant", 
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
                        ANY = " -----[ ENHANCEMENT SHAMAN ]----- ",
                    },
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
			{
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "StopTwistingManaEnh",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Twisting at Mana (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to stop totem twisting while Shamanistic Rage is on CD/not active.", 
                    },                     
                    M = {},
                },
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "StopShocksManaEnh",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Shocks at Mana (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to stop using shocks while Shamanistic Rage is on CD/not active.", 
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
                        ANY = " -----[ ELEMENTAL SHAMAN ]----- ",
                    },
                },
            },
			{
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "StopShocksManaEle",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Shocks at Mana (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to stop using shocks.", 
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
                        ANY = " -----[ RESTORATION SHAMAN ]----- ",
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
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },  
		},
}