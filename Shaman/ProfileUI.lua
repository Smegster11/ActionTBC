--[[
-------------------------------------------------------------------------------
-- Introduction 
-------------------------------------------------------------------------------
If you plan to build profile without use lua then you can skip this guide
Important to create mouseover, focus, focustarget, targettarget toggles as Checkbox as on their state will relly many things in API


-------------------------------------------------------------------------------
-- №1: Create snippet 
-------------------------------------------------------------------------------
Write in chat "/tmw options" > LUA Snippets > Profile (left side) > "+" > Write name "ProfileUI" in title of the snippet


-------------------------------------------------------------------------------
-- №2: Set profile defaults 
-------------------------------------------------------------------------------
Constances (written in Constans.lua)
--]]

-- Map locals to get faster performance
local _G, setmetatable					= _G, setmetatable
local TMW 								= _G.TMW
local CNDT								= TMW.CNDT
local Env								= CNDT.Env
local A 								= _G.Action

-- Constants for Shaman specializations (assuming these are defined in Constans.lua or similar)
-- You would typically define these if they are not already globally available.
-- For the purpose of this template, I'll use placeholders.
-- In a real scenario, these would look something like:
-- local ACTION_CONST_SHAMAN_ELEMENTAL    = 262 -- Example Spec ID
-- local ACTION_CONST_SHAMAN_ENHANCEMENT  = 263 -- Example Spec ID
-- local ACTION_CONST_SHAMAN_RESTO        = 264 -- Example Spec ID

-- Placeholder constants for demonstration. Replace with actual IDs if available.
local ACTION_CONST_SHAMAN_ANY          = "ANY_SHAMAN_SPEC" -- For settings that apply to all shaman specs
local ACTION_CONST_SHAMAN_ELEMENTAL    = "SHAMAN_ELEMENTAL"
local ACTION_CONST_SHAMAN_ENHANCEMENT  = "SHAMAN_ENHANCEMENT"
local ACTION_CONST_SHAMAN_RESTO        = "SHAMAN_RESTO"

-- This indicates to use 'The Action's all components and make it initializated for current profile 
A.Data.ProfileEnabled[A.CurrentProfile] = true 

