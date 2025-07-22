--############################
--##### SMEG'S SHAMAN UI #####
--############################

local TMW                     = TMW
local CNDT                    = TMW.CNDT
local Env                     = CNDT.Env

local A                       = Action
local GetToggle               = A.GetToggle
local InterruptIsValid        = A.InterruptIsValid

local UnitCooldown            = A.UnitCooldown
local Unit                    = A.Unit
local Player                  = A.Player
local Pet                     = A.Pet
local LoC                     = A.LossOfControl
local MultiUnits              = A.MultiUnits
local EnemyTeam               = A.EnemyTeam
local FriendlyTeam            = A.FriendlyTeam
local TeamCache               = A.TeamCache
local InstanceInfo            = A.InstanceInfo
local select, setmetatable    = select, setmetatable

-- Placeholder constants for Shaman specializations.
-- In a full setup, these might be global constants provided by the addon or defined elsewhere.
local ACTION_CONST_SHAMAN_ANY = "ANY_SHAMAN_SPEC" -- For settings that apply to all shaman specs
local ACTION_CONST_SHAMAN_ELEMENTAL = "SHAMAN_ELEMENTAL"
local ACTION_CONST_SHAMAN_ENHANCEMENT = "SHAMAN_ENHANCEMENT"
local ACTION_CONST_SHAMAN_RESTO = "SHAMAN_RESTO"

A.Data.ProfileEnabled[Action.CurrentProfile] = true

