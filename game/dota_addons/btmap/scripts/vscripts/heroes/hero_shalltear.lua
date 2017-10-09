require('libraries/timers')

-- Passive
function ZeroManaOnSpawn( event ) 
	local hero = event.caster
	Timers:CreateTimer(.01, function()
		hero.blood = 0
        CustomNetTables:SetTableValue("blood","blood",{value = hero.blood})
    end)
end

function ManaOnAttack( event )
	local hero = event.caster
	local level = hero:GetLevel()
	local manaGain = 0.01 * level + 3
    if not hero.blood then hero.blood = 0 end
    hero.blood = hero.blood + manaGain
    if hero.blood >= 100 then hero.blood = 100 end
    CustomNetTables:SetTableValue("blood","blood",{value = hero.blood})
end

function ManaOnAttacked( event )
   local hero = event.caster
   local level = hero:GetLevel()
   if not hero.blood then hero.blood = 0 end
   
   local manaGain = 0.01 * level + 0.4
   hero.blood = hero.blood + manaGain
   if hero.blood >= 100 then hero.blood = 100 end
   CustomNetTables:SetTableValue("blood","blood",{value = hero.blood})
end

-- Mana on Skill (used in Skill1, 2)
function ManaOnSkill( event )
	local caster = event.caster
    if not caster.blood then caster.blood = 0 end
	if caster.blood == 100 then
		caster:CastAbilityImmediately(caster:FindAbilityByName("hero_shalltear_skill5"),caster:GetPlayerOwnerID())
	end
	local manaGain = event.ability:GetLevelSpecialValueFor("mana_gain", (event.ability:GetLevel()-1))
	caster.blood = caster.blood + manaGain
    if caster.blood >= 100 then caster.blood = 100 end
    CustomNetTables:SetTableValue("blood","blood",{value = caster.blood})
end

function Skill2_AoE( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local ability_level = ability:GetLevel() - 1

    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

    local damage_table = {}
    damage_table.attacker = caster
    damage_table.victim = target
    damage_table.damage_type = ability:GetAbilityDamageType()
    damage_table.ability = ability
    damage_table.damage = damage

    ApplyDamage(damage_table)
end