-------------------------------------------------------------------------------
-- №3: Create UI on 'The Action' for current profile 
-------------------------------------------------------------------------------
A.Data.ProfileUI = {
    DateTime = "v1.0 (22.07.2025)", -- Corrected date format to match template
    [2] = { -- Spec tab
        -- General Shaman Settings (applied to all specs, or if SpecOverride is AUTO)
        -- We can use a custom key like ACTION_CONST_SHAMAN_ANY for these general settings.
        [ACTION_CONST_SHAMAN_ANY] = {
            LayoutOptions = { columns = 2, gutter = 3, padding = { left = 3, right = 3, top = 10, bottom = 10 } },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " -----[ GENERAL ]----- ",
                    },
                    S = 14, -- Added font size for headers
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = true,
                    L = {
                        enUS = "Use @mouseover",
                    },
                    TT = {
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing",
                    },
                    M = {},
                },
                { -- TARGETTARGET
                    E = "Checkbox",
                    DB = "InterruptTargetTarget",
                    DBV = true,
                    L = {
                        ANY = "Use @TargetTarget",
                    },
                    TT = {
                        ANY = "Will check your target's target for interrupts and purges (useful for Restoration).",
                    },
                    M = {},
                },
            },
            {
                { -- AOE
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        enUS = "Use AoE",
                    },
                    TT = {
                        enUS = "Enable multiunits actions",
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
                { -- Healthstone / Healing Potion
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HSHealth",
                    DBV = 40,
                    ONOFF = true, -- Changed to true to display OFF if MIN (0) is selected
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
                    DBV = 10,
                    ONOFF = true, -- Changed to true to display OFF if MIN (0) is selected
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
                    MIN = 0, -- Changed MIN to 0 for consistency with other sliders and ONOFF
                    MAX = 100,
                    DB = "Runes",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Mana (%) for Demonic Rune",
                    },
                    TT = {
                        ANY = "Mana (%) for Demonic Rune (CURRENTLY DISABLED DUE TO ROTATION-BREAKING BUG).",
                    },
                    M = {},
                    isDisabled = true, -- Added to reflect "CURRENTLY DISABLED"
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            {
                { -- Weapon Sync
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
                    S = 14,
                },
            },
            {
                { -- ReactionTotem
                    E = "Checkbox",
                    DB = "RecommendationTotem",
                    DBV = true,
                    L = {
                        ANY = "Use Recommended Totems",
                    },
                    TT = {
                        ANY = "Uses recommended totems based on your current encounter (not yet implemented).",
                    },
                    M = {},
                    isDisabled = true, -- Added to reflect "not yet implemented"
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
        },
        -- Enhancement Shaman Specific Settings
        [ACTION_CONST_SHAMAN_ENHANCEMENT] = {
            LayoutOptions = { columns = 2, gutter = 3, padding = { left = 3, right = 3, top = 10, bottom = 10 } },
            { -- ENHANCEMENT HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " -----[ ENHANCEMENT SHAMAN ]----- ",
                    },
                    S = 14,
                },
            },
            {
                { -- Shamanistic Rage Value
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "ShamanisticRageMana",
                    DBV = 50,
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
                { -- Stop Twisting Mana Enh
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "StopTwistingManaEnh",
                    DBV = 30,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Stop Twisting at Mana (%)",
                    },
                    TT = {
                        ANY = "Value (%) to stop totem twisting while Shamanistic Rage is on CD/not active.",
                    },
                    M = {},
                },
                { -- Stop Shocks Mana Enh
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "StopShocksManaEnh",
                    DBV = 30,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Stop Shocks at Mana (%)",
                    },
                    TT = {
                        ANY = "Value (%) to stop using shocks while Shamanistic Rage is on CD/not active.",
                    },
                    M = {},
                },
            },
        },
        -- Elemental Shaman Specific Settings
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
            LayoutOptions = { columns = 2, gutter = 3, padding = { left = 3, right = 3, top = 10, bottom = 10 } },
            { -- ELEMENTAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " -----[ ELEMENTAL SHAMAN ]----- ",
                    },
                    S = 14,
                },
            },
            {
                { -- Stop Shocks Mana Ele
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "StopShocksManaEle",
                    DBV = 30,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Stop Shocks at Mana (%)",
                    },
                    TT = {
                        ANY = "Value (%) to stop using shocks.",
                    },
                    M = {},
                },
            },
        },
        -- Restoration Shaman Specific Settings
        [ACTION_CONST_SHAMAN_RESTO] = {
            LayoutOptions = { columns = 2, gutter = 3, padding = { left = 3, right = 3, top = 10, bottom = 10 } },
            { -- RESTORATION HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " -----[ RESTORATION SHAMAN ]----- ",
                    },
                    S = 14,
                },
            },
            { -- Healing Wave Header
                {
                    E = "Header",
                    L = {
                        ANY = " Healing Wave ",
                    },
                    S = 14,
                },
            },
            {
                { -- Healing Wave Rank 1
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HealingWave1",
                    DBV = 60,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Rank 1 (%)",
                    },
                    TT = {
                        ANY = "Value (%) to use Healing Wave Rank 1",
                    },
                    M = {},
                },
                { -- Healing Wave Rank 7
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HealingWave7",
                    DBV = 60,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Rank 7 (%)",
                    },
                    TT = {
                        ANY = "Value (%) to use Healing Wave Rank 7.",
                    },
                    M = {},
                },
            },
            {
                { -- Healing Wave Rank 10
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HealingWave10",
                    DBV = 60,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Rank 10 (%)",
                    },
                    TT = {
                        ANY = "Value (%) to use Healing Wave Rank 10.",
                    },
                    M = {},
                },
                { -- Healing Wave Max Rank
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HealingWave12", -- Assuming Rank 12 is Max Rank for now, change if different
                    DBV = 60,
                    ONOFF = true, -- Changed to true for OFF at 0
                    L = {
                        ANY = "Max Rank (%)",
                    },
                    TT = {
                        ANY = "Value (%) to use Healing Wave Max Rank.",
                    },
                    M = {},
                },
            },
            {
                { -- Healing Way
                    E = "Checkbox",
                    DB = "HealingWay",
                    DBV = true,
                    L = {
                        ANY = "R1 Spam Healing Way",
                    },
                    TT = {
                        ANY = "Spam R1 Healing Wave on tank until Healing Way buff is active.",
                    },
                    M = {},
                },
            },
        },
    },
    -- [7] = { ... message tab configurations ... } -- Add your message tab configurations here if you have any.
}

