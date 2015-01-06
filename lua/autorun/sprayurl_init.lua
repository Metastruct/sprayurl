//   _____                       _    _ _____  _      
//  / ____|                     | |  | |  __ \| |     
// | (___  _ __  _ __ __ _ _   _| |  | | |__) | |     
//  \___ \| '_ \| '__/ _` | | | | |  | |  _  /| |     
//  ____) | |_) | | | (_| | |_| | |__| | | \ \| |____ 
// |_____/| .__/|_|  \__,_|\__, |\____/|_|  \_\______|
//        | |               __/ |                     
//        |_|              |___/       By FailCake :D (edunad)               


// Changelog
// $ If image is not found, it will display a 404image.
// $ Added sprayurl_enablewhitelist to server
// $ Added quickspray by doing sprayurl "<link>"
// $ Added sprayurl_enablewhitelist to enable / disable whitelist, its now disabled by default! Yay freedom
// $ Added sprayurl_weblist to check what websites are allowed if whitelist is enabled.

function findInTable(fnd,tbl)
		
		if fnd == nil || tbl == nil then return false end
		if #tbl <= 0 then return false end
		
        for i,v in pairs(tbl) do
            if string.find(fnd,v) then
                return true
            end
        end

        return false
end

if CLIENT then
	
	CreateClientConVar( "sprayurl_enabled", "1", true, false )
	CreateClientConVar( "sprayurl_texture", "https://dl.dropboxusercontent.com/u/6696045/Applications/sprayDefault.png", true, false )
	CreateClientConVar( "sprayurl_maxretry", "5", true, false )
	CreateClientConVar( "sprayurl_keywordban", "1", true, false )
	
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
			
			SprayEditor.PANEL.HelpMenu = SprayEditor.PANEL.Sheet:Add( "DPanelSelect" )
			SprayEditor.PANEL.Sheet:AddSheet( "Help", SprayEditor.PANEL.HelpMenu, "icon16/book_open.png" )
			
			SprayEditor.PANEL.BanMenu = SprayEditor.PANEL.Sheet:Add( "DPanelSelect" )
			SprayEditor.PANEL.Sheet:AddSheet( "Keywords Bans", SprayEditor.PANEL.BanMenu, "icon16/cancel.png" )
			
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
			SprayEditor.PANEL.BCrossTxt:SetTextColor(Color(1,1,1))
	
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
			
			// TUTORIAL
			
			SprayEditor.PANEL.LblTutorial = SprayEditor.PANEL.HelpMenu:Add("DLabel")
			SprayEditor.PANEL.LblTutorial:SetPos(55,2)
			SprayEditor.PANEL.LblTutorial:SetText("=== How to use SprayURL ===")
			SprayEditor.PANEL.LblTutorial:SizeToContents() 
			SprayEditor.PANEL.LblTutorial:SetTextColor(Color(1,1,1))
			
			SprayEditor.PANEL.LblRich = SprayEditor.PANEL.HelpMenu:Add("RichText")
			SprayEditor.PANEL.LblRich:SetSize(255,80)
			SprayEditor.PANEL.LblRich:SetPos(10,20)
			
			function SprayEditor.PANEL.LblRich:Paint(w,h)
				draw.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50 ) )
			end

			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 255, 255, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "==== How to use SprayURL ====\n\n" )
			SprayEditor.PANEL.LblRich:AppendText( "1 = " )
			SprayEditor.PANEL.LblRich:InsertColorChange( 180, 180, 180, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "Bind a key to sprayurl\n" )
			SprayEditor.PANEL.LblRich:AppendText( [[example : ]] )
			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 120, 0, 255 )
			SprayEditor.PANEL.LblRich:AppendText( [[bind "p" "sprayurl"]].."\n" )
			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 255, 255, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "2 = " )
			SprayEditor.PANEL.LblRich:InsertColorChange( 180, 180, 180, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "Assign a texture to your spray at the Setings\n" )
			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 255, 255, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "3 = " )
			SprayEditor.PANEL.LblRich:InsertColorChange( 180, 180, 180, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "Done!\n\n" )
			
			/*		RichText is bugged.
			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 255, 255, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "==== Fixing Issues ====\n\n" )
			SprayEditor.PANEL.LblRich:InsertColorChange( 180, 180, 180, 255 )
			SprayEditor.PANEL.LblRich:AppendText( "If you are missing textures then run this command\n" )
			SprayEditor.PANEL.LblRich:InsertColorChange( 255, 120, 0, 255 )
			SprayEditor.PANEL.LblRich:AppendText( [[sprayurl_clearcache]].."\n" )
			*/
			
			// BANS
				
			SprayEditor.PANEL.BanRich = SprayEditor.PANEL.BanMenu:Add("DListView")
			SprayEditor.PANEL.BanRich:SetSize(255,70)
			SprayEditor.PANEL.BanRich:SetPos(10,5)
			SprayEditor.PANEL.BanRich:SetMultiSelect( false )
			SprayEditor.PANEL.BanRich:AddColumn( "=== Banned Keywords ===" )
			
			if ckText.BannedKeywords != nil then
				for i,v in pairs(ckText.BannedKeywords) do
					if v != nil and v != "" then
						SprayEditor.PANEL.BanRich:AddLine(v)	
					end
				end
			end
			
			SprayEditor.PANEL.BanTxt = SprayEditor.PANEL.BanMenu:Add("DTextEntry")
			SprayEditor.PANEL.BanTxt:SetPos(10,80)
			SprayEditor.PANEL.BanTxt:SetValue("")
			SprayEditor.PANEL.BanTxt:SetSize(200,20)
			
			SprayEditor.PANEL.AddBans = SprayEditor.PANEL.BanMenu:Add( "DButton" )
			SprayEditor.PANEL.AddBans:SetSize(25,20)
			SprayEditor.PANEL.AddBans:SetPos(215,80)
			SprayEditor.PANEL.AddBans:SetText("")
			SprayEditor.PANEL.AddBans:SetImage("icon16/add.png")
			SprayEditor.PANEL.AddBans:SetTextColor(Color(1,1,1))
			SprayEditor.PANEL.AddBans.DoClick = function()
				local txt = SprayEditor.PANEL.BanTxt:GetValue() 
				
				if txt != nil and txt != "" then
					if !table.HasValue(ckText.BannedKeywords,txt) then
						
						surface.PlaySound("buttons/button14.wav") // Beep!
						table.insert(ckText.BannedKeywords,txt)
						SprayEditor.PANEL.BanRich:AddLine(txt)
						
						saveKeywords()
						SprayEditor.PANEL.BanTxt:SetValue("")
					end
				end
		
			end
			
			SprayEditor.PANEL.RemoveBans = SprayEditor.PANEL.BanMenu:Add( "DButton" )
			SprayEditor.PANEL.RemoveBans:SetSize(25,20)
			SprayEditor.PANEL.RemoveBans:SetPos(240,80)
			SprayEditor.PANEL.RemoveBans:SetText("")
			SprayEditor.PANEL.RemoveBans:SetImage("icon16/cross.png")
			SprayEditor.PANEL.RemoveBans:SetTextColor(Color(1,1,1))
			SprayEditor.PANEL.RemoveBans.DoClick = function()
				
				local numb = SprayEditor.PANEL.BanRich:GetSelectedLine( )
				
				if numb != nil then
					table.remove(ckText.BannedKeywords,numb)
					SprayEditor.PANEL.BanRich:RemoveLine(numb)
					surface.PlaySound("garrysmod/ui_hover.wav") // Beep!
					saveKeywords()
				end
				
			end	
			
			// ---------------- Credits ---------------- //
			SprayEditor.PANEL.CreedTxt = SprayEditor.PANEL.CreditsSettings:Add("DLabel")
			SprayEditor.PANEL.CreedTxt:SetPos(98,80)
			SprayEditor.PANEL.CreedTxt:SetText("By FailCake :D")
			SprayEditor.PANEL.CreedTxt:SizeToContents() 
			SprayEditor.PANEL.CreedTxt:SetTextColor(Color(1,1,1))
				
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

	function saveKeywords()
		
		if !file.Exists( "sprayurl", "DATA" ) or !file.Exists( "sprayurl/keywords.txt", "DATA" ) then
			error("Failed to find Sprayurl data folder! Close and Re-open the menu.")
		end
		
		local dt = ""
		for i,v in pairs(ckText.BannedKeywords) do
			if v != nil and v != "" then
				dt = dt .. v .. "\n"
			end
		end
		
		file.Write( "sprayurl/keywords.txt", dt )
		
	end

	function loadKeywords()
		
		table.Empty(ckText.BannedKeywords)
		
		if !file.Exists( "sprayurl", "DATA" ) then
			file.CreateDir( "sprayurl" )
			print("[SprayURL] Data dir not found. Creating.")
		end
		
		if !file.Exists( "sprayurl/keywords.txt", "DATA" ) then
			file.Write( "sprayurl/keywords.txt", "porn\nhentai\nsex\n" )
			ckText.BannedKeywords = {"porn","hentai","sex"}
		else
			
			local dt = file.Read( "sprayurl/keywords.txt", "DATA" )
			local dtparse = string.split(dt,"\n")
			
			if dtparse == nil || #dtparse <= 0 then
				file.Write( "sprayurl/keywords.txt", "porn\nhentai\nsex" )
				ckText.BannedKeywords = {"porn","hentai","sex"}
			else
				
				for i,v in pairs(dtparse) do
					if v != nil and v != "" then
						table.insert(ckText.BannedKeywords,v)	
					end
				end
				
			end
			
		end
		
	end
	
			
	function BoolToInt(bol)
		if bol then
			return 1
		else
			return 0
		end
	end

