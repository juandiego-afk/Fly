
local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Flying = false

-- Función para activar/desactivar el vuelo
local function toggleFly()
    Flying = not Flying
    
    if Flying then
        -- Desactiva la gravedad (se siente como flotar)
        Humanoid.PlatformStand = true 
        print("Vuelo Activado")
    else
        -- Reactiva la gravedad
        Humanoid.PlatformStand = false
        print("Vuelo Desactivado")
    end
end

-- Detectar cuando el jugador presiona una tecla
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- 'gameProcessedEvent' evita que el vuelo se active al escribir en el chat
    if input.KeyCode == Enum.KeyCode.F and not gameProcessedEvent then
        toggleFly()
    end
end)

-- Bucle para el movimiento de vuelo
game:GetService("RunService").RenderStepped:Connect(function()
    if Flying and Character and Humanoid.Health > 0 then
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            -- Mueve el personaje en la dirección de la cámara para 'volar'
            local MoveVector = Vector3.new(Humanoid.MoveDirection.X, 0, Humanoid.MoveDirection.Z)
            
            -- Controla el movimiento hacia arriba (salto) y hacia abajo (agacharse)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then -- Salto (subir)
                MoveVector = MoveVector + Vector3.new(0, 1, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then -- Agacharse (bajar)
                MoveVector = MoveVector + Vector3.new(0, -1, 0)
            end
            
            -- Aplica la velocidad de vuelo
            HRP.CFrame = HRP.CFrame + HRP.CFrame.lookVector * MoveVector.Z + HRP.CFrame.rightVector * MoveVector.X + HRP.CFrame.upVector * MoveVector.Y
        end
    end
end)
