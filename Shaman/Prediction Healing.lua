local _G, math, type, pairs            = _G, math, type, pairs
local math_max                        = math.max

local A                             = _G.Action
local toStr                            = A.toStr
local strOnlyBuilder                = A.strOnlyBuilder
local IsActionTable                    = A.IsActionTable
local Print                         = A.Print
local GetToggle                        = A.GetToggle
local Unit                             = A.Unit 
local GetCurrentGCD                    = A.GetCurrentGCD
local TeamCache                        = A.TeamCache
local TeamCacheFriendly                = TeamCache.Friendly
local HealingEngine                    = A.HealingEngine
local HealingEngineIsManaSave        = HealingEngine.IsManaSave

local HealComm                         = _G.LibStub("LibHealComm-4.0", true)

local GetSpellBonusHealing            = _G.GetSpellBonusHealing
local UnitGUID                        = _G.UnitGUID

local PL                             = A[A.PlayerClass]
local GetHealingTypeByName            = {
    [PL.LesserHealingWave:Info()]            = {"CAST",         "LesserHealingWave"        },
    [PL.HealingWave:Info()]        = {"CAST",         "HealingWave"    },
    [PL.ChainHeal:Info()]            = {"CAST",    "ChainHeal"        },
}

function A:PredictHeal(unitID, variation, unitGUID)     
    -- @usage obj:PredictHeal(unitID[, variation[, unitGUID]]) 
    -- @return boolean, number 
    -- Returns:
    -- [1] true if action can be used
    -- [2] total amount of predicted missed health 
    local Info                        = GetHealingTypeByName[self:Info()]    
    if not Info then 
        return false, 0 
    end 
    
    local PO                         = GetToggle(8, "PredictOptions")
    -- PO[1] incHeal
    -- PO[2] incDMG
    -- PO[3] threat -- not usable in prediction
    -- PO[4] HoTs
    -- PO[5] absorbPossitive
    -- PO[6] absorbNegative
    local variation                 = variation or 1  
    if (A.IamHealer or GetToggle(1, "HE_AnyRole")) and HealingEngineIsManaSave(unitID) then 
        variation = math_max(variation - 1 + GetToggle(8, "ManaManagementPredictVariation"), 1)        
    end 
    
    local category                     = Info[1]
    local spellName                    = Info[2]
    
    -- [[ MANUAL ]] 
    local custom                    
        custom                         = GetToggle(2, strOnlyBuilder(spellName, self.isRank))    
    
    if custom and custom < 100 and Unit(unitID):HealthPercent() > custom then 
        return false, 0
    end 
    
    -- [[ AUTO ]] 
    local health                    = Unit(unitID):Health()
    local health_max                = Unit(unitID):HealthMax()
    
    -- Switch mode to percentage if real health broken 
    if health <= 0 or health_max <= 0 then 
        local p_health_max             = Unit("player"):HealthMax()
        
        health                        = Unit(unitID):HealthPercent() * p_health_max / 100
        health_max                     = p_health_max
    end 
    
    local health_deficit            = health_max - health
    -- unitID is full health 
    if health_deficit <= 0 then
        return false, 0 
    end 
    
    -- [[ PREDICT OPTIONS ]]    
    local castTime                    = (category == "CAST" and self:GetSpellCastTime()) or 0 
    if castTime > 0 then 
        castTime                     = castTime + GetCurrentGCD()
    end 
    
    local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
    if PO[1] and castTime > 0 then 
        incHeal                        = Unit(unitID):GetIncomingHeals(castTime, unitGUID)
    end 
    
    if PO[2] and castTime > 0 then 
        incDMG                         = Unit(unitID):GetDMG() * castTime
    end     
    
    if PO[4] and castTime > 0 then -- 4 here!
        HoTs                         = Unit(unitID):GetHEAL() * castTime
    end 
    
    if PO[5] then 
        absorbPossitive             = Unit(unitID):GetAbsorb()
        -- Better don't touch it, not tested anyway
        if absorbPossitive >= health_deficit then 
            absorbPossitive = 0
        end 
    end 
    
    if PO[6] then 
        absorbNegative                 = Unit(unitID):GetTotalHealAbsorbs()
    end 
    
    -- HealComm: Modificators of healing 
    local extraHealModifier            = 1
    if HealComm then 
        extraHealModifier            = HealComm:GetPlayerHealingMod() * HealComm:GetHealModifier(unitGUID or UnitGUID(unitID))
    end 
    
    local withoutOptions     
        local description             = self:GetSpellDescription()
        withoutOptions                = (((description[1] + description[2]) / 2) + GetSpellBonusHealing()) * extraHealModifier * variation
    
    local total                     = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
    
    return health_deficit >= total, total 
end

function A.DebugPredictHeal(unitID)
    if unitID and A[A.PlayerClass] then 
        local bool, total 
        for key, action in pairs(A[A.PlayerClass]) do 
            if type(action) == "table" and IsActionTable(action) and GetHealingTypeByName[action:Info()] then 
                bool, total = action:PredictHeal(unitID)
                Print(key .. ": " .. toStr[bool] .. ", " .. Unit(unitID):HealthDeficit() .. " >= " .. total)
            end 
        end 
    end 
end 

