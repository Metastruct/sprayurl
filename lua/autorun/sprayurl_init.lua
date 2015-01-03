
//   _____                       _    _ _____  _      
//  / ____|                     | |  | |  __ \| |     
// | (___  _ __  _ __ __ _ _   _| |  | | |__) | |     
//  \___ \| '_ \| '__/ _` | | | | |  | |  _  /| |     
//  ____) | |_) | | | (_| | |_| | |__| | | \ \| |____ 
// |_____/| .__/|_|  \__,_|\__, |\____/|_|  \_\______|
//        | |               __/ |                     
//        |_|              |___/       By FailCake :D (edunad)               
//
// Changelog
// $ Fixed Queue
// $ Fixed Retries.


if CLIENT then
	
	ckText = ckText or {}
	ckText.cachedMaterials = ckText.cachedMaterials or {}
	ckText.SpraysQueue = ckText.SpraysQueue or {}
	ckText.SpraysDownloaded = ckText.SpraysDownloaded or {}
	ckText.MAX_ATTEMPTS = ckText.MAX_ATTEMPTS or 5
	
	ckText.shaderType = "UnlitGeneric"
	
	ckText.matdata = ckText.matdata or {}
	ckText.matdata["$translucent"] = 1
	ckText.matdata["$nocull"] = 1
	ckText.matdata["$vertexcolor"] = 1
	ckText.matdata["$vertexalpha"] = 1
	ckText.matdata["$no_fullbright"] = 1

	ckText.MSG_OK = 1
	ckText.MSG_FAILED = 2
	ckText.MSG_DOWNLOADREQUEST = 3
	
	surface.CreateFont("sprayload", 
	{
		font = "Arial",
		size = 20,
		weight = 10,
		antialias = true,
		outline = true,
	})

	function downloadFailed(reason,name)
		print("[URLSpray] Error : " .. reason)
		hook.Remove("Think","DL_Text")
		ckText.SpraysDownloaded[name] = ckText.MSG_FAILED
	end

	// Heavily based on PAPC3 (CLIENT SIDE)
	function textureDLL(url,override)
		
		if !override and ckText.cachedMaterials[url] != nil then
			print("[URLSpray] Material ".. url .. " already downloaded.")
			ckText.SpraysDownloaded[url] = ckText.MSG_OK
			return
		end 
		
		if override then
			ckText.cachedMaterials[url] = Material("models/debug/debugwhite")	
			ckText.SpraysDownloaded[url] = 0
		end
		
		print("[URLSpray] Downloading Material : " .. url)
		
		if IsValid(ckText.pnl) then
			ckText.pnl:Remove()
		end
		
		ckText.pnl = vgui.Create("DHTML")
		ckText.pnl:SetVisible(true)
		ckText.pnl:SetSize(ScrW(), ScrH())
		ckText.pnl:SetPos(ScrW()-1, ScrH()-1)
		ckText.pnl:SetHTML([[
		<html>
		<style type="text/css">
			html 
			{			
				overflow:hidden;
			}
			
			.contain{
				position:absolute;
				top:0px;
				width:100%;
				height:100%;
				
				background-image: url(']]..url..[[');
				background-size:contain;
				background-repeat:no-repeat;
				
			}
		</style>		
		<body>
			<div class="contain"></div>
		</body>
		</html>
		]])
	
		local CDTime = 0
		local OK = false
		
	
		hook.Add("Think","DL_Text",function()

			if !IsValid(ckText.pnl) then
				downloadFailed("Panel failed to open!",url)
				return
			end
			
			local html_mat = ckText.pnl:GetHTMLMaterial()
			
			if !ckText.pnl:IsLoading() and !OK then
				
				if html_mat == nil then
					ckText.pnl:Remove()
					downloadFailed("Failed to get HTML Material!",url)
					return
				end
				
				OK = true
				CDTime = CurTime() + 1
			end
			
			if OK and CDTime < CurTime() then
				
				local vertex_mat = CreateMaterial(url, ckText.shaderType,ckText.matdata )
				local textur = html_mat:GetTexture("$basetexture")
							
				textur:Download()
				vertex_mat:SetTexture("$basetexture", textur)	
				textur:Download()
				
				ckText.cachedMaterials[url] = CreateMaterial(url, ckText.shaderType,ckText.matdata)
				ckText.cachedMaterials[url]:SetTexture("$basetexture", textur)	
				
				ckText.SpraysDownloaded[url] = ckText.MSG_OK
				
			    ckText.pnl:Remove()
				hook.Remove("Think","DL_Text")
			end
			
		end)
		
	end	

	hook.Add("HUDPaint","QueueShow",function()
		
		if !LocalPlayer():Alive() then return end
		
		for i,v in pairs(ckText.SpraysQueue) do
			if #ckText.SpraysQueue > 0 then
				
				if v == nil then continue end
				
				local dist = ( LocalPlayer():GetPos() - v.SprayPos ):Length()
				
				if dist > 10000 then return end
				
				local pos2d = v.SprayPos:ToScreen()
				
				surface.SetFont("sprayload")
				surface.SetTextColor(255, 255, 255, 255)
				
				local strDn = "Spray Queue #"..i
				local Drl = "Downloading"
				local str = Drl .. ("."):rep(CurTime()*5%3)
				
				local w, h = surface.GetTextSize(strDn)
				local w2, h2 = surface.GetTextSize(Drl.. "...")
				
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos(pos2d.x - w/2, pos2d.y - h/2 - 20)
				surface.DrawText(strDn)
				surface.SetTextPos(pos2d.x - w2/2, pos2d.y - h2/2)
				surface.DrawText(str)
				
				if v.Retry then
				
					local Retr = "Download Attempt #" .. math.abs(ckText.MAX_ATTEMPTS - v.Attempts) .. " ("..ckText.MAX_ATTEMPTS..")"
					local w3, h3 = surface.GetTextSize(Retr)
					
					surface.SetTextColor( 255, 155, 0, 255 )
					surface.SetTextPos(pos2d.x - w3/2 , pos2d.y - h3/2 + 40)
					surface.DrawText(Retr)
					
				end
			end
		end
		
	end)

	hook.Add("Think","GenerateSprays",function()
	
		if #ckText.SpraysQueue > 0 then
			for i,k in pairs(ckText.SpraysQueue) do
				
				local v = ckText.SpraysQueue[1]
				
				if v.TEXT == nil then
					table.remove(ckText.SpraysQueue,1)
					return
				end
				
				if ckText.SpraysDownloaded[v.TEXT] == 0 then
					ckText.SpraysDownloaded[v.TEXT] = ckText.MSG_DOWNLOADREQUEST
					textureDLL(v.TEXT,false) // No Override.
				end
				
				// If the material is downloaded
				if ckText.SpraysDownloaded[v.TEXT] == ckText.MSG_OK then
					
				   local Mat = ckText.cachedMaterials[v.TEXT]
				   
				   if Mat != nil then
				   	
				   		util.DecalEx( Mat,
							game.GetWorld(), 
							v.SprayPos,
							v.NormalPos,
							Color(255,255,255,255), 
							700,
							700)
						
						sound.Play( "player/sprayer.wav", v.SprayPos)
						table.remove(ckText.SpraysQueue,1)
	   				else
	   					print("[URLSpray] Texture still missing, redownloading.")
		   				ckText.SpraysDownloaded[v.TEXT] = 0
		   				continue
		   			end
			   
				elseif ckText.SpraysDownloaded[v.TEXT] == ckText.MSG_FAILED then
					
					if v.CoolDOWN < CurTime() then
					   	if v.Attempts > 0 then
								
							v.Attempts = v.Attempts - 1	
							v.CoolDOWN = CurTime() + 1
							ckText.SpraysDownloaded[v.TEXT] = 0
							v.Retry = true
								
							continue
						else
							print("[SprayURL] Failed to create Spray (ID : " .. v.TEXT .. ")")
							table.remove(ckText.SpraysQueue,1)
							ckText.SpraysDownloaded[v.TEXT] = 0
							continue
						end
					end
			
				end
			end
		end
		
	end)

	net.Receive( "sprayURL", function(len, ply) 
		
		if !GetConVar("sprayURL_enabled"):GetBool() then return end
		
		local Texture = net.ReadString()
		local Pos = net.ReadVector()
		local NormalPos = net.ReadVector()
		
		ckText.MAX_ATTEMPTS = GetConVarNumber("sprayurl_maxretry")

		table.insert(ckText.SpraysQueue,
		{
			TEXT = Texture,
			SprayPos = Pos,
			Attempts = ckText.MAX_ATTEMPTS,
			NormalPos = NormalPos,
			Retry = false,
			CoolDOWN = 0
		})
		
		ckText.SpraysDownloaded[Texture] = 0
		
	end)
	
	net.Receive( "sprayWarning", function(len, ply) 
		surface.PlaySound( "buttons/button2.wav" )
		local msg = net.ReadString()
		chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), msg )
	end)

	concommand.Add("sprayurl",function(ply)
		net.Start("sprayRequest")
		net.WriteString(GetConVar( "sprayURL_texture" ):GetString()) // URL
		net.SendToServer()
	end)
	
	concommand.Add("sprayurl_clearchache",function(ply)
		table.Empty(ckText.cachedMaterials)
		table.Empty(ckText.SpraysQueue)
		table.Empty(ckText.SpraysDownloaded)
	end)
	
