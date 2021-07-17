--#############################
--##### TRIP'S TBC SHAMAN #####
--#############################

local _G, setmet5atable, pairs, ipairs, select, error, math = 
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
local HealComm                                 = LibStub("LibHealComm-4.0")


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
local DetermineHealObject                    = Action.DetermineHealObject 
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
local CanUseManaRune                    	= Action.CanUseManaRune

local TeamCacheFriendly                        = TeamCache.Friendly
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()

local SPELL_FAILED_TARGET_NO_POCKETS        = _G.SPELL_FAILED_TARGET_NO_POCKETS      
local ERR_INVALID_ITEM_TARGET                = _G.ERR_INVALID_ITEM_TARGET    
local MAX_BOSS_FRAMES                        = _G.MAX_BOSS_FRAMES
local ACTION_CONST_STOPCAST                    = CONST.STOPCAST  

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
	GiftoftheNaaru							= Create({ Type = "Spell", ID = 28880		}),	

	--General
    Throw									= Create({ Type = "Spell", ID = 2764,     QueueForbidden = true, BlockForbidden = true	}),	

	--Weapon Enchants
	FlametongueWeapon						= Create({ Type = "Spell", ID = 8024	}),
	FrostbrandWeapon						= Create({ Type = "Spell", ID = 8033	}),	
	WindfuryWeapon							= Create({ Type = "Spell", ID = 8232	}),	
	RockbiterWeapon							= Create({ Type = "Spell", ID = 8017	}),

	--Elemental
	LightningBolt							= Create({ Type = "Spell", ID = 403, useMaxRank = true		}),
	EarthShock								= Create({ Type = "Spell", ID = 8042, useMaxRank = true		}),
	EarthbindTotem							= Create({ Type = "Spell", ID = 2484, useMaxRank = true		}),	
	StoneclawTotem							= Create({ Type = "Spell", ID = 5730, useMaxRank = true		}),	
	FlameShock								= Create({ Type = "Spell", ID = 8050, useMaxRank = true		}),	
	SearingTotem							= Create({ Type = "Spell", ID = 3599, useMaxRank = true		}),	
	Purge									= Create({ Type = "Spell", ID = 370		}),	
	FireNovaTotem							= Create({ Type = "Spell", ID = 1535, useMaxRank = true		}),
--	FireNovaTotem2							= Create({ Type = "Spell", ID = 8498, isRank = 2	}),
--	FireNovaTotem3							= Create({ Type = "Spell", ID = 8499, isRank = 3	}),
--	FireNovaTotem4							= Create({ Type = "Spell", ID = 11314, isRank = 4	}),
--	FireNovaTotem5							= Create({ Type = "Spell", ID = 11315, isRank = 5	}),
--	FireNovaTotem6							= Create({ Type = "Spell", ID = 25546, isRank = 6	}),
--	FireNovaTotem7							= Create({ Type = "Spell", ID = 25547, isRank = 7	}),
	FrostShock								= Create({ Type = "Spell", ID = 8056, useMaxRank = true		}),
	MagmaTotem								= Create({ Type = "Spell", ID = 8190, useMaxRank = true		}),	
	ChainLightning							= Create({ Type = "Spell", ID = 421, useMaxRank = true		}),	
	TotemofWrath							= Create({ Type = "Spell", ID = 30706	}),
	ElementalMastery						= Create({ Type = "Spell", ID = 16166	}),
	TranquilAirTotem						= Create({ Type = "Spell", ID = 25908	}),		

	--Enhancement
	ShamanisticFocus						= Create({ Type = "Spell", ID = 43338	}),	
	StoneskinTotem							= Create({ Type = "Spell", ID = 8071, useMaxRank = true		}),	
	LightningShield							= Create({ Type = "Spell", ID = 324, useMaxRank = true		}),	
	StrengthofEarthTotem					= Create({ Type = "Spell", ID = 8075, useMaxRank = true		}),	
	GhostWolf								= Create({ Type = "Spell", ID = 2645	}),	
	WaterBreathing							= Create({ Type = "Spell", ID = 131		}),	
	FrostResistanceTotem					= Create({ Type = "Spell", ID = 8181	}),	
	FarSight								= Create({ Type = "Spell", ID = 6196	}),
	FlametongueTotem						= Create({ Type = "Spell", ID = 8227	}),	
	FireResistanceTotem						= Create({ Type = "Spell", ID = 8184	}),
	WaterWalking							= Create({ Type = "Spell", ID = 546		}),		
	GroundingTotem							= Create({ Type = "Spell", ID = 8177	}),	
	NatureResistanceTotem					= Create({ Type = "Spell", ID = 10595	}),	
	WindfuryTotem							= Create({ Type = "Spell", ID = 8512, useMaxRank = true	}),	
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
	FireElementalTotem						= Create({ Type = "Spell", ID = 2894	}),		
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
    EarthShield1							= Create({ Type = "Spell", ID = 974	, isRank = 1 	}),	
    EarthShield2							= Create({ Type = "Spell", ID = 32593	, isRank = 2 	}),	
    EarthShield3							= Create({ Type = "Spell", ID = 32594	, isRank = 3 	}),		
    WaterShield								= Create({ Type = "Spell", ID = 24398	}),	
    NaturesSwiftness						= Create({ Type = "Spell", ID = 16188	}),	
	
	--Misc
	SuperHealingPotion						= Create({ Type = "Potion", ID = 22829, QueueForbidden = true }),
	DualWield								= Create({ Type = "Spell", ID = 30798, Hidden = true }),
	HealingWay								= Create({ Type = "Spell", ID = 29203, Hidden = true }),
}

local A                                     = setmetatable(Action[Action.PlayerClass], { __index = Action })

local player = "player"
local target = "target"
local pet = "pet"
local targettarget = "targettarget"
local focustarget = "focustarget"
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
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    IsSpellIsCast                           = {[A.LesserHealingWave:Info()] = "LesserHealingWave", [A.HealingWave:Info()] = "HealingWave", [A.ChainHeal:Info()] = "ChainHeal"}, 
    LastPrimaryUnitGUID     				= nil, 
    LastPrimaryUnitID        				= nil, 
    LastPrimarySpellName     				= nil, 
    LastPrimarySpellID        				= nil,
    SyncUsed								= false, 
	TotemsRecalled							= true,
}