A.Data.ProfileUI = {
    DateTime = "v1.0 (22.07.2025)", -- Corrected date format
    [2] = { -- Class settings tab
        -- General Shaman Settings (applied to all specs, or if SpecOverride is AUTO)
        [ACTION_CONST_SHAMAN_ANY] = {
            LayoutOptions = { columns = 2, gutter = 5, padding = { left = 5, right = 5, top = 10, bottom = 10 } },
            { -- GENERAL HEADER
                E = "Header",
                L = { ANY = " -----[ GENERAL ]----- " },
                S = 14,
            },
            { -- GENERAL OPTIONS FIRST ROW
                LayoutOptions = { columns = 3, gutter = 5 }, -- Explicit layout for this row of checkboxes
                { -- MOUSEOVER
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = { enUS = "Use @mouseover" },
                    TT = { enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing" },
                    M = {},
                },
                { -- TARGETTARGET
                    E = "Checkbox",
                    DB = "InterruptTargetTarget",
                    DBV = true,
                    L = { ANY = "Use @TargetTarget" },
                    TT = { ANY = "Will check your target's target for interrupts and purges (useful for Restoration)." },
                    M = {},
                },
                { -- AOE
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = { enUS = "Use AoE" },
                    TT = { enUS = "Enable multiunits actions" },
                    M = {},
                },
            },
            { -- SPEC & SHIELD CONTROLLERS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these dropdowns
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
                    L = { ANY = "Shaman Spec Override" },
                    TT = { ANY = "Pick what spec you're playing (AUTO will choose the spec you have invested the most talent points in)." },
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
                    L = { ANY = "Elemental Shield" },
                    TT = { ANY = "Pick what Elemental Shield to keep up on yourself." },
                    M = {},
                },
            },
            { E = "LayoutSpace" }, -- Layout space for visual separation
            { -- POTION USAGE & SLIDERS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for potion elements
                { -- RECOVERY POTION CONTROLLER (Single element, but part of this grouped layout)
                    E = "Dropdown",
                    OT = {
                        { text = "Healing Potion", value = "HealingPotion" },
                        { text = "Mana Potion", value = "ManaPotion" },
                        { text = "Haste Potion", value = "HastePotion" },
                    },
                    DB = "PotionController",
                    DBV = "HealingPotion",
                    L = { ANY = "Potion Usage" },
                    TT = { ANY = "Pick what potion you would like to use. Sliders for HP/MP." },
                    M = {},
                },
                -- The next two elements are part of this row/group
                { E = "Label", L = { ANY = "Use Healthstone|Healing Potion slider on page 1 for Healing Potion." } },
            },
            { -- HEALTHSTONE & MANA POTION SLIDERS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these two sliders
                { -- Healthstone
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "HSHealth", DBV = 40, ONOFF = true,
                    L = { ANY = "HP (%) for HealthStone" },
                    TT = { ANY = "HP (%) to use HealthStone" }, M = {},
                },
                { -- Mana Potion
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "PotionMana", DBV = 10, ONOFF = true,
                    L = { ANY = "Mana (%) for Mana Potion" },
                    TT = { ANY = "Mana (%) to use Mana Potion" }, M = {},
                },
            },
            { -- DEMONIC RUNE SLIDER (Separated for clarity as it's disabled)
                LayoutOptions = { columns = 1 }, -- Single column layout for this element
                { -- Demonic Rune
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "Runes", DBV = 100, ONOFF = true,
                    L = { ANY = "Mana (%) for Demonic Rune" },
                    TT = { ANY = "Mana (%) for Demonic Rune (CURRENTLY DISABLED DUE TO ROTATION-BREAKING BUG)." },
                    M = {}, isDisabled = true,
                },
            },
            { E = "LayoutSpace" },
            { -- WEAPON SYNC & SHOCK INTERRUPT
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these checkboxes
                { -- Weapon Sync
                    E = "Checkbox",
                    DB = "WeaponSync", DBV = false,
                    L = { ANY = "Weapon Sync" },
                    TT = { ANY = "Attempt to sync your weapon swing timers to make the most out of flurry procs (might not work correctly with fast weapons)" },
                    M = {},
                },
                { -- Shock Interrupt
                    E = "Checkbox",
                    DB = "ShockInterrupt", DBV = false,
                    L = { ANY = "Save Shocks for Interrupts" },
                    TT = { ANY = "Save your shock CD for interrupts only." },
                    M = {},
                },
            },
            { E = "LayoutSpace" },
            { -- TOTEM CONTROLLER HEADER
                E = "Header",
                L = { ANY = " -----[ TOTEM CONTROLLER ]----- " },
                S = 14,
            },
            { -- TOTEM OPTIONS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these checkboxes
                { -- RecommendationTotem
                    E = "Checkbox",
                    DB = "RecommendationTotem", DBV = true,
                    L = { ANY = "Use Recommended Totems" },
                    TT = { ANY = "Uses recommended totems based on your current encounter (not yet implemented)." },
                    M = {}, isDisabled = true,
                },
                { -- Weave WF
                    E = "Checkbox",
                    DB = "WeaveWF", DBV = false,
                    L = { ANY = "Weave Windfury Totem" },
                    TT = { ANY = "Weave Windfury Totem with your chosen Air Totem from the dropdown." },
                    M = {},
                },
            },
            { E = "LayoutSpace" },
            { -- FIRE & EARTH TOTEM DROPDOWNS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these dropdowns
                { -- FIRE TOTEM
                    E = "Dropdown",
                    OT = {
                        { text = "AUTO", value = "AUTO" }, { text = "Searing", value = "Searing" },
                        { text = "Fire Nova", value = "FireNova" }, { text = "Frost Resistance", value = "FrostResistance" },
                        { text = "Magma", value = "Magma" }, { text = "Flametongue", value = "Flametongue" },
                        { text = "Totem of Wrath", value = "TotemofWrath" }, { text = "None", value = "None" },
                    },
                    DB = "FireTotem", DBV = "AUTO", L = { ANY = "Fire Totem" },
                    TT = { ANY = "Pick what Fire Totem you would like to prioritise." }, M = {},
                },
                { -- EARTH TOTEM
                    E = "Dropdown",
                    OT = {
                        { text = "AUTO", value = "AUTO" }, { text = "Stoneskin", value = "Stoneskin" },
                        { text = "Earthbind", value = "Earthbind" }, { text = "Stoneclaw", value = "Stoneclaw" },
                        { text = "Strength of Earth", value = "StrengthofEarth" }, { text = "Tremor", value = "Tremor" },
                        { text = "None", value = "None" },
                    },
                    DB = "EarthTotem", DBV = "AUTO", L = { ANY = "Earth Totem" },
                    TT = { ANY = "Pick what Earth Totem you would like to prioritise." }, M = {},
                },
            },
            { -- AIR & WATER TOTEM DROPDOWNS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these dropdowns
                { -- AIR TOTEM
                    E = "Dropdown",
                    OT = {
                        { text = "AUTO", value = "AUTO" }, { text = "Grounding", value = "Grounding" },
                        { text = "Nature Resistance", value = "NatureResistance" }, { text = "Windfury", value = "Windfury" },
                        { text = "Windwall", value = "Windwall" }, { text = "Grace of Air", value = "GraceofAir" },
                        { text = "Tranquil Air", value = "TranquilAir" }, { text = "Wrath of Air", value = "WrathofAir" },
                        { text = "None", value = "None" },
                    },
                    DB = "AirTotem", DBV = "AUTO", L = { ANY = "Air Totem" },
                    TT = { ANY = "Pick what Air Totem you would like to prioritise." }, M = {},
                },
                { -- WATER TOTEM
                    E = "Dropdown",
                    OT = {
                        { text = "AUTO", value = "AUTO" }, { text = "Healing Stream", value = "HealingStream" },
                        { text = "Poison Cleansing", value = "PoisonCleansing" }, { text = "Mana Spring", value = "ManaSpring" },
                        { text = "Disease Cleansing", value = "DiseaseCleansing" }, { text = "Fire Resistance", value = "FireResistance" },
                        { text = "None", value = "None" },
                    },
                    DB = "WaterTotem", DBV = "AUTO", L = { ANY = "Water Totem" },
                    TT = { ANY = "Pick what Water Totem you would like to prioritise." }, M = {},
                },
            },
            { E = "LayoutSpace" },
            { -- WEAPON ENCHANTS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these dropdowns
                { -- Main Hand Enchant
                    E = "Dropdown",
                    OT = {
                        { text = "Windfury", value = "Windfury" }, { text = "Rockbiter", value = "Rockbiter" },
                        { text = "Flametongue", value = "Flametongue" }, { text = "Frostbrand", value = "Frostbrand" },
                        { text = "None", value = "None" },
                    },
                    DB = "MainHandEnchant", DBV = "None", L = { ANY = "Main Hand Enchant" },
                    TT = { ANY = "Main Hand Enchant" }, M = {},
                },
                { -- Offhand Enchant
                    E = "Dropdown",
                    OT = {
                        { text = "Windfury", value = "Windfury" }, { text = "Rockbiter", value = "Rockbiter" },
                        { text = "Flametongue", value = "Flametongue" }, { text = "Frostbrand", value = "Frostbrand" },
                        { text = "None", value = "None" },
                    },
                    DB = "OffhandEnchant", DBV = "None", L = { ANY = "Offhand Enchant" },
                    TT = { ANY = "Offhand Enchant" }, M = {},
                },
            },
        },
        -- Enhancement Shaman Specific Settings
        [ACTION_CONST_SHAMAN_ENHANCEMENT] = {
            LayoutOptions = { columns = 2, gutter = 5, padding = { left = 5, right = 5, top = 10, bottom = 10 } },
            { -- ENHANCEMENT HEADER
                E = "Header",
                L = { ANY = " -----[ ENHANCEMENT SHAMAN ]----- " },
                S = 14,
            },
            { -- SHAMANISTIC RAGE SLIDER
                LayoutOptions = { columns = 1 }, -- Single column for this slider
                { -- Shamanistic Rage Value
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "ShamanisticRageMana", DBV = 50, ONOFF = true,
                    L = { ANY = "Shamanistic Rage Mana (%)" },
                    TT = { ANY = "Value mana (%) to use Shamanistic Rage" }, M = {},
                },
            },
            { -- STOP TWISTING & SHOCKS SLIDERS
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these two sliders
                { -- Stop Twisting Mana Enh
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "StopTwistingManaEnh", DBV = 30, ONOFF = true,
                    L = { ANY = "Stop Twisting at Mana (%)" },
                    TT = { ANY = "Value (%) to stop totem twisting while Shamanistic Rage is on CD/not active." }, M = {},
                },
                { -- Stop Shocks Mana Enh
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "StopShocksManaEnh", DBV = 30, ONOFF = true,
                    L = { ANY = "Stop Shocks at Mana (%)" },
                    TT = { ANY = "Value (%) to stop using shocks while Shamanistic Rage is on CD/not active." }, M = {},
                },
            },
        },
        -- Elemental Shaman Specific Settings
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
            LayoutOptions = { columns = 2, gutter = 5, padding = { left = 5, right = 5, top = 10, bottom = 10 } },
            { -- ELEMENTAL HEADER
                E = "Header",
                L = { ANY = " -----[ ELEMENTAL SHAMAN ]----- " },
                S = 14,
            },
            { -- STOP SHOCKS SLIDER
                LayoutOptions = { columns = 1 }, -- Single column for this slider
                { -- Stop Shocks Mana Ele
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "StopShocksManaEle", DBV = 30, ONOFF = true,
                    L = { ANY = "Stop Shocks at Mana (%)" },
                    TT = { ANY = "Value (%) to stop using shocks." }, M = {},
                },
            },
        },
        -- Restoration Shaman Specific Settings
        [ACTION_CONST_SHAMAN_RESTO] = {
            LayoutOptions = { columns = 2, gutter = 5, padding = { left = 5, right = 5, top = 10, bottom = 10 } },
            { -- RESTORATION HEADER
                E = "Header",
                L = { ANY = " -----[ RESTORATION SHAMAN ]----- " },
                S = 14,
            },
            { -- Healing Wave Header
                E = "Header",
                L = { ANY = " Healing Wave " },
                S = 14,
            },
            { -- HEALING WAVE RANK SLIDERS (Group 1)
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these two sliders
                { -- Healing Wave Rank 1
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "HealingWave1", DBV = 60, ONOFF = true,
                    L = { ANY = "Rank 1 (%)" },
                    TT = { ANY = "Value (%) to use Healing Wave Rank 1" }, M = {},
                },
                { -- Healing Wave Rank 7
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "HealingWave7", DBV = 60, ONOFF = true,
                    L = { ANY = "Rank 7 (%)" },
                    TT = { ANY = "Value (%) to use Healing Wave Rank 7." }, M = {},
                },
            },
            { -- HEALING WAVE RANK SLIDERS (Group 2)
                LayoutOptions = { columns = 2, gutter = 5 }, -- Explicit layout for these two sliders
                { -- Healing Wave Rank 10
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "HealingWave10", DBV = 60, ONOFF = true,
                    L = { ANY = "Rank 10 (%)" },
                    TT = { ANY = "Value (%) to use Healing Wave Rank 10." }, M = {},
                },
                { -- Healing Wave Max Rank
                    E = "Slider",
                    MIN = 0, MAX = 100, DB = "HealingWave12", DBV = 60, ONOFF = true,
                    L = { ANY = "Max Rank (%)" },
                    TT = { ANY = "Value (%) to use Healing Wave Max Rank." }, M = {},
                },
            },
            { -- HEALING WAY CHECKBOX
                LayoutOptions = { columns = 1 }, -- Single column for this checkbox
                { -- Healing Way
                    E = "Checkbox",
                    DB = "HealingWay", DBV = true,
                    L = { ANY = "R1 Spam Healing Way" },
                    TT = { ANY = "Spam R1 Healing Wave on tank until Healing Way buff is active." }, M = {},
                },
            },
        },
    },
}

-- Default ProfileDB (often mirrors the DBV values in ProfileUI)
A.Data.ProfileDB = {
    [2] = {
        [ACTION_CONST_SHAMAN_ANY] = {
            mouseover = true, InterruptTargetTarget = true, AoE = true,
            SpecOverride = "AUTO", ShieldType = "Water", PotionController = "HealingPotion",
            HSHealth = 40, PotionMana = 10, Runes = 100,
            WeaponSync = false, ShockInterrupt = false, RecommendationTotem = true, WeaveWF = false,
            FireTotem = "AUTO", EarthTotem = "AUTO", AirTotem = "AUTO", WaterTotem = "AUTO",
            MainHandEnchant = "None", OffhandEnchant = "None",
        },
        [ACTION_CONST_SHAMAN_ENHANCEMENT] = {
            ShamanisticRageMana = 50, StopTwistingManaEnh = 30, StopShocksManaEnh = 30,
        },
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
            StopShocksManaEle = 30,
        },
        [ACTION_CONST_SHAMAN_RESTO] = {
            HealingWave1 = 60, HealingWave7 = 60, HealingWave10 = 60, HealingWave12 = 60,
            HealingWay = true,
        },
    },
}