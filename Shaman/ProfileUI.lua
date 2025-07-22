--############################
--##### SMEG'S SHAMAN UI #####
--############################

local _G, select, setmetatable = _G, select, setmetatable

local A = _G.Action
local TMW = _G.TMW -- Keep this if Sio uses TMW's libraries for CNDT/Env
local CNDT = TMW and TMW.CNDT
local Env = CNDT and CNDT.Env

-- Reuse A for common functions (assuming Sio aliases them under A)
local GetToggle = A.GetToggle
local InterruptIsValid = A.InterruptIsValid

local UnitCooldown = A.UnitCooldown
local Unit = A.Unit
local Player = A.Player
local Pet = A.Pet
local LoC = A.LossOfControl
local MultiUnits = A.MultiUnits
local EnemyTeam = A.EnemyTeam
local FriendlyTeam = A.FriendlyTeam
local TeamCache = A.TeamCache
local InstanceInfo = A.InstanceInfo

-- Placeholder constants for Shaman specializations.
local ACTION_CONST_SHAMAN_ANY = "ANY_SHAMAN_SPEC"
local ACTION_CONST_SHAMAN_ELEMENTAL = "SHAMAN_ELEMENTAL"
local ACTION_CONST_SHAMAN_ENHANCEMENT = "SHAMAN_ENHANCEMENT"
local ACTION_CONST_SHAMAN_RESTO = "SHAMAN_RESTO"

-- Localized Strings -
local L = {
    SeparatorGeneral = { enUS = " -----[ GENERAL ]----- " },
    SeparatorTotemController = { enUS = " -----[ TOTEM CONTROLLER ]----- " },
    SeparatorEnhancement = { enUS = " -----[ ENHANCEMENT SHAMAN ]----- " },
    SeparatorElemental = { enUS = " -----[ ELEMENTAL SHAMAN ]----- " },
    SeparatorRestoration = { enUS = " -----[ RESTORATION SHAMAN ]----- " },
    SeparatorHealingWave = { enUS = " Healing Wave " },
    
    UseMouseover = { enUS = "Use @mouseover" },
    UseMouseoverTT = {
        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing",
    },
    UseTargetTarget = { enUS = "Use @TargetTarget" },
    UseTargetTargetTT = {
        enUS = "Will check your target's target for interrupts and purges (useful for Restoration).",
    },
    UseAoE = { enUS = "Use AoE" },
    UseAoETT = { enUS = "Enable multiunits actions" },
    
    ShamanSpecOverride = { ANY = "Shaman Spec Override" },
    ShamanSpecOverrideTT = { ANY = "Pick what spec you're playing (AUTO will choose the spec you have invested the most talent points in)." },
    ElementalShield = { ANY = "Elemental Shield" },
    ElementalShieldTT = { ANY = "Pick what Elemental Shield to keep up on yourself." },
    
    PotionUsage = { ANY = "Potion Usage" },
    PotionUsageTT = { ANY = "Pick what potion you would like to use. Sliders for HP/MP." },
    HealingPotionInfo = { ANY = "Use Healthstone|Healing Potion slider on page 1 for Healing Potion." },
    
    HSHealth = { ANY = "HP (%) for HealthStone" },
    HSHealthTT = { ANY = "HP (%) to use HealthStone" },
    PotionMana = { ANY = "Mana (%) for Mana Potion" },
    PotionManaTT = { ANY = "Mana (%) to use Mana Potion" },
    DemonicRuneMana = { ANY = "Mana (%) for Demonic Rune" },
    DemonicRuneManaTT = { ANY = "Mana (%) for Demonic Rune (CURRENTLY DISABLED DUE TO ROTATION-BREAKING BUG)." },
    
    WeaponSync = { ANY = "Weapon Sync" },
    WeaponSyncTT = { ANY = "Attempt to sync your weapon swing timers to make the most out of flurry procs (might not work correctly with fast weapons)" },
    ShockInterrupt = { ANY = "Save Shocks for Interrupts" },
    ShockInterruptTT = { ANY = "Save your shock CD for interrupts only." },
    
    RecommendationTotem = { ANY = "Use Recommended Totems" },
    RecommendationTotemTT = { ANY = "Uses recommended totems based on your current encounter (not yet implemented)." },
    WeaveWF = { ANY = "Weave Windfury Totem" },
    WeaveWFTT = { ANY = "Weave Windfury Totem with your chosen Air Totem from the dropdown." },
    
    FireTotem = { ANY = "Fire Totem" },
    FireTotemTT = { ANY = "Pick what Fire Totem you would like to prioritise." },
    EarthTotem = { ANY = "Earth Totem" },
    EarthTotemTT = { ANY = "Pick what Earth Totem you would like to prioritise." },
    AirTotem = { ANY = "Air Totem" },
    AirTotemTT = { ANY = "Pick what Air Totem you would like to prioritise." },
    WaterTotem = { ANY = "Water Totem" },
    WaterTotemTT = { ANY = "Pick what Water Totem you would like to prioritise." },
    
    MainHandEnchant = { ANY = "Main Hand Enchant" },
    MainHandEnchantTT = { ANY = "Main Hand Enchant" },
    OffhandEnchant = { ANY = "Offhand Enchant" },
    OffhandEnchantTT = { ANY = "Offhand Enchant" },
    
    ShamanisticRageMana = { ANY = "Shamanistic Rage Mana (%)" },
    ShamanisticRageManaTT = { ANY = "Value mana (%) to use Shamanistic Rage" },
    StopTwistingManaEnh = { ANY = "Stop Twisting at Mana (%)" },
    StopTwistingManaEnhTT = { ANY = "Value (%) to stop totem twisting while Shamanistic Rage is on CD/not active." },
    StopShocksManaEnh = { ANY = "Stop Shocks at Mana (%)" },
    StopShocksManaEnhTT = { ANY = "Value (%) to stop using shocks while Shamanistic Rage is on CD/not active." },
    
    StopShocksManaEle = { ANY = "Stop Shocks at Mana (%)" },
    StopShocksManaEleTT = { ANY = "Value (%) to stop using shocks." },
    
    HealingWaveR1 = { ANY = "Rank 1 (%)" },
    HealingWaveR1TT = { ANY = "Value (%) to use Healing Wave Rank 1" },
    HealingWaveR7 = { ANY = "Rank 7 (%)" },
    HealingWaveR7TT = { ANY = "Value (%) to use Healing Wave Rank 7." },
    HealingWaveR10 = { ANY = "Rank 10 (%)" },
    HealingWaveR10TT = { ANY = "Value (%) to use Healing Wave Rank 10." },
    HealingWaveMaxRank = { ANY = "Max Rank (%)" },
    HealingWaveMaxRankTT = { ANY = "Value (%) to use Healing Wave Max Rank." },
    HealingWayR1Spam = { ANY = "R1 Spam Healing Way" },
    HealingWayR1SpamTT = { ANY = "Spam R1 Healing Wave on tank until Healing Way buff is active." },
}