local ImmuneFire = {
[6073] = true, -- Searing Infernal
[2760] = true, -- Burning Exile
[5850] = true, -- Blazing Elemental
[16491] = true, -- Mana Feeder
[6520] = true, -- Scorching Elemental
[17307] = true, -- Nazan
}

local ImmuneNature = {
[2762] = true, -- Thundering Exile
[2592] = true, -- Rumbling Exile
[2735] = true, -- Lesser Rock Elemental
[92] = true, -- Rock Elemental
[2736] = true, -- Greater Rock Elemental
[2752] = true, -- Rumbler (Greater Rock Elemental rarespawn)
[2919] = true, -- Fam'retor Guardian (Badlands quest enemy)
[9396] = true, -- Ground Pounder
[5855] = true, -- Magma Elemental
[8278] = true, -- Smoulder (Rarespawn)
[16491] = true, -- Mana Feeder
}		

local function TotemBuffInRange()
	
	return Unit(player):HasBuffs({
	8184,		--Fire Resistance Rank 1
	10534, 		--Fire Resistance Rank 2
	10535, 		--Fire Resistance Rank 3
	25562, 		--Fire Resistance Rank 4
	
	124,		--Flametongue Rank 1
	285,		--Flametongue Rank 2
	543, 		--Flametongue Rank 3
	1683,  		--Flametongue Rank 4
	2637,   	--Flametongue Rank 5
	
	8182, 		--Frost Resistance Rank 1
	10476,   	--Frost Resistance Rank 2
	10477,  	--Frost Resistance Rank 3
	25559,  	--Frost Resistance Rank 4
	
	8836,   	--Grace of Air Rank 1
	10626,   	--Grace of Air Rank 2
	25360,   	--Grace of Air Rank 3
	
	8178,  		--Grounding
	
	10596,   	--Nature Resistance Rank 1
	10598,   	--Nature Resistance Rank 2
	10599,   	--Nature Resistance Rank 3
	25573,  	--Nature Resistance Rank 4
	
	8072, 	--Stoneskin Rank 1
	8156,  	--Stoneskin Rank 2
	8157,  	--Stoneskin Rank 3
	10403, 	--Stoneskin Rank 4
	10404,  --Stoneskin Rank 5
	10405,  --Stoneskin Rank 6
	25506,  --Stoneskin Rank 7
	25507, 	--Stoneskin Rank 8
	
	8076, 	--Strenth of Earth Rank 1
	8162, 	--Strenth of Earth Rank 2
	8163,  	--Strenth of Earth Rank 3
	10441,	--Strenth of Earth Rank 4
	25362, 	--Strenth of Earth Rank 5
	25527, 	--Strenth of Earth Rank 6

	1783,		--Windfury Rank 1
	563,		--Windfury Rank 2
	564,		--Windfury Rank 3
	2638,		--Windfury Rank 4
	2639, 		--Windfury Rank 5
	
	15108,  	--Windwall Rank 1
	15109,  	--Windwall Rank 2
	15110,  	--Windwall Rank 3
	25576, 		--Windwall Rank 4
	
	5672, 	--Healing Stream Rank 1
	6371, 	--Healing Stream Rank 2
	6372, 	--Healing Stream Rank 3
	10460, 	--Healing Stream Rank 4
	10461, 	--Healing Stream Rank 5
	25566, 	--Healing Stream Rank 6
	
	5677,   	--Mana Spring Rank 1
	10491,   	--Mana Spring Rank 2
	10493,   	--Mana Spring Rank 3
	10494,  	--Mana Spring Rank 4
	25569,  	--Mana Spring Rank 5

	16191, 		--Mana Tide Rank 1
	17355,  	--Mana Tide Rank 2
	17360,   	--Mana Tide Rank 3
	

	25909,  	--Tranquil Air
	
	24853,	--Enamored Water Spirit (Trinket)
	
	30708,	--Totem of Wrath
	
	2895,		--Wrath of Air Totem
	}) > 0 
	
end

-- Tracks destination unit of the casting spells to prevent by stopcasting overhealing 
local function CastStart(event, ...)
    local unitID, _, spellID = ...
    if unitID == player and spellID then 
        local spellName = GetSpellInfo(spellID)
        if spellName and Temp.IsSpellIsCast[spellName] then 
            Temp.LastPrimaryUnitGUID     = (IsUnitFriendly("mouseover") and UnitGUID("mouseover")) or (IsUnitFriendly("target") and UnitGUID("target")) or UnitGUID(player)
            Temp.LastPrimaryUnitID        = TeamCacheFriendlyGUIDs[Temp.LastPrimaryUnitGUID]
            Temp.LastPrimarySpellName     = spellName 
            Temp.LastPrimarySpellID        = spellID
        end 
    end 
end 

local function CastStop(event, ...)
    if Temp.LastPrimaryUnitGUID then     
        local unitID = ...
        if unitID == player then 
            Temp.LastPrimaryUnitGUID     = nil 
            Temp.LastPrimaryUnitID        = nil 
            Temp.LastPrimarySpellName     = nil 
            Temp.LastPrimarySpellID        = nil 
        end 
    end 
end 

local function CanStopCastingOverHeal(unit, unitGUID)
    -- @return boolean 
    if GetToggle(1, "StopCast") and Temp.LastPrimaryUnitGUID then
        local castLeftSeconds, castDonePercent, _, spellName = Unit(player):IsCastingRemains()
        if castLeftSeconds > 0 and castLeftSeconds <= 0.35 and spellName == Temp.LastPrimarySpellName and (Temp.LastPrimaryUnitID or (unit and ((unitGUID or UnitGUID(unit)) == Temp.LastPrimaryUnitGUID))) then
            local unit = Temp.LastPrimaryUnitID or unit
            if Unit(unit):HealthPercent() >= 100 then 
                return true 
            end 
            
            local Key = Temp.IsSpellIsCast[spellName]
            local ObjKey
            for i = 0, huge do 
                if i == 0 then 
                    ObjKey = Key
                else 
                    ObjKey = Key .. i
                end 
                
                if A[ObjKey] then 
                    if A[ObjKey].ID == Temp.LastPrimarySpellID then 
                        return not A[ObjKey]:PredictHeal(unit, nil, unitGUID)
                    end 
                else 
                    break 
                end 
            end 
        end 
    end 