end

	

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

	ckText.MSG_NONE = 0
	ckText.MSG_OK = 1
	ckText.MSG_FAILED = 2
	ckText.MSG_DOWNLOADREQUEST = 3
	ckText.MSG_ABORT = 4

	ckText.BannedKeywords = ckText.BannedKeywords or {}
	ckText.WhitelistRequestCD = ckText.WhitelistRequestCD or 0
	
	// Load Banned Keywords
	loadKeywords()
	
	surface.CreateFont("sprayload", 
	{
		font = "Arial",
		size = 20,
		weight = 10,
		antialias = true,
		outline = true,
	})

	function downloadFailed(reason)
		print("[SprayURL] Error : " .. reason)
		hook.Remove("Think","DL_Text")
	end

	// Heavily based on PAPC3 (CLIENT SIDE)
	function textureDLL(url,override)
	
		if !override and ckText.cachedMaterials[url] != nil then
			print("[SprayURL] Material ".. url .. " already downloaded.")
			ckText.SpraysDownloaded[url] = ckText.MSG_OK
			return
		end 
		
		ckText.SpraysDownloaded[url] = ckText.MSG_DOWNLOADREQUEST
		
		print("[SprayURL] Downloading Material : " .. url)
		
		if IsValid(ckText.pnl) then
			ckText.pnl:Remove()
		end
		
		ckText.pnl = vgui.Create("HTML")
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
				top:-1px;
				left:-1px;
				width:]].. ScrW() ..[[px;
				height:]].. ScrH() ..[[px;
			}
			
			.contain img{
				width:100%;
			}
			
			img[src='Error.src']{
			    display: none;
			}
		
		</style>		
			<body>
				<div class="contain">
					<img src="]]..url..[[" alt="" onerror="this.src='https://dl.dropboxusercontent.com/u/6696045/applications/imgNotFound.png'" />
				</div>
			</body>
		</html>
		]])
	
		local CDTime = 0
		local OK = false
		local LoadTime = CurTime() + 5

		hook.Add("Think","DL_Text",function()

			if !IsValid(ckText.pnl) or ckText.pnl == NULL then
				downloadFailed("Panel failed to open!")
				ckText.SpraysDownloaded[url] = ckText.MSG_FAILED
				return
			end
			
			local html_mat = ckText.pnl:GetHTMLMaterial()
			
			if !ckText.pnl:IsLoading() and !OK then
				
				if html_mat == nil then
					ckText.pnl:Remove()
					downloadFailed("Failed to get HTML Material!")
					ckText.SpraysDownloaded[url] = ckText.MSG_FAILED
					return
				else
					OK = true
					CDTime = CurTime() + 1	
				end
				
			end
			
			if ckText.pnl:IsLoading() and !OK then
				if LoadTime < CurTime() then
					ckText.pnl:Remove()
					downloadFailed("Exceded Load Time!")
					ckText.SpraysDownloaded[url] = ckText.MSG_FAILED
				end
			end
			
			if OK and CDTime < CurTime() then
				
				local vertex_mat = CreateMaterial(url, ckText.shaderType,ckText.matdata )
				
				local textur = html_mat:GetTexture("$basetexture")
							
				textur:Download()
				vertex_mat:SetTexture("$basetexture", textur)	
				textur:Download()
				
				local mst = CreateMaterial(url, ckText.shaderType,ckText.matdata)
				mst:SetTexture("$basetexture", textur)
				
				if mst == nil or mst:Width() <= 0 or mst:Height() <= 0 or mst:IsError( ) then
					ckText.pnl:Remove()
					downloadFailed("Image Error or too small!")
					ckText.SpraysDownloaded[url] = ckText.MSG_ABORT
					return
				end

				ckText.cachedMaterials[url] = mst
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
				
				if dist > 2000 then return end
				
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
				
				if v == nil || v.TEXT == nil then
					table.remove(ckText.SpraysQueue,1)
					return
				end
				
				if ckText.SpraysDownloaded[v.TEXT] == ckText.MSG_NONE then
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
						
						sound.Play( "player/sprayer.wav", v.SprayPos,75,100,0.3)
						table.remove(ckText.SpraysQueue,1)
						print("[SprayURL] Sprayed Texture : " .. v.TEXT)
						
	   				else
	   					print("[SprayURL] Texture still missing, redownloading.")
		   				ckText.SpraysDownloaded[v.TEXT] = ckText.MSG_NONE
		   				continue
		   			end
			   
				elseif ckText.SpraysDownloaded[v.TEXT] == ckText.MSG_FAILED then
					
					if v.CoolDOWN < CurTime() then
					   	if v.Attempts > 0 then
								
							v.Attempts = v.Attempts - 1	
							v.CoolDOWN = CurTime() + 2
							ckText.SpraysDownloaded[v.TEXT] = ckText.MSG_NONE
							v.Retry = true
								
							continue
						else
							print("[SprayURL] Failed to create Spray (ID : " .. v.TEXT .. ")")
							table.remove(ckText.SpraysQueue,1)
							table.remove(ckText.SpraysDownloaded,v.TEXT)
							continue
						end
					end
			
				elseif ckText.SpraysDownloaded[v.TEXT] == ckText.MSG_ABORT then
				
					table.remove(ckText.SpraysQueue,1)
					table.remove(ckText.SpraysDownloaded,v.TEXT)
					
					continue
				
				end
			end
		end
		
	end)

	net.Receive( "sprayURL", function(len, ply) 
		
		if !GetConVar("sprayURL_enabled"):GetBool() then return end
		
		local Texture = net.ReadString()
		local Pos = net.ReadVector()
		local NormalPos = net.ReadVector()
		local Sender = net.ReadEntity()
		
		if GetConVar("sprayurl_keywordban"):GetBool() then 
			if ckText.BannedKeywords != NULL or #ckText.BannedKeywords > 0 then
				if findInTable(Texture,ckText.BannedKeywords) then
					chat.AddText(Color(255,0,0), "[SprayURL]",Color(255,155,0),"[Banned Keywords] ",Color(255,255,255), "Blocked Spray from ",Color(255,0,0),Sender:Name() .. " !" )
					return
				end
			end
		end

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
		
		ckText.SpraysDownloaded[Texture] = ckText.MSG_NONE
		
	end)
	
	net.Receive( "sprayWarning", function(len, ply) 
		surface.PlaySound( "buttons/button2.wav" )
		local msg = net.ReadString()
		chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), msg )
	end)
	
	net.Receive( "whitelistSend", function(len, ply) 
		local tbl = net.ReadTable()
		if tbl == nil then return end
		if #tbl > 0 then
			
			chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), "==== Allowed Websites ====" )
			for tf,te in pairs(tbl) do
				chat.AddText(Color(255,255,255), te )
			end
			chat.AddText(Color(255,255,255), "==== ============ ====" )
		end
	end)

	concommand.Add("sprayurl",function(ply,cmdd,args)
		
		net.Start("sprayRequest")
			
			local Quicky = false
			
			if args != nil && #args > 0 then
				if args[1] != "" then
					Quicky = true
				end
			end
		
			if Quicky then
				net.WriteString(args[1]) // URL	
			else
				net.WriteString(GetConVar( "sprayURL_texture" ):GetString()) // URL		
			end
		
		net.SendToServer()
		
	end)
	
	concommand.Add("sprayurl_reloadkeywords",function(ply)
		loadKeywords()
		chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), "Keywords Reloaded!" )
	end)
	
	concommand.Add("sprayurl_weblist",function(ply)
		if ckText.WhitelistRequestCD < CurTime() then
			net.Start("whitelistRequest")
			net.SendToServer()
			ckText.WhitelistRequestCD = CurTime() + 25
		else
			chat.AddText(Color(255,0,0), "[SprayURL] ",Color(255,255,255), "Wait ".. math.Round(math.abs(CurTime() - ckText.WhitelistRequestCD)) .. " seconds!")
		end
	end)
	
	concommand.Add("sprayurl_clearchache",function(ply,cmdd,args)
		table.Empty(ckText.cachedMaterials)
		table.Empty(ckText.SpraysQueue)
		table.Empty(ckText.SpraysDownloaded)
		if args != nil && #args > 0 then
			if args[1] != "0" then
				RunConsoleCommand("r_cleardecals")
			end
		end
	end)
	
