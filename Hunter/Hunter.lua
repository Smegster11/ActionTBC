--#############################
--##### TRIP'S TBC HUNTER #####
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
local AuraType									= LibStub("LibAuraTypes")

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

	--Beast Mastery
	AspectoftheBeast						= Create({ Type = "Spell", ID = 13161		}),
	AspectoftheCheetah						= Create({ Type = "Spell", ID = 5118		}),
    AspectoftheHawk							= Create({ Type = "Spell", ID = 13165		}),
    AspectoftheMonkey						= Create({ Type = "Spell", ID = 13163		}),
    AspectofthePack							= Create({ Type = "Spell", ID = 13159		}),
    AspectoftheViper						= Create({ Type = "Spell", ID = 34074		}),	
    AspectoftheWild							= Create({ Type = "Spell", ID = 20043		}),
    BeastLore								= Create({ Type = "Spell", ID = 1462		}),
    BestialWrath							= Create({ Type = "Spell", ID = 19574		}),
    CallPet									= Create({ Type = "Spell", ID = 883			}),
    DismissPet								= Create({ Type = "Spell", ID = 2641		}),
    EagleEye								= Create({ Type = "Spell", ID = 6197		}),
    EyesoftheBeast							= Create({ Type = "Spell", ID = 1002		}),
    FeedPet									= Create({ Type = "Spell", ID = 6991		}),
    Intimidation							= Create({ Type = "Spell", ID = 19577		}),
    KillCommand								= Create({ Type = "Spell", ID = 34026		}),	
    MendPet									= Create({ Type = "Spell", ID = 136			}),
    RevivePet								= Create({ Type = "Spell", ID = 982			}),
    ScareBeast								= Create({ Type = "Spell", ID = 1513		}),
    TameBeast								= Create({ Type = "Spell", ID = 1515		}),

	--Marksmanship
    AimedShot								= Create({ Type = "Spell", ID = 19434		}),    
	ArcaneShot								= Create({ Type = "Spell", ID = 3044		}),
    ConcussiveShot							= Create({ Type = "Spell", ID = 5116		}),
    DistractingShot							= Create({ Type = "Spell", ID = 20736		}),
    Flare									= Create({ Type = "Spell", ID = 1543		}),
    HuntersMark								= Create({ Type = "Spell", ID = 1130		}),
    MultiShot								= Create({ Type = "Spell", ID = 2643		}),
    RapidFire								= Create({ Type = "Spell", ID = 3045		}),
    ScatterShot								= Create({ Type = "Spell", ID = 19503		}),	
    ScorpidSting							= Create({ Type = "Spell", ID = 3043		}),
    SerpentSting							= Create({ Type = "Spell", ID = 1978		}),
    SilencingShot							= Create({ Type = "Spell", ID = 34490		}),	
    SteadyShot								= Create({ Type = "Spell", ID = 34120		}),	
    TrueshotAura							= Create({ Type = "Spell", ID = 19506		}),	
    ViperSting								= Create({ Type = "Spell", ID = 3034		}),	
    Volley									= Create({ Type = "Spell", ID = 1510		}),
	TranquilizingShot						= Create({ Type = "Spell", ID = 19801		}),

	--Survival
    Counterattack							= Create({ Type = "Spell", ID = 19306		}),
    Deterrence								= Create({ Type = "Spell", ID = 19263		}),
    Disengage								= Create({ Type = "Spell", ID = 781			}),
    ExplosiveTrap							= Create({ Type = "Spell", ID = 13813		}),
    FeignDeath								= Create({ Type = "Spell", ID = 5384		}),
    FreezingTrap							= Create({ Type = "Spell", ID = 1499		}),
	FreezingTrapDebuff						= Create({ Type = "Spell", ID = 3355 or 14308 }),
    FrostTrap								= Create({ Type = "Spell", ID = 13809		}),
    ImmolationTrap							= Create({ Type = "Spell", ID = 13795		}),
    Misdirection							= Create({ Type = "Spell", ID = 34477		}),	
    MongooseBite							= Create({ Type = "Spell", ID = 1495		}),
    RaptorStrike							= Create({ Type = "Spell", ID = 2973		}),
    Readiness								= Create({ Type = "Spell", ID = 23989		}),
    SnakeTrap								= Create({ Type = "Spell", ID = 34600		}),	
    TrackHidden								= Create({ Type = "Spell", ID = 19885		}),	
    WingClip								= Create({ Type = "Spell", ID = 2974		}),
    WyvernString							= Create({ Type = "Spell", ID = 19386		}),

	--Talents
	RapidKilling1							= Create({ Type = "Talent", ID = 34948		}),
	RapidKilling2							= Create({ Type = "Talent", ID = 34949		}),	

	--Misc
    Heroism									= Create({ Type = "Spell", ID = 32182		}),
    Bloodlust								= Create({ Type = "Spell", ID = 2825		}),
    Drums									= Create({ Type = "Spell", ID = 29529		}),
	SuperHealingPotion						= Create({ Type = "Potion", ID = 22829, QueueForbidden = true }),
	Healthstone								= Create({ Type = "Spell", ID = 19013		}),
	HastePotion								= Create({ Type = "Item", ID = 22838		}),	
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
[15691] = true,
[20478] = true, -- Arcane Servant
}	