end 

--########################
--### NEARBY BREAKABLE ###
--########################

function NearbyBreakable(unit)
	local nearbybreakable = 0
	local NearbyIsBreakable = MultiUnits:GetActiveUnitPlates()
	if NearbyIsBreakable then  
		for NearbyIsBreakable_unit in pairs(NearbyIsBreakable) do             
			if Unit(NearbyIsBreakable_unit):GetRange() <= 10 and Unit(NearbyIsBreakable_unit):HasDeBuffs("BreakAble") > 0 then 
				nearbybreakable = 1
			end         
		end 
	end
    
    if nearbybreakable == 1 then 
		return true else 
		return false 
	end
end 

--######################
--### MANATIDE CHECK ###
--######################

local function ManaTideCheck()
        
    local current_party_mana = 0;
    local total_party_mana = 0;
    local ManaTide = A.GetToggle(2, "ManaTide")
    
    if UnitPowerType("player") == 0 then
        current_party_mana = current_party_mana + UnitPower("player" , 0);
        total_party_mana = total_party_mana + UnitPowerMax("player" , 0);
    end
    if UnitPowerType("party1") == 0 then
        current_party_mana = current_party_mana + UnitPower("party1" , 0);
        total_party_mana = total_party_mana + UnitPowerMax("party1" , 0);
    end
    if UnitPowerType("party2") == 0 then
        current_party_mana = current_party_mana + UnitPower("party2" , 0);
        total_party_mana = total_party_mana + UnitPowerMax("party2" , 0);
    end
    if UnitPowerType("party3") == 0 then
        current_party_mana = current_party_mana + UnitPower("party3" , 0);
        total_party_mana = total_party_mana + UnitPowerMax("party3" , 0);
    end
    if UnitPowerType("party4") == 0 then
        current_party_mana = current_party_mana + UnitPower("party4" , 0);
        total_party_mana = total_party_mana + UnitPowerMax("party4" , 0);
    end
    
    local TotalPercent = math.ceil(current_party_mana/total_party_mana*100)
    
    if TotalPercent < ManaTide then
        ShouldManaTide = true
    else
        ShouldManaTide = false
    end
    
    return ShouldManaTide
end

--###################
--### WEAPON SYNC ###
--###################

local function DoWeaponSync()
	local MHSwing = Player:GetSwing(1)
	local OHSwing = Player:GetSwing(2)
	local MHSwingMax = Player:GetSwingMax(1)
	local WeaponSync = A.GetToggle(2, "WeaponSync")	


	if MHSwing > MHSwingMax - 0.5 then 
		Temp.SyncUsed = false
	end

	if WeaponSync then --and A.DualWield:IsTalentLearned() then
		if MHSwing < MHSwingMax / 2 then
			if (OHSwing <= MHSwing) or ((MHSwing - 0.5) < OHSwing) then
				if not Temp.SyncUsed then
					Temp.SyncUsed = true					
					return A.SentryTotem					
				end
			end
		end
	end
end

--#########################
--### INTERRUPT / PURGE ###
--#########################
local function Interrupt(unit)
	local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = InterruptIsValid(unit, "Main", true, nil)
	local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()			
	
	local isEmergency = Unit(target):HealthPercent() > 0 and Unit(target):HealthPercent() <= 30	and IsUnitFriendly(target)
	
	if A.EarthShock:IsReady(unit, nil, nil, true) and IsUnitEnemy(unit) and useKick and not notInterruptable and castRemainsTime >= A.GetLatency() and not ImmuneNature[npcID] then 
		if SpecOverride == "Enhancement" or SpecOverride == "Elemental" or (SpecOverride == "Restoration" and not isEmergency) then
			return A.EarthShock 
		end  
	end 
end

local function Purge(unit)
	if A.Purge:IsReady(unit) and inCombat and IsUnitEnemy(unit) and AuraIsValid(unit, "UsePurge", "PurgeHigh")  then 
		if SpecOverride == "Enhancement" or SpecOverride == "Elemental" or (SpecOverride == "Restoration" and not isEmergency) then    	
			return A.Purge
		end
	end  
end