local LayoutConfigOptions = { columns = 12, rows = 1, gutter = 10, padding = { left = 5, right = 5 } }
local SliderMarginOptions = { margin = { top = 10 } } -- Not used directly in layout, but for elements if needed.

A.Data.ProfileEnabled[A.CurrentProfile] = true

-- Initialize ProfileUI --
A.Data.ProfileUI = {
    DateTime = "Smeg's Shaman v1.0",
    [2] = { -- This is the 'Shaman' tab itself
        ["SHAMAN"] = { -- This is the primary container for the Shaman tab's content
            -- Initial layout for the main Shaman content area
            LayoutOptions = LayoutConfigOptions,
        },
    },
}

-- Point ProfileUI to the specific Shaman section
-- This is where all the content for the Shaman tab will be added sequentially.
local ProfileUI_ShamanTabContent = A.Data.ProfileUI[2]["SHAMAN"]

-- Use a counter for explicit indexing instead of #
local uiCounter = 1

----------------------------------------------------------------------
--------------------- S H A M A N   A N Y   S P E C ----------------
----------------------------------------------------------------------
ProfileUI_ShamanTabContent[uiCounter] = {
    { E = "Header", L = L.SeparatorGeneral, S = 14 },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 3, gutter = 5 },
    {
        E = "Checkbox", DB = "mouseover", DBV = true,
        L = L.UseMouseover, TT = L.UseMouseoverTT, M = {},
    },
    {
        E = "Checkbox", DB = "InterruptTargetTarget", DBV = true,
        L = L.UseTargetTarget, TT = L.UseTargetTargetTT, M = {},
    },
    {
        E = "Checkbox", DB = "AoE", DBV = true,
        L = L.UseAoE, TT = L.UseAoETT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Dropdown",
        OT = { { text = "Enhancement", value = "Enhancement" }, { text = "Elemental", value = "Elemental" },
            { text = "Restoration", value = "Restoration" }, { text = "AUTO", value = "AUTO" }, },
        DB = "SpecOverride", DBV = "AUTO", L = L.ShamanSpecOverride,
        TT = L.ShamanSpecOverrideTT, M = {},
    },
    {
        E = "Dropdown",
        OT = { { text = "Water Shield", value = "Water" }, { text = "Lightning Shield", value = "Lightning" }, },
        DB = "ShieldType", DBV = "Water", L = L.ElementalShield,
        TT = L.ElementalShieldTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Dropdown",
        OT = { { text = "Healing Potion", value = "HealingPotion" }, { text = "Mana Potion", value = "ManaPotion" },
            { text = "Haste Potion", value = "HastePotion" }, },
        DB = "PotionController", DBV = "HealingPotion", L = L.PotionUsage,
        TT = L.PotionUsageTT, M = {},
    },
    { E = "Label", L = L.HealingPotionInfo },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "HSHealth", DBV = 40, ONOFF = true,
        L = L.HSHealth, TT = L.HSHealthTT, M = {},
    },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "PotionMana", DBV = 10, ONOFF = true,
        L = L.PotionMana, TT = L.PotionManaTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 1 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "Runes", DBV = 100, ONOFF = true,
        L = L.DemonicRuneMana, TT = L.DemonicRuneManaTT, M = {}, isDisabled = true,
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Checkbox", DB = "WeaponSync", DBV = false,
        L = L.WeaponSync, TT = L.WeaponSyncTT, M = {},
    },
    {
        E = "Checkbox", DB = "ShockInterrupt", DBV = false,
        L = L.ShockInterrupt, TT = L.ShockInterruptTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

----------------------------------------------------------------------
------------------- T O T E M   C O N T R O L L E R ----------------
----------------------------------------------------------------------
ProfileUI_ShamanTabContent[uiCounter] = {
    { E = "Header", L = L.SeparatorTotemController, S = 14 },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Checkbox", DB = "RecommendationTotem", DBV = true,
        L = L.RecommendationTotem, TT = L.RecommendationTotemTT, M = {}, isDisabled = true,
    },
    {
        E = "Checkbox", DB = "WeaveWF", DBV = false,
        L = L.WeaveWF, TT = L.WeaveWFTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Dropdown", OT = { { text = "AUTO", value = "AUTO" }, { text = "Searing", value = "Searing" }, { text = "Fire Nova", value = "FireNova" }, { text = "Frost Resistance", value = "FrostResistance" }, { text = "Magma", value = "Magma" }, { text = "Flametongue", value = "Flametongue" }, { text = "Totem of Wrath", value = "TotemofWrath" }, { text = "None", value = "None" }, },
        DB = "FireTotem", DBV = "AUTO", L = L.FireTotem, TT = L.FireTotemTT, M = {},
    },
    {
        E = "Dropdown", OT = { { text = "AUTO", value = "AUTO" }, { text = "Stoneskin", value = "Stoneskin" }, { text = "Earthbind", value = "Earthbind" }, { text = "Stoneclaw", value = "Stoneclaw" }, { text = "Strength of Earth", value = "StrengthofEarth" }, { text = "Tremor", value = "Tremor" }, { text = "None", value = "None" }, },
        DB = "EarthTotem", DBV = "AUTO", L = L.EarthTotem, TT = L.EarthTotemTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Dropdown", OT = { { text = "AUTO", value = "AUTO" }, { text = "Grounding", value = "Grounding" }, { text = "Nature Resistance", value = "NatureResistance" }, { text = "Windfury", value = "Windfury" }, { text = "Windwall", value = "Windwall" }, { text = "Grace of Air", value = "GraceofAir" }, { text = "Tranquil Air", value = "TranquilAir" }, { text = "Wrath of Air", value = "WrathofAir" }, { text = "None", value = "None" }, },
        DB = "AirTotem", DBV = "AUTO", L = L.AirTotem, TT = L.AirTotemTT, M = {},
    },
    {
        E = "Dropdown", OT = { { text = "AUTO", value = "AUTO" }, { text = "Healing Stream", value = "Healing Stream" }, { text = "Poison Cleansing", value = "PoisonCleansing" }, { text = "Mana Spring", value = "ManaSpring" }, { text = "Disease Cleansing", value = "DiseaseCleansing" }, { text = "Fire Resistance", value = "FireResistance" }, { text = "None", value = "None" }, },
        DB = "WaterTotem", DBV = "AUTO", L = L.WaterTotem, TT = L.WaterTotemTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

----------------------------------------------------------------------
--------------------- W E A P O N   E N C H A N T S ----------------
----------------------------------------------------------------------
ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Dropdown", OT = { { text = "Windfury", value = "Windfury" }, { text = "Rockbiter", value = "Rockbiter" }, { text = "Flametongue", value = "Flametongue" }, { text = "Frostbrand", value = "Frostbrand" }, { text = "None", value = "None" }, },
        DB = "MainHandEnchant", DBV = "None", L = L.MainHandEnchant, TT = L.MainHandEnchantTT, M = {},
    },
    {
        E = "Dropdown", OT = { { text = "Windfury", value = "Windfury" }, { text = "Rockbiter", value = "Rockbiter" }, { text = "Flametongue", value = "Flametongue" }, { text = "Frostbrand", value = "Frostbrand" }, { text = "None", value = "None" }, },
        DB = "OffhandEnchant", DBV = "None", L = L.OffhandEnchant, TT = L.OffhandEnchantTT, M = {},
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace" }
uiCounter = uiCounter + 1

----------------------------------------------------------------------
------------------ S P E C I A L I Z A T I O N S -------------------
----------------------------------------------------------------------


-- Enhancement Shaman Specific Settings
ProfileUI_ShamanTabContent[uiCounter] = {
    E = "Header", L = L.SeparatorEnhancement, S = 14,
    M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Enhancement" and A.GetCurrentSpec() ~= "ENHANCEMENT" end } -- Example hide condition
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 1 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "ShamanisticRageMana", DBV = 50, ONOFF = true,
        L = L.ShamanisticRageMana, TT = L.ShamanisticRageManaTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Enhancement" and A.GetCurrentSpec() ~= "ENHANCEMENT" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "StopTwistingManaEnh", DBV = 30, ONOFF = true,
        L = L.StopTwistingManaEnh, TT = L.StopTwistingManaEnhTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Enhancement" and A.GetCurrentSpec() ~= "ENHANCEMENT" end }
    },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "StopShocksManaEnh", DBV = 30, ONOFF = true,
        L = L.StopShocksManaEnh, TT = L.StopShocksManaEnhTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Enhancement" and A.GetCurrentSpec() ~= "ENHANCEMENT" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace", M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Enhancement" and A.GetCurrentSpec() ~= "ENHANCEMENT" end } }
uiCounter = uiCounter + 1


-- Elemental Shaman Specific Settings
ProfileUI_ShamanTabContent[uiCounter] = {
    E = "Header", L = L.SeparatorElemental, S = 14,
    M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Elemental" and A.GetCurrentSpec() ~= "ELEMENTAL" end }
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 1 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "StopShocksManaEle", DBV = 30, ONOFF = true,
        L = L.StopShocksManaEle, TT = L.StopShocksManaEleTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Elemental" and A.GetCurrentSpec() ~= "ELEMENTAL" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace", M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Elemental" and A.GetCurrentSpec() ~= "ELEMENTAL" end } }
uiCounter = uiCounter + 1


-- Restoration Shaman Specific Settings
ProfileUI_ShamanTabContent[uiCounter] = {
    E = "Header", L = L.SeparatorRestoration, S = 14,
    M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    E = "Header", L = L.SeparatorHealingWave, S = 14,
    M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "HealingWave1", DBV = 60, ONOFF = true,
        L = L.HealingWaveR1, TT = L.HealingWaveR1TT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
    },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "HealingWave7", DBV = 60, ONOFF = true,
        L = L.HealingWaveR7, TT = L.HealingWaveR7TT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 2, gutter = 5 },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "HealingWave10", DBV = 60, ONOFF = true,
        L = L.HealingWaveR10, TT = L.HealingWaveR10TT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
    },
    {
        E = "Slider", MIN = 0, MAX = 100, DB = "HealingWave12", DBV = 60, ONOFF = true,
        L = L.HealingWaveMaxRank, TT = L.HealingWaveMaxRankTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = {
    LayoutOptions = { columns = 1 },
    {
        E = "Checkbox", DB = "HealingWay", DBV = true,
        L = L.HealingWayR1Spam, TT = L.HealingWayR1SpamTT, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end }
    },
}
uiCounter = uiCounter + 1

ProfileUI_ShamanTabContent[uiCounter] = { E = "LayoutSpace", M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end } }
uiCounter = uiCounter + 1