--API - Spell
Pet:AddActionsSpells(3, {

	-- number accepted
	17253, 17255, 17256, 17257, 17258, 17259, 17260, 17261, 27050, -- Bite
	16827, 16828, 16829, 16830, 16831, 16832, 3010, 3009, 27049, -- Claw
	35290, 35291, 35292, 35293, 35294, 35295, 35296, 35297, 35298 -- Gore 
}, true)


local function AtRange(unit)
	-- @return boolean 
	return A.ArcaneShot:IsInRange(unit)
end 
AtRange = A.MakeFunctionCachedDynamic(AtRange)

local function InMelee(unit)
	-- @return boolean 
	return A.WingClip:IsInRange(unit)
end 
InMelee = A.MakeFunctionCachedDynamic(InMelee)

function Player:Casting_TimeMult(spellID) 
    local casti_speedmult = A_Unit(self.UnitID):CastTime(spellID)     
    return casti_speedmult 
end 

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
	local AutoSyncCDs = A.GetToggle(2, "AutoSyncCDs")
	local ManaSave = A.GetToggle(2, "ManaSave")
	local MendPet = A.GetToggle(2, "MendPet")
	local FreezingTrapPvE = A.GetToggle(2, "FreezingTrapPvE")
	local UseArcane = A.GetToggle(2, "UseArcane")
	local ArcaneShotMana = A.GetToggle(2, "ArcaneShotMana")
	local ConcussiveShotPvE = A.GetToggle(2, "ConcussiveShotPvE")
	local IntimidationPvE = A.GetToggle(2, "IntimidationPvE")
	local ProtectFreeze = A.GetToggle(2, "ProtectFreeze")
	local ReadinessController = A.GetToggle(2, "ReadinessController")
	local StingController = A.GetToggle(2, "StingController")
	local Experimental = A.GetToggle(2, "Experimental")
	local ManaViperStart = A.GetToggle(2, "ManaViperStart")
	local ManaViperEnd = A.GetToggle(2, "ManaViperEnd")
	local StaticMark = A.GetToggle(2, "StaticMark")
	local BossMark = A.GetToggle(2, "BossMark")	
	local HSHealth = A.GetToggle(2, "HSHealth")
	local ManaRune = A.GetToggle(2, "Runes")	

	local speed = UnitRangedDamage("player");
	local speedofWpn = UnitRangedDamage("player");
	local WpnBaseSpeed = speedofWpn * 1.38	
	local haste = speed / WpnBaseSpeed
	local ShootTimer = Player:GetSwingShoot() - 0.5
	local SteadyAfterHaste = Player:Casting_TimeMult(A.SteadyShot.ID) * haste
	local MultiAfterHaste = Player:Casting_TimeMult(A.MultiShot.ID) * haste

	local UsePotions = A.GetToggle(1, "Potions")		
	local PotionController = A.GetToggle(2, "PotionController")
	
	local PetCCd = LoC:Get("STUN") > 0 and LoC:Get("FEAR") > 0 and LoC:Get("SLEEP") > 0 and LoC:Get("DISORIENT") > 0 and LoC:Get("INCAPACITATE") > 0 and LoC:Get("ROOT") > 0 and LoC:Get("DISARM") > 0 and LoC:Get("CYCLONE") > 0 and LoC:Get("DAZE") > 0 and LoC:Get("FREEZE") > 0 and LoC:Get("CHARM") > 0 and LoC:Get("HORROR") > 0 and LoC:Get("PACIFY") > 0 and LoC:Get("PACIFYSILENCE") > 0 and LoC:Get("POLYMORPH") > 0 and LoC:Get("POSSESS") > 0 and LoC:Get("SAP") > 0 and LoC:Get("SNARE") > 0 and LoC:Get("CONFUSE") > 0 and LoC:Get("SILENCE") > 0 -- thanks warces for the list

	local AspectController = A.GetToggle(2, "AspectController")
		--AspectController[1] = Hawk
		--AspectController[2] = Cheetah
		--AspectController[3] = Viper
		
	local CDController = A.GetToggle(2, "CDController")
		--CDController[1] = BestialWrath
		--CDController[2] = RapidFire
		--CDController[3] = Readiness
		--CDController[4] = Racial (troll/orc)
	

	local BurnPhase = Unit(player):HasBuffs(A.Heroism.ID) > 0 or Unit(player):HasBuffs(A.Bloodlust.ID) > 0 or Unit(player):HasBuffs(A.Drums.ID) > 0
	local CheetahBuff = Unit(player):HasBuffs(A.AspectoftheCheetah.ID, true) > 0 or Unit(player):HasBuffs(A.AspectofthePack.ID, true) > 0

    --###############################
	--##### POTIONS/HEALTHSTONE #####
	--###############################
	
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

	if CanUseManaRune(icon) then
		return true
	end

    --#####################
	--##### INTERRUPT #####
	--#####################

	local castLeft, _, _, _, notKickAble = Unit("target" or "mouseover"):IsCastingRemains()
	if castLeft > A.GetGCD() + A.GetLatency() then 
		
		if not notKickAble and A.SilencingShot:IsReadyByPassCastGCD(unit, nil, nil, true) and A.SilencingShot:IsInRange() then 
			return A.SilencingShot:Show(icon)    
		end 

		if A.ScatterShot:IsReadyByPassCastGCD(unit, nil, nil, true) and A.ScatterShot:IsInRange() then 
			return A.ScatterShot:Show(icon)    
		end 
	end 
	
    --###############
	--##### OOC #####
	--###############	
	
	if AspectController[3] then --Viper
		if A.AspectoftheViper:IsReady(player) and Unit(player):HasBuffs(A.AspectoftheViper.ID, true) == 0 and Player:ManaPercentage() < ManaViperStart and not Player:IsMounted() then
			return A.AspectoftheViper:Show(icon)
		end
	end
	
	if AspectController[2] then --Cheetah
		if A.AspectoftheCheetah:IsReady(player) and Unit(player):HasBuffs(A.AspectoftheCheetah.ID, true) == 0 and ((Player:ManaPercentage() > ManaViperEnd and AspectController[3]) or not AspectController[3]) and not inCombat and not Player:IsMounted() and not A.IsUnitEnemy(target) then
			return A.AspectoftheCheetah:Show(icon)
		end
	end

	if A.CallPet:IsReady(player) and Pet:CanCall() then
		return A.CallPet:Show(icon)
	end
	
	if A.RevivePet:IsReady(player) and Unit(pet):IsDead() then
		return A.RevivePet:Show(icon)
	end
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
	local npcID = select(6, Unit(unit):InfoGUID())

        if A.TranquilizingShot:IsReady(unit) and AuraIsValid(unit, "UseExpelEnrage", "Enrage") then 
            return A.TranquilizingShot:Show(icon)
        end 
	
		if A.Misdirection:IsReady(player) and Unit(focus):IsExists() then
			if combatTime < 6 then
				return A.Misdirection:Show(icon)
			end
			
			if combatTime > 6 and not Unit(targettarget):IsTank() then
				return A.Misdirection:Show(icon)
			end
		end
	
		if AspectController[1] then --Hawk
			if A.AspectoftheHawk:IsReady(player) and Unit(player):HasBuffs(A.AspectoftheHawk.ID, true) == 0 and (inCombat or A.IsUnitEnemy(unit)) and ((Player:ManaPercentage() > ManaViperEnd and AspectController[3]) or not AspectController[3]) and not Player:IsMounted() then
				return A.AspectoftheHawk:Show(icon)
			end
		end

		if A.Readiness:IsReady(player) then
			if ReadinessController == "RapidFire" then
				if A.RapidFire:GetCooldown() >= 120-(30 * num(A.RapidKilling1:IsTalentLearned()))-(30 * num(A.RapidKilling2:IsTalentLearned())) then
					return A.Readiness:Show(icon)
				end
			end
			if ReadinessController == "Misdirection" then
				if A.Misdirection:GetCooldown() >= 10 then
					return A.Readiness:Show(icon)
				end
			end
		end

		if ProtectFreeze and Unit(target):HasDeBuffs(A.FreezingTrapDebuff.ID) > 0 and A.MultiUnits:GetActiveEnemies() >= 2 then
			return A:Show(icon, CONST.AUTOTARGET)
		end

		if A.FreezingTrap:IsReady(player) and FreezingTrapPvE and A.MultiUnits:GetActiveEnemies() >= 2 and A.MultiUnits:GetByRangeInCombat(5, 1, 5) >= 1 then
			return A.FreezingTrap:Show(icon)
		end

		if A.MendPet:IsReady(player) and Unit(pet):HealthPercent() < MendPet and Pet:IsActive() and Unit(pet):HasBuffs(A.MendPet.ID, true) == 0 then
			return A.MendPet:Show(icon)
		end

		if A.HuntersMark:IsReady(unit) and Unit(unit):HasDeBuffs(A.HuntersMark.ID) == 0 and ((Player:GetDeBuffsUnitCount(A.HuntersMark.ID) == 0 and StaticMark) or not StaticMark) and Unit(unit):TimeToDie() > 2 and not ImmuneArcane[npcID] and ((Unit(unit):IsBoss() and BossMark) or not BossMark) then
			return A.HuntersMark:Show(icon)
		end

		--EXPERIMENTAL PET CONTROLLER
		if Experimental and Pet:IsActive() then
			if not Pet:IsAttacking() and not PetCCd and Unit(pet):HealthPercent() > MendPet then
				return A:Show(icon, CONST.AUTOATTACK)
			end
			
			if Unit(pet):HealthPercent() < MendPet - 10 and Pet:IsAttacking() then
				return A.AspectoftheMonkey:Show(icon)
			end
		end

		if A.KillCommand:IsReady(unit) then
			return A.KillCommand:Show(icon)
		end

		if AtRange() then
			if not Player:IsShooting() then
				return A:Show(icon, CONST.AUTOSHOOT)
			end	

			if A.Intimidation:IsReady(unit) and IntimidationPvE and UnitIsUnit(targettarget, player) and Unit(target):IsControlAble("stun") then
				return A.Intimidation:Show(icon)
			end
			
			if A.ConcussiveShot:IsReady(unit) and ConcussiveShotPvE and Unit(target):IsMelee() and UnitIsUnit(targettarget, player) and A.LastPlayerCastName ~= A.Intimidation:Info() and (not A.Intimidation:IsReady(unit) or Unit(pet):HasBuffs(A.Intimidation.ID) == 0 or not IntimidationPvE) and Unit(unit):HasDeBuffs(A.WingClip.ID) < A.GetGCD() and not ImmuneArcane[npcID] then
				return A.ConcussiveShot:Show(icon)
			end
			
			if BurstIsON(unit) or (not BurstIsON(unit) and AutoSyncCDs) then
				if (AutoSyncCDs and BurnPhase) or not AutoSyncCDs then
					if A.BestialWrath:IsReady(player) and CDController[1] and Pet:IsActive() and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.BestialWrath:Show(icon)
					end
				
					if A.RapidFire:IsReady(player) and CDController[2] and Unit(player):HasBuffs(A.RapidFire.ID, true) == 0 and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.RapidFire:Show(icon)
					end

					if A.Readiness:IsReady(player) and CDController[3] then
						if ReadinessController == "RapidFire" then
							if A.RapidFire:GetCooldown() >= 60 then
								return A.Readiness:Show(icon)
							end
						end
						if ReadinessController == "Misdirection" then
							if A.Misdirection:GetCooldown() > 30 then
								return A.Readiness:Show(icon)
							end
						end
					end

					if A.BloodFury:IsReady(player) and CDController[4] and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.BloodFury:Show(icon)
					end
					
					if A.Berserking:IsReady(player) and CDController[4] and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.Berserking:Show(icon)
					end

					if UsePotions and PotionController == "HastePotion" and A.HastePotion:IsReady(player) then
						return A:Show(icon, CONST.POTION)
					end

					--Trinket 1
					if A.Trinket1:IsReady(player) then
						return A.Trinket1:Show(icon)    
					end
					
					--Trinket 2
					if A.Trinket2:IsReady(player) then
						return A.Trinket2:Show(icon)    
					end					
					
				end					
			end
 
			if isMoving and A.ArcaneShot:IsReady(unit) and not ImmuneArcane[npcID] and Player:ManaPercentage() > ArcaneShotMana then
				return A.ArcaneShot:Show(icon)
			end
 
			local ShootTimer = Player:GetSwingShoot()
			--print(ShootTimer)
			if warces then
				if speed > 1.89 then
					--5:5:1:1
					if (ShootTimer + GetLatency() + 0.12) >= MultiAfterHaste and (ShootTimer + GetLatency()) < SteadyAfterHaste and A.MultiShot:IsReady(unit) and UseAoE and A.LastPlayerCastName == A.SteadyShot:Info() then
						return A.MultiShot:Show(icon)
					end
					if (ShootTimer + GetLatency()) > 0 and (ShootTimer + GetLatency()) < SteadyAfterHaste and A.ArcaneShot:IsReady(unit) and not ImmuneArcane[npcID] and A.LastPlayerCastName == A.SteadyShot:Info() and UseArcane then
						return A.ArcaneShot:Show(icon)
					end
					if (ShootTimer + GetLatency() + 0.36) >= SteadyAfterHaste and A.SteadyShot:IsReady(unit) and A.LastPlayerCastName == A.ArcaneShot:Info() then
						return A.SteadyShot:Show(icon)  
					end
					if (ShootTimer + GetLatency()) >= SteadyAfterHaste and A.SteadyShot:IsReady(unit) then
						return A.SteadyShot:Show(icon)  
					end
				end
				if speed <= 1.87 and speed > 1.624 then
					--5:6:1:1
					if (ShootTimer + GetLatency() + 0.1) > 0 and (ShootTimer + GetLatency()) < SteadyAfterHaste and A.ArcaneShot:IsReady(unit) and not ImmuneArcane[npcID] and A.LastPlayerCastName == A.SteadyShot:Info() and UseArcane then
						return A.ArcaneShot:Show(icon)
					end
					if (ShootTimer + GetLatency()) >= MultiAfterHaste and (ShootTimer + GetLatency()) < SteadyAfterHaste and A.MultiShot:IsReady(unit) and UseAoE and A.LastPlayerCastName == A.ArcaneShot:Info() then
						return A.MultiShot:Show(icon)
					end
					if (ShootTimer + GetLatency() + 0.2) >= SteadyAfterHaste and A.SteadyShot:IsReady(unit) and A.LastPlayerCastName == A.MultiShot:Info() then
						return A.SteadyShot:Show(icon)  
					end
					if (ShootTimer + GetLatency()) >= SteadyAfterHaste and A.SteadyShot:IsReady(unit) then
						return A.SteadyShot:Show(icon)  
					end
				end
				if speed <= 1.624 then
					--1:1
					if (ShootTimer + GetLatency()) >= SteadyAfterHaste and A.SteadyShot:IsReady(unit) then
						return A.SteadyShot:Show(icon)  
					end
				end
			end
			
			if not warces and ShootTimer < Player:Execute_Time(A.SteadyShot.ID) and (ShootTimer > Player:Execute_Time(A.MultiShot.ID) or ShootTimer <= A.GetLatency()) and Player:ManaPercentage() > ManaSave then
				if A.MultiShot:IsReady(unit) and UseAoE then
					return A.MultiShot:Show(icon)
				end
				
				if StingController == "SerpentSting" then
					if A.SerpentSting:IsReady(unit) and Unit(unit):HasDeBuffs(A.SerpentSting.ID, true) <= A.GetGCD() and Unit(unit):TimeToDie() >= 4 then
						return A.SerpentSting:Show(icon)
					end
				end
				
				if StingController == "ScorpidSting" then
					if A.ScorpidSting:IsReady(unit) and Unit(unit):HasDeBuffs(A.ScorpidSting.ID, true) <= A.GetGCD() + 0.5 and Unit(unit):IsBoss() then
						return A.ScorpidSting:Show(icon)
					end
				end
				
				if StingController == "ViperSting" then
					if A.ViperSting:IsReady(unit) and Unit(unit):PowerType() == "MANA" and Unit(unit):Power() >= 10 then
						return A.ViperSting:Show(icon)
					end
				end
				
				if A.ArcaneShot:IsReady(unit) and UseArcane and not ImmuneArcane[npcID] and Player:ManaPercentage() > ArcaneShotMana then
					return A.ArcaneShot:Show(icon)
				end
			end

			if (ShootTimer >= Player:Execute_Time(A.SteadyShot.ID) or (ShootTimer <= A.GetLatency() and ShootTimer > 0)) and Player:ManaPercentage() > ManaSave then
				if A.SteadyShot:IsReady(unit) then
					return A.SteadyShot:Show(icon)
				end					
			end

		end

		if InMelee() then
			if not Player:IsAttacking() then
				return A:Show(icon, CONST.AUTOATTACK)
			end

			if A.Disengage:IsReady(unit) and UnitIsUnit(targettarget, player) and (not A.Intimidation:IsReady(unit) or Unit(pet):HasBuffs(A.Intimidation.ID) == 0 or not IntimidationPvE) then
                return A.Disengage:Show(icon)
            end
			
			if A.ExplosiveTrap:IsReady(unit) and A.MultiUnits:GetByRange(5, 3) > 2 and UseAoE then
				return A.ExplosiveTrap:Show(icon)
			end
			
			if A.WingClip:IsReady(unit) and Unit(unit):HasDeBuffs(A.WingClip.ID, true) <= A.GetGCD() and A.WingClip:AbsentImun(unit, Temp.TotalAndPhysAndCC) then
				return A.WingClip:Show(icon)
			end			
			
			if A.MongooseBite:IsReady(unit) then
				return A.MongooseBite:Show(icon)
			end
			
			if A.RaptorStrike:IsReady(unit) and not A.RaptorStrike:IsSpellCurrent() then
				return A.RaptorStrike:Show(icon)
			end
		
		end
		
       
    end

    -- End on EnemyRotation()
	
    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unit = "target"
        if EnemyRotation(unit) then 
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
