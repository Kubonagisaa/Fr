-- Định nghĩa chức năng nhảy server
function TPReturner()
    local PlaceID = game.PlaceId
    local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    for _, v in pairs(Site.data) do
        local ID = tostring(v.id)
        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
        sendNotification("Nhảy Server", "Đã nhảy server thành công!")
        return
    end
end

-- Hàm gửi thông báo
function sendNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- Hàm kiểm tra và dịch chuyển đến trái cây trong workspace
function tpToFruit(workspace)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Fruit") then
            local fruitPosition = obj.PrimaryPart.Position
            game.Players.LocalPlayer.Character:MoveTo(fruitPosition) -- Dịch chuyển đến vị trí trái cây
            sendNotification("TP Fruit", "Đã dịch chuyển đến trái cây!")
            return true
        end
    end
    return false
end

-- Tự động nhảy server nếu không có trái cây trong 130 giây
spawn(function()
    local noFruitTime = 0 -- Thời gian không có trái cây
    local canTeleport = true -- Biến kiểm soát việc nhảy server

    while true do
        wait(5) -- Kiểm tra mỗi 5 giây
        local hasFruit = tpToFruit(workspace)

        if hasFruit then
            noFruitTime = 0 -- Reset thời gian nếu có trái cây
            canTeleport = true -- Cho phép nhảy server lại
        else
            noFruitTime = noFruitTime + 5 -- Tăng thời gian không có trái cây

            if noFruitTime >= 130 and canTeleport then -- Nếu đã 130 giây và chưa nhảy server
                TPReturner() -- Nhảy server
                noFruitTime = 0 -- Reset lại thời gian
                canTeleport = false -- Ngăn không cho nhảy server lại ngay lập tức
            end
        end
    end
end)

-- Tải script tìm kiếm trái cây với tốc độ tween nhanh hơn
spawn(function()
    local success, err = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/marisdeptrai/Script-Free/main/FruitFinder.lua")
        scriptContent = scriptContent:gsub("TweenSpeed = %d+", "TweenSpeed = 800") -- Thay đổi tốc độ tween
        loadstring(scriptContent)()
    end)

    if not success then
        sendNotification("Error", "Không thể tải script tìm kiếm trái cây: " .. tostring(err))
    end
end)

-- Chức năng noclip tự động
local noclip = true
local player = game.Players.LocalPlayer

-- Vòng lặp để thực hiện noclip
game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Thông báo khi noclip được bật
sendNotification("Noclip", "Noclip đã được bật tự động")
