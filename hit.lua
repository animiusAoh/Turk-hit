-- Script ubicado en ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PunchEvent = Instance.new("RemoteEvent")
PunchEvent.Name = "PunchEvent"
PunchEvent.Parent = ReplicatedStorage

PunchEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and humanoid.Health > 0 and rootPart then
        -- Detección de impacto frontal simple mediante OverlapParams
        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude
        overlapParams.FilterDescendantsInstances = {character}
        
        local hitBoxSize = Vector3.new(4, 5, 4)
        local hitBoxCFrame = rootPart.CFrame * CFrame.new(0, 0, -2)
        
        local partsInRegion = workspace:GetPartBoundsInBox(hitBoxCFrame, hitBoxSize, overlapParams)
        
        for _, part in ipairs(partsInRegion) do
            local targetHumanoid = part.Parent:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and targetHumanoid.Health > 0 then
                -- Aplicar daño seguro desde el servidor
                targetHumanoid:TakeDamage(10)
                break -- Previene aplicar daño múltiple en una sola instancia
            end
        end
    end
end)
