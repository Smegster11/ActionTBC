--#############################
--##### TRIP'S TBC SHAMAN #####
--#############################

local _G, setmetatable, pairs, ipairs, select, error, math = 
_G, setmetatable, pairs, ipairs, select, error, math 

local wipe                                     = _G.wipe     
local math_max                                = math.max      

local TMW                                     = _G.TMW 
local strlowerCache                          = TMW.strlowerCache
local Action                                = _G.Action
local toNum                                 = Action.toNum
local CONST                                 = Action.Const
local Create                                 = Action.Create
local Listener                                = Action.Listener
local Print                                    = Action.Print
local TeamCache                                = Action.TeamCache
local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam
local LoC                                     = Action.LossOfControl
local Player                                = Action.Player 
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local Totem                                    = LibStub("LibTotemInfo-1.0") 

local SetToggle                                = Action.SetToggle
local GetToggle                                = Action.GetToggle
local GetPing                                = Action.GetPing
local GetGCD                                = Action.GetGCD
local GetCurrentGCD                            = Action.GetCurrentGCD
local GetLatency                            = Action.GetLatency
local GetSpellInfo                            = Action.GetSpellInfo
local BurstIsON                                = Action.BurstIsON
local InterruptIsValid                        = Action.InterruptIsValid
local IsUnitEnemy                            = Action.IsUnitEnemy
local DetermineUsableObject                    = Action.DetermineUsableObject 
local DetermineIsCurrentObject                = Action.DetermineIsCurrentObject 
local DetermineCountGCDs                    = Action.DetermineCountGCDs 
local DetermineCooldownAVG                    = Action.DetermineCooldownAVG 
local AuraIsValid                            = Action.AuraIsValid
local HealingEngine                             = Action.HealingEngine

local CanUseStoneformDefense                = Action.CanUseStoneformDefense
local CanUseStoneformDispel                    = Action.CanUseStoneformDispel
local CanUseHealingPotion                    = Action.CanUseHealingPotion
local CanUseLivingActionPotion                = Action.CanUseLivingActionPotion
local CanUseLimitedInvulnerabilityPotion    = Action.CanUseLimitedInvulnerabilityPotion
local CanUseRestorativePotion                = Action.CanUseRestorativePotion
local CanUseSwiftnessPotion                    = Action.CanUseSwiftnessPotion

local TeamCacheFriendly                        = TeamCache.Friendly
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()

local SPELL_FAILED_TARGET_NO_POCKETS        = _G.SPELL_FAILED_TARGET_NO_POCKETS      
local ERR_INVALID_ITEM_TARGET                = _G.ERR_INVALID_ITEM_TARGET    
local MAX_BOSS_FRAMES                        = _G.MAX_BOSS_FRAMES  

local CreateFrame                            = _G.CreateFrame
local UIParent                                = _G.UIParent        
local StaticPopup1                            = _G.StaticPopup1    
local StaticPopup1Button2                    -- nil because frame is not created at this moment

local GetWeaponEnchantInfo                    = _G.GetWeaponEnchantInfo    
local GetItemInfo                            = _G.GetItemInfo  
local      UnitGUID,       UnitIsUnit,      UnitCreatureType,       UnitAttackPower = 
_G.UnitGUID, _G.UnitIsUnit, _G.UnitCreatureType, _G.UnitAttackPower

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