-- You can still use the alternative method for adding elements after the initial A.Data.ProfileUI definition.
-- For instance, to add something specific to Enhancement:
local ProfileUI_Enhancement = A.Data.ProfileUI[2][ACTION_CONST_SHAMAN_ENHANCEMENT]
-- ProfileUI_Enhancement[#ProfileUI_Enhancement + 1] = {
--     {
--         E = "Checkbox",
--         DB = "NewEnhancementOption",
--         DBV = true,
--         L = {
--             ANY = "New Enhancement Specific Option",
--         },
--     },
-- }

-- Misc: About ProfileDB (example) - Retained for reference from your template.
-- A.Data.ProfileDB will create A.Data.ProfileDB, you can set A.Data.ProfileDB like this instead of pointing DB and DBV actually in the ProfileUI, but if both up then A.Data.ProfileUI will overwrite A.Data.ProfileDB
-- So don't take attention on it unless you need it for some purposes like visual comfort
A.Data.ProfileDB = {
    [2] = {
        [ACTION_CONST_SHAMAN_ANY] = {
            mouseover = true,
            InterruptTargetTarget = true,
            AoE = true,
            SpecOverride = "AUTO",
            ShieldType = "Water",
            PotionController = "HealingPotion",
            HSHealth = 40,
            PotionMana = 10,
            Runes = 100,
            WeaponSync = false,
            ShockInterrupt = false,
            RecommendationTotem = true,
            WeaveWF = false,
            FireTotem = "AUTO",
            EarthTotem = "AUTO",
            AirTotem = "AUTO",
            WaterTotem = "AUTO",
            MainHandEnchant = "None",
            OffhandEnchant = "None",
        },
        [ACTION_CONST_SHAMAN_ENHANCEMENT] = {
            ShamanisticRageMana = 50,
            StopTwistingManaEnh = 30,
            StopShocksManaEnh = 30,
        },
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
            StopShocksManaEle = 30,
        },
        [ACTION_CONST_SHAMAN_RESTO] = {
            HealingWave1 = 60,
            HealingWave7 = 60,
            HealingWave10 = 60,
            HealingWave12 = 60,
            HealingWay = true,
        },
    },
}

-------------------------------------------------------------------------------
-- №4: Use remain space for shared code between all specializations in profile (optional)
-------------------------------------------------------------------------------
-- Your shared code can go here, outside the A.Data.ProfileUI definition.
-- The local variables defined at the top of your original code can stay there.
local GetToggle              = A.GetToggle
local InterruptIsValid       = A.InterruptIsValid
local Unit                   = A.Unit
local select                 = select

-- Example of how to access a toggle:
-- local useMouseover = GetToggle(2, "mouseover")
-- if useMouseover then ... end

-- Your existing shared functions would typically go here:
-- function A.GrappleWeaponIsReady(unitID, skipShouldStop, isMsg)
--     -- ... your code ...
-- end

-- function A:CanInterruptPassive(unitID, countGCD)
--     -- ... your code ...
-- end