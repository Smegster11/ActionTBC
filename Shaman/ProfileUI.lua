--##########################################
--##### SMEG'S RESTORATION SHAMAN PROFILE UI #####
--##########################################

local _G, select, setmetatable = _G, select, setmetatable

local A = _G.Action
local L = {}

-- Localized Strings
L.SeparatorGeneral = { enUS = "< G E N E R A L >" }
L.SeparatorRestoration = { enUS = "< R E S T O R A T I O N >" }

L.UseMouseover = { enUS = "Use @mouseover" }
L.UseMouseoverTT = { enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing" }
L.UseTargetTarget = { enUS = "Use @TargetTarget" }
L.UseTargetTargetTT = { enUS = "Will check your target's target for interrupts and purges (useful for Restoration)." }
L.UseAoE = { enUS = "Use AoE" }
L.UseAoETT = { enUS = "Enable multiunits actions" }
L.ShamanSpecOverride = { ANY = "Shaman Spec Override" }
L.ShamanSpecOverrideTT = { ANY = "Pick what spec you're playing (AUTO will choose the spec you have invested the most talent points in)." }

local LayoutConfigOptions = { gutter = 10, padding = { left = 5, right = 5 } }

A.Data.ProfileEnabled[A.CurrentProfile] = true

A.Data.ProfileUI = {
	DateTime = "Smeg's Restoration Shaman v1.0-beta",
	[2] = {
		["SHAMAN"] = {
			LayoutOptions = LayoutConfigOptions,
		},
	},
}

local ProfileUI_ShamanTabContent = A.Data.ProfileUI[2]["SHAMAN"]

----------------------------------------------------------------------
-----------------------------G E N E R A L----------------------------
----------------------------------------------------------------------
ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	{ E = "Header", L = L.SeparatorGeneral },
}

ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	{
		E = "Checkbox",
		DB = "mouseover",
		DBV = true,
		L = L.UseMouseover,
		TT = L.UseMouseoverTT,
		M = {},
	},
}

ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	{
		E = "Checkbox",
		DB = "InterruptTargetTarget",
		DBV = true,
		L = L.UseTargetTarget,
		TT = L.UseTargetTargetTT,
		M = {},
	},
}

ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	{
		E = "Checkbox",
		DB = "AoE",
		DBV = true,
		L = L.UseAoE,
		TT = L.UseAoETT,
		M = {},
	},
}

ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	{ E = "Dropdown", OT = { { text = "Restoration", value = "Restoration" }, { text = "AUTO", value = "AUTO" } }, DB = "SpecOverride", DBV = "Restoration", L = L.ShamanSpecOverride, TT = L.ShamanSpecOverrideTT, M = {} },
}

ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = { E = "LayoutSpace" }

----------------------------------------------------------------------
--------------------------R E S T O R A T I O N-----------------------
----------------------------------------------------------------------
ProfileUI_ShamanTabContent[#ProfileUI_ShamanTabContent + 1] = {
	E = "Header", L = L.SeparatorRestoration, M = { hide = function() return A.Data.ProfileDB[A.CurrentProfile][2].SHAMAN.SpecOverride ~= "Restoration" and A.GetCurrentSpec() ~= "RESTO" end },
}

---
-- ProfileDB Initialization
A.Data.ProfileDB = {
	[2] = {
		["SHAMAN"] = {
			mouseover = true, InterruptTargetTarget = true, AoE = true,
			SpecOverride = "Restoration",
		},
	},
}