end

if SERVER then

	local plymeta = FindMetaTable( "Player" )
	if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

	CreateConVar( "sprayurl_plyCooldown", "15", FCVAR_ARCHIVE || FCVAR_SERVER_CAN_EXECUTE, "Sets the Cooldown for sprayURL to the players" )

	util.AddNetworkString( "sprayURL" )
	util.AddNetworkString( "sprayRequest" )
	util.AddNetworkString( "sprayWarning" )
	
	SprayURL = SprayURL or {}
	SprayURL.PlayerSpray = SprayURL.PlayerSpray or {}
	
	// Todo : Add sprayurl_mature if disabled, block porn (what are you, gay?).
	SprayURL.BannedWebsites = {"","","",""} // Does nothing yet.
	
	// Allowed Formats.
	SprayURL.AllowedFormats = {
    png = true,
    jpg = true,
    bmp = true,
    jpeg = true,
    jpe = true,
    pns = true,
    pgm = true,
    tga = true
	}
	
	net.Receive( "sprayRequest", function(len, ply)
		
		if !IsValid(ply) then return end
				
		local URL = net.ReadString()
		local extension = URL:lower():sub(-4)
		
		if !string.find(URL,"steampowered") then
			if !extension:sub(1,1) == "." or !SprayURL.AllowedFormats[extension:sub(2)] then
				net.Start("sprayWarning")
						net.WriteString("Wrong Spray Url! Must Contain (.png,.jpg,etc)")
				net.Send(ply)
				return
			end
		end

		if SprayURL.PlayerSpray[ply:SteamID()] != nil then
			if SprayURL.PlayerSpray[ply:SteamID()] < CurTime() then
				ply:CreateURLSpray(URL)
			else
				net.Start("sprayWarning")
					net.WriteString("You can't place a URLSpray Yet! Wait ".. math.abs(CurTime() - SprayURL.PlayerSpray[ply:SteamID()]) )
			   	net.Send(ply)
			end
		else
			ply:CreateURLSpray(URL)	
		end
			
		
	end)
	

	function plymeta:CreateURLSpray(url)
		
		local tr = util.QuickTrace(self:GetShootPos(), self:GetAimVector() * 128, self)
		
		if tr.HitWorld and self:Alive() then
			
			if !self:IsAdmin() || !self:IsSuperAdmin() then
				SprayURL.PlayerSpray[self:SteamID()] = CurTime() + GetConVarNumber( "sprayURL_plyCooldown" )
			end
			
			self:EmitSound("buttons/combine_button1.wav")
			self:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
			
			net.Start("sprayURL")
				net.WriteString(url) // PlayerID
				net.WriteVector(tr.HitPos) // Spray pos
				net.WriteVector(tr.HitNormal) // Spray pos
			net.Broadcast()
		
		end
	end

