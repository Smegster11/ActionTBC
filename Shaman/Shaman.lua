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
local Pet                                       = LibStub("PetLibrary") 

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
    ShootBow								= Create({ Type = "Spell", ID = 2480,     QueueForbidden = true, BlockForbidden = true	}),
    ShootCrossbow							= Create({ Type = "Spell", ID = 7919,     QueueForbidden = true, BlockForbidden = true	}),
    ShootGun                                = Create({ Type = "Spell", ID = 7918,     QueueForbidden = true, BlockForbidden = true	}),
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
	FrostShock								= Create({ Type = "Spell", ID = 8056	}),
	MagmaTotem								= Create({ Type = "Spell", ID = 8190	}),	
	ChainLightning							= Create({ Type = "Spell", ID = 421		}),	
	TotemofWrath							= Create({ Type = "Spell", ID = 30706	}),	

	--Enhancement
	RockbiterWeapon							= Create({ Type = "Spell", ID = 8017	}),
	ShamanisticFocus						= Create({ Type = "Spell", ID = 43338	}),	
	StoneskinTotem							= Create({ Type = "Spell", ID = 8071	}),	
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
	SentryTotem								= Create({ Type = "Spell", ID = 6495	}),
	WindwallTotem							= Create({ Type = "Spell", ID = 15107	}),
	Stormstrike								= Create({ Type = "Spell", ID = 17364	}),
	GraceofAirTotem							= Create({ Type = "Spell", ID = 8835	}),	
	ShamanisticRage							= Create({ Type = "Spell", ID = 30823	}),
	WrathofAirTotem							= Create({ Type = "Spell", ID = 3738	}),	
	EarthElementalTotem						= Create({ Type = "Spell", ID = 2062	}),	
    Bloodlust								= Create({ Type = "Spell", ID = 2825	}),

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
	
	--Misc
    Heroism									= Create({ Type = "Spell", ID = 32182		}),
    Drums									= Create({ Type = "Spell", ID = 29529		}),
	SuperHealingPotion						= Create({ Type = "Potion", ID = 22829, QueueForbidden = true }),
}

local A                                     = setmetatable(Action[Action.PlayerClass], { __index = Action })

local player = "player"
local target = "target"
local pet = "pet"
local targettarget = "targettarget"
local focus = "focus"

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
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
}

local ImmuneArcane = {
[18864] = true,
[18865] = true,
[15691] = true
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
		local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
		if IsUnitEnemy(unit) and castLeft > A.GetGCD() + A.GetLatency() then 	
			if not notKickAble and A.EarthShock:IsReadyByPassCastGCD(unit, nil, nil, true) and A.EarthShock:IsInRange() then 
				return A.EarthShock:Show(icon)    
			end 	
		end 
	end	
	
	--########################
	--### HEALING ROTATION ###
	--########################
	
	local function HealingRotation(unit)
	
		-- Maintain Water Shield
		-- Maintain Earth Shield on tank
		-- Maintain best totems
		-- Mana Tide Totem when group benefits
		-- Chain Heal R4 or Chain Heal R5 spam (even single target?)
		-- Nature's Swiftness + Healing Wave R12 for burst
		-- Lesser Healing Wave if healing needs to be faster than Chain Heal
	
	end
	
	--#######################
	--### DAMAGE ROTATION ###
	--#######################
	
	local function DamageRotation(unit)
	
	--Elemental
	--Single Target
		-- Maintain Water Shield
		-- Maintain Totem of Wrath, Mana Spring Totem, and Wrath of Air Totem
		-- Use Elemental Mastery with Chain Lightning
		-- Chain Lightning
		-- Lightning Bolt
		-- Flame Shock while moving
	
	--AoE
		-- Fire Nova Totem
		-- Chain Lightning
		-- Magma Totem after Fire Nova Totem explodes
		-- Maintain Flame Shock 2 targets
		-- Lightning Bolt
	
	--Enhancement
	--Single Target
		-- Maintain Water Shield
		-- Windfury Weapon on both weapons
		-- Maintain Strength of Earth Totem, Mana Spring Totem, Searing Totem
		-- If TotemicFocus talent then Totem Twist with Windfury and Grace of Air, otherwise just Grace of Air totem
		-- Cast Fire Elemental Totem before Bloodlust
		-- Weapon sync ??? Jesus Christ...
		-- Shamanistic Rage without capping mana
		-- Stormstrike
		-- Flame Shock / Earth Shock if target already has Flame Shock dot
		-- If not totem twisting, use Fire Nova Totem, then recast Searing Totem when Fire Nova explodes.
	
	--AoE
		-- Fire Nova Totem
		-- Magma Totem after Fire Nova Totem explodes.
		-- Maintain Flame Shock 2 targets
	
	end
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
	local npcID = select(6, Unit(unit):InfoGUID())

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