---
-- This section for ProfileDB needs to be added as a separate TMW snippet
-- Or if TMW snippets can be combined, put it after the ProfileUI definition.
-- It initializes the default values for the UI elements.

-- Initialize ProfileDB based on your previous settings,
-- structured to match the new ProfileUI organization.
A.Data.ProfileDB = {
    [2] = { -- Corresponds to the Shaman tab
        ["SHAMAN"] = { -- This holds the data for the main Shaman section
            mouseover = true, InterruptTargetTarget = true, AoE = true,
            SpecOverride = "AUTO", ShieldType = "Water", PotionController = "HealingPotion",
            HSHealth = 40, PotionMana = 10, Runes = 100,
            WeaponSync = false, ShockInterrupt = false, RecommendationTotem = true, WeaveWF = false,
            FireTotem = "AUTO", EarthTotem = "AUTO", AirTotem = "AUTO", WaterTotem = "AUTO",
            MainHandEnchant = "None", OffhandEnchant = "None",
            
            -- Spec-specific data keys, will be accessed via A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.KEY
            ShamanisticRageMana = 50, StopTwistingManaEnh = 30, StopShocksManaEnh = 30,
            StopShocksManaEle = 30,
            HealingWave1 = 60, HealingWave7 = 60, HealingWave10 = 60, HealingWave12 = 60,
            HealingWay = true,
        },
    },
}