Action[Action.PlayerClass]                     = {
	--Racial
    Shadowmeld								= Create({ Type = "Spell", ID = 20580		}),  
    Perception								= Create({ Type = "Spell", ID = 20600, FixedTexture = CONST.HUMAN	}), 
    BloodFury								= Create({ Type = "Spell", ID = 20572		}), 
    Berserking								= Create({ Type = "Spell", ID = 20554		}), 
    Stoneform								= Create({ Type = "Spell", ID = 20594		}), 
    WilloftheForsaken						= Create({ Type = "Spell", ID = 7744		}), 
    EscapeArtist							= Create({ Type = "Spell", ID = 20589		}),	
	ArcaneTorrent							= Create({ Type = "Spell", ID = 28730		}),

	--General
    Throw									= Create({ Type = "Spell", ID = 2764,     QueueForbidden = true, BlockForbidden = true	}),	

	--Elemental
	LightningBolt							= Create({ Type = "Spell", ID = 403		}),
	EarthShock								= Create({ Type = "Spell", ID = 8042	}),
	EarthbindTotem							= Create({ Type = "Spell", ID = 2484	}),	
	StoneclawTotem							= Create({ Type = "Spell", ID = 5730	}),	
	FlameShock								= Create({ Type = "Spell", ID = 8050	}),	
	SearingTotem							= Create({ Type = "Spell", ID = 3599	}),	
	Purge									= Create({ Type = "Spell", ID = 370		}),	
	FireNovaTotem							= Create({ Type = "Spell", ID = 1535	}),
	FireNovaTotem2							= Create({ Type = "Spell", ID = 8498	}),
	FireNovaTotem3							= Create({ Type = "Spell", ID = 8499	}),
	FireNovaTotem4							= Create({ Type = "Spell", ID = 11314	}),
	FireNovaTotem5							= Create({ Type = "Spell", ID = 11315	}),
	FireNovaTotem6							= Create({ Type = "Spell", ID = 25546	}),
	FireNovaTotem7							= Create({ Type = "Spell", ID = 25547	}),
	FrostShock								= Create({ Type = "Spell", ID = 8056	}),
	MagmaTotem								= Create({ Type = "Spell", ID = 8190	}),	
	ChainLightning							= Create({ Type = "Spell", ID = 421		}),	
	TotemofWrath							= Create({ Type = "Spell", ID = 30706	}),
	ElementalMastery						= Create({ Type = "Spell", ID = 16166	}),
	TranquilAirTotem						= Create({ Type = "Spell", ID = 25908	}),		

	--Enhancement
	RockbiterWeapon							= Create({ Type = "Spell", ID = 8017	}),
	ShamanisticFocus						= Create({ Type = "Spell", ID = 43338	}),	
	StoneskinTotem							= Create({ Type = "Spell", ID = 8071, isRank = 1	}),
	StoneskinTotem2							= Create({ Type = "Spell", ID = 8154, isRank = 2	}),	
	LightningShield							= Create({ Type = "Spell", ID = 324		}),	
	FlametongueWeapon						= Create({ Type = "Spell", ID = 8024	}),
	StrengthofEarthTotem					= Create({ Type = "Spell", ID = 8075	}),	
	GhostWolf								= Create({ Type = "Spell", ID = 2645	}),	
	FrostbrandWeapon						= Create({ Type = "Spell", ID = 8033	}),	
	WaterBreathing							= Create({ Type = "Spell", ID = 131		}),	
	FrostResistanceTotem					= Create({ Type = "Spell", ID = 8181	}),	
	FarSight								= Create({ Type = "Spell", ID = 6196	}),
	FlametongueTotem						= Create({ Type = "Spell", ID = 8227	}),	
	FireResistanceTotem						= Create({ Type = "Spell", ID = 8184	}),
	WaterWalking							= Create({ Type = "Spell", ID = 546		}),	
	WindfuryWeapon							= Create({ Type = "Spell", ID = 8232	}),	
	GroundingTotem							= Create({ Type = "Spell", ID = 8177	}),	
	NatureResistanceTotem					= Create({ Type = "Spell", ID = 10595	}),	
	WindfuryTotem							= Create({ Type = "Spell", ID = 8512	}),	
	WindfuryTotem2							= Create({ Type = "Spell", ID = 10613	}),	
	WindfuryTotem3							= Create({ Type = "Spell", ID = 10614	}),
	WindfuryTotem4							= Create({ Type = "Spell", ID = 25585	}),
	WindfuryTotem5							= Create({ Type = "Spell", ID = 25587	}),		
	SentryTotem								= Create({ Type = "Spell", ID = 6495	}),
	WindwallTotem							= Create({ Type = "Spell", ID = 15107	}),
	Stormstrike								= Create({ Type = "Spell", ID = 17364	}),
	GraceofAirTotem							= Create({ Type = "Spell", ID = 8835	}),	
	ShamanisticRage							= Create({ Type = "Spell", ID = 30823	}),
	WrathofAirTotem							= Create({ Type = "Spell", ID = 3738	}),	
	EarthElementalTotem						= Create({ Type = "Spell", ID = 2062	}),	
    Bloodlust								= Create({ Type = "Spell", ID = 2825	}),
    Heroism									= Create({ Type = "Spell", ID = 32182	}),	

	--Restoration
    HealingWave1							= Create({ Type = "Spell", ID = 331, isRank = 1		}),	
    HealingWave2							= Create({ Type = "Spell", ID = 332, isRank = 2		}),
    HealingWave3							= Create({ Type = "Spell", ID = 547, isRank = 3		}),
    HealingWave4							= Create({ Type = "Spell", ID = 913, isRank = 4		}),
    HealingWave5							= Create({ Type = "Spell", ID = 939, isRank = 5		}),
    HealingWave6							= Create({ Type = "Spell", ID = 959, isRank = 6		}),
    HealingWave7							= Create({ Type = "Spell", ID = 8005, isRank = 7	}),
    HealingWave8							= Create({ Type = "Spell", ID = 10395, isRank = 8	}),
    HealingWave9							= Create({ Type = "Spell", ID = 10395, isRank = 9	}),
    HealingWave10							= Create({ Type = "Spell", ID = 25357, isRank = 10	}),
    HealingWave11							= Create({ Type = "Spell", ID = 25391, isRank = 11	}),	
    HealingWave								= Create({ Type = "Spell", ID = 25396, useMaxRank = true, Desc = "Max Rank"		}),
    AncestralSpirit							= Create({ Type = "Spell", ID = 2008	}),	
    CurePoison								= Create({ Type = "Spell", ID = 526		}),	
    TremorTotem								= Create({ Type = "Spell", ID = 8143	}),
    LesserHealingWave1						= Create({ Type = "Spell", ID = 8004, isRank = 1	}),	
    LesserHealingWave2						= Create({ Type = "Spell", ID = 8008, isRank = 2	}),	
    LesserHealingWave3						= Create({ Type = "Spell", ID = 8010, isRank = 3	}),	
    LesserHealingWave4						= Create({ Type = "Spell", ID = 10466, isRank = 4	}),	
    LesserHealingWave5						= Create({ Type = "Spell", ID = 10467, isRank = 5	}),	
    LesserHealingWave6						= Create({ Type = "Spell", ID = 10468, isRank = 6	}),	
    LesserHealingWave						= Create({ Type = "Spell", ID = 25420, useMaxRank = true, Desc = "Max Rank"		}),
    HealingStreamTotem						= Create({ Type = "Spell", ID = 5394	}),	
    PoisonCleansingTotem					= Create({ Type = "Spell", ID = 8166	}),
    CureDisease								= Create({ Type = "Spell", ID = 2870	}),	
    ManaSpringTotem							= Create({ Type = "Spell", ID = 5675	}),	
    TotemicCall								= Create({ Type = "Spell", ID = 36936	}),		
    DiseaseCleansingTotem					= Create({ Type = "Spell", ID = 8170	}),
    ChainHeal1								= Create({ Type = "Spell", ID = 1064, isRank = 1	}),	
    ChainHeal2								= Create({ Type = "Spell", ID = 10622, isRank = 2	}),	
    ChainHeal3								= Create({ Type = "Spell", ID = 10623, isRank = 3	}),	
    ChainHeal4								= Create({ Type = "Spell", ID = 25422, isRank = 4	}),	
    ChainHeal								= Create({ Type = "Spell", ID = 25423, useMaxRank = true, Desc = "Max Rank"		}),
    ManaTideTotem							= Create({ Type = "Spell", ID = 16190	}),
    EarthShield								= Create({ Type = "Spell", ID = 974		}),	
    WaterShield								= Create({ Type = "Spell", ID = 24398	}),	
    NaturesSwiftness						= Create({ Type = "Spell", ID = 16188	}),	
	
	--Misc
	SuperHealingPotion						= Create({ Type = "Potion", ID = 22829, QueueForbidden = true }),
}