end

if SERVER then

	local plymeta = FindMetaTable( "Player" )
	if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

	CreateConVar( "sprayurl_plyCooldown", "15", FCVAR_ARCHIVE || FCVAR_SERVER_CAN_EXECUTE, "Sets the Cooldown for sprayURL to the players" )
	CreateConVar( "sprayurl_enablewhitelist", "0", FCVAR_ARCHIVE || FCVAR_SERVER_CAN_EXECUTE, "Enable / Disable Website whitelist." )

	util.AddNetworkString( "sprayURL" )
	util.AddNetworkString( "sprayRequest" )
	util.AddNetworkString( "sprayWarning" )
	util.AddNetworkString( "whitelistRequest" )
	util.AddNetworkString( "whitelistSend" )

	SprayURL = SprayURL or {}
	SprayURL.PlayerSpray = SprayURL.PlayerSpray or {}
	
	// Allowed Websited without images formats.
	SprayURL.AllowedWebsites =
	{
		"puu.sh/", // Works
		"dl.dropboxusercontent.com/", // Works
		"i.imgur.com/", // Works
		"steampowered.com/", // Works
		"steamusercontent.com/", // Works
		"fc01.deviantart.net/", // Works
		"9cache.com/", // Works
		"2.media.dorkly.cvcdn.com/", // Works
		"media.tumblr", // Works
		
		// Requested Whitelists
		"photobucket"
	}
	
	// Steam is silly and doesnt have a format.
	SprayURL.CustomFormats = {
		"steampowered",
		"steamusercontent"
	}
	
	// Allowed Formats.
	SprayURL.AllowedFormats = {
	    png = true,
	    jpg = true,
	    bmp = true,
	    jpeg = true,
	    jpe = true,
	    pns = true,
	    pgm = true,
	    tga = true,
	    gif = true
	}
	
	net.Receive( "whitelistRequest", function(len, ply)
		if GetConVarNumber( "sprayurl_enablewhitelist" ) then
			if SprayURL.AllowedWebsites == nil || #SprayURL.AllowedWebsites <= 0 then return end
			net.Start("whitelistSend")
				net.WriteTable(SprayURL.AllowedWebsites)
			net.Send(ply)
		end
	end)
	
	net.Receive( "sprayRequest", function(len, ply)
		
		if !IsValid(ply) then return end
				
		local URL = net.ReadString()
		local extension = URL:lower():sub(-4)
		
		if findInTable(URL,SprayURL.AllowedWebsites) || GetConVarNumber( "sprayurl_enablewhitelist" ) == 0 then
			if !extension:sub(1,1) == "." or !SprayURL.AllowedFormats[extension:sub(2)] and !findInTable(URL,SprayURL.CustomFormats) then
				net.Start("sprayWarning")
						net.WriteString("Incorrect Image format Url!")
				net.Send(ply)
				return
			end
		elseif GetConVarNumber( "sprayurl_enablewhitelist" ) then
			net.Start("sprayWarning")
				net.WriteString("Website not Whitelisted! For more info run sprayurl_weblist on console.")
			net.Send(ply)
			return
		end

		if SprayURL.PlayerSpray[ply:SteamID()] != nil then
			if SprayURL.PlayerSpray[ply:SteamID()] < CurTime() then
				ply:CreateURLSpray(URL)
			else
				net.Start("sprayWarning")
					net.WriteString("You can't place a URLSpray Yet! Wait ".. math.Round(math.abs(CurTime() - SprayURL.PlayerSpray[ply:SteamID()])) )
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
			
			hook.Run("sprayurl_requestspray", self, url, tr)
			
			net.Start("sprayURL")
				net.WriteString(url) // PlayerID
				net.WriteVector(tr.HitPos) // Spray pos
				net.WriteVector(tr.HitNormal) // Spray pos
				net.WriteEntity(self)
			net.Broadcast()
		
		end
	end

end

