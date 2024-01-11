local playerPed = PlayerPedId()

local weaponRecoilValues = {
    [`weapon_pistol50`] = 3.5,
    -- Add more weapons with their respective recoil values
    -- [`new_weapon`] = new_recoil_value,
}

-- Simple "machine learning" model parameters
local modelWeights = {
    playerSpeedWeight = 0.5,
    weaponRecoilWeight = 0.3,
}

local function CalculateAmplitudeScale(num, baseMin, baseMax, targetMin, targetMax)
    return (((num - baseMin) * (targetMax - targetMin)) / (baseMax - baseMin)) + targetMin
end

function ApplyRecoilBasedOnStateOrSpeed(ped, weapon, modifier)
    local amplitude = 1.0

    -- Simulating player speed as a feature
    local pedSpeed = GetEntitySpeed(ped) * 1.5

    -- Simulating weapon recoil as a feature
    local weaponRecoil = weaponRecoilValues[weapon] or 3.5

    -- Simulating "machine learning" model decision-making
    amplitude = CalculateAmplitudeScale(pedSpeed, 0.0, 150.0, 1.0, 8.0) * modelWeights.playerSpeedWeight
    amplitude = amplitude + CalculateAmplitudeScale(weaponRecoil, 0.0, 10.0, 1.0, 5.0) * modelWeights.weaponRecoilWeight

    SetWeaponRecoilShakeAmplitude(weapon, amplitude * modifier)
end

CreateThread(function()
    while true do
        Wait(150)

        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            local _, currentWeapon = GetCurrentPedWeapon(ped, true)
            ApplyRecoilBasedOnStateOrSpeed(ped, currentWeapon, 1.0)
        end
    end
end)