local A                                     = setmetatable(Action[Action.PlayerClass], { __index = Action })

local player = "player"
local target = "target"
local pet = "pet"
local targettarget = "targettarget"
local focus = "focus"
local mouseover = "mouseover"

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

--Register Toaster
Toaster:Register("TripToast", function(toast, ...)
	local title, message, spellID = ...
	toast:SetTitle(title or "nil")
	toast:SetText(message or "nil")
	if spellID then 
		if type(spellID) ~= "number" then 
			error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
			toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
		else 
			toast:SetIconTexture((GetSpellTexture(spellID)))
		end 
	else 
		toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
	end 
	toast:SetUrgencyLevel("normal") 
end)

------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
	TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
	TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"}
}

local WindfuryActive = {
["Windfury Totem"] = true,
["Windfury Totem II"] = true,
["Windfury Totem III"] = true,
["Windfury Totem VI"] = true,
["Windfury Totem V"] = true,
}

local FireNovaActive = {
["Fire Nova Totem"] = true,
["Fire Nova Totem II"] = true,
["Fire Nova Totem III"] = true,
["Fire Nova Totem IV"] = true,
["Fire Nova Totem V"] = true,
["Fire Nova Totem VI"] = true,
["Fire Nova Totem VII"] = true,
} 


--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)

    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
	local combatTime = Unit(player):CombatTime()
	local UseAoE = A.GetToggle(2, "AoE")
	local SpecOverride = A.GetToggle(2, "SpecOverride")
	local ShieldType = A.GetToggle(2, "ShieldType")
	
	local FireTotem = A.GetToggle(2, "FireTotem")
	local EarthTotem = A.GetToggle(2, "EarthTotem")
	local AirTotem = A.GetToggle(2, "AirTotem")	
	local WaterTotem = A.GetToggle(2, "WaterTotem")

	local FireTotemTimeRemaining = Player:GetTotemTimeLeft(1)
	local EarthTotemTimeRemaining = Player:GetTotemTimeLeft(2)
	local WaterTotemTimeRemaining = Player:GetTotemTimeLeft(3)
	local AirTotemTimeRemaining = Player:GetTotemTimeLeft(4)
	
	local ActiveFireTotem = select(2, Player:GetTotemInfo(1))
	local ActiveEarthTotem = select(2, Player:GetTotemInfo(2))
	local ActiveWaterTotem = select(2, Player:GetTotemInfo(3))
	local ActiveAirTotem = select(2, Player:GetTotemInfo(4))
	--Usage ActiveFireTotem == A.FireNovaTotem:Info()
	
	local WeaveWF = A.GetToggle(2, "WeaveWF")
	
	local LesserHealingWaveHP = A.GetToggle(2, "LesserHealingWaveHP")
	local HealingWaveHP = A.GetToggle(2, "HealingWaveHP")	
	local ChainHealHP = A.GetToggle(2, "ChainHealHP")
	local ChainHealTargets = A.GetToggle(2, "ChainHealTargets")	
	
	local ShamanisticRageMana = A.GetToggle(2, "ShamanisticRageMana")  

	--###############
	--### POTIONS ###
	--###############

	local function PotionHandler()
		local UsePotions = A.GetToggle(1, "Potions")		
		local PotionController = A.GetToggle(2, "PotionController")
		local PotionHealth = A.GetToggle(2, "PotionHealth")
		local PotionMana = A.GetToggle(2, "PotionMana")
		
		if UsePotions and combatTime > 2 then
			if PotionController == "HealingPotion" then
				if Unit(player):HealthPercent() <= PotionHealth then 
					return A:Show(icon, CONST.POTION) 
				end 
			elseif PotionController == "ManaPotion" then
				if Player:ManaPercentage() <= PotionMana then
					return A:Show(icon, CONST.POTION)
				end
			elseif PotionController == "RejuvenationPotion" then
				if Unit(player):HealthPercent() <= PotionHealth and Player:ManaPercentage() <= PotionMana then
					return A:Show(icon, CONST.POTION)
				end
			end	
		end	
	end

	--#################
	--### INTERRUPT ###
	--#################

	local function InterruptHandler()
	
		unit = mouseover or target
		
		local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
		if IsUnitEnemy(unit) and castLeft > A.GetGCD() + A.GetLatency() then 	
			if not notKickAble and A.EarthShock:IsReadyByPassCastGCD(unit, nil, nil, true) and A.EarthShock:IsInRange() then 
				return A.EarthShock:Show(icon)    
			end 	
		end 
	end	
	
	--##############
	--### TOTEMS ###
	--##############		

	if A.TotemicCall:IsReady(player) and not inCombat then
		if (FireTotemTimeRemaining > A.GetGCD() or EarthTotemTimeRemaining > A.GetGCD() or WaterTotemTimeRemaining > A.GetGCD() or AirTotemTimeRemaining > A.GetGCD()) then
			return A.TotemicCall:Show(icon)
		end
	end	

	if A.TremorTotem:IsReady(player) and FriendlyTeam():GetDeBuffs("Sleep", 30) > 0 or FriendlyTeam():GetDeBuffs("Fear", 30) > 0 and ActiveEarthTotem ~= A.TremorTotem:Info() then
		return A.TremorTotem:Show(icon)
	end   
	
	local function TotemHandler()
	
			if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] then
				if FireTotem == "Searing" and A.SearingTotem:IsReady(player) then
					return A.SearingTotem:Show(icon)
				elseif FireTotem == "FireNova" and A.FireNovaTotem:IsReady(player) then
					return A.FireNovaTotem:Show(icon)			
				elseif FireTotem == "FrostResistance" and A.FrostResistanceTotem:IsReady(player) then
					return A.FrostResistanceTotem:Show(icon)
				elseif FireTotem == "Magma" and A.MagmaTotem:IsReady(player) then
					return A.MagmaTotem:Show(icon)			
				elseif FireTotem == "Flametongue" and A.FlametongueTotem:IsReady(player) then
					return A.FlametongueTotem:Show(icon)
				end
			end
			
			if EarthTotemTimeRemaining <= A.GetGCD() * 4 then
				if EarthTotem == "Stoneskin" and A.StoneskinTotem:IsReady(player) then
					return A.StoneskinTotem:Show(icon)
				elseif EarthTotem == "Earthbind" and A.EarthbindTotem:IsReady(player) then
					return A.EarthbindTotem:Show(icon)
				elseif EarthTotem == "Stoneclaw" and A.StoneclawTotem:IsReady(player) then
					return A.StoneclawTotem:Show(icon)					
				elseif EarthTotem == "StrengthofEarth" and A.StrengthofEarthTotem:IsReady(player) then
					return A.StrengthofEarthTotem:Show(icon)
				elseif EarthTotem == "Tremor" and A.TremorTotem:IsReady(player) then
					return A.TremorTotem:Show(icon)	
				end
			end

			if WeaveWF and A.WindfuryTotem:IsReady(player) and A.WindfuryTotem:GetSpellTimeSinceLastCast() >= 10 and inCombat and AirTotem ~= "Windfury" then
				return A.WindfuryTotem:Show(icon)
			end

			if (AirTotemTimeRemaining <= A.GetGCD() * 4 and not WeaveWF) or (WeaveWF and WindfuryActive[ActiveAirTotem]) then
				if AirTotem == "Grounding" and A.GroundingTotem:IsReady(player) then
					return A.GroundingTotem:Show(icon)
				elseif AirTotem == "NatureResistance" and A.NatureResistanceTotem:IsReady(player) then
					return A.NatureResistanceTotem:Show(icon)
				elseif AirTotem == "Windfury" and A.WindfuryTotem:IsReady(player) then
					return A.WindfuryTotem:Show(icon)					
				elseif AirTotem == "Windwall" and A.WindwallTotem:IsReady(player) then
					return A.WindwallTotem:Show(icon)
				elseif AirTotem == "GraceofAir" and A.GraceofAirTotem:IsReady(player) then
					return A.GraceofAirTotem:Show(icon)	
				elseif AirTotem == "TranquilAir" and A.TranquilAirTotem:IsReady(player) then
					return A.TranquilAirTotem:Show(icon)	
				elseif AirTotem == "WrathofAir" and A.WrathofAirTotem:IsReady(player) then
					return A.WrathofAirTotem:Show(icon)						
				end
			end		

			if WaterTotemTimeRemaining <= A.GetGCD() * 4 then
				if WaterTotem == "HealingStream" and A.HealingStreamTotem:IsReady(player) then
					return A.HealingStreamTotem:Show(icon)
				elseif WaterTotem == "PoisonCleansing" and A.PoisonCleansingTotem:IsReady(player) then
					return A.PoisonCleansingTotem:Show(icon)
				elseif WaterTotem == "ManaSpring" and A.ManaSpringTotem:IsReady(player) then
					return A.ManaSpringTotem:Show(icon)					
				elseif WaterTotem == "DiseaseCleansing" and A.DiseaseCleansingTotem:IsReady(player) then
					return A.DiseaseCleansingTotem:Show(icon)
				elseif WaterTotem == "FireResistance" and A.FireResistanceTotem:IsReady(player) then
					return A.FireResistanceTotem:Show(icon)							
				end
			end					
			
	end
	
	--########################
	--### HEALING ROTATION ###
	--########################
	
	local function HealingRotation(unit)
	
		if SpecOverride == "Restoration" or (SpecOverride == "AUTO" and A.GetCurrentSpecialization() == 264) then
			--Emergency
			-- Nature's Swiftness + Healing Wave R12 for burst
			if Unit(unit):HealthPercent() <= 30 then
				if A.NaturesSwiftness:IsReady(player) then
					return A.NaturesSwiftness:Show(icon)
				end
				
				if A.LesserHealingWave:IsReady(unit) and Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) == 0 then 
					return A.LesserHealingWave:Show(icon)
				end
			end
			
			if Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) > 0 and Unit(unit):HealthPercent() <= 60 then
				return A.HealingWave:Show(icon)
			end
		
			-- Maintain Water Shield
			if A.WaterShield:IsReady(player) and ShieldType == "Water" and Unit(player):HasBuffs(A.WaterShield.ID) == 0 then
				return A.WaterShield:Show(icon)
			end
			if A.LightningShield:IsReady(player) and ShieldType == "Lightning" and Unit(player):HasBuffs(A.LightningShield.ID) == 0 then
				return A.LightningShield:Show(icon)
			end					
			-- Maintain Earth Shield on tank
			if A.EarthShield:IsReady(unit) and Unit(unit):HasBuffs(A.EarthShield.ID) == 0 and Unit(unit):IsTank() then
				return A.EarthShield:Show(icon)
			end
			-- Maintain best totems
			if TotemHandler() then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 then
						return A.MagmaTotem:Show(icon)
					end
					if A.SearingTotem:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) then
						return A.SearingTotem:Show(icon)
					end
				end
				if ActiveFireTotem == A.MagmaTotem:Info() then
					if A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE then
						return A.SearingTotem:Show(icon)
					end
				end
			end			
			
			if WaterTotem == "AUTO" and inCombat and WaterTotemTimeRemaining <= A.GetGCD() * 4 then
				if A.ManaSpringTotem:IsReady(player) then
					return A.ManaSpringTotem:Show(icon)
				end
			end
			
			-- Mana Tide Totem when group benefits
			
			
			-- Chain Heal R4 or Chain Heal R5 spam
			if A.ChainHeal:IsReady(unit) and not isMoving and Unit(unit):HealthPercent() <= ChainHealHP and A.HealingEngine.GetBelowHealthPercentUnits(ChainHealHP, 40) >= ChainHealTargets then
				return A.ChainHeal:Show(icon)
			end
			
			-- Healing Wave ST
			if A.HealingWave:IsReady(unit) and not isMoving and Unit(unit):HealthPercent() <= HealingWaveHP then
				return A.HealingWave:Show(icon)
			end
			
			-- Lesser Healing Wave
			if A.LesserHealingWave:IsReady(unit) and not isMoving and Unit(unit):HealthPercent() <= LesserHealingWaveHP then
				return A.LesserHealingWave:Show(icon)
			end
			
		end
		
	end
	
	--#######################
	--### DAMAGE ROTATION ###
	--#######################
	
	local function DamageRotation(unit)
	
        if A.Purge:IsReady(unit) and inCombat and AuraIsValid(unit, "UsePurge", "PurgeHigh") then 
            return A.Purge:Show(icon)
        end   	
	
	--Elemental
		if SpecOverride == "Elemental" or SpecOverride == "Restoration" or (SpecOverride == "AUTO" and A.GetCurrentSpecialization() == 262) then	
	--Single Target
			if A.LightningBolt:IsReady(unit) and not inCombat then
				return A.LightningBolt:Show(icon)
			end
		-- Maintain Water Shield
			if A.WaterShield:IsReady(player) and ShieldType == "Water" and Unit(player):HasBuffs(A.WaterShield.ID) == 0 then
				return A.WaterShield:Show(icon)
			end
			if A.LightningShield:IsReady(player) and ShieldType == "Lightning" and Unit(player):HasBuffs(A.LightningShield.ID) == 0 then
				return A.LightningShield:Show(icon)
			end	
		-- Maintain Totem of Wrath, Mana Spring Totem, and Wrath of Air Totem
			if TotemHandler() and not isMoving and A.FlameShock:IsInRange(unit) then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 then
						return A.MagmaTotem:Show(icon)
					end
					if A.SearingTotem:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) then
						return A.SearingTotem:Show(icon)
					end
				end
				if ActiveFireTotem == A.MagmaTotem:Info() then
					if A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE then
						return A.SearingTotem:Show(icon)
					end
				end
			end			
			
			if WaterTotem == "AUTO" and WaterTotemTimeRemaining <= A.GetGCD() * 4 and not isMoving and A.FlameShock:IsInRange(unit) then
				if A.ManaSpringTotem:IsReady(player) then
					return A.ManaSpringTotem:Show(icon)
				end
			end
		
		-- Use Elemental Mastery with Chain Lightning
			if A.ChainLightning:IsReady(unit) and Unit(player):HasBuffs(A.ElementalMastery.ID, true) > 0 then 
				return A.ChainLightning:Show(icon)
			end
			if A.ElementalMastery:IsReady(player) and A.ChainLightning:GetCooldown() <= A.GetGCD() and BurstIsON(unit) then
				return A.ElementalMastery:Show(icon)
			end
		-- Chain Lightning
			if A.ChainLightning:IsReady(unit) and UseAoE and not isMoving then
				return A.ChainLightning:Show(icon)
			end
		-- Flame Shock while moving
			if A.FlameShock:IsReady(unit) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.ElementalMastery.ID, true) == 0 and Unit(unit):TimeToDie() >= 12 then
				return A.FlameShock:Show(icon)
			end
			if A.EarthShock:IsReady(unit) then
				return A.EarthShock:Show(icon)
			end
			
		-- Lightning Bolt
			if A.LightningBolt:IsReady(unit) and not isMoving then
				return A.LightningBolt:Show(icon)
			end
	
		end
		
		
	--Enhancement
		if SpecOverride == "Enhancement" or (SpecOverride == "AUTO" and A.GetCurrentSpecialization() == 263) then		
	--Single Target
		-- Maintain Water Shield
			if A.WaterShield:IsReady(player) and ShieldType == "Water" and Unit(player):HasBuffs(A.WaterShield.ID) == 0 then
				return A.WaterShield:Show(icon)
			end
			if A.LightningShield:IsReady(player) and ShieldType == "Lightning" and Unit(player):HasBuffs(A.LightningShield.ID) == 0 then
				return A.LightningShield:Show(icon)
			end			
		-- Windfury Weapon on both weapons
		
		
		-- Maintain Strength of Earth Totem, Mana Spring Totem, Searing Totem
			if TotemHandler() and A.FlameShock:IsInRange(unit) then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 then
						return A.MagmaTotem:Show(icon)
					end
					if A.SearingTotem:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) then
						return A.SearingTotem:Show(icon)
					end
				end
				if ActiveFireTotem == A.MagmaTotem:Info() then
					if A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE then
						return A.SearingTotem:Show(icon)
					end
				end
			end			
			
			if WaterTotem == "AUTO" and A.FlameShock:IsInRange(unit) and WaterTotemTimeRemaining <= A.GetGCD() * 4 then
				if A.ManaSpringTotem:IsReady(player) then
					return A.ManaSpringTotem:Show(icon)
				end
			end
			
			if EarthTotem == "AUTO" and A.FlameShock:IsInRange(unit) and EarthTotemTimeRemaining <= A.GetGCD() * 4 then
				if A.StrengthofEarthTotem:IsReady(player) then
					return A.StrengthofEarthTotem:Show(icon)
				end
			end
		
		-- If TotemicFocus talent then Totem Twist with Windfury and Grace of Air, otherwise just Grace of Air totem
			if AirTotem == "AUTO" and A.FlameShock:IsInRange(unit) and AirTotemTimeRemaining <= A.GetGCD() * 4 then
				if A.GraceofAirTotem:IsReady(player) then
					return A.GraceofAirTotem:Show(icon)
				end
			end
			
		
		-- Cast Fire Elemental Totem before Bloodlust
		-- Weapon sync ??? Jesus Christ...
		-- Shamanistic Rage without capping mana
			if A.ShamanisticRage:IsReady(player) and Player:ManaPercentage() <= ShamanisticRageMana and Unit(unit):TimeToDie() >= 15 then
				return A.ShamanisticRage:Show(icon)
			end
		
		-- Stormstrike
			if A.Stormstrike:IsReady(unit) then
				return A.Stormstrike:Show(icon)
			end
			
		-- Flame Shock / Earth Shock if target already has Flame Shock dot
			if A.FlameShock:IsReady(unit) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.ElementalMastery.ID, true) == 0 and Unit(unit):TimeToDie() >= 12 then
				return A.FlameShock:Show(icon)
			end
			if A.EarthShock:IsReady(unit) and (Unit(unit):HasDeBuffs(A.FlameShock.ID, true) >= 6 or Unit(unit):TimeToDie() <= 12) then
				return A.EarthShock:Show(icon)
			end		
		
		-- If not totem twisting, use Fire Nova Totem, then recast Searing Totem when Fire Nova explodes.
	
		end 
	end

    -- End on EnemyRotation()

    -- Potions
    if PotionHandler() then 
        return true
    end 
	
	--Interrupt
	if InterruptHandler() then
		return true
	end
	
    -- Heal Target 
    if IsUnitFriendly(target) then 
        unit = target 
        
        if HealingRotation(unit) then 
            return true 
        end 
    end  
	    
    -- Heal Mouseover
    if IsUnitFriendly(mouseover) then 
        unit = mouseover  
        
        if HealingRotation(unit) then 
            return true 
        end             
    end 
	
    -- DPS Mouseover 
    if IsUnitEnemy(mouseover) then 
        unit = mouseover    
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 
	
    -- DPS Target     
    if IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end  
end
-- Finished

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil
