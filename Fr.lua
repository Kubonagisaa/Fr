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

-- Hàm kiểm tra trái cây trong workspace
function checkForFruits(workspace)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Fruit") then
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
        local hasFruit = checkForFruits(workspace)

        if hasFruit then
            sendNotification("Fruit", "Có trái cây trên bản đồ.")
            noFruitTime = 0 -- Reset thời gian nếu có trái cây
            canTeleport = true -- Cho phép nhảy server lại
        else
            noFruitTime = noFruitTime + 5 -- Tăng thời gian không có trái cây

            if noFruitTime >= 50 and canTeleport then -- Nếu đã 130 giây và chưa nhảy server
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
        scriptContent = scriptContent:gsub("TweenSpeed = %d+", "TweenSpeed = 200") -- Thay đổi tốc độ tween
        loadstring(scriptContent)()
    end)

    if not success then
        sendNotification("Error", "Không thể tải script tìm kiếm trái cây: " .. tostring(err))
    end
end)
