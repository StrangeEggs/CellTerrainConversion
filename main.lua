
local terrain = game.Workspace.Terrain
local cells = terrain:CountCells()
if game.Workspace:FindFirstChild("TerrainPoint1") == nil then
	warn("No TerrainPoint1 brick! Create a 4x4x4 brick named TerrainPoint1 and put it at one corner of the map.")
	return
end
if game.Workspace:FindFirstChild("TerrainPoint2") == nil then
	warn("No TerrainPoint1 brick! Create a 4x4x4 brick named TerrainPoint1 and put it at one corner of the map.")
	return
end
local point1 = game.Workspace.TerrainPoint1.Position
local point2 = game.Workspace.TerrainPoint2.Position
local terrainModel = Instance.new("Folder", game.ServerStorage)
terrainModel.Name = "ConvertedTerrain"
local converted = {}
local totalConverted = 0
function checkInTable(Table,Value)
	for i,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
local gc1 = game.Workspace.Terrain:WorldToCell(point1)
local gc2 = game.Workspace.Terrain:WorldToCell(point2)
for x = gc1.X,gc2.X do
	for y = gc1.Y,gc2.Y do
		for z = gc1.Z,gc2.Z do
			if checkInTable(converted, string.format("%s,%s,%s", x,y,z)) == false then
				local material,block,rotation = game.Workspace.Terrain:GetCell(x,y,z)
				if material ~= Enum.CellMaterial.Empty then
					table.insert(converted, string.format("%s,%s,%s", x,y,z))
					totalConverted = totalConverted + 1
					print("Converted",x,y,z,material,block,rotation)
					local data = Instance.new("StringValue", terrainModel)
					data.Name = material.Name
					local pos = Instance.new("Vector3Value", data)
					pos.Name = "Position"
					pos.Value = game.Workspace.Terrain:CellCenterToWorld(x,y,z)
					local blockVal = Instance.new("StringValue", data)
					blockVal.Name = "Block"
					blockVal.Value = block.Name
					local orient = Instance.new("StringValue", data)
					orient.Name = "Orientation"
					orient.Value = rotation.Name
					local isTop = Instance.new("BoolValue", data)
					isTop.Name = "IsTop"
					if block == Enum.CellBlock.Solid then
						local gctop = game.Workspace.Terrain:GetCell(x,y+1,z)
						if gctop == Enum.CellMaterial.Empty then
							isTop.Value = true
						end
					end
				end
				game:GetService("RunService").RenderStepped:wait()
			end
		end
	end
end
print("Successfully converted",totalConverted,"cells.")
