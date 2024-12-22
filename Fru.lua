local args = {
    [1] = "SetTeam",
    [2] = "Marines"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

loadstring(game:HttpGet('https://raw.githubusercontent.com/VNT-UNIVERSAL/Panda-Hub/main/Release/fruit.lua'))()