end

if CLIENT then
	
	CreateClientConVar( "sprayurl_enabled", "1", true, false )
	CreateClientConVar( "sprayurl_texture", "https://dl.dropboxusercontent.com/u/6696045/Applications/sprayDefault.png", true, false )
	CreateClientConVar( "sprayurl_maxretry", "5", true, false )
	
	local SprayEditor = SprayEditor or {}
	
	--CreateContextMenu()
	SprayEditor.EnableToggle = GetConVar( "sprayURL_enabled" ):GetBool()
	
	list.Set(
		"DesktopWindows", 
		"SprayURL",
		{
			title = "SprayURL Menu",
			icon = "icon32/wand.png",
			width = 300,
			height = 170,
			onewindow = true,
			init = function(icn, pnl)
			
			SprayEditor.PANEL = pnl
			SprayEditor.PANEL:SetPos(ScrW() - 310,40)
				
			SprayEditor.PANEL.Sheet = SprayEditor.PANEL:Add( "DPropertySheet" )
			SprayEditor.PANEL.Sheet:Dock(LEFT)
			SprayEditor.PANEL.Sheet:SetSize( 290, 0 )
			SprayEditor.PANEL.Sheet:SetPos(5,0)
		
			SprayEditor.PANEL.Settings = SprayEditor.PANEL.Sheet:Add( "DPanelSelect" )
			SprayEditor.PANEL.Sheet:AddSheet( "Settings", SprayEditor.PANEL.Settings, "icon16/cog_edit.png" )
			
			SprayEditor.PANEL.CreditsSettings = SprayEditor.PANEL.Sheet:Add( "DPanelSelect" )
			SprayEditor.PANEL.Sheet:AddSheet( "Credits :D", SprayEditor.PANEL.CreditsSettings, "icon16/star.png" )
			
			SprayEditor.PANEL.EnableSpray = SprayEditor.PANEL.Settings:Add( "DButton" )
			SprayEditor.PANEL.EnableSpray:SizeToContents()
			
			if SprayEditor.EnableToggle then
				SprayEditor.PANEL.EnableSpray:SetText("Disable SprayURL")
				SprayEditor.PANEL.EnableSpray:SetTextColor(Color(150,0,0))
			else
				SprayEditor.PANEL.EnableSpray:SetText("Enable SprayURL")
				SprayEditor.PANEL.EnableSpray:SetTextColor(Color(0,150,0))
			end
			
			SprayEditor.PANEL.EnableSpray:SetPos(10,6)
			SprayEditor.PANEL.EnableSpray:SetSize(250,20)
			SprayEditor.PANEL.EnableSpray.DoClick = function()

				SprayEditor.EnableToggle = !SprayEditor.EnableToggle
				RunConsoleCommand("sprayurl_enabled",BoolToInt(SprayEditor.EnableToggle))
					
				if SprayEditor.EnableToggle then
					SprayEditor.PANEL.EnableSpray:SetText("Disable SprayURL")
					SprayEditor.PANEL.EnableSpray:SetTextColor(Color(150,0,0))
				else
					SprayEditor.PANEL.EnableSpray:SetText("Enable SprayURL")
					SprayEditor.PANEL.EnableSpray:SetTextColor(Color(0,150,0))
				end
							
			end

			SprayEditor.PANEL.BCrossTxt = SprayEditor.PANEL.Settings:Add("DLabel")
			SprayEditor.PANEL.BCrossTxt:SetPos(10,33)
			SprayEditor.PANEL.BCrossTxt:SetText("URL :")
			SprayEditor.PANEL.BCrossTxt:SizeToContents() 

			SprayEditor.PANEL.URLTxt = SprayEditor.PANEL.Settings:Add("DTextEntry")
			SprayEditor.PANEL.URLTxt:SetPos(40,30)
			SprayEditor.PANEL.URLTxt:SetValue(GetConVar( "sprayurl_texture" ):GetString())
			SprayEditor.PANEL.URLTxt:SetSize(170,20)
			
			SprayEditor.PANEL.SetSpray = SprayEditor.PANEL.Settings:Add( "DButton" )
			SprayEditor.PANEL.SetSpray:SetSize(45,20)
			SprayEditor.PANEL.SetSpray:SetPos(215,30)
			SprayEditor.PANEL.SetSpray:SetText("Set")
			SprayEditor.PANEL.SetSpray:SetTextColor(Color(1,1,1))
			SprayEditor.PANEL.SetSpray.DoClick = function()
				local AValue = tostring(SprayEditor.PANEL.URLTxt:GetValue())
				RunConsoleCommand("sprayurl_texture",tostring(AValue))
				chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), "Spray Set!" )
			end
			
			SprayEditor.PANEL.CleanSpray = SprayEditor.PANEL.Settings:Add( "DButton" )
			SprayEditor.PANEL.CleanSpray:SetSize(250,20)
			SprayEditor.PANEL.CleanSpray:SetPos(10,70)
			SprayEditor.PANEL.CleanSpray:SetText("Clean Sprays")
			SprayEditor.PANEL.CleanSpray:SetTextColor(Color(1,1,1))
			SprayEditor.PANEL.CleanSpray.DoClick = function()
				RunConsoleCommand("r_cleardecals")
				chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), "Decals / Sprays Cleaned!" )
			end
			
			// ---------------- Credits ---------------- //
			SprayEditor.PANEL.CreedTxt = SprayEditor.PANEL.CreditsSettings:Add("DLabel")
			SprayEditor.PANEL.CreedTxt:SetPos(98,80)
			SprayEditor.PANEL.CreedTxt:SetText("By FailCake :D")
			SprayEditor.PANEL.CreedTxt:SizeToContents() 
				
			SprayEditor.PANEL.CreedImg = SprayEditor.PANEL.CreditsSettings:Add("DImageButton")
			SprayEditor.PANEL.CreedImg:SetPos( 100, 10 )
			SprayEditor.PANEL.CreedImg:SetSize( 64, 64 )
			SprayEditor.PANEL.CreedImg:SetImage( "icon32/wand.png" )
			SprayEditor.PANEL.CreedImg.DoClick = function()
				gui.OpenURL("http://steamcommunity.com/id/edunad")
			end
			
			end
		}
	)
			
	function BoolToInt(bol)
		if bol then
			return 1
		else
			return 0
		end
	end

end