--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)

    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local RacialAllowed = A.GetToggle(1, "Racial")
	local combatTime = Unit(player):CombatTime()
	local UseAoE = A.GetToggle(2, "AoE")
	local SpecOverride = A.GetToggle(2, "SpecOverride")
	local ShieldType = A.GetToggle(2, "ShieldType")
	local ManaRune = A.GetToggle(2, "ManaRune")
	local InterruptTargetTarget = A.GetToggle(2, "InterruptTargetTarget")
	local NearbyBreakable = NearbyBreakable()

	local Trinket1Choice = A.GetToggle(2, "Trinket1Choice")
	local Trinket2Choice = A.GetToggle(2, "Trinket2Choice")
	local Trinket1Value = A.GetToggle(2, "Trinket1Value")
	local Trinket2Value = A.GetToggle(2, "Trinket2Value")
	
	local MainHandEnchant = A.GetToggle(2, "MainHandEnchant")
	local OffhandEnchant = A.GetToggle(2, "OffhandEnchant")
	
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
	local ShockInterrupt = A.GetToggle(2, "ShockInterrupt")
	
	local ChainHeal1 = A.GetToggle(2, "ChainHeal1")
	local ChainHeal3 = A.GetToggle(2, "ChainHeal3")
	local ChainHealMax = A.GetToggle(2, "ChainHeal5")
	local HealingWaveMax = A.GetToggle(2, "HealingWave12")
	local HealingWave10 = A.GetToggle(2, "HealingWave10")
	local HealingWave7 = A.GetToggle(2, "HealingWave7")
	local HealingWave1 = A.GetToggle(2, "HealingWave1")
	local LesserHealingWave5 = A.GetToggle(2, "LesserHealingWave5")
	local LesserHealingWaveMax = A.GetToggle(2, "LesserHealingWave7")					
	
	local ShamanisticRageMana = A.GetToggle(2, "ShamanisticRageMana")  
	local StopTwistingManaEnh = A.GetToggle(2, "StopTwistingManaEnh")
	local StopShocksManaEnh = A.GetToggle(2, "StopShocksManaEnh")
	local StopShocksManaEle = A.GetToggle(2, "StopShocksManaEle")	

	local npcID = select(6, Unit(target):InfoGUID())

    --###############################
	--##### POTIONS/HEALTHSTONE #####
	--###############################
	
	local function RecoveryItems()
		local UsePotions = A.GetToggle(1, "Potion")		
		local PotionController = A.GetToggle(2, "PotionController")

		if not Player:IsStealthed() then  
			local Healthstone = GetToggle(2, "HSHealth") 
			if Healthstone >= 0 then 
				local HealthStoneObject = DetermineUsableObject(player, true, nil, true, nil, A.HSGreater3, A.HSGreater2, A.HSGreater1, A.HS3, A.HS2, A.HS1, A.HSLesser3, A.HSLesser2, A.HSLesser1, A.HSMajor3, A.HSMajor2, A.HSMajor1, A.HSMinor3, A.HSMinor2, A.HSMinor1)
				if HealthStoneObject then 			
					if Healthstone >= 100 then -- AUTO 
						if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then 
							return HealthStoneObject:Show(icon)	
						end 
					elseif Unit(player):HealthPercent() <= Healthstone then 
						return HealthStoneObject:Show(icon)								 
					end 
				end 
			end 		
		end 
		
		if UsePotions and combatTime > 2 then
			if PotionController == "HealingPotion" then
				if CanUseHealingPotion(icon) then 
					return true
				end 
			end	
		end	

		--[[if CanUseManaRune(icon) then
			return true
		end]]
	end

	--################
	--### ENCHANTS ###
	--################	
	
	local function ImbueWeapon()
		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
		
		local WindfuryBuff = {[283] = true, [284] = true, [525] = true, [1669] = true, [2636] = true }
		local RockbiterBuff = {[29] = true, [6] = true, [3029] = true }	
		local FlametongueBuff = {[5] = true, [4] = true, [3] = true, [523] = true, [1665] = true, [1666] = true, [2634] = true }
		local FrostbrandBuff = {[2] = true, [12] = true, [524] = true, [1667] = true, [1668] = true, [2635] = true }		
		
		if not hasMainHandEnchant and Unit(player):HasBuffs(A.GhostWolf.ID) == 0 then
			if MainHandEnchant == "Windfury" then
				if A.WindfuryWeapon:IsReady(player) and ((WindfuryBuff[mainHandEnchantID] and mainHandExpiration <= 3000 and not inCombat) or not WindfuryBuff[mainHandEnchantID]) then
					return A.WindfuryWeapon:Show(icon)
				end
			elseif MainHandEnchant == "Rockbiter" then
				if A.RockbiterWeapon:IsReady(player) and ((RockbiterBuff[mainHandEnchantID] and mainHandExpiration <= 3000 and not inCombat) or not RockbiterBuff[mainHandEnchantID]) then
					return A.RockbiterWeapon:Show(icon)
				end		
			elseif MainHandEnchant == "Flametongue" then
				if A.FlametongueWeapon:IsReady(player) and ((FlametongueBuff[mainHandEnchantID] and mainHandExpiration <= 3000 and not inCombat) or not FlametongueBuff[mainHandEnchantID]) then
					return A.FlametongueWeapon:Show(icon)
				end		
			elseif MainHandEnchant == "Frostbrand" then
				if A.FrostbrandWeapon:IsReady(player) and ((FrostbrandBuff[mainHandEnchantID] and mainHandExpiration <= 3000 and not inCombat) or not FrostbrandBuff[mainHandEnchantID]) then
					return A.FrostbrandWeapon:Show(icon)
				end		
			end
		end
		
		if not hasOffHandEnchant and Unit(player):HasBuffs(A.GhostWolf.ID) == 0 then
			if OffhandEnchant == "Windfury" then
				if A.WindfuryWeapon:IsReady(player) and ((WindfuryBuff[offHandEnchantID] and offHandExpiration <= 3000 and not inCombat) or not WindfuryBuff[offHandEnchantID]) then
					return A.WindfuryWeapon:Show(icon)
				end
			elseif OffhandEnchant == "Rockbiter" then
				if A.RockbiterWeapon:IsReady(player) and ((RockbiterBuff[offHandEnchantID] and offHandExpiration <= 3000 and not inCombat) or not RockbiterBuff[offHandEnchantID]) then
					return A.RockbiterWeapon:Show(icon)
				end		
			elseif OffhandEnchant == "Flametongue" then
				if A.FlametongueWeapon:IsReady(player) and ((FlametongueBuff[offHandEnchantID] and offHandExpiration <= 3000 and not inCombat) or not FlametongueBuff[offHandEnchantID]) then
					return A.FlametongueWeapon:Show(icon)
				end		
			elseif OffhandEnchant == "Frostbrand" then
				if A.FrostbrandWeapon:IsReady(player) and ((FrostbrandBuff[offHandEnchantID] and offHandExpiration <= 3000 and not inCombat) or not FrostbrandBuff[offHandEnchantID]) then
					return A.FrostbrandWeapon:Show(icon)
				end		
			end
		end	
	end

	--########################
	--### ELEMENTAL SHIELD ###
	--########################

	local function ElementalShield()
		if A.WaterShield:IsReady(player) and ShieldType == "Water" and Unit(player):HasBuffs(A.WaterShield.ID) == 0 then
			return A.WaterShield:Show(icon)
		end
		
		if A.LightningShield:IsReady(player) and ShieldType == "Lightning" and Unit(player):HasBuffs(A.LightningShield.ID) == 0 and not ImmuneNature[npcID] then
			return A.LightningShield:Show(icon)
		end	

		local EarthShieldActive = HealingEngine.GetBuffsCount(A.EarthShield1.ID, nil, player) >= 1 or HealingEngine.GetBuffsCount(A.EarthShield2.ID, nil, player) >= 1 or HealingEngine.GetBuffsCount(A.EarthShield3.ID, nil, player) >= 1

		if A.EarthShield1:IsReady(focus) and Unit(focus):IsExists() and not EarthShieldActive then 
			return A.EarthShield1:Show(icon)
		end

	end
	
	--##############
	--### TOTEMS ###
	--##############		

	if A.TotemicCall:IsReady(player) and not inCombat and not TotemBuffInRange() then
		if (FireTotemTimeRemaining > A.GetGCD() or EarthTotemTimeRemaining > A.GetGCD() or WaterTotemTimeRemaining > A.GetGCD() or AirTotemTimeRemaining > A.GetGCD()) then
			return A.TotemicCall:Show(icon)
		end
	end	

	if A.TremorTotem:IsReady(player) and ActiveEarthTotem ~= A.TremorTotem:Info() then
		if FriendlyTeam():GetDeBuffs("Sleep", 30) > 0 or FriendlyTeam():GetDeBuffs("Fear", 30) > 0 then 
			return A.TremorTotem:Show(icon)
		end
		
		if A.MultiUnits:GetByRangeCasting(40, 1, nil, {"Fear", "Terror", "Bellowing Roar"}) >= 1 then
			return A.TremorTotem:Show(icon)
		end
		
	end   

	
	local function TotemHandler()
		
		local RecommendationTotem = A.GetToggle(2, "RecommendationTotem")
		if RecommendationTotem then
			for npc in pairs(ActiveUnitPlates) do 
			local npcIDAoE = select(6, Unit(npc):InfoGUID())
			local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, spellId                   = UnitCastingInfo(npc)
				if A.EarthbindTotem:IsReady(player) and EarthbindRecommendation[npcIDAoE] and ActiveEarthTotem ~= A.EarthbindTotem:Info() then
					return A.EarthbindTotem:Show(icon)
				end
				if A.StoneclawTotem:IsReady(player) and StoneclawRecommendation[npcIDAoE] and not StoneclawActive[ActiveEarthTotem] then
					return A.StoneclawTotem:Show(icon)
				end
				if A.FireResistanceTotem:IsReady(player) and FireResistanceRecommendation[npcIDAoE] and not FireResistanceActive[ActiveWaterTotem] then
					return A.FireResistanceTotem:Show(icon)
				end
				if A.FrostResistanceTotem:IsReady(player) and FrostResistanceRecommendation[npcIDAoE] and not FrostResistanceActive[ActiveFireTotem] then
					return A.FrostResistanceTotem:Show(icon)
				end
				if A.GroundingTotem:IsReady(player) and GroundingRecommendation[spellId] and ActiveAirTotem ~= A.GroundingTotem:Info() then
					return A.GroundingTotem:Show(icon)
				end
				if A.NatureResistanceTotem:IsReady(player) and NatureResistanceRecommendation[npcIDAoE] and not NatureResistanceActive[ActiveAirTotem] then
					return A.NatureResistanceTotem:Show(icon)
				end
				if A.StoneskinTotem:IsReady(player) and StoneskinRecommendation[npcIDAoE] and not StoneskinActive[ActiveEarthTotem] then
					return A.StoneskinTotem:Show(icon)
				end
				if A.WindwallTotem:IsReady(player) and WindwallRecommendation[npcIDAoE] and not WindwallActive[ActiveAirTotem] then
					return A.WindwallTotem:Show(icon)
				end
				if A.DiseaseCleansingTotem:IsReady(player) and DiseaseCleansingRecommendation[npcIDAoE] and ActiveWaterTotem ~= A.DiseaseCleansingTotem:Info() then
					return A.DiseaseCleansingTotem:Show(icon)
				end
				if A.PoisonCleansingTotem:IsReady(player) and PoisonCleansingRecommendation[npcIDAoE] and ActiveWaterTotem ~= A.PoisonCleansingTotem:Info() then
					return A.PoisonCleansingTotem:Show(icon)
				end
				if A.TremorTotem:IsReady(player) and TremorRecommendation[npcIDAoE] and ActiveEarthTotem ~= A.TremorTotem:Info() then
					return A.TremorTotem:Show(icon)
				end
				if A.FireElementalTotem:IsReady(player) and FireElementalRecommendation[npcIDAoE] and ActiveFireTotem ~= A.FireElementalTotem:Info() then
					return A.FireElementalTotem:Show(icon)
				end
				if A.EarthElementalTotem:IsReady(player) and EarthElementalRecommendation[npcIDAoE] and ActiveEarthTotem ~= A.EarthElementalTotem:Info() then
					return A.EarthElementalTotem:Show(icon)
				end
			end
		
		end
	
		if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and ActiveFireTotem ~= A.FireElementalTotem:Info() then
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
			elseif FireTotem == "TotemofWrath" and A.TotemofWrath:IsReady(player) then
				return A.TotemofWrath:Show(icon)					
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

		if WeaveWF and (Player:ManaPercentage() >= StopTwistingManaEnh or Unit(player):HasBuffs(A.ShamanisticRage.ID, true) > 0 or A.ShamanisticRage:IsReadyByPassCastGCD()) and A.WindfuryTotem:IsReady(player) and A.WindfuryTotem:GetSpellTimeSinceLastCast() >= 10 and inCombat and AirTotem ~= "Windfury" then
			return A.WindfuryTotem:Show(icon)
		end

		if (AirTotemTimeRemaining <= A.GetGCD() * 4 and not WeaveWF) or (WeaveWF and WindfuryActive[ActiveAirTotem] and (Player:ManaPercentage() >= StopTwistingManaEnh or Unit(player):HasBuffs(A.ShamanisticRage.ID, true) > 0 or A.ShamanisticRage:IsReadyByPassCastGCD())) then
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

			local isManaSave = HealingEngine.IsManaSave(unit)
			local isEmergency = Unit(unit):HealthPercent() > 0 and Unit(unit):HealthPercent() <= 30	and A.HealingWave:IsInRange(unit) 
			local unitGUID                                     = UnitGUID(unit)
		
	        if CanStopCastingOverHeal(unit) then 
	            return A:Show(icon, ACTION_CONST_STOPCAST)
	        end 

			--Emergency
			-- Nature's Swiftness + Healing Wave R12 for burst

			if A.Trinket1:IsReady(player) and inCombat then 
				if Trinket1Choice == "Health" and Unit(unit):HealthPercent() <= Trinket1Value then 
					return A.Trinket1:Show(icon)
				elseif Trinket1Choice == "Mana" and Player:ManaPercentage() <= Trinket1Value then 
					return A.Trinket1:Show(icon)
				end
			end

			if A.Trinket2:IsReady(player) and inCombat then 
				if Trinket2Choice == "Health" and Unit(unit):HealthPercent() <= Trinket2Value then 
					return A.Trinket2:Show(icon)
				elseif Trinket2Choice == "Mana" and Player:ManaPercentage() <= Trinket2Value then 
					return A.Trinket2:Show(icon)
				end
			end			

			if isEmergency and inCombat then

                -- Nature's Swiftness 
                if A.NaturesSwiftness:IsReady(player) then 
                    return A.NaturesSwiftness:Show(icon)
                end 

				if A.HealingWave:IsReady(unit) and Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) > 0 then
					return A.HealingWave:Show(icon)
				end

				if A.NaturesSwiftness:GetCooldown() > A.GetGCD() and Unit(player):HasBuffs(A.NaturesSwiftness.ID) == 0 and A.GetToggle(1, "Racial") then
					if A.BloodFury:IsReady(player) then
						return A.BloodFury:Show(icon)
					end
					
					if A.Berserking:IsReady(player) then
						return A.Berserking:Show(icon)
					end
				end

				if A.LesserHealingWave:IsReady(unit) and Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) == 0 then 
					return A.LesserHealingWave:Show(icon)
				end

	        end  

			--TT Interrupt
			
			local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = InterruptIsValid(focustarget, "Main", true, nil)	

			local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()				
			
			if A.EarthShock:IsReady(focustarget, nil, nil, true) and InterruptTargetTarget and IsUnitEnemy(focustarget) and useKick and not notInterruptable and castRemainsTime >= A.GetLatency() and not ImmuneNature[npcID] and not isEmergency then 
				if castRemainsTime < secondsLeft then
					return A.EarthShock:Show(icon)
				end
			end
			
			if A.Purge:IsReady(targettarget) and InterruptTargetTarget and inCombat and IsUnitEnemy(targettarget) and AuraIsValid(targettarget, "UsePurge", "PurgeHigh") then 
				return A.Purge:Show(icon)
			end

			--Just consume Nature's Swiftness buff if someone else snipes heal first.
			if Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) > 0 and Unit(unit):HealthPercent() <= 60 then
				return A.HealingWave:Show(icon)
			end
					
			-- Maintain Earth Shield on tank
			--[[local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")
	        if A.EarthShield:IsReady() and A.LastPlayerCastID ~= A.EarthShield.ID and ActiveEarthShield() == 0 then
	            for i = 1, #CurrentTanks do 
	                if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
                      	if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffs(A.EarthShield.ID, true) == 0 then 
							if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
								HealingEngine.SetTarget(CurrentTanks[i].Unit)  
								break
							end 	                                                                    
	                    end                    
	                end                
	            end    
	        end]]

			
			-- Maintain best totems
			if TotemHandler() then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) and ActiveFireTotem ~= A.FireElementalTotem:Info() and not FrostResistanceActive[ActiveFireTotem] then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 and not NearbyBreakable then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 and not NearbyBreakable then
						return A.MagmaTotem:Show(icon)
					end
					if A.SearingTotem:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) and not ImmuneFire[npcID] then
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
			local ManaTideCheck = ManaTideCheck()
			if A.ManaTideTotem:IsReady(player) and ManaTideCheck and inCombat and HealingEngine.GetBossHealthPercent() > 1 then
				return A.ManaTideTotem:Show(icon)
			end

			--Cleanse
			local getmembersAll = HealingEngine.Data.SortedUnitIDs			
			if A.CurePoison:IsReady(unit) then
				for i = 1, #getmembersAll do 
					if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel poisons") then  
                        if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
                          HealingEngine.SetTarget(getmembersAll[i].Unit) 
                          break
                        end 					                									
					end				
				end
			end
			
			if A.CureDisease:IsReady(unit) then
				for i = 1, #getmembersAll do 
					if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel diseases") then  
                        if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
                          HealingEngine.SetTarget(getmembersAll[i].Unit) 
                          break
                        end 					                									
					end				
				end
			end			

			if A.CurePoison:IsReady(unit) and AuraIsValid(unit, "UseDispel", "Dispel poisons") then
				return A.CurePoison:Show(icon)
			end

			if A.CureDisease:IsReady(unit) and AuraIsValid(unit, "UseDispel", "Dispel diseases") then
				return A.CureDisease:Show(icon)
			end
			
			if A.GiftoftheNaaru:IsReady(unit) and RacialAllowed and Unit(unit):HealthPercent() <= 50 then 
				return A.GiftoftheNaaru:Show(icon)
			end
			
			--Chain Heal
			local numGroupMembers = GetNumGroupMembers()
			local RaidChainHealMeleeOnly = A.GetToggle(2, "RaidChainHealMeleeOnly")
			if A.ChainHeal:IsReady(unit) and not isMoving then 
				if (numGroupMembers > 1 and numGroupMembers <= 5) or (numGroupMembers >= 6 and not RaidChainHealMeleeOnly) then	
					if Unit(unit):HealthPercent() <= ChainHealMax and A.HealingEngine.GetBelowHealthPercentUnits(ChainHealMax, 40) >= 2 and not isManaSave then
						return A.ChainHeal:Show(icon)
					elseif Unit(unit):HealthPercent() <= ChainHeal3 and A.HealingEngine.GetBelowHealthPercentUnits(ChainHeal3, 40) >= 2 and not isManaSave then
						return A.ChainHeal3:Show(icon)
					elseif Unit(unit):HealthPercent() <= ChainHeal1 and A.HealingEngine.GetBelowHealthPercentUnits(ChainHeal1, 40) >= 2 then
						return A.ChainHeal1:Show(icon)
					end	
				elseif numGroupMembers >= 6 and RaidChainHealMeleeOnly then
					if Unit(unit):HealthPercent() <= ChainHealMax and A.HealingEngine.HealingByRange(40, A.ChainHeal, true, true) and not isManaSave then
						return A.ChainHeal:Show(icon)
					elseif Unit(unit):HealthPercent() <= ChainHeal3 and A.HealingEngine.HealingByRange(40, A.ChainHeal, true, true) >= 2 and not isManaSave then
						return A.ChainHeal3:Show(icon)
					elseif Unit(unit):HealthPercent() <= ChainHeal1 and A.HealingEngine.HealingByRange(40, A.ChainHeal, true, true) >= 2 then
						return A.ChainHeal1:Show(icon)
					end	
				end											
			end 

			-- Healing Wave ST
			if A.HealingWave:IsReady(unit) and not isMoving then 
				if Unit(unit):HealthPercent() <= HealingWaveMax and not isManaSave then
					return A.HealingWave:Show(icon)
				elseif Unit(unit):HealthPercent() <= HealingWave10 and not isManaSave then 
					return A.HealingWave10:Show(icon)
				elseif Unit(unit):HealthPercent() <= HealingWave7 then 
					return A.HealingWave7:Show(icon)
				elseif Unit(unit):HealthPercent() <= HealingWave1 then 
					return A.HealingWave1:Show(icon)
				end
			end

			--Keep Healing Way active
			if A.IsTalentLearned(29206) then -- Healing Way
				local HealingWay = A.GetToggle(2, "HealingWay")
				local HealingWayFocus = A.GetToggle(2, "HealingWayFocus")
				if A.HealingWave:IsReady(focus) and HealingWayFocus and Unit(focus):IsExists() and IsUnitFriendly(focus) and (Unit(focus):HasBuffs(A.HealingWay.ID) <= 2 or Unit(focus):HasBuffsStacks(A.HealingWay.ID) < 3) then 
					return A.HealingWave1:Show(icon)
				end
				
				if A.HealingWave:IsReady(unit) and HealingWay and Unit(unit):IsTank() and Unit(unit):HasBuffs(A.HealingWay.ID) <= 2 and Unit(unit):HasBuffsStacks(A.HealingWay.ID) < 3  then
					return A.HealingWave1:Show(icon)
				end
			end

			-- Lesser Healing Wave
			if A.LesserHealingWave:IsReady(unit) and not isMoving then --and LesserHealingWaveDyn:PredictHeal(unit) then 
				if Unit(unit):HealthPercent() <= LesserHealingWaveMax and not isManaSave then 
					return A.LesserHealingWave:Show(icon)
				elseif Unit(unit):HealthPercent() <= LesserHealingWave5 then 
					return A.LesserHealingWave5:Show(icon)
				end
			end
			
		end
		
	end
	
	--#######################
	--### DAMAGE ROTATION ###
	--#######################
	
	local function DamageRotation(unit) 	
	
		local Interrupts = Interrupt(unit)
		if Interrupts then
			return Interrupts:Show(icon)
		end
		
		local Purges = Purge(unit)
		if Purges then
			return Purges:Show(icon)
		end	
	
		--#####################	
		--##### ELEMENTAL #####
		--#####################
	
		if SpecOverride == "Elemental" or SpecOverride == "Restoration" or (SpecOverride == "AUTO" and A.GetCurrentSpecialization() == 262) then	
	--Single Target
		-- Maintain Totem of Wrath, Mana Spring Totem, and Wrath of Air Totem
			if TotemHandler() and not isMoving and A.FlameShock:IsInRange(unit) then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) and ActiveFireTotem ~= A.FireElementalTotem:Info() and not FrostResistanceActive[ActiveFireTotem] then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 and A.MultiUnits:GetByRangeAreaTTD(10) > 5 and not NearbyBreakable  then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 and A.MultiUnits:GetByRangeAreaTTD(10) > 5 and not ImmuneFire[npcID] and not NearbyBreakable then
						return A.MagmaTotem:Show(icon)
					end
					if A.TotemofWrath:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) then
						return A.TotemofWrath:Show(icon)
					end					
					if A.SearingTotem:IsReady(player) and inCombat and (A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE or not A.MagmaTotem:IsReady(player)) and not ImmuneFire[npcID] then
						return A.SearingTotem:Show(icon)
					end
				end
				if ActiveFireTotem == A.MagmaTotem:Info() then
					if A.MultiUnits:GetByRangeInCombat(10, 2) < 2 or not UseAoE then
						if A.TotemofWrath:IsReady(player) then
							return A.TotemofWrath:Show(icon)
						elseif A.SearingTotem:IsReady(player) and not A.TotemofWrath:IsReady(player) then
							return A.SearingTotem:Show(icon)
						end
					end
				end
			end			
			
			if WaterTotem == "AUTO" and WaterTotemTimeRemaining <= A.GetGCD() * 4 and not isMoving and A.FlameShock:IsInRange(unit) then
				if A.ManaSpringTotem:IsReady(player) then
					return A.ManaSpringTotem:Show(icon)
				end
			end
			
			if AirTotem == "AUTO" and AirTotemTimeRemaining <= A.GetGCD() * 4 and not isMoving and A.FlameShock:IsInRange(unit) then
				if A.WrathofAirTotem:IsReady(player) then
					return A.WrathofAirTotem:Show(icon)
				end
			end			
			
			-- Cast Fire Elemental Totem before Bloodlust
			if RacialAllowed then
				if A.BloodFury:IsReady(player) and BurstIsON(unit) then
					return A.BloodFury:Show(icon)
				end
				
				if A.Berserking:IsReady(player) and BurstIsON(unit) then
					return A.Berserking:Show(icon)
				end
			end

			--Trinket 1
			if A.Trinket1:IsReady(player) and BurstIsON(unit) and SpecOverride ~= "Restoration" then
				return A.Trinket1:Show(icon)    
			end
			
			--Trinket 2
			if A.Trinket2:IsReady(player) and BurstIsON(unit) and SpecOverride ~= "Restoration" then
				return A.Trinket2:Show(icon)    
			end					
		
			if A.FrostShock:IsReady(unit) and Unit(target):IsMelee() and UnitIsUnit(targettarget, player) and Unit(unit):HasBuffs("AllCC") == 0 then
				return A.FrostShock:Show(icon)
			end
		
		-- Use Elemental Mastery with Chain Lightning
			if A.ChainLightning:IsReady(unit) and Unit(player):HasBuffs(A.ElementalMastery.ID, true) > 0 and not ImmuneNature[npcID] then 
				return A.ChainLightning:Show(icon)
			end
			if A.ElementalMastery:IsReady(player) and A.ChainLightning:GetCooldown() <= A.GetGCD() and Player:IsCasting() ~= A.ChainLightning:Info() and BurstIsON(unit) and not ImmuneNature[npcID] then
				return A.ElementalMastery:Show(icon)
			end
		-- Chain Lightning
			if A.ChainLightning:IsReady(unit) and UseAoE and not isMoving and not ImmuneNature[npcID] then
				if (Unit(unit):IsBoss() and Unit(unit):HealthPercent() <= (Player:ManaPercentage() + 30)) or not Unit(unit):IsBoss() then
					return A.ChainLightning:Show(icon)
				end
			end
		-- Flame Shock while moving
			if A.FlameShock:IsReady(unit) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.ElementalMastery.ID, true) == 0 and Unit(unit):TimeToDie() >= 12 and Player:ManaPercentage() >= StopShocksManaEle and not ShockInterrupt and not ImmuneFire[npcID] then
				return A.FlameShock:Show(icon)
			end
			if A.EarthShock:IsReady(unit) and Player:ManaPercentage() >= StopShocksManaEle and not ShockInterrupt and not ImmuneNature[npcID] then
				return A.EarthShock:Show(icon)
			end
			
		-- Lightning Bolt
			if A.LightningBolt:IsReady(unit) and not isMoving and not ImmuneNature[npcID] then
				return A.LightningBolt:Show(icon)
			end
	
		end
		
		--#######################	
		--##### ENHANCEMENT #####
		--#######################
	
		if SpecOverride == "Enhancement" or (SpecOverride == "AUTO" and A.GetCurrentSpecialization() == 263) then		
		
		-- Windfury Weapon on both weapons
		
		
		-- Maintain Strength of Earth Totem, Mana Spring Totem, Searing Totem
			if TotemHandler() and A.FlameShock:IsInRange(unit) then
				return true
			end		

			if FireTotem == "AUTO" and A.FlameShock:IsInRange(unit) and ActiveFireTotem ~= A.FireElementalTotem:Info() and (not ImmuneFire[npcID] or not FrostResistanceActive[ActiveFireTotem]) then -- FlameShock same range as SearingTotem
				if UseAoE and A.FireNovaTotem:IsReady(player) and (A.MultiUnits:GetByRangeInCombat(10, 2) >= 2 or not WeaveWF) and A.MultiUnits:GetByRangeAreaTTD(10) > 5 and not NearbyBreakable then
					return A.FireNovaTotem:Show(icon)
				end
				if FireTotemTimeRemaining <= A.GetGCD() * 4 and not FireNovaActive[ActiveFireTotem] and not A.FireNovaTotem:IsSpellLastCastOrGCD() then
					if UseAoE and A.MagmaTotem:IsReady(player) and A.MultiUnits:GetByRangeInCombat(8, 2) >= 2 and A.MultiUnits:GetByRangeAreaTTD(10) > 5 and not NearbyBreakable then
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
			if RacialAllowed and A.Stormstrike:IsInRange() then
				if A.BloodFury:IsReady(player) and BurstIsON(unit) then
					return A.BloodFury:Show(icon)
				end
				
				if A.Berserking:IsReady(player) and BurstIsON(unit) then
					return A.Berserking:Show(icon)
				end
			end
			
			--Trinket 1
			if A.Trinket1:IsReady(player) and BurstIsON(unit) then
				return A.Trinket1:Show(icon)    
			end
			
			--Trinket 2
			if A.Trinket2:IsReady(player) and BurstIsON(unit) then
				return A.Trinket2:Show(icon)    
			end				
		
		-- Weapon sync ??? Jesus Christ...
			local DoWeaponSync = DoWeaponSync()
			if DoWeaponSync then 
				return DoWeaponSync:Show(icon)
			end
		
		-- Shamanistic Rage without capping mana
			if A.ShamanisticRage:IsReady(player) and A.Stormstrike:IsInRange() and Player:ManaPercentage() <= ShamanisticRageMana and Unit(unit):TimeToDie() >= 15 then
				return A.ShamanisticRage:Show(icon)
			end
		
		-- Stormstrike
			if A.Stormstrike:IsReady(unit) then
				return A.Stormstrike:Show(icon)
			end
			
		-- Flame Shock / Earth Shock if target already has Flame Shock dot
			if A.FlameShock:IsReady(unit) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.ElementalMastery.ID, true) == 0 and Unit(unit):TimeToDie() >= 12 and (Player:ManaPercentage() >= StopShocksManaEnh or Unit(player):HasBuffs(A.ShamanisticRage.ID, true) > 0 or A.ShamanisticRage:IsReadyByPassCastGCD()) and not ShockInterrupt and not ImmuneFire[npcID] then
				return A.FlameShock:Show(icon)
			end
			if A.EarthShock:IsReady(unit) and (Player:ManaPercentage() >= StopShocksManaEnh or Unit(player):HasBuffs(A.ShamanisticRage.ID, true) > 0 or A.ShamanisticRage:IsReadyByPassCastGCD()) and not ShockInterrupt and not ImmuneNature[npcID] then
				return A.EarthShock:Show(icon)
			end		
		
		-- If not totem twisting, use Fire Nova Totem, then recast Searing Totem when Fire Nova explodes.
	
		end 
	end

	if ImbueWeapon() then 
		return true 
	end

	if ElementalShield() then 
		return true 
	end

	if inCombat then 
		if RecoveryItems() then
			return true
		end
	end


    -- End on EnemyRotation()
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
