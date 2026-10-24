local G=(getgenv and getgenv()) or _G
local P,RS,UIS,TS,HS,Lt,TX=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("HttpService"),game:GetService("Lighting"),game:GetService("TextService")
local LP=P.LocalPlayer
local function gp()
	local o,r=pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
	if o and r then return r end
	return LP:WaitForChild("PlayerGui")
end
local function fail(e)
	warn("[Midnite] "..tostring(e))
	pcall(function()
		local g=Instance.new("ScreenGui") g.Name="MidniteErr" g.ResetOnSpawn=false g.Parent=gp()
		local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-20,0,90) l.Position=UDim2.fromOffset(10,40) l.BackgroundColor3=Color3.fromRGB(150,20,20) l.TextColor3=Color3.new(1,1,1) l.TextWrapped=true l.TextSize=14 l.Font=Enum.Font.Code l.Text="Midnite error: "..tostring(e) l.Parent=g
		task.delay(20,function() g:Destroy() end)
	end)
end

local ok,err=pcall(function()
local rgb=Color3.fromRGB
local CFG,SND="Midnite_Config.json","rbxasset://sounds/switch.wav"
if G.MidniteStop then pcall(G.MidniteStop) end
for _,g in ipairs(gp():GetChildren()) do if g.Name=="Midnite" or g.Name=="MidniteErr" then g:Destroy() end end
local W,H=430,340
local GREEN,RED=rgb(60,230,110),rgb(235,60,60)

-- ===== UI styles =====
local THEMES={
	Black={bg=rgb(0,0,0),bar=rgb(0,0,0),row=rgb(18,18,18),inp=rgb(30,30,30),line=rgb(70,70,70),t=rgb(245,245,245),dm=rgb(150,150,150),r=1,tr=0},
	Midnite={bg=rgb(9,5,15),bar=rgb(6,3,11),row=rgb(20,12,32),inp=rgb(32,18,50),line=rgb(85,40,135),t=rgb(236,230,250),dm=rgb(150,130,185),r=1.2,tr=0},
	Violet={bg=rgb(20,10,36),bar=rgb(14,6,26),row=rgb(36,20,60),inp=rgb(52,30,84),line=rgb(120,70,190),t=rgb(245,240,255),dm=rgb(170,150,210),r=1,tr=0},
	Obsidian={bg=rgb(12,12,14),bar=rgb(8,8,10),row=rgb(24,24,28),inp=rgb(38,38,44),line=rgb(70,70,80),t=rgb(235,235,240),dm=rgb(140,140,150),r=.6,tr=0},
	Ember={bg=rgb(26,10,8),bar=rgb(18,6,4),row=rgb(44,20,14),inp=rgb(64,30,22),line=rgb(140,60,40),t=rgb(255,235,220),dm=rgb(200,150,120),r=1,tr=0},
	Dark={bg=rgb(22,22,28),bar=rgb(17,17,22),row=rgb(30,30,38),inp=rgb(42,42,52),line=rgb(60,60,74),t=rgb(240,240,245),dm=rgb(150,150,162),r=1,tr=0},
	Light={bg=rgb(238,240,246),bar=rgb(222,225,234),row=rgb(250,250,255),inp=rgb(226,229,238),line=rgb(190,194,210),t=rgb(30,30,40),dm=rgb(100,104,120),r=1,tr=0},
	Neon={bg=rgb(8,8,12),bar=rgb(4,4,8),row=rgb(18,18,28),inp=rgb(30,30,46),line=rgb(50,50,74),t=rgb(240,240,255),dm=rgb(140,140,170),r=1,tr=0},
	Ocean={bg=rgb(12,26,40),bar=rgb(8,18,30),row=rgb(22,46,68),inp=rgb(32,62,90),line=rgb(50,90,120),t=rgb(225,240,255),dm=rgb(130,170,200),r=1.2,tr=0},
	Sharp={bg=rgb(18,18,18),bar=rgb(10,10,10),row=rgb(30,30,30),inp=rgb(44,44,44),line=rgb(70,70,70),t=rgb(235,235,235),dm=rgb(140,140,140),r=0,tr=0},
	Midnight={bg=rgb(10,12,30),bar=rgb(6,8,20),row=rgb(20,24,50),inp=rgb(30,36,70),line=rgb(55,62,110),t=rgb(225,230,255),dm=rgb(130,140,190),r=1.4,tr=0},
	Sunset={bg=rgb(40,20,30),bar=rgb(30,14,22),row=rgb(60,30,44),inp=rgb(80,40,58),line=rgb(120,60,80),t=rgb(255,235,225),dm=rgb(220,160,150),r=1.2,tr=0},
	Forest={bg=rgb(16,30,22),bar=rgb(10,22,16),row=rgb(24,46,34),inp=rgb(34,62,46),line=rgb(55,95,70),t=rgb(225,245,230),dm=rgb(140,185,155),r=1,tr=0},
	Cyber={bg=rgb(10,10,16),bar=rgb(6,6,10),row=rgb(16,20,30),inp=rgb(24,30,44),line=rgb(0,160,140),t=rgb(200,255,250),dm=rgb(90,170,170),r=0,tr=0},
	Glass={bg=rgb(30,34,44),bar=rgb(20,24,32),row=rgb(50,56,70),inp=rgb(64,72,90),line=rgb(110,120,140),t=rgb(245,247,252),dm=rgb(180,186,200),r=1.4,tr=.35},
	Candy={bg=rgb(250,235,250),bar=rgb(240,215,240),row=rgb(255,246,255),inp=rgb(245,225,245),line=rgb(230,180,230),t=rgb(90,30,90),dm=rgb(150,100,150),r=2,tr=0},
	Mono={bg=rgb(28,28,28),bar=rgb(20,20,20),row=rgb(40,40,40),inp=rgb(55,55,55),line=rgb(90,90,90),t=rgb(245,245,245),dm=rgb(160,160,160),r=0,tr=0},
	Retro={bg=rgb(34,28,18),bar=rgb(24,20,12),row=rgb(52,42,26),inp=rgb(70,56,34),line=rgb(140,110,60),t=rgb(255,220,150),dm=rgb(200,160,100),r=0,tr=0},
}
local UIN={"Black","Midnite","Violet","Obsidian","Ember","Dark","Light","Neon","Ocean","Sharp","Midnight","Sunset","Forest","Cyber","Glass","Candy","Mono","Retro"}
local ACCS={rgb(150,80,255),rgb(200,60,160),rgb(0,170,255),rgb(150,90,255),rgb(60,220,120),rgb(255,70,70),rgb(255,150,40),rgb(255,215,50),rgb(0,230,230),rgb(240,240,240),rgb(255,105,180),rgb(120,255,80),rgb(40,90,255),rgb(255,255,0),rgb(0,255,160),rgb(255,0,90),rgb(140,100,60)}
local BGS={"Midnite Wave","Solid","Gradient","Color Cycle","Aurora","Grid","Scanlines","Rings","Glow","Photo","Checker","Waves","Starfield","Stripes"}
local FXS={"None","Matrix","Snow","Rain","Stars","Bubbles","Fireflies","Sparks","Confetti","Embers","Orbs","Leaves","Glitch"}
local FONTN={"Jura","SourceSansLight","Michroma","Oswald","Code","Arcade","SciFi","Ubuntu","Nunito","SourceSans","Gotham","GothamMedium","Arial","Cartoon","Bangers","LuckiestGuy","PermanentMarker","IndieFlower","Creepster","Fantasy"}
local FL={}
for _,n in ipairs(FONTN) do if pcall(function() return Enum.Font[n] end) then FL[#FL+1]=n end end
local LANGS={"English","Español","Français","Português","Deutsch"}
local C={} for k,v in pairs(THEMES.Midnite) do C[k]=v end
local S={acc=rgb(150,80,255),font=Enum.Font.SourceSans}
local F={fly=false,flySpeed=50,walk=false,walkVal=16,walkMulti=1,noclip=false,inf=false,spin=false,spinSpeed=20,spinMulti=1,afk=false,
	up=false,dn=false,tpAll=false,tpDelay=.25,tpLoop=true,hAll=false,hTime=5,hLoop=true,hDist=4,hH=0,hOrbit=false,hSpeed=2,
	snd=true,quick=true,rainbow=false,ui="Midnite",fn="Jura",lang="English",ready=false,dHide=false,
	bgStyle="Midnite Wave",bgSpeed=1,fx="None",fxN=28,fxSpeed=1,trans=0,radMul=1,bgImg="",wm=false,jp=false,jpVal=50,espHp=false,bgH=.74,bgS=.65,bgV=1,dp=false,dpHp=30,dpH=400,dpBack=80,nv=false,spam=false,spamMsg="gg",spamDelay=3,aj=false,bh=false,rw=false,aimDz=0,aimDelay=0,cham=false,welcome=true,ctp=false,sprint=false,sprintSpd=32,ghost=false,freeze=false,aimHoriz=false,aimJit=0,aimMin=0,ohead=false,hideOthers=false,bloom=false,sunrays=false,blur=false,cc=false,ccSat=0,ccCon=0,bloomStr=1,tint=false,tintOp=.3,animSpd=1,vol=.5,flash=false,shake=false,jit=false,sglow=true,menuKey="RightShift",sa=true,saFov=120,saMode="Auto",saTarget=nil,ac=false,acCps=10}
local NOSAVE={up=1,dn=1,ready=1,dHide=1,tpAll=1,hAll=1,tpSel=1,org=1,hP=1,lockP=1,holding=1}
local TR={
 ["Español"]="Aim=Apuntar;Visuals=Visuales;Player=Jugador;Game=Juego;Settings=Ajustes;Aimbot=Aimbot;Target=Objetivo;Trigger=Disparo;ESP=ESP;Crosshair=Mira;World=Mundo;Main=Principal;Teleport=Teletransp.;Haunt=Acechar;Performance=Rendimiento;UI=Interfaz;Save=Guardar;Profile=Perfil;Look=Aspecto",
 ["Français"]="Aim=Viser;Visuals=Visuels;Player=Joueur;Game=Jeu;Settings=Réglages;Aimbot=Aimbot;Target=Cible;Trigger=Gâchette;ESP=ESP;Crosshair=Réticule;World=Monde;Main=Principal;Teleport=Téléport;Haunt=Hanter;Performance=Perfs;UI=Interface;Save=Sauver;Profile=Profil;Look=Apparence",
 ["Português"]="Aim=Mira;Visuals=Visuais;Player=Jogador;Game=Jogo;Settings=Config.;Aimbot=Aimbot;Target=Alvo;Trigger=Gatilho;ESP=ESP;Crosshair=Mira;World=Mundo;Main=Principal;Teleport=Teleporte;Haunt=Assombrar;Performance=Desempenho;UI=Interface;Save=Salvar;Profile=Perfil;Look=Visual",
 ["Deutsch"]="Aim=Zielen;Visuals=Visuell;Player=Spieler;Game=Spiel;Settings=Optionen;Aimbot=Aimbot;Target=Ziel;Trigger=Abzug;ESP=ESP;Crosshair=Fadenkreuz;World=Welt;Main=Haupt;Teleport=Teleport;Haunt=Spuken;Performance=Leistung;UI=Oberfläche;Save=Speichern;Profile=Profil;Look=Optik"}
local T={}
for l,s in pairs(TR) do T[l]={} for a,b in s:gmatch("(%w+)=([^;]+)") do T[l][a]=b end end
local function tr(k) local m=T[F.lang] return (m and m[k]) or k end

local function tw(o,t,p,s) t=t/math.max(F.animSpd or 1,.05) TS:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p):Play() end
local BACK=Enum.EasingStyle.Back
local gui,main,showToast,dockUpd,fxBg,bgUG,rebuildSubs
local lastS=0
local function sfx(p)
	if not F.snd or tick()-lastS<.05 then return end
	lastS=tick()
	pcall(function() local s=Instance.new("Sound") s.SoundId=SND s.Volume=F.vol or .5 s.PlaybackSpeed=p or 1.2 s.Parent=gui or workspace s:Play() task.delay(1.5,function() s:Destroy() end) end)
end
local function isP(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
local CN,REG,FONTS,CR,HOOK,TG,NB,SETS,DKT,HB,EXIT={}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local X={navs={},subN={},LK=nil,LINK={}}
local function cn(c) CN[#CN+1]=c return c end
local function cornerVal(base) return math.floor(base*C.r*F.radMul+.5) end
local function pnt(o,k)
	if k=="a" then o.BackgroundColor3=S.acc
	elseif k=="at" then o.TextColor3=S.acc
	elseif k=="as" then o.Color=S.acc
	elseif k=="t" then o.TextColor3=C.t
	elseif k=="dm" then o.TextColor3=C.dm
	else o.BackgroundColor3=C[k] if k=="row" or k=="inp" or k=="bar" then o.BackgroundTransparency=F.glass and .35 or 0 end end
end
local function reg(o,k) REG[#REG+1]={o,k} pnt(o,k) end
local function ripple(o,i)
	local r=Instance.new("Frame") r.BackgroundColor3=Color3.new(1,1,1) r.BackgroundTransparency=.6 r.BorderSizePixel=0
	r.AnchorPoint=Vector2.new(.5,.5) r.Size=UDim2.fromOffset(4,4) r.ZIndex=o.ZIndex+1
	r.Position=UDim2.fromOffset(i.Position.X-o.AbsolutePosition.X,i.Position.Y-o.AbsolutePosition.Y)
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=r
	r.Parent=o
	tw(r,.5,{Size=UDim2.fromOffset(120,120),BackgroundTransparency=1})
	task.delay(.55,function() r:Destroy() end)
end
local function N(c,p,par,k)
	local o=Instance.new(c)
	if o:IsA("GuiObject") then o.BorderSizePixel=0 end
	if c=="TextLabel" or c=="TextButton" or c=="TextBox" then
		o.Font=S.font o.TextSize=13 o.TextColor3=C.t FONTS[#FONTS+1]=o
		if c=="TextLabel" then o.BackgroundTransparency=1 end
	end
	for a,v in pairs(p or {}) do o[a]=v end
	if k then reg(o,k) end
	if c=="TextButton" then
		local sc=Instance.new("UIScale") sc.Parent=o
		o.InputBegan:Connect(function(i) if isP(i) then tw(sc,.08,{Scale=.94}) ripple(o,i) end end)
		o.InputEnded:Connect(function() tw(sc,.14,{Scale=1},BACK) end)
		o.Activated:Connect(function() if not o:GetAttribute("q") then sfx() end end)
	end
	if par then o.Parent=par end
	return o
end
local function cr(o,r) local u=Instance.new("UICorner") u.CornerRadius=UDim.new(0,cornerVal(r or 6)) u.Parent=o CR[#CR+1]={u,r or 6} return u end
local function applyAcc(c) S.acc=c for _,r in ipairs(REG) do pcall(pnt,r[1],r[2]) end for _,f in ipairs(HOOK) do pcall(f) end end

-- ===== animated background =====
local function BGC() return Color3.fromHSV(F.bgH,F.bgS,F.bgV) end
local BGSTYLES={"Grid","Scanlines","Rings","Glow","Photo","Checker","Waves","Starfield","Stripes"}
local BGP={}
local function bgPool(name,count,mk)
	if not BGP[name] then
		BGP[name]={}
		for i=1,count do BGP[name][i]=mk(i) end
	end
	return BGP[name]
end
local function bgFrame()
	return N("Frame",{Size=UDim2.fromOffset(1,1),BackgroundColor3=S.acc,BackgroundTransparency=.7,ZIndex=0,Visible=false},fxBg,"a")
end
local function bgFx(st,t,sp)
	local BCc=BGC()
	for _,s in ipairs(BGSTYLES) do if BGP[s] then for _,f in ipairs(BGP[s]) do f.BackgroundColor3=BCc local us=f:FindFirstChildOfClass("UIStroke") if us then us.Color=BCc end end end end
	bgUG.Color=ColorSequence.new(BGC():Lerp(Color3.new(),.75),BGC():Lerp(Color3.new(),.93)) bgUG.Rotation=90
	if st=="Grid" then
		local g=bgPool("Grid",26,bgFrame)
		local ox,oy=(t*sp*24)%40,(t*sp*14)%40
		for i=1,13 do
			local v=g[i] v.Size=UDim2.fromOffset(1,H) v.Position=UDim2.fromOffset(math.floor(i*40-ox),0) v.Visible=true
			local hz=g[13+i] hz.Size=UDim2.fromOffset(W,1) hz.Position=UDim2.fromOffset(0,math.floor(i*40-oy)) hz.Visible=true
		end
	elseif st=="Scanlines" then
		local g=bgPool("Scanlines",40,bgFrame)
		for j=1,40 do
			local l=g[j] l.Size=UDim2.fromOffset(W,2) l.BackgroundTransparency=.5
			l.Position=UDim2.fromOffset(0,math.floor(((j*8+t*sp*60)%(H+8))-8)) l.Visible=true
		end
	elseif st=="Rings" then
		local g=bgPool("Rings",6,function()
			local f=bgFrame() f.BackgroundTransparency=1
			local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=f
			local s=Instance.new("UIStroke") s.Thickness=2 s.Parent=f reg(s,"as")
			return f
		end)
		for i=1,6 do
			local ph=(t*sp*.35+(i-1)/6)%1
			local sz=math.floor(20+ph*460)
			local f=g[i]
			f.Size=UDim2.fromOffset(sz,sz) f.Position=UDim2.fromOffset(math.floor(W/2-sz/2),math.floor(H/2-sz/2)) f.Visible=true
			f:FindFirstChildOfClass("UIStroke").Transparency=.1+ph*.9
		end
	elseif st=="Glow" then
		local g=bgPool("Glow",2,function()
			local f=bgFrame() f.AnchorPoint=Vector2.new(.5,.5) f.BackgroundTransparency=.8
			local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=f
			return f
		end)
		for i=1,2 do
			local a=t*sp*.4+i*2.1
			local sz=math.floor(260+math.sin(t*sp+i)*40)
			local f=g[i] f.Size=UDim2.fromOffset(sz,sz)
			f.Position=UDim2.fromOffset(math.floor(W/2+math.cos(a)*120),math.floor(H/2+math.sin(a*.8)*70)) f.Visible=true
		end
	elseif st=="Checker" then
		local g=bgPool("Checker",48,bgFrame)
		for i=1,48 do
			local c,r=(i-1)%8,math.floor((i-1)/8)
			local f=g[i] f.Size=UDim2.fromOffset(54,36) f.Position=UDim2.fromOffset(c*54,r*36) f.Visible=true
			f.BackgroundTransparency=((c+r)%2==0) and (.55+.3*math.sin(t*sp+i)) or 1
		end
	elseif st=="Waves" then
		local g=bgPool("Waves",120,bgFrame)
		for k=1,120 do
			local r=math.floor((k-1)/20)+1 local c=(k-1)%20+1
			local f=g[k] f.Size=UDim2.fromOffset(4,4) f.BackgroundTransparency=.3
			f.Position=UDim2.fromOffset(c*22,math.floor(r*45+18*math.sin(c*.5+t*sp*2+r*.7)))
			f.Visible=true
		end
	elseif st=="Starfield" then
		local g=bgPool("Starfield",70,bgFrame)
		for k=1,70 do
			local f=g[k] f.Size=UDim2.fromOffset(2,2)
			f.Position=UDim2.fromOffset((k*137)%W,(k*263)%H)
			f.BackgroundTransparency=.2+.7*(.5+.5*math.sin(t*sp*3+k)) f.Visible=true
		end
	elseif st=="Stripes" then
		local g=bgPool("Stripes",12,bgFrame)
		for k=1,12 do
			local f=g[k] f.Size=UDim2.fromOffset(260,16) f.Rotation=35 f.BackgroundTransparency=.55 f.Visible=true
			f.Position=UDim2.fromOffset(math.floor((k*70+t*sp*50)%(W+300)-200),(k*60)%H)
		end
	elseif st=="Photo" then
		local g=bgPool("Photo",1,function()
			local im=Instance.new("ImageLabel")
			im.Size=UDim2.new(1,0,1,0) im.BackgroundTransparency=1 im.ScaleType=Enum.ScaleType.Crop
			im.ImageTransparency=.35 im.ZIndex=0 im.Visible=false im.Parent=fxBg
			return im
		end)
		g[1].Image=F.bgImg or "" g[1].Visible=true
	end
end
local bgClock,bgAcc=0,0
local function bgPaint(dt)
	if dt then bgAcc=bgAcc+dt if bgAcc<.03 then return end bgClock=bgClock+bgAcc end
	bgAcc=0
	if not bgUG then return end
	local st,sp,t=F.bgStyle,F.bgSpeed,bgClock
	for _,s in ipairs(BGSTYLES) do if BGP[s] then for _,f in ipairs(BGP[s]) do f.Visible=(s==st) end end end
	if st=="Solid" then
		bgUG.Color=ColorSequence.new(BGC():Lerp(Color3.new(),.7),BGC():Lerp(Color3.new(),.7)) bgUG.Rotation=90
	elseif st=="Gradient" then
		bgUG.Color=ColorSequence.new(BGC():Lerp(Color3.new(),.75),BGC():Lerp(Color3.new(),.93)) bgUG.Rotation=90
	elseif st=="Color Cycle" then
		local h=(t*sp*.05)%1
		bgUG.Color=ColorSequence.new(Color3.fromHSV(h,.7,.35),Color3.fromHSV((h+.33)%1,.7,.18))
		bgUG.Rotation=90
	elseif st=="Grid" or st=="Scanlines" or st=="Rings" or st=="Glow" or st=="Photo" or st=="Checker" or st=="Waves" or st=="Starfield" or st=="Stripes" then bgFx(st,t,sp)
	elseif st=="Aurora" then
		bgUG.Color=ColorSequence.new(C.bg:Lerp(BGC(),.3),C.bar:Lerp(BGC(),.08))
		bgUG.Rotation=(t*sp*25)%360
	else
		-- Midnite Wave: black with a purple band that pulses and sweeps around
		local pulse=.5+.5*math.sin(t*sp*1.2)
		local pc=Color3.fromHSV(F.bgH,F.bgS,math.clamp(F.bgV*(.55+.45*pulse),0,1))
		local blk=rgb(8,4,14)
		bgUG.Color=ColorSequence.new({
			ColorSequenceKeypoint.new(0,blk),
			ColorSequenceKeypoint.new(.45,blk:Lerp(pc,.35)),
			ColorSequenceKeypoint.new(.6,pc),
			ColorSequenceKeypoint.new(1,blk)})
		bgUG.Rotation=(t*sp*18)%360
	end
end
local function updBg()
	local tr2=math.max(C.tr or 0,F.trans or 0)
	if main then main.BackgroundTransparency=1 end
	if fxBg then fxBg.BackgroundTransparency=tr2 fxBg.Visible=true end
	bgPaint(nil)
end
local function applyTheme(n)
	local d=THEMES[n] if not d then return end
	for k,v in pairs(d) do C[k]=v end
	F.ui=n
	for _,r in ipairs(REG) do pcall(pnt,r[1],r[2]) end
	for _,c in ipairs(CR) do pcall(function() c[1].CornerRadius=UDim.new(0,cornerVal(c[2])) end) end
	for _,f in ipairs(HOOK) do pcall(f) end
	updBg()
end
local function applyFont(n)
	local f=Enum.Font[n] if not f then return end
	S.font=f F.fn=n
	for _,o in ipairs(FONTS) do pcall(function() if not o:GetAttribute("kf") then o.Font=f end end) end
	if rebuildSubs then pcall(rebuildSubs) end
end
local function drag(h,f)
	local d,s0,p0=false,nil,nil
	h.InputBegan:Connect(function(i) if isP(i) then d=true s0=i.Position p0=f.Position end end)
	cn(UIS.InputChanged:Connect(function(i)
		if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local v=i.Position-s0 f.Position=UDim2.new(p0.X.Scale,p0.X.Offset+v.X,p0.Y.Scale,p0.Y.Offset+v.Y)
		end
	end))
	cn(UIS.InputEnded:Connect(function(i) if isP(i) then d=false end end))
end

-- ===== icons =====
X.ICN={
 target={{"ring",18,18,0,0,99,1.5},{"ring",8,8,0,0,99,1.5},{"bar",2,4,0,-12,0},{"bar",2,4,0,12,0},{"bar",4,2,-12,0,0},{"bar",4,2,12,0,0}},
 eye={{"ring",22,13,0,0,99,1.5},{"ring",7,7,0,0,99,1.5}},
 person={{"ring",9,9,0,-5,99,1.5},{"ring",16,9,0,7,6,1.5}},
 game={{"ring",22,14,0,0,5,1.5},{"dot",3,3,-5,0,0},{"dot",3,3,5,0,0}},
 gear={{"ring",18,18,0,0,99,1.5},{"ring",7,7,0,0,99,1.5}},
 ghost={{"ring",16,16,0,-2,8,1.5},{"dot",3,3,-3,-3,0},{"dot",3,3,3,-3,0}},
 bolt={{"bar",2,10,-2,-3,20},{"bar",2,10,2,3,20}},
 cross={{"bar",2,18,0,0,0},{"bar",18,2,0,0,0}},
 globe={{"ring",18,18,0,0,99,1.5},{"ring",8,18,0,0,99,1.5},{"bar",18,2,0,0,0}},
 speed={{"ring",18,18,0,0,99,1.5},{"bar",2,9,0,-2,35}},
 star={{"bar",2,16,0,0,0},{"bar",2,16,0,0,60},{"bar",2,16,0,0,120}},
 disk={{"ring",18,18,0,0,4,1.5},{"ring",9,6,0,-4,2,1.5}},
 pin={{"ring",12,12,0,-3,99,1.5},{"bar",2,6,0,8,0}},
 palette={{"ring",18,18,0,0,99,1.5},{"dot",3,3,-5,-3,0},{"dot",3,3,4,-5,0}},
 news={{"ring",20,16,0,0,3,1.5},{"bar",12,2,-3,-4,0},{"bar",12,2,-3,0,0},{"bar",7,2,4,4,0}},
 pad={{"ring",22,14,0,0,5,1.5},{"bar",6,2,-5,-1,0},{"bar",2,6,-5,-1,0},{"dot",2,2,5,-2,0},{"dot",2,2,5,2,0}},
 ok={{"ring",12,12,-4,-2,99,1.5},{"bar",2,9,4,1,-15},{"bar",2,9,7.5,1,0},{"bar",2,8,11,2,15}},
 tools={{"ring",10,10,-4,-4,99,1.5},{"bar",3,16,4,4,45}},
 quiet={{"ring",20,20,0,0,99,1.5},{"dot",2,2,-4,-3,0},{"dot",2,2,4,-3,0},{"bar",2,7,0,4,0}},
 misc={{"bar",2,14,-6,0,0},{"bar",2,14,0,0,0},{"bar",2,14,6,0,0},{"dot",4,4,-6,-3,0},{"dot",4,4,0,3,0},{"dot",4,4,6,-2,0}},
 bot={{"ring",16,12,0,2,3,1.5},{"dot",3,3,-3,0,0},{"dot",3,3,3,0,0},{"bar",2,4,0,-8,0}},
 laugh={{"ring",21,21,0,0,99,1.5},{"bar",5,2,-5,-3,20},{"bar",5,2,5,-3,-20},{"ring",12,6,0,3,3,1.5}},
}
X.SI={Changelog="news",Main="gear",Teleport="pin",Haunt="ghost",UI="palette",Look="star",Save="disk",Profile="person",Aimbot="star",Target="target",Trigger="bolt",ESP="eye",Crosshair="cross",World="globe",Performance="speed"}
X.part=function(box,e,k)
	local t,w,h=e[1],math.max(1,math.floor(e[2]*k+.5)),math.max(1,math.floor(e[3]*k+.5))
	local f=Instance.new("Frame")
	f.AnchorPoint=Vector2.new(.5,.5) f.Position=UDim2.new(.5,e[4]*k,.5,e[5]*k) f.Size=UDim2.fromOffset(w,h) f.BorderSizePixel=0 f.Parent=box
	if t=="dot" then reg(f,"a") cr(f,99)
	elseif t=="bar" then f.Rotation=e[6] or 0 reg(f,"a") cr(f,2)
	else
		f.BackgroundTransparency=1 cr(f,e[6] or 99)
		local s=Instance.new("UIStroke") s.Thickness=math.max(1,e[7] or 1.4) s.Parent=f reg(s,"as")
	end
end
X.icon=function(par,kind,sz,pos)
	local k=sz/22
	local box=Instance.new("Frame") box.BackgroundTransparency=1 box.BorderSizePixel=0
	box.Size=UDim2.fromOffset(sz,sz) box.Position=pos or UDim2.new(.5,-sz/2,.5,-sz/2) box.Parent=par
	for _,e in ipairs(X.ICN[kind] or X.ICN.star) do X.part(box,e,k) end
end

-- ===== window =====
gui=N("ScreenGui",{Name="Midnite",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},gp())
local EL=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1},gui)
local ldr=N("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(250,140),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.3,GroupTransparency=1,ZIndex=100},gui)
cr(ldr,12)
local dots={}
for i=1,8 do local a=math.rad((i-1)*45) dots[i]=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,math.cos(a)*14,0,30+math.sin(a)*14),Size=UDim2.fromOffset(5,5)},ldr,"a") cr(dots[i],99) end
N("TextLabel",{Size=UDim2.new(1,0,0,22),Position=UDim2.fromOffset(0,52),Text="Midnite",TextSize=18},ldr,"at")
N("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.fromOffset(0,78),Text="Loading...",TextSize=11},ldr,"dm")
local ldb=N("Frame",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,102),Size=UDim2.fromOffset(180,4)},ldr,"row") cr(ldb,2)
local ldf=N("Frame",{Size=UDim2.new(.9,0,1,0)},ldb,"a") cr(ldf,2)
local ldc=cn(RS.RenderStepped:Connect(function()
	local ph=(tick()*7)%8
	for i,d in ipairs(dots) do d.BackgroundTransparency=.1+((ph-i)%8)/8*.85 end
end))
tw(ldr,.35,{GroupTransparency=0})

main=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(W,H),ClipsDescendants=true,Active=true},gui,"bg") cr(main,10)
local mS=Instance.new("UIScale") mS.Scale=0 mS.Parent=main
local mSt=Instance.new("UIStroke") mSt.Thickness=1 mSt.Transparency=.3 mSt.Parent=main reg(mSt,"as")

-- background layer: always drawn, colors come from bgPaint
fxBg=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(1,1,1),Visible=true,ZIndex=0},main)
cr(fxBg,10)
bgUG=Instance.new("UIGradient") bgUG.Rotation=90 bgUG.Parent=fxBg
bgUG.Color=ColorSequence.new(BGC():Lerp(Color3.new(),.7),BGC():Lerp(Color3.new(),.7))

-- particle layer
local PLF=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=5,Visible=false},main)
local PART={}
for i=1,60 do
	local f=N("Frame",{Size=UDim2.fromOffset(4,4),BackgroundColor3=Color3.new(1,1,1),ZIndex=5,Visible=false},PLF) cr(f,99)
	PART[i]={f=f,x=0,y=0,vx=0,vy=0,s=4,ph=math.random()*6.3,col=Color3.new(1,1,1)}
end
local function resetP(p,init)
	local m=F.fx
	p.s=math.random(3,5) p.vx=0 p.vy=0 p.col=Color3.new(1,1,1)
	p.x=math.random()*W p.y=math.random()*H
	if m=="Snow" then p.vy=math.random(20,40) if not init then p.y=-10 end
	elseif m=="Rain" then p.vy=220 p.s=10 p.col=rgb(150,200,255) if not init then p.y=-10 end
	elseif m=="Stars" then p.s=2
	elseif m=="Bubbles" then p.vy=-math.random(25,50) p.s=math.random(6,12) p.col=rgb(120,200,255) if not init then p.y=H+10 end
	elseif m=="Fireflies" then p.vx=math.random(-15,15) p.vy=math.random(-15,15) p.s=3 p.col=rgb(255,235,120)
	elseif m=="Sparks" then local a=math.random()*6.28 local sp=math.random(60,160) p.x=W/2 p.y=H/2 p.vx=math.cos(a)*sp p.vy=math.sin(a)*sp p.s=3 p.col=rgb(255,170,60)
	elseif m=="Confetti" then p.vy=math.random(40,80) p.vx=math.random(-20,20) p.s=math.random(4,7) p.col=Color3.fromHSV(math.random(),.8,1) if not init then p.y=-10 end
	elseif m=="Embers" then p.vy=-math.random(30,70) p.vx=math.random(-10,10) p.s=math.random(3,5) p.col=rgb(255,120,40) if not init then p.y=H+10 end
	elseif m=="Orbs" then p.vx=math.random(-12,12) p.vy=math.random(-12,12) p.s=math.random(8,14) p.col=rgb(170,90,255)
	elseif m=="Leaves" then p.vx=math.random(-30,30) p.vy=math.random(25,50) p.s=math.random(5,8) p.col=rgb(120,200,90) if not init then p.y=-10 end
	elseif m=="Matrix" then p.vy=math.random(60,180) p.s=3 p.col=rgb(120,255,140) if not init then p.y=-10 end
	elseif m=="Glitch" then p.s=math.random(8,40) p.col=rgb(math.random(120,255),math.random(60,255),255)
	end
	p.f.Size=(m=="Rain") and UDim2.fromOffset(1,p.s) or UDim2.fromOffset(p.s,p.s)
	p.f.BackgroundColor3=p.col p.f.BackgroundTransparency=0
end
local function setFx(m)
	F.fx=m PLF.Visible=m~="None"
	for i,p in ipairs(PART) do
		p.f.Visible=(i<=F.fxN) and m~="None"
		if p.f.Visible then resetP(p,true) end
	end
end

local side=N("Frame",{Size=UDim2.new(0,46,1,0)},main,"bar")
local logo=N("TextLabel",{Size=UDim2.new(1,0,0,34),Text="M",TextSize=20},side,"at")
pcall(function() logo.Font=Enum.Font.Michroma end)
logo:SetAttribute("kf",true)
local CATS={{k="person",n="Player"},{k="target",n="Aim"},{k="eye",n="Visuals"},{k="pad",n="Game"},{k="ok",n="Looks"},{k="laugh",n="Troll"},{k="tools",n="Tools"},{k="quiet",n="Silent Aim"},{k="misc",n="Misc"},{k="news",n="New"}}
for _,c in ipairs(CATS) do c.s={} end
local CI,CURP=1,nil
local PAGES={}
local showCat,showKey
local updInd
local function paintNav()
	for _,n in ipairs(X.navs) do
		local on=n.on()
		n.b.BackgroundColor3=C.row
		n.st.Color=on and S.acc or C.line
		n.st.Thickness=on and 1.5 or 1
	end
	for _,n in ipairs(X.subN) do
		local on=n.on()
		n.b.BackgroundColor3=C.row
		n.st.Color=on and S.acc or C.line
		n.b.TextColor3=on and S.acc or C.t
	end
end
X.paint=function() paintNav() if updInd then task.defer(updInd) end end
HOOK[#HOOK+1]=X.paint
local catBtns={}
local sbox=N("ScrollingFrame",{Position=UDim2.fromOffset(0,66),Size=UDim2.new(1,0,1,-66),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y},side)
for i,c in ipairs(CATS) do
	local b=N("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(6,(i-1)*40),Text=""},sbox) cr(b,8)
	local st=Instance.new("UIStroke") st.Thickness=1 st.Parent=b
	X.icon(b,c.k,22,UDim2.fromOffset(6,6))
	catBtns[i]={b=b,st=st}
	X.navs[#X.navs+1]={b=b,st=st,on=function() return CI==i end}
	b.Activated:Connect(function() showCat(i) end)
end
local top=N("Frame",{Position=UDim2.fromOffset(46,0),Size=UDim2.new(1,-46,0,58)},main,"bar")
local catL=N("TextLabel",{Size=UDim2.fromOffset(70,34),Position=UDim2.fromOffset(8,0),Text="Aim",TextXAlignment=Enum.TextXAlignment.Left,TextSize=13},top,"at")
local subBar=N("ScrollingFrame",{Position=UDim2.fromOffset(78,4),Size=UDim2.new(1,-150,0,26),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollingDirection=Enum.ScrollingDirection.X},top)
local sbl=Instance.new("UIListLayout") sbl.FillDirection=Enum.FillDirection.Horizontal sbl.Padding=UDim.new(0,4) sbl.VerticalAlignment=Enum.VerticalAlignment.Center sbl.SortOrder=Enum.SortOrder.LayoutOrder sbl.Parent=subBar
local hideB=N("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-58,0,5),Text="-",TextSize=18},top,"row") cr(hideB,6)
local exitB=N("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0,5),Text="X",TextSize=12,BackgroundColor3=RED},top) cr(exitB,6)
N("Frame",{Position=UDim2.fromOffset(46,58),Size=UDim2.new(1,-46,0,1)},main,"line")
local heroAv=N("ImageLabel",{Size=UDim2.fromOffset(40,40),Position=UDim2.fromOffset(10,9),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"},top) cr(heroAv,20)
local heroTitle=N("TextLabel",{Size=UDim2.new(1,-200,0,20),Position=UDim2.fromOffset(60,9),Text="Welcome to MidNite",TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},top,"at")
pcall(function() heroTitle.Font=Enum.Font.Michroma end) heroTitle:SetAttribute("kf",true)
local heroStat=N("TextLabel",{Size=UDim2.new(1,-200,0,16),Position=UDim2.fromOffset(60,31),Text="@"..LP.Name.."  |  "..LP.DisplayName,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},top,"dm")
drag(logo,main) drag(top,main)
local body=N("Frame",{Position=UDim2.fromOffset(46,60),Size=UDim2.new(1,-46,1,-60),BackgroundTransparency=1,ClipsDescendants=true},main)

local sGlow=N("Frame",{Size=UDim2.fromOffset(46,42),Position=UDim2.fromOffset(0,-4),BackgroundTransparency=.8,ZIndex=0},sbox,"a") cr(sGlow,12)
local sInd=N("Frame",{Size=UDim2.fromOffset(3,20),Position=UDim2.fromOffset(0,7),ZIndex=3},sbox,"a") cr(sInd,2)
local hGlow=N("Frame",{Size=UDim2.fromOffset(0,10),Position=UDim2.fromOffset(0,27),BackgroundTransparency=.8,ZIndex=0},top,"a") cr(hGlow,5)
local hInd=N("Frame",{Size=UDim2.fromOffset(0,2),Position=UDim2.fromOffset(0,31),ZIndex=3},top,"a") cr(hInd,1)
updInd=function()
	local y=(CI-1)*40
	tw(sGlow,.35,{Position=UDim2.fromOffset(0,y-4)})
	tw(sInd,.35,{Position=UDim2.fromOffset(0,y+7)})
	for _,n in ipairs(X.subN) do
		if n.on() and n.b.Parent then
			local x=n.b.AbsolutePosition.X-top.AbsolutePosition.X
			local w=n.b.AbsoluteSize.X
			tw(hInd,.35,{Position=UDim2.fromOffset(x,31),Size=UDim2.fromOffset(w,2)})
			tw(hGlow,.35,{Position=UDim2.fromOffset(x-4,27),Size=UDim2.fromOffset(w+8,10)})
		end
	end
end

local function tsz(t) return TX:GetTextSize(t,12,S.font,Vector2.new(400,22)).X end
X.subN={}
local STACK={}
local SECS={}
local SECN=0
local function stackFor(cname)
	if not STACK[cname] then
		local g=N("CanvasGroup",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,GroupTransparency=1,Visible=false},body)
		local s=N("ScrollingFrame",{Size=UDim2.new(1,-8,1,-6),Position=UDim2.fromOffset(4,4),BackgroundTransparency=1,ScrollBarThickness=2,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y},g)
		local l=Instance.new("UIListLayout") l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,6) l.Parent=s
		STACK[cname]={g=g,s=s}
	end
	return STACK[cname].s
end
-- open or close one section; the body slides in/out, the arrow rotates
local function setSec(key,open,anim)
	if G.midnitePreview then G.midnitePreview(open and key or nil) end
	local s=SECS[key] if not s then return end
	s.open=open
	tw(s.chev,.25,{Rotation=open and 0 or -90})
	if open then
		s.p.Visible=true
		if not anim then s.p.AutomaticSize=Enum.AutomaticSize.Y return end
		s.p.AutomaticSize=Enum.AutomaticSize.None
		s.p.Size=UDim2.new(1,-8,0,0)
		task.defer(function()
			if not s.open then return end
			tw(s.p,.3,{Size=UDim2.new(1,-8,0,s.l.AbsoluteContentSize.Y)},BACK)
			task.delay(.32,function() if s.open then s.p.AutomaticSize=Enum.AutomaticSize.Y end end)
		end)
	else
		if not anim then s.p.Visible=false s.p.AutomaticSize=Enum.AutomaticSize.None s.p.Size=UDim2.new(1,-8,0,0) return end
		local h=s.p.AbsoluteSize.Y
		s.p.AutomaticSize=Enum.AutomaticSize.None
		s.p.Size=UDim2.new(1,-8,0,h)
		tw(s.p,.25,{Size=UDim2.new(1,-8,0,0)})
		task.delay(.26,function() if not s.open then s.p.Visible=false end end)
	end
end
rebuildSubs=function(fade)
	local c=CATS[CI]
	catL.Text=tr(c.n)
	catL.Size=UDim2.fromOffset(160,18) catL.Position=UDim2.new(1,-170,0,36) catL.TextXAlignment=Enum.TextXAlignment.Right
	subBar.Visible=false hInd.Visible=false hGlow.Visible=false
	for name,st in pairs(STACK) do if name~=c.n then st.g.Visible=false end end
	local st=STACK[c.n]
	if st then
		st.g.Visible=true
		if fade then st.g.GroupTransparency=1 tw(st.g,.28,{GroupTransparency=0})
		else st.g.GroupTransparency=0 end
	end
	local any=false
	for _,sn in ipairs(c.s) do local s=SECS[c.n.."/"..sn] if s and s.open then any=true end end
	if not any and c.s[1] then setSec(c.n.."/"..c.s[1],true,false) end
	X.paint()
end
showKey=function(key) if SECS[key] then setSec(key,true,false) end end
showCat=function(i)
	CI=i rebuildSubs(true)
	local sc=catBtns[i] and catBtns[i].b:FindFirstChildOfClass("UIScale")
	if sc then sc.Scale=.75 tw(sc,.4,{Scale=1},BACK) end
end
local function page(cname,sn)
	local key=cname.."/"..sn
	if PAGES[key] then return PAGES[key] end
	local c
	for _,x in ipairs(CATS) do if x.n==cname then c=x end end
	if not table.find(c.s,sn) then c.s[#c.s+1]=sn end
	local list=stackFor(cname)
	SECN=SECN+1
	local hdr=N("TextButton",{Size=UDim2.new(1,-8,0,36),Text=tr(sn),TextSize=13,LayoutOrder=SECN*2-1,AutoButtonColor=false},list,"inp") cr(hdr,8)
	local chev=N("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-24,.5,-7),BackgroundTransparency=1,Rotation=0},hdr)
	N("Frame",{Size=UDim2.fromOffset(8,2),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(4,6),Rotation=45},chev,"a")
	N("Frame",{Size=UDim2.fromOffset(8,2),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(10,6),Rotation=-45},chev,"a")
	local p=N("Frame",{Size=UDim2.new(1,-8,0,0),BackgroundTransparency=1,ClipsDescendants=true,Visible=false,LayoutOrder=SECN*2,AutomaticSize=Enum.AutomaticSize.None},list)
	local l=Instance.new("UIListLayout") l.SortOrder=Enum.SortOrder.LayoutOrder l.Parent=p
	PAGES[key]=p
	SECS[key]={key=key,hdr=hdr,chev=chev,p=p,l=l,open=false}
	hdr.Activated:Connect(function() setSec(key,not SECS[key].open,true) end)
	return p
end

-- ===== widgets =====
local ORD=0
local function ord() ORD=ORD+1 return ORD end
local function row(pg,h)
	local f=N("Frame",{Size=UDim2.new(1,-8,0,h or 36),BackgroundTransparency=1,LayoutOrder=ord(),ClipsDescendants=true},pg)
	N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1)},f,"line")
	return f
end
local function head(pg,t)
	local f=N("Frame",{Size=UDim2.new(1,-8,0,24),BackgroundTransparency=1,LayoutOrder=ord()},pg)
	N("TextLabel",{Size=UDim2.new(1,-8,1,-4),Position=UDim2.fromOffset(4,0),Text=string.upper(t),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom},f,"at")
end
local function lbl(f,title,desc,w)
	w=w or .6
	local t=N("TextLabel",{Size=UDim2.new(w,0,0,desc and 17 or 0),Position=UDim2.fromOffset(8,desc and 5 or 0),Text=title,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,TextSize=13},f,"t")
	if not desc then t.Size=UDim2.new(w,0,1,0) end
	if desc then N("TextLabel",{Size=UDim2.new(w,-6,0,13),Position=UDim2.fromOffset(8,21),Text=desc,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,TextSize=10},f,"dm") end
end

-- linked rows slide in/out under a toggle
X.reveal=function(f,on)
	local full=f:GetAttribute("H") or 36
	if f:GetAttribute("open")==on then return end
	f:SetAttribute("open",on)
	if on then f.Visible=true end
	tw(f,.3,{Size=UDim2.new(1,-8,0,on and full or 0)},BACK)
	for _,d in ipairs(f:GetDescendants()) do
		if d:IsA("GuiObject") and not d:IsA("UIScale") then
			if d:GetAttribute("bg")==nil then d:SetAttribute("bg",d.BackgroundTransparency) end
			tw(d,.3,{BackgroundTransparency=on and d:GetAttribute("bg") or 1})
			if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
				if d:GetAttribute("tt")==nil then d:SetAttribute("tt",d.TextTransparency) end
				tw(d,.3,{TextTransparency=on and d:GetAttribute("tt") or 1})
			end
		end
	end
	if not on then task.delay(.32,function() if f:GetAttribute("open")==false then f.Visible=false end end) end
end
local function linkRow(f)
	local lk=X.LK
	if not lk then return end
	X.LINK[lk]=X.LINK[lk] or {}
	table.insert(X.LINK[lk],f)
	f:SetAttribute("H",f.Size.Y.Offset)
	f:SetAttribute("open",F[lk] and true or false)
	if not F[lk] then f.Size=UDim2.new(1,-8,0,0) f.Visible=false end
end
local function tg(pg,title,desc,flag,cb)
	local f=row(pg,desc and 40 or 34) lbl(f,title,desc)
	local sw=N("TextButton",{Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-46,.5,-10),Text="",AutoButtonColor=false},f) cr(sw,10) sw:SetAttribute("q",true)
	local kn=N("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(3,3),BackgroundColor3=Color3.new(1,1,1)},sw) cr(kn,7)
	local function paint(an)
		local on=F[flag] and true or false
		local bc=on and S.acc or C.inp
		local pos=on and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3)
		if an then tw(sw,.18,{BackgroundColor3=bc}) tw(kn,.2,{Position=pos},BACK) else sw.BackgroundColor3=bc kn.Position=pos end
	end
	HOOK[#HOOK+1]=function() paint(false) end
	paint(false)
	TG[flag]=function(v,q)
		F[flag]=v and true or false paint(true)
		if not q then sfx(v and 1.5 or .8) end
		if X.LINK[flag] then for _,lf in ipairs(X.LINK[flag]) do X.reveal(lf,F[flag]) end end
		if cb then cb(F[flag]) end
		if DKT[flag] then pcall(DKT[flag]) end
	end
	sw.Activated:Connect(function() TG[flag](not F[flag]) end)
	linkRow(f)
	return f
end
local function nb(pg,title,desc,flag,mn,mx,cb)
	mn=mn or 0
	local f=row(pg,40) lbl(f,title,desc,.36)
	-- open-ended numbers get a slider range that grows with the value
	local function hi() return mx or math.max(100,(F[flag] or 0)*2) end
	local hit=N("Frame",{Size=UDim2.new(.36,0,0,22),Position=UDim2.new(.38,4,.5,-11),BackgroundTransparency=1,Active=true},f)
	local tk=N("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.fromOffset(0,9)},hit,"inp") cr(tk,2)
	local fl=N("Frame",{Size=UDim2.new(0,0,1,0)},tk,"a") cr(fl,2)
	local kn=N("Frame",{Size=UDim2.fromOffset(12,12),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(0,0,.5,0),BackgroundColor3=Color3.new(1,1,1)},tk) cr(kn,6)
	local tb=N("TextBox",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-56,.5,-11),Text="",TextSize=11,ClearTextOnFocus=false},f,"inp") cr(tb,5)
	local function fmt(v) return (math.floor(v)==v) and tostring(math.floor(v)) or string.format("%.2f",v) end
	local function rd()
		local q=math.clamp((F[flag]-mn)/math.max(hi()-mn,.0001),0,1)
		fl.Size=UDim2.new(q,0,1,0) kn.Position=UDim2.new(q,0,.5,0)
		tb.Text=fmt(F[flag])
	end
	local function ap(n)
		if n<mn then n=mn end
		if mx and n>mx then n=mx end
		F[flag]=n rd()
		if cb then cb(n) end
	end
	NB[flag]=ap
	tb.FocusLost:Connect(function() local n=tonumber(tb.Text) if n then ap(n) else rd() end end)
	local dg=false
	local function fm(x)
		local v=mn+math.clamp((x-tk.AbsolutePosition.X)/math.max(tk.AbsoluteSize.X,1),0,1)*(hi()-mn)
		ap(math.floor(v*100+.5)/100)
	end
	hit.InputBegan:Connect(function(i) if isP(i) then dg=true pcall(function() pg.ScrollingEnabled=false end) fm(i.Position.X) end end)
	cn(UIS.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fm(i.Position.X) end end))
	cn(UIS.InputEnded:Connect(function(i) if dg and isP(i) then dg=false pcall(function() pg.ScrollingEnabled=true end) end end))
	rd()
	linkRow(f)
	return ap
end
local function ch(pg,title,desc,list,flag,cb,sty)
	local f=row(pg,desc and 40 or 34) lbl(f,title,desc,.36)
	local sc=N("ScrollingFrame",{Size=UDim2.new(.64,-8,0,24),Position=UDim2.new(.36,0,.5,-12),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollingDirection=Enum.ScrollingDirection.X},f)
	local L2=Instance.new("UIListLayout") L2.FillDirection=Enum.FillDirection.Horizontal L2.Padding=UDim.new(0,4) L2.VerticalAlignment=Enum.VerticalAlignment.Center L2.SortOrder=Enum.SortOrder.LayoutOrder L2.Parent=sc
	local bs,cs={},{}
	local function pn()
		for n,b in pairs(bs) do
			local on=n==F[flag]
			b.TextColor3=on and S.acc or C.t
			cs[n].Color=on and S.acc or C.line
			cs[n].Thickness=on and 1.5 or 1
		end
	end
	HOOK[#HOOK+1]=pn
	local function set(n,q) F[flag]=n pn() if not q then sfx() end if cb then cb(n) end end
	SETS[flag]=set
	for i,n in ipairs(list) do
		local b=N("TextButton",{Size=UDim2.fromOffset(0,22),AutomaticSize=Enum.AutomaticSize.X,Text=n,TextSize=11,LayoutOrder=i},sc)
		cr(b,5)
		local pd=Instance.new("UIPadding") pd.PaddingLeft=UDim.new(0,7) pd.PaddingRight=UDim.new(0,7) pd.Parent=b
		local st=Instance.new("UIStroke") st.Thickness=1 st.Parent=b
		if sty then sty(b,n) end
		bs[n]=b cs[n]=st
		b.Activated:Connect(function() set(n) end)
	end
	pn()
	linkRow(f)
	return set
end
local function sl(pg,title,flag,mn,mx,cb)
	local f=row(pg,40) lbl(f,title,nil,.4)
	local hit=N("Frame",{Size=UDim2.new(.36,0,0,22),Position=UDim2.new(.4,4,.5,-11),BackgroundTransparency=1,Active=true},f)
	local tk=N("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.fromOffset(0,9)},hit,"inp") cr(tk,2)
	local fl=N("Frame",{Size=UDim2.new(0,0,1,0)},tk,"a") cr(fl,2)
	local kn=N("Frame",{Size=UDim2.fromOffset(12,12),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(0,0,.5,0),BackgroundColor3=Color3.new(1,1,1)},tk) cr(kn,6)
	local tb=N("TextBox",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-56,.5,-11),Text="",TextSize=11,ClearTextOnFocus=false},f,"inp") cr(tb,5)
	local function rd()
		local q=(F[flag]-mn)/(mx-mn)
		fl.Size=UDim2.new(q,0,1,0) kn.Position=UDim2.new(q,0,.5,0)
		tb.Text=string.format("%.2f",F[flag])
	end
	local function st(v) F[flag]=math.clamp(math.floor(v*100+.5)/100,mn,mx) rd() if cb then cb(F[flag]) end end
	NB[flag]=st
	tb.FocusLost:Connect(function() local n=tonumber(tb.Text) if n then st(n) else rd() end end)
	local dg=false
	local function fm(x) st(mn+math.clamp((x-tk.AbsolutePosition.X)/math.max(tk.AbsoluteSize.X,1),0,1)*(mx-mn)) end
	hit.InputBegan:Connect(function(i) if isP(i) then dg=true pcall(function() pg.ScrollingEnabled=false end) fm(i.Position.X) end end)
	cn(UIS.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fm(i.Position.X) end end))
	cn(UIS.InputEnded:Connect(function(i) if dg and isP(i) then dg=false pcall(function() pg.ScrollingEnabled=true end) end end))
	rd()
	linkRow(f)
end
local function btnRow(pg,a,b,fa,fb)
	local f=row(pg,36)
	local x=N("TextButton",{Size=UDim2.new(.5,-12,0,24),Position=UDim2.fromOffset(8,6),Text=a,TextSize=12},f,"inp") cr(x,6)
	local y=N("TextButton",{Size=UDim2.new(.5,-12,0,24),Position=UDim2.new(.5,4,0,6),Text=b,TextSize=12},f,"a") cr(y,6)
	y.TextColor3=Color3.new(1,1,1)
	x.Activated:Connect(fa) y.Activated:Connect(fb)
	return f
end
local function swatches(pg)
	local f=row(pg,40) lbl(f,"Accent Color","Pick a color or Rainbow",.38)
	local sc=N("ScrollingFrame",{Size=UDim2.new(.62,-8,0,24),Position=UDim2.new(.38,0,.5,-12),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollingDirection=Enum.ScrollingDirection.X},f)
	local L2=Instance.new("UIListLayout") L2.FillDirection=Enum.FillDirection.Horizontal L2.Padding=UDim.new(0,4) L2.VerticalAlignment=Enum.VerticalAlignment.Center L2.SortOrder=Enum.SortOrder.LayoutOrder L2.Parent=sc
	local rb=N("TextButton",{Size=UDim2.fromOffset(22,22),Text="",AutoButtonColor=false,LayoutOrder=0},sc) cr(rb,11)
	local g=Instance.new("UIGradient")
	g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,rgb(255,0,0)),ColorSequenceKeypoint.new(.33,rgb(0,255,0)),ColorSequenceKeypoint.new(.66,rgb(0,0,255)),ColorSequenceKeypoint.new(1,rgb(255,0,0))})
	g.Parent=rb
	rb.Activated:Connect(function() TG.rainbow(true) end)
	for i,c in ipairs(ACCS) do
		local b=N("TextButton",{Size=UDim2.fromOffset(22,22),BackgroundColor3=c,Text="",AutoButtonColor=false,LayoutOrder=i},sc) cr(b,11)
		b.Activated:Connect(function() if F.rainbow then TG.rainbow(false,true) end applyAcc(c) end)
	end
end
local function plist(pg,getSel,onPick,withView)
	local btns={}
	local function paint() for p,b in pairs(btns) do b.TextColor3=(p==getSel()) and GREEN or C.t end end
	local function refresh()
		for _,b in pairs(btns) do if b.Parent then b.Parent:Destroy() end end
		btns={}
		for _,p in ipairs(P:GetPlayers()) do if p~=LP then
			local f=N("Frame",{Size=UDim2.new(1,-8,0,30),BackgroundTransparency=1,LayoutOrder=ord()},pg)
			local av=N("ImageLabel",{Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(4,3),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"},f) cr(av,12)
			local b=N("TextButton",{Size=UDim2.new(1,withView and -88 or -34,1,0),Position=UDim2.fromOffset(34,0),Text=p.Name,TextSize=12},f,"row") cr(b,6)
			local bst=Instance.new("UIStroke") bst.Thickness=1 bst.Color=C.line bst.Parent=b
			b.Activated:Connect(function() onPick(p) paint() end)
			btns[p]=b
			if withView then
				local v=N("TextButton",{Size=UDim2.fromOffset(46,30),Position=UDim2.new(1,-46,0,0),Text="View",TextSize=11},f,"inp") cr(v,6)
				v.Activated:Connect(function() local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid") if h then workspace.CurrentCamera.CameraSubject=h end end)
			end
		end end
		paint()
	end
	refresh()
	cn(P.PlayerAdded:Connect(function() task.wait(.3) refresh() end))
	cn(P.PlayerRemoving:Connect(function() task.wait(.3) refresh() end))
	HOOK[#HOOK+1]=paint
	return refresh,paint
end

local TILE_COL={Checker={rgb(14,10,24),rgb(120,70,200)},Waves={rgb(10,8,20),rgb(160,100,255)},Starfield={rgb(4,4,10),rgb(200,180,255)},Stripes={rgb(16,8,26),rgb(150,80,255)},["Midnite Wave"]={rgb(8,4,14),rgb(150,80,255)},Solid={rgb(26,26,32),rgb(26,26,32)},Gradient={rgb(40,40,52),rgb(12,12,18)},["Color Cycle"]={rgb(200,60,160),rgb(40,90,255)},Aurora={rgb(60,30,100),rgb(150,80,255)},Grid={rgb(12,8,22),rgb(110,60,200)},Scanlines={rgb(6,6,10),rgb(0,200,200)},Rings={rgb(14,6,28),rgb(190,120,255)},Glow={rgb(12,6,22),rgb(170,90,255)},Photo={rgb(40,40,48),rgb(90,90,110)}}
local function colorWheel(pg)
	local f=N("Frame",{Size=UDim2.new(1,-8,0,0),BackgroundTransparency=1,LayoutOrder=ord(),ClipsDescendants=true},pg)
	local wh=N("Frame",{Size=UDim2.fromOffset(136,136),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1},f)
	local prev=N("Frame",{Size=UDim2.fromOffset(40,40),Position=UDim2.new(.5,-20,.5,-20)},wh) cr(prev,20)
	local refresh
	local function setCol(h,s,v) F.bgH,F.bgS,F.bgV=h,s,v updBg() refresh() end
	for i=0,35 do
		local a=math.rad(i*10)
		local d=N("TextButton",{Size=UDim2.fromOffset(12,12),Position=UDim2.fromOffset(68+math.cos(a)*60-6,68+math.sin(a)*60-6),Text="",AutoButtonColor=false,BackgroundColor3=Color3.fromHSV(i/36,1,1)},wh) cr(d,6)
		d.Activated:Connect(function() setCol(i/36,.85,math.max(F.bgV,.5)) end)
	end
	local vb=N("TextButton",{Size=UDim2.fromOffset(22,136),Position=UDim2.fromOffset(160,8),Text="",AutoButtonColor=false},f) cr(vb,6)
	local vg=Instance.new("UIGradient") vg.Rotation=90 vg.Parent=vb
	local dg=false
	local function vset(y)
		local v=1-math.clamp((y-vb.AbsolutePosition.Y)/math.max(vb.AbsoluteSize.Y,1),0,1)
		setCol(F.bgH,F.bgS,math.max(v,.03))
	end
	vb.InputBegan:Connect(function(i) if isP(i) then dg=true vset(i.Position.Y) end end)
	cn(UIS.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then vset(i.Position.Y) end end))
	cn(UIS.InputEnded:Connect(function(i) if isP(i) then dg=false end end))
	local rs=N("TextButton",{Size=UDim2.fromOffset(120,26),Position=UDim2.fromOffset(196,8),Text="Reset Purple",TextSize=11},f,"inp") cr(rs,6)
	rs.Activated:Connect(function() setCol(.74,.65,1) end)
	N("TextLabel",{Size=UDim2.fromOffset(180,44),Position=UDim2.fromOffset(196,42),TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Text="Tap the ring to pick a color. Drag the bar to change brightness."},f,"dm")
	refresh=function()
		prev.BackgroundColor3=Color3.fromHSV(F.bgH,F.bgS,F.bgV)
		vg.Color=ColorSequence.new(Color3.fromHSV(F.bgH,F.bgS,1),Color3.new(0,0,0))
	end
	HOOK[#HOOK+1]=refresh
	refresh()
	return {open=function(anim)
		if anim then tw(f,.4,{Size=UDim2.new(1,-8,0,160)},BACK) else f.Size=UDim2.new(1,-8,0,160) end
	end}
end

local function tilePreview(b,name)
	local function add(props)
		local o=Instance.new("Frame") o.BorderSizePixel=0
		for k,v in pairs(props) do o[k]=v end
		o.Parent=b return o
	end
	local function ring(sz,tr)
		local r=add({Size=UDim2.fromOffset(sz,sz),Position=UDim2.new(.5,-sz/2,.5,-sz/2),BackgroundTransparency=1})
		local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=r
		local s=Instance.new("UIStroke") s.Thickness=1.5 s.Color=S.acc s.Transparency=tr s.Parent=r
		return r
	end
	local function band(y,rot,tr)
		local f=add({Size=UDim2.fromOffset(150,26),Position=UDim2.fromOffset(-20,y),Rotation=rot,BackgroundColor3=S.acc,BackgroundTransparency=tr})
		return f
	end
	if name=="Grid" then
		for i=1,6 do add({Size=UDim2.fromOffset(1,78),Position=UDim2.fromOffset(i*16,0),BackgroundColor3=S.acc,BackgroundTransparency=.4}) end
		for j=1,4 do add({Size=UDim2.fromOffset(104,1),Position=UDim2.fromOffset(0,j*16),BackgroundColor3=S.acc,BackgroundTransparency=.4}) end
	elseif name=="Scanlines" then
		for j=1,14 do add({Size=UDim2.fromOffset(104,2),Position=UDim2.fromOffset(0,j*5),BackgroundColor3=S.acc,BackgroundTransparency=.45}) end
	elseif name=="Rings" then
		ring(24,.2) ring(48,.45) ring(72,.7)
	elseif name=="Glow" then
		local g=add({Size=UDim2.fromOffset(70,70),Position=UDim2.new(.5,-35,.5,-35),BackgroundColor3=S.acc,BackgroundTransparency=.55})
		local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=g
	elseif name=="Photo" then
		local fr=add({Size=UDim2.fromOffset(50,34),Position=UDim2.new(.5,-25,.5,-17),BackgroundTransparency=1})
		local s=Instance.new("UIStroke") s.Thickness=2 s.Color=S.acc s.Parent=fr
		local sun=add({Size=UDim2.fromOffset(9,9),Position=UDim2.fromOffset(34,8),BackgroundColor3=S.acc})
		local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=sun
	elseif name=="Checker" then
		for c=0,3 do for r=0,2 do if (c+r)%2==0 then add({Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(6+c*24,6+r*24),BackgroundColor3=S.acc,BackgroundTransparency=.35}) end end end
	elseif name=="Waves" then
		for c=1,10 do add({Size=UDim2.fromOffset(4,4),Position=UDim2.fromOffset(c*10,40+math.floor(12*math.sin(c*.7))),BackgroundColor3=S.acc}) end
		for c=1,10 do add({Size=UDim2.fromOffset(4,4),Position=UDim2.fromOffset(c*10,22+math.floor(10*math.sin(c*.7+1))),BackgroundColor3=S.acc,BackgroundTransparency=.5}) end
	elseif name=="Starfield" then
		for k=1,25 do add({Size=UDim2.fromOffset(2,2),Position=UDim2.fromOffset((k*137)%100+2,(k*263)%70+4),BackgroundColor3=Color3.new(1,1,1)}) end
	elseif name=="Stripes" then
		for k=1,4 do add({Size=UDim2.fromOffset(150,8),Position=UDim2.fromOffset(-20+k*18,k*16),Rotation=35,BackgroundColor3=S.acc,BackgroundTransparency=.4}) end
	elseif name=="Aurora" or name=="Midnite Wave" or name=="Color Cycle" then
		band(30,-25,.45) band(12,-25,.7)
	end
end
local function bgTiles(pg)
	local f=row(pg,96)
	local sc=N("ScrollingFrame",{Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),BackgroundTransparency=1,ScrollBarThickness=2,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollingDirection=Enum.ScrollingDirection.X},f)
	local L=Instance.new("UIListLayout") L.FillDirection=Enum.FillDirection.Horizontal L.Padding=UDim.new(0,6) L.SortOrder=Enum.SortOrder.LayoutOrder L.Parent=sc
	local tiles={}
	local function pn()
		for name,t in pairs(tiles) do
			local on=name==F.bgStyle
			t.st.Color=on and S.acc or C.line
			t.st.Thickness=on and 2 or 1
		end
	end
	HOOK[#HOOK+1]=pn
	local wf=colorWheel(pg)
	SETS.bgStyle=function(n,q) F.bgStyle=n pn() if not q then sfx() end updBg() if wf then wf.open(not q) end end
	for i,name in ipairs(BGS) do
		local cols=TILE_COL[name] or {C.bg,C.bar}
		local b=N("TextButton",{Size=UDim2.fromOffset(104,78),Text="",AutoButtonColor=false,LayoutOrder=i},sc) cr(b,8)
		local g=Instance.new("UIGradient") g.Rotation=45 g.Color=ColorSequence.new(cols[1],cols[2]) g.Parent=b
		tilePreview(b,name)
		N("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.4,Text=name,TextSize=10,TextTruncate=Enum.TextTruncate.AtEnd,TextColor3=Color3.new(1,1,1)},b)
		local st=Instance.new("UIStroke") st.Thickness=1 st.Color=C.line st.Parent=b
		tiles[name]={st=st}
		b.Activated:Connect(function() SETS.bgStyle(name) end)
	end
	pn()
end

-- ===== fly =====
local fc,ctl,fpos,flw,fyaw
pcall(function() local m=LP:FindFirstChild("PlayerScripts"):FindFirstChild("PlayerModule") ctl=require(m):GetControls() end)
local fctl=N("Frame",{Size=UDim2.fromOffset(52,110),Position=UDim2.new(1,-66,.5,-55),BackgroundTransparency=1,Visible=false},gui)
for i,k in ipairs({"up","dn"}) do
	local b=N("TextButton",{Size=UDim2.fromOffset(52,50),Position=UDim2.fromOffset(0,(i-1)*60),Text=(i==1) and "▲" or "▼",TextSize=20,AutoButtonColor=false},fctl,"row") cr(b,8) b:SetAttribute("q",true)
	b.InputBegan:Connect(function(x)
		if isP(x) then F[k]=true local c c=x.Changed:Connect(function() if x.UserInputState==Enum.UserInputState.End then F[k]=false c:Disconnect() end end) end
	end)
end
cn(UIS.InputBegan:Connect(function(i,g) if g then return end  end))
cn(UIS.InputEnded:Connect(function(i)  end))
local function root() local c=LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function hum() local c=LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function flat(v) local f=Vector3.new(v.X,0,v.Z) if f.Magnitude<.01 then return Vector3.zero end return f.Unit end
local function stopFly()
	F.fly=false F.up=false F.dn=false fctl.Visible=false
	if fc then fc:Disconnect() fc=nil end
	local h=hum() if h then h.PlatformStand=false end
end
local function startFly()
	local r,h=root(),hum() if not r or not h then return end
	if fc then fc:Disconnect() fc=nil end
	F.fly=true h.PlatformStand=true
	fpos=r.Position flw=fpos
	local look=r.CFrame.LookVector
	fyaw=math.atan2(-look.X,-look.Z)
	fc=RS.RenderStepped:Connect(function(dt)
		local cam,hm,rt=workspace.CurrentCamera,hum(),root()
		if not rt or not hm then return end
		hm.PlatformStand=true
		if (rt.Position-flw).Magnitude>8 then fpos=rt.Position end
		local d=Vector3.zero
		if ctl then
			local okm,v=pcall(ctl.GetMoveVector,ctl)
			if okm and v and v.Magnitude>.2 then d=cam.CFrame.LookVector*(-v.Z)+cam.CFrame.RightVector*v.X end
		elseif hm.MoveDirection.Magnitude>.2 then d=hm.MoveDirection end
		
		if d.Magnitude>1 then d=d.Unit end
		fpos=fpos+d*F.flySpeed*dt
		local rot
		if F.spin then fyaw=fyaw+math.rad(F.spinSpeed*F.spinMulti) rot=CFrame.Angles(0,fyaw,0)
		else local f=flat(cam.CFrame.LookVector) rot=(f.Magnitude>0) and CFrame.lookAt(Vector3.zero,f) or CFrame.new() end
		rt.AssemblyLinearVelocity=Vector3.zero rt.AssemblyAngularVelocity=Vector3.zero
		rt.CFrame=CFrame.new(fpos)*rot
		flw=fpos
	end)
end

-- ===== teleport + haunt =====
local function tpTo(p)
	local a,m=p.Character and p.Character:FindFirstChild("HumanoidRootPart"),root()
	if not(a and m) then return false end
	if not F.org then F.org=m.CFrame end
	m.CFrame=a.CFrame*CFrame.new(0,0,3)
	F.tpSel=p
	return true
end
local tpTok=0
local function runTpAll(v)
	tpTok=tpTok+1
	if not v then return end
	local my=tpTok
	task.spawn(function()
		while F.tpAll and tpTok==my do
			local l={} for _,p in ipairs(P:GetPlayers()) do if p~=LP then l[#l+1]=p end end
			if #l==0 then break end
			for _,p in ipairs(l) do
				if not(F.tpAll and tpTok==my) then break end
				if p.Parent then tpTo(p) task.wait(math.max(.03,F.tpDelay)) end
			end
			if not F.tpLoop then break end
			task.wait()
		end
		if tpTok==my and F.tpAll then TG.tpAll(false,true) end
	end)
end
local hTok=0
local function runHauntAll(v)
	hTok=hTok+1
	if not v then F.hP=nil return end
	local my=hTok
	task.spawn(function()
		while F.hAll and hTok==my do
			local l={} for _,p in ipairs(P:GetPlayers()) do if p~=LP then l[#l+1]=p end end
			if #l==0 then break end
			for _,p in ipairs(l) do
				if not(F.hAll and hTok==my) then break end
				if p.Parent then
					F.hP=p
					local t0=tick()
					while F.hAll and hTok==my and p.Parent and tick()-t0<F.hTime do task.wait(.1) end
				end
			end
			if not F.hLoop then break end
			task.wait()
		end
		if hTok==my and F.hAll then TG.hAll(false,true) end
	end)
end
local function hauntPick(p)
	if F.hP==p then F.hP=nil return end
	if F.hAll then TG.hAll(false,true) end
	if not F.org then local r=root() if r then F.org=r.CFrame end end
	F.hP=p
end

-- ===== character changer =====
local function wear(src,ch)
	local h=ch:FindFirstChildOfClass("Humanoid") if not h then return false end
	local WEAR={Shirt=1,Pants=1,ShirtGraphic=1,BodyColors=1,CharacterMesh=1}
	for _,c in ipairs(ch:GetChildren()) do if WEAR[c.ClassName] or c:IsA("Accoutrement") then c:Destroy() end end
	for _,c in ipairs(src:GetChildren()) do
		if c:IsA("Accoutrement") then pcall(function() h:AddAccessory(c:Clone()) end)
		elseif WEAR[c.ClassName] then c:Clone().Parent=ch end
	end
	local sh,dh=src:FindFirstChild("Head"),ch:FindFirstChild("Head")
	if sh and dh then
		local sm,dm=sh:FindFirstChildOfClass("SpecialMesh"),dh:FindFirstChildOfClass("SpecialMesh")
		if sm and dm then dm:Destroy() sm:Clone().Parent=dh end
	end
	return true
end
local function becomeU(n,me)
	task.spawn(function()
		local good=false
		pcall(function()
			local h=hum() if not h then return end
			local id=me and LP.UserId or tonumber(n) or P:GetUserIdFromNameAsync(n)
			if pcall(function() h:ApplyDescription(P:GetHumanoidDescriptionFromUserId(id)) end) then good=true return end
			local src
			if not me then for _,p in ipairs(P:GetPlayers()) do if p.UserId==id and p.Character then src=p.Character end end end
			if not src then pcall(function() src=P:GetCharacterAppearanceAsync(id) end) end
			if src and LP.Character and wear(src,LP.Character) then good=true end
		end)
		showToast(good and "Done!" or "Failed")
	end)
end

-- ===== save / load =====
local function saveCfg()
	local d={acc={math.floor(S.acc.R*255+.5),math.floor(S.acc.G*255+.5),math.floor(S.acc.B*255+.5)}}
	for k,v in pairs(F) do
		local t=type(v)
		if (t=="boolean" or t=="number" or t=="string") and not NOSAVE[k] then d[k]=v end
	end
	local o=pcall(function() writefile(CFG,HS:JSONEncode(d)) end)
	showToast(o and "Saved!" or "Save failed")
	sfx(1.7)
end
local function loadCfg(show)
	local o,d=pcall(function() if isfile and isfile(CFG) then return HS:JSONDecode(readfile(CFG)) end end)
	if not o or type(d)~="table" then return end
	if type(d.ui)=="string" and SETS.ui then SETS.ui(d.ui,true) end
	if type(d.fn)=="string" and SETS.fn then SETS.fn(d.fn,true) end
	if type(d.lang)=="string" and SETS.lang then SETS.lang(d.lang,true) end
	if type(d.acc)=="table" and #d.acc==3 then applyAcc(rgb(d.acc[1],d.acc[2],d.acc[3])) end
	for k,v in pairs(d) do
		if not NOSAVE[k] then
			if type(v)=="number" and NB[k] then if F[k]~=v then NB[k](v) end
			elseif type(v)=="boolean" and TG[k] then if F[k]~=v then TG[k](v,true) end
			elseif type(v)=="string" and SETS[k] and k~="ui" and k~="fn" and k~="lang" then SETS[k](v,true) end
		end
	end
	if show then showToast("Loaded!") sfx(1.7) end
end

-- ===== toast + dock =====
local toast=N("TextLabel",{Size=UDim2.fromOffset(150,34),Position=UDim2.new(1,-160,1,-50),Text="",TextSize=13,TextTransparency=1,BackgroundTransparency=1,ZIndex=20},gui,"bar") cr(toast,8)
local tSt=Instance.new("UIStroke") tSt.Thickness=1 tSt.Transparency=1 tSt.Parent=toast reg(tSt,"as")
local tk=0
showToast=function(t)
	tk=tk+1 local my=tk
	toast.Text=t toast.BackgroundTransparency=.1 toast.TextTransparency=0 tSt.Transparency=0 toast.Position=UDim2.new(1,-160,1,-30) tw(toast,.35,{Position=UDim2.new(1,-160,1,-50)},BACK)
	task.delay(2.5,function() if my==tk then tw(toast,.6,{BackgroundTransparency=1,TextTransparency=1}) tw(tSt,.6,{Transparency=1}) end end)
end
local dock=N("Frame",{Position=UDim2.new(0,8,.5,-70),Size=UDim2.fromOffset(96,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},gui)
local dkL=Instance.new("UIListLayout") dkL.Padding=UDim.new(0,4) dkL.SortOrder=Enum.SortOrder.LayoutOrder dkL.Parent=dock
local dkH=N("TextButton",{Size=UDim2.new(1,0,0,18),Text="Midnite",TextSize=11,LayoutOrder=0,AutoButtonColor=false},dock,"bar") cr(dkH,6) dkH:SetAttribute("q",true)
reg(dkH,"at") drag(dkH,dock)
local dkHide=N("TextButton",{Size=UDim2.new(1,0,0,22),Text="Hide Buttons",TextSize=11,LayoutOrder=999},dock,"inp") cr(dkHide,6)
local showB=N("TextButton",{Size=UDim2.fromOffset(96,24),Position=UDim2.new(0,8,.5,-70),Text="Show Buttons",TextSize=11,Visible=false},gui,"a") cr(showB,6)
showB.TextColor3=Color3.new(1,1,1)
dkHide.Activated:Connect(function() F.dHide=true dockUpd() end)
showB.Activated:Connect(function() F.dHide=false dockUpd() end)
dockUpd=function()
	local on=F.quick and F.ready
	dock.Visible=on and not F.dHide
	showB.Visible=on and F.dHide
end
local function dockAdd(flag,label)
	local b=N("TextButton",{Size=UDim2.new(1,0,0,24),Text=label,TextSize=11,LayoutOrder=ord()},dock,"row") cr(b,6)
	local bst=Instance.new("UIStroke") bst.Thickness=1 bst.Color=C.line bst.Parent=b
	local function pn()
		local on=F[flag] and true or false
		b.TextColor3=on and S.acc or C.t
		bst.Color=on and S.acc or C.line
	end
	HOOK[#HOOK+1]=pn pn()
	DKT[flag]=pn
	b.Activated:Connect(function() TG[flag](not F[flag]) end)
end

-- ===== pages: Player =====
do
	local pM=page("Player","Main")
	head(pM,"Movement")
	tg(pM,"Flying","Smooth flight. Stick or WASD to move, E / Q up and down.","fly",function(v) if v then startFly() else stopFly() end end)
	X.LK="fly" nb(pM,"Fly Speed",nil,"flySpeed",1) X.LK=nil
	tg(pM,"Walk Speed",nil,"walk",function(v) if not v then local h=hum() if h then h.WalkSpeed=16 end end end)
	X.LK="walk" nb(pM,"Speed",nil,"walkVal",0) nb(pM,"Walk Multi",nil,"walkMulti",0) X.LK=nil
	tg(pM,"Noclip",nil,"noclip")
	tg(pM,"Inf Jump",nil,"inf")
	tg(pM,"Jump Power","Overrides your jump height","jp",function(v) if not v then local h=hum() if h then h.JumpPower=50 end end end)
	X.LK="jp" nb(pM,"Jump Power",nil,"jpVal",1,500) X.LK=nil
	tg(pM,"Death Protection","Whenever under the HP trigger, teleports you up in the sky","dp")
	X.LK="dp" nb(pM,"HP Trigger",nil,"dpHp",1,100) nb(pM,"Back Down at HP",nil,"dpBack",1,100) nb(pM,"Sky Height",nil,"dpH",50,5000) X.LK=nil
	tg(pM,"Spinbot",nil,"spin")
	X.LK="spin" nb(pM,"Spin Speed",nil,"spinSpeed",0) nb(pM,"Spin Multi",nil,"spinMulti",0) X.LK=nil
	head(pM,"Utility")
	tg(pM,"Anti-AFK","Stops the idle kick","afk")
	btnRow(pM,"Respawn","Rejoin",function() local h=hum() if h then h.Health=0 end end,function()
		pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,LP) end)
	end)
	head(pM,"Character")
	local cf=row(pM,36)
	local nm=N("TextBox",{Size=UDim2.new(1,-150,0,22),Position=UDim2.fromOffset(8,7),Text="",PlaceholderText="Username or ID",ClearTextOnFocus=false,TextSize=11},cf,"inp") cr(nm,5)
	local cap=N("TextButton",{Size=UDim2.fromOffset(60,22),Position=UDim2.new(1,-134,0,7),Text="Apply",TextSize=11},cf,"a") cr(cap,5)
	cap.TextColor3=Color3.new(1,1,1)
	local crs=N("TextButton",{Size=UDim2.fromOffset(60,22),Position=UDim2.new(1,-68,0,7),Text="Reset",TextSize=11},cf,"inp") cr(crs,5)
	cap.Activated:Connect(function() if nm.Text~="" then becomeU(nm.Text) end end)
	crs.Activated:Connect(function() becomeU(nil,true) end)
end
do
	local pT=page("Player","Teleport")
	head(pT,"Teleport")
	tg(pT,"Teleport All","Visits each player in order","tpAll",function(v) runTpAll(v) end)
	X.LK="tpAll" nb(pT,"TP Delay","Seconds between players","tpDelay",.03,10) tg(pT,"Loop",nil,"tpLoop") X.LK=nil
	local ptT
	btnRow(pT,"Back to start","Stop view",function()
		local r=root() if r and F.org then r.CFrame=F.org F.org=nil end
		F.tpSel=nil if ptT then ptT() end
	end,function() local h=hum() if h then workspace.CurrentCamera.CameraSubject=h end end)
	head(pT,"Players (tap to teleport)")
	local _
	_,ptT=plist(pT,function() return F.tpSel end,tpTo,true)
end
do
	local pH=page("Player","Haunt")
	head(pH,"Haunt")
	tg(pH,"Haunt All","Follows each player for the set time","hAll",function(v) runHauntAll(v) end)
	X.LK="hAll" nb(pH,"Time per Player",nil,"hTime",.5,120) tg(pH,"Loop",nil,"hLoop") X.LK=nil
	nb(pH,"Distance",nil,"hDist",0,100)
	nb(pH,"Height",nil,"hH",-50,100)
	tg(pH,"Orbit","Circle around the player","hOrbit")
	X.LK="hOrbit" nb(pH,"Orbit Speed",nil,"hSpeed",.1,50) X.LK=nil
	local ptH
	btnRow(pH,"Stop haunting","Back to start",function()
		if F.hAll then TG.hAll(false,true) end
		F.hP=nil if ptH then ptH() end
	end,function()
		local r=root() if r and F.org then r.CFrame=F.org F.org=nil end
		F.hP=nil if ptH then ptH() end
	end)
	head(pH,"Players (tap to haunt)")
	local _
	_,ptH=plist(pH,function() return F.hP end,hauntPick,false)
end

-- ===== pages: Aim, Visuals, Game =====
local function part2()
local G0=workspace.Gravity
local DEF={aim=false,aimFov=150,aimDist=500,aimAlive=true,aimWall=false,aimPred=0,tc=true,smooth=0,ap="Head",pr="Crosshair",sticky=false,skipFF=false,noFr=false,hold=false,
	showFov=true,fovFill=false,snap=false,thud=false,trig=false,trigD=.12,holding=false,
	esp=false,trace=false,espN=true,espD=true,xh=false,xht="+",xhS=1,fb=false,tod=false,todVal=14,nofog=false,
	gf="Default",grav=G0,hideUI=false,noTags=false,mute=false,pot=false,fps=false,ping=false,fpsCap=60,fovOn=false,fovVal=70,zoom=false,lockP=nil}
for k,v in pairs(DEF) do if F[k]==nil then F[k]=v end end
local fv0,fbBk,todBk,fogBk,zBk,guiBk=nil,nil,nil,nil,nil,{}
local pinLbl

local fov=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(300,300),BackgroundTransparency=1,Visible=false},gui,"a") cr(fov,200)
local fovS=Instance.new("UIStroke") fovS.Thickness=1.5 fovS.Parent=fov reg(fovS,"as")
local function fovSize() tw(fov,.2,{Size=UDim2.fromOffset(F.aimFov*2,F.aimFov*2)}) end
local snl=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Visible=false},EL,"a")
local thl=N("TextLabel",{Size=UDim2.fromOffset(240,20),Position=UDim2.new(.5,-120,0,40),TextSize=12,Visible=false},gui,"bar") cr(thl,6)
local holdB=N("TextButton",{Size=UDim2.fromOffset(60,60),Position=UDim2.new(1,-80,.6,0),Text="AIM",TextSize=14,Visible=false,AutoButtonColor=false},gui,"a") cr(holdB,30)
holdB.TextColor3=Color3.new(1,1,1)
holdB.InputBegan:Connect(function(i) if isP(i) then F.holding=true end end)
holdB.InputEnded:Connect(function(i) if isP(i) then F.holding=false end end)
cn(UIS.InputBegan:Connect(function(i,g) if not g and i.UserInputType==Enum.UserInputType.MouseButton2 then F.holding=true end end))
cn(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton2 then F.holding=false end end))

local friend,cT,lastTr={},nil,0
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Exclude
local PARTS={Head={"Head"},Torso={"UpperTorso","Torso"},Root={"HumanoidRootPart"},Closest={"Head","UpperTorso","Torso","HumanoidRootPart"}}
local function ldf(p) task.spawn(function() local o,r=pcall(function() return LP:IsFriendsWith(p.UserId) end) friend[p]=(o and r) and true or false end) end
for _,p in ipairs(P:GetPlayers()) do if p~=LP then ldf(p) end end
cn(P.PlayerAdded:Connect(ldf))
cn(P.PlayerRemoving:Connect(function(p) if F.lockP==p then F.lockP=nil end end))
local function mate(p)
	if F.wl and F.wl[p.UserId] then return true end
	if not F.tc then return false end
	return p.Team~=nil and LP.Team~=nil and p.Team==LP.Team
end
local function evalP(p,cam,ctr,me,forced)
	local pc=p.Character local hm=pc and pc:FindFirstChildOfClass("Humanoid") if not hm then return end
	if F.aimAlive and hm.Health<=0 then return end
	local hr=pc:FindFirstChild("HumanoidRootPart")
	if not forced then
		if mate(p) or (F.noFr and friend[p]) or (F.skipFF and pc:FindFirstChildOfClass("ForceField")) then return end
		if me and hr and (hr.Position-me.Position).Magnitude>F.aimDist then return end
		if me and hr and (hr.Position-me.Position).Magnitude<F.aimMin then return end
	end
	local best,bs
	for _,nm in ipairs(PARTS[F.ap] or PARTS.Head) do
		local pr=pc:FindFirstChild(nm)
		if pr then
			local pos=pr.Position
			if F.aimPred>0 and hr then pos=pos+hr.AssemblyLinearVelocity*F.aimPred end
			local sp,on=cam:WorldToViewportPoint(pos)
			local d=(Vector2.new(sp.X,sp.Y)-ctr).Magnitude
			if forced or (on and d<=F.aimFov) then
				local vis=true
				if not forced and not F.aimWall then
					rp.FilterDescendantsInstances={pc,LP.Character}
					vis=workspace:Raycast(cam.CFrame.Position,pos-cam.CFrame.Position,rp)==nil
				end
				if vis and (not bs or d<bs) then best,bs=pos,d end
			end
		end
	end
	return best,bs
end
local function pick()
	local cam=workspace.CurrentCamera local ctr=cam.ViewportSize/2 local me=root()
	if F.lockP and F.lockP.Parent then
		local pos=evalP(F.lockP,cam,ctr,me,true)
		return pos,(pos and F.lockP) or nil
	end
	if F.sticky and cT and cT.Parent then
		local pos=evalP(cT,cam,ctr,me)
		if pos then return pos,cT end
	end
	local bp,bpl,bsc
	for _,p in ipairs((G.midniteTargets and G.midniteTargets() or P:GetPlayers())) do
		if p~=LP then
			local pos,d=evalP(p,cam,ctr,me)
			if pos then
				local sc=d or 0
				if F.pr=="Distance" and me then sc=(pos-me.Position).Magnitude
				elseif F.pr=="Health" then local hm=p.Character and p.Character:FindFirstChildOfClass("Humanoid") sc=hm and hm.Health or 999 end
				if not bsc or sc<bsc then bp,bpl,bsc=pos,p,sc end
			end
		end
	end
	cT=bpl
	return bp,bpl
end
pcall(function() RS:UnbindFromRenderStep("MidniteAim") end)
local aimSince,lastPl=0,nil
local function aimReady(pl,pos)
	if pl~=lastPl then lastPl=pl aimSince=tick() end
	if tick()-aimSince<F.aimDelay then return false end
	local cam=workspace.CurrentCamera
	local sp=cam:WorldToViewportPoint(pos)
	return (Vector2.new(sp.X,sp.Y)-cam.ViewportSize/2).Magnitude>F.aimDz
end
RS:BindToRenderStep("MidniteAim",Enum.RenderPriority.Camera.Value+1,function()
	local cam=workspace.CurrentCamera
	local on=F.aim or F.trig
	fov.Visible=F.aim and F.showFov
	snl.Visible=false thl.Visible=false
	if not on then return end
	local wantAim=F.aim and (not F.hold or F.holding)
	local pos,pl
	if wantAim or F.trig then pos,pl=pick() end
	if wantAim and pos and aimReady(pl,pos) then
		if F.aimHoriz then pos=Vector3.new(pos.X,cam.CFrame.Position.Y,pos.Z) end
		if F.aimJit>0 then local j=F.aimJit*.1 pos=pos+Vector3.new((math.random()-.5)*j,(math.random()-.5)*j,(math.random()-.5)*j) end
		local cf=cam.CFrame local goal=CFrame.lookAt(cf.Position,pos)
		local a=1-math.clamp(F.smooth,0,.95)
		cam.CFrame=(a>=1) and goal or cf:Lerp(goal,a)
	end
	local ctr=cam.ViewportSize/2
	local sp if pos then sp=cam:WorldToViewportPoint(pos) end
	if F.lockP and sp and sp.Z>0 then fov.Position=UDim2.fromOffset(sp.X,sp.Y) else fov.Position=UDim2.new(.5,0,.5,0) end
	if F.snap and sp and sp.Z>0 then
		local b=Vector2.new(sp.X,sp.Y) local d=b-ctr
		snl.Size=UDim2.fromOffset(d.Magnitude,1.5) snl.Position=UDim2.fromOffset((ctr.X+b.X)/2,(ctr.Y+b.Y)/2) snl.Rotation=math.deg(math.atan2(d.Y,d.X)) snl.Visible=true
	end
	if F.thud and pl then
		local pc=pl.Character local hm=pc and pc:FindFirstChildOfClass("Humanoid") local r=pc and pc:FindFirstChild("HumanoidRootPart") local me=root()
		thl.Text=pl.Name.." | "..(hm and math.floor(hm.Health) or 0).." HP | "..((me and r) and math.floor((r.Position-me.Position).Magnitude) or 0).."m"
		thl.Visible=true
	end
	if F.trig and pos and sp and sp.Z>0 and mouse1click and tick()-lastTr>F.trigD and (Vector2.new(sp.X,sp.Y)-ctr).Magnitude<25 then
		lastTr=tick() pcall(mouse1click)
	end
end)

do
	local pA=page("Aim","Aimbot")
	head(pA,"Aimbot")
	tg(pA,"Aimbot","Locks the camera onto targets in your FOV","aim",function() fovSize() holdB.Visible=F.hold and F.aim end)
	X.LK="aim" nb(pA,"FOV Size",nil,"aimFov",10,nil,function() fovSize() end) nb(pA,"Max Distance",nil,"aimDist",1) nb(pA,"Deadzone","Center pixels it won't bother aiming at","aimDz",0,300) nb(pA,"Engage Delay","Seconds before it locks onto a new target","aimDelay",0,3) X.LK=nil
	tg(pA,"Team Check","Skips your teammates","tc")
	tg(pA,"Alive Check","Ignores dead players","aimAlive")
	tg(pA,"Wallbang","Aims through walls","aimWall")
	tg(pA,"Sticky Aim","Keeps the same target","sticky")
	tg(pA,"Skip Forcefield","Ignores players with forcefields","skipFF")
	tg(pA,"Ignore Friends","Never aims at your friends","noFr")
	tg(pA,"Hold to Aim","Aim only while holding AIM or right mouse","hold",function(v) holdB.Visible=v and F.aim end)
	ch(pA,"Aim Part",nil,{"Head","Torso","Root","Closest"},"ap")
	ch(pA,"Priority","Who gets picked first",{"Crosshair","Distance","Health"},"pr")
	sl(pA,"Smoothness","smooth",0,.95)
	sl(pA,"Prediction","aimPred",0,1)
	head(pA,"Visuals")
	tg(pA,"Show FOV Circle",nil,"showFov")
	tg(pA,"FOV Fill",nil,"fovFill",function(v) fov.BackgroundTransparency=v and .85 or 1 end)
	tg(pA,"Target Line",nil,"snap")
	tg(pA,"Target HUD","Name, health and distance","thud")

	local pTg=page("Aim","Target")
	head(pTg,"Lock on a player")
	N("TextLabel",{Size=UDim2.new(1,-8,0,18),Text="Tap a name to lock on. Tap again to unlock.",TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},pTg,"dm")
	local clr=row(pTg,34)
	local cb2=N("TextButton",{Size=UDim2.new(1,-16,0,24),Position=UDim2.fromOffset(8,5),Text="Clear lock",TextSize=12},clr,"inp") cr(cb2,6)
	local _,pT2=plist(pTg,function() return F.lockP end,function(p)
		if F.lockP==p then F.lockP=nil
		else F.lockP=p if not F.aim then TG.aim(true) end end
	end,false)
	cb2.Activated:Connect(function() F.lockP=nil pT2() end)

	do
		local pW=page("Aim","Whitelist")
		head(pW,"Whitelisted players")
		N("TextLabel",{Size=UDim2.new(1,-8,0,30),TextWrapped=true,Text="Tap a player to whitelist them. Whitelisted players are ignored by the aimbot.",TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=ord()},pW,"dm")
		F.wl=F.wl or {}
		local btns,wlRows={},{}
		local function paint() for uid,b in pairs(btns) do b.TextColor3=F.wl[uid] and GREEN or C.t end end
		local function refresh()
			for _,r in ipairs(wlRows) do r:Destroy() end
			wlRows,btns={},{}
			for _,pl in ipairs(P:GetPlayers()) do if pl~=LP then
				local f=N("Frame",{Size=UDim2.new(1,-8,0,30),BackgroundTransparency=1,LayoutOrder=ord()},pW)
				wlRows[#wlRows+1]=f
				local av=N("ImageLabel",{Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(4,3),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..pl.UserId.."&w=150&h=150"},f) cr(av,12)
				local b=N("TextButton",{Size=UDim2.new(1,-34,1,0),Position=UDim2.fromOffset(34,0),Text=pl.Name,TextSize=12},f,"row") cr(b,6)
				b.Activated:Connect(function() F.wl[pl.UserId]=(not F.wl[pl.UserId]) or nil paint() end)
				btns[pl.UserId]=b
			end end
			paint()
		end
		refresh()
		cn(P.PlayerAdded:Connect(function() task.wait(.3) refresh() end))
		cn(P.PlayerRemoving:Connect(function() task.wait(.3) refresh() end))
		HOOK[#HOOK+1]=paint
	end

	local pTr=page("Aim","Trigger")
	head(pTr,"Triggerbot")
	tg(pTr,"Triggerbot","Clicks when a target is under your crosshair","trig")
	X.LK="trig" nb(pTr,"Click Delay","Seconds between clicks","trigD",.02,2) X.LK=nil
end

local ESP={}
local function mkE(p)
	local b=N("Frame",{BackgroundTransparency=1,Visible=false},EL)
	local st=Instance.new("UIStroke") st.Thickness=1.5 st.Parent=b reg(st,"as")
	local function t(y,ay) return N("TextLabel",{Size=UDim2.fromOffset(240,14),AnchorPoint=Vector2.new(.5,ay),Position=UDim2.new(.5,0,y,(y==0) and -1 or 1),TextSize=11,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=0},b) end
	local hp=N("Frame",{Size=UDim2.fromOffset(3,10),Position=UDim2.fromOffset(-6,0),BackgroundColor3=GREEN,ZIndex=2},b)
	return {b=b,st=st,hp=hp,n=t(0,1),d=t(1,0),t=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Visible=false},EL,"a")}
end
local function clrE()
	for _,e in pairs(ESP) do pcall(function() e.b:Destroy() e.t:Destroy() end) end
	ESP={}
end
cn(RS.RenderStepped:Connect(function()
	if not F.esp then return end
	local cam=workspace.CurrentCamera local vs=cam.ViewportSize local me=root()
	for _,p in ipairs(P:GetPlayers()) do if p~=LP then
		local pc=p.Character local r=pc and pc:FindFirstChild("HumanoidRootPart") local hm=pc and pc:FindFirstChildOfClass("Humanoid")
		local e,sh=ESP[p],false
		if r and hm and hm.Health>0 then
			local t1=cam:WorldToViewportPoint(r.Position+Vector3.new(0,3,0))
			local b1=cam:WorldToViewportPoint(r.Position-Vector3.new(0,3.2,0))
			if t1.Z>0 and b1.Z>0 then
				sh=true
				if not e then e=mkE(p) ESP[p]=e end
				local hh=math.abs(b1.Y-t1.Y) local ww=hh*.55
				e.b.Position=UDim2.fromOffset(t1.X-ww/2,t1.Y) e.b.Size=UDim2.fromOffset(ww,hh)
				e.n.Visible=F.espN e.d.Visible=F.espD
				if e.hp then e.hp.Visible=F.espHp e.hp.Size=UDim2.fromOffset(3,math.max(1,e.b.Size.Y.Offset*math.clamp(hm.Health/math.max(hm.MaxHealth,1),0,1))) end
				e.n.Text=(p.DisplayName~=p.Name) and (p.DisplayName.." (@"..p.Name..")") or p.Name
				if me then e.d.Text=math.floor((r.Position-me.Position).Magnitude).."m" end
				if F.trace then
					local a,c=Vector2.new(vs.X/2,vs.Y),Vector2.new(b1.X,b1.Y) local d=c-a
					e.t.Size=UDim2.fromOffset(d.Magnitude,1.5) e.t.Position=UDim2.fromOffset((a.X+c.X)/2,(a.Y+c.Y)/2)
					e.t.Rotation=math.deg(math.atan2(d.Y,d.X)) e.t.Visible=true
				else e.t.Visible=false end
			end
		end
		if e then e.b.Visible=sh if not sh then e.t.Visible=false end end
	end end
end))
cn(P.PlayerRemoving:Connect(function(p) local e=ESP[p] if e then pcall(function() e.b:Destroy() e.t:Destroy() end) ESP[p]=nil end end))

local xh=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(40,40),BackgroundTransparency=1,Visible=false},gui)
local xhS=Instance.new("UIScale") xhS.Scale=F.xhS xhS.Parent=xh
local function xbar(w,h,x,y,r)
	local f=Instance.new("Frame") f.AnchorPoint=Vector2.new(.5,.5) f.Position=UDim2.new(.5,x,.5,y) f.Size=UDim2.fromOffset(w,h)
	f.Rotation=r or 0 f.BorderSizePixel=0 f.BackgroundColor3=S.acc f.Parent=xh
	return f
end
local function bx()
	for _,c in ipairs(xh:GetChildren()) do if not c:IsA("UIScale") then c:Destroy() end end
	local t=F.xht
	if t=="+" then xbar(24,2,0,0) xbar(2,24,0,0)
	elseif t=="•" then local d=xbar(6,6,0,0) local u=Instance.new("UICorner") u.CornerRadius=UDim.new(1,0) u.Parent=d
	elseif t=="O" then
		local c=Instance.new("Frame") c.AnchorPoint=Vector2.new(.5,.5) c.Position=UDim2.new(.5,0,.5,0) c.Size=UDim2.fromOffset(24,24) c.BackgroundTransparency=1 c.BorderSizePixel=0 c.Parent=xh
		local u=Instance.new("UICorner") u.CornerRadius=UDim.new(1,0) u.Parent=c
		local s=Instance.new("UIStroke") s.Thickness=2 s.Color=S.acc s.Parent=c
	elseif t=="X" then xbar(28,2,0,0,45) xbar(28,2,0,0,-45)
	else xbar(14,2,-5,-4,40) xbar(14,2,-5,4,-40) end
end
HOOK[#HOOK+1]=function()
	for _,c in ipairs(xh:GetChildren()) do
		if c:IsA("Frame") then
			c.BackgroundColor3=S.acc
			for _,s in ipairs(c:GetChildren()) do if s:IsA("UIStroke") then s.Color=S.acc end end
		end
	end
end

do
	local pE=page("Visuals","ESP")
	head(pE,"Players")
	tg(pE,"ESP","Boxes around players","esp",function(v) if not v then clrE() end end)
	X.LK="esp" tg(pE,"Tracers","Lines from the bottom of the screen","trace") tg(pE,"Show Names","Names above boxes","espN") tg(pE,"Show Distance","Distance below boxes","espD") tg(pE,"Health Bar","Green bar showing health","espHp") tg(pE,"Chams","Colored glow on players through walls","cham") X.LK=nil

	local pX=page("Visuals","Crosshair")
	head(pX,"Crosshair")
	tg(pX,"Crosshair","Draws a crosshair in the center","xh",function(v) xh.Visible=v end)
	X.LK="xh" ch(pX,"Style",nil,{"+","•","O","X",">"},"xht",function() bx() end)
	nb(pX,"Size",nil,"xhS",.3,4,function(n) xhS.Scale=n end) X.LK=nil
	bx()

	local pW=page("Visuals","World")
	head(pW,"Lighting")
	tg(pW,"Night Vision","Green tint with brighter shadows","nv",function(v)
		local cc=Lt:FindFirstChild("MidniteNV")
		if v then
			if not cc then cc=Instance.new("ColorCorrectionEffect") cc.Name="MidniteNV" cc.Parent=Lt end
			cc.TintColor=Color3.fromRGB(190,255,190) cc.Brightness=.15 cc.Contrast=.2 cc.Enabled=true
		elseif cc then cc:Destroy() end
	end)
	tg(pW,"Fullbright",nil,"fb",function(v)
		if v then fbBk=fbBk or {Brightness=Lt.Brightness,GlobalShadows=Lt.GlobalShadows,Ambient=Lt.Ambient,OutdoorAmbient=Lt.OutdoorAmbient}
		elseif fbBk then for k,x in pairs(fbBk) do pcall(function() Lt[k]=x end) end fbBk=nil end
	end)
	tg(pW,"Custom Time","Sets the time of day","tod",function(v)
		if v then todBk=todBk or Lt.ClockTime
		elseif todBk then Lt.ClockTime=todBk todBk=nil end
	end)
	X.LK="tod" nb(pW,"Hour (0-24)",nil,"todVal",0,24) X.LK=nil
	tg(pW,"Remove Fog","Clears distance fog","nofog",function(v)
		if v then fogBk=fogBk or Lt.FogEnd
		elseif fogBk then Lt.FogEnd=fogBk fogBk=nil end
	end)
end

local GFs,GFc,gfo={}, {}, nil
local function gfa(o)
	if gfo and (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) and not o:IsDescendantOf(gui) then
		if GFs[o]==nil then GFs[o]=o.Font end
		o.Font=gfo
	end
end
local function GFN(n)
	for _,c in ipairs(GFc) do c:Disconnect() end GFc={}
	if n=="Default" or not Enum.Font[n] then
		gfo=nil
		for o,f in pairs(GFs) do pcall(function() o.Font=f end) end
		GFs={} return
	end
	gfo=Enum.Font[n]
	local pg2=LP:FindFirstChild("PlayerGui")
	GFc[#GFc+1]=workspace.DescendantAdded:Connect(function(o) pcall(gfa,o) end)
	if pg2 then GFc[#GFc+1]=pg2.DescendantAdded:Connect(function(o) pcall(gfa,o) end) end
	task.spawn(function()
		for _,r0 in ipairs({workspace,pg2 or workspace}) do
			local d=r0:GetDescendants()
			for i=1,#d do
				if F.gf~=n then return end
				pcall(gfa,d[i])
				if i%300==0 then RS.Heartbeat:Wait() end
			end
		end
	end)
end

local muC,mu={}, {}
local function mA(o) if o:IsA("Sound") and not o:IsDescendantOf(gui) then if mu[o]==nil then mu[o]=o.Volume end o.Volume=0 end end
local function setMute(v)
	for _,c in ipairs(muC) do c:Disconnect() end muC={}
	if v then
		local SS=game:GetService("SoundService")
		muC[1]=workspace.DescendantAdded:Connect(function(o) pcall(mA,o) end)
		muC[2]=SS.DescendantAdded:Connect(function(o) pcall(mA,o) end)
		task.spawn(function()
			for _,r0 in ipairs({workspace,SS}) do
				local d=r0:GetDescendants()
				for i=1,#d do if not F.mute then return end pcall(mA,d[i]) if i%300==0 then RS.Heartbeat:Wait() end end
			end
		end)
	else
		local s=mu mu={}
		for o,vv in pairs(s) do pcall(function() o.Volume=vv end) end
	end
end
local function setHide(v)
	local pg2=LP:FindFirstChild("PlayerGui")
	if v then
		guiBk={}
		if pg2 then for _,g in ipairs(pg2:GetChildren()) do if g:IsA("ScreenGui") and g~=gui and g.Enabled then guiBk[#guiBk+1]=g g.Enabled=false end end end
		pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,false) end)
	else
		for _,g in ipairs(guiBk) do pcall(function() g.Enabled=true end) end guiBk={}
		pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,true) end)
	end
end
local function setTags(v)
	for _,q in ipairs(P:GetPlayers()) do
		local hm=q.Character and q.Character:FindFirstChildOfClass("Humanoid")
		if hm then hm.DisplayDistanceType=v and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer end
	end
end

do
	local pG=page("Game","Main")
	head(pG,"Game font")
	local gl={"Default"} for _,n in ipairs(FL) do gl[#gl+1]=n end
	ch(pG,"Game Font","Changes the game's text font",gl,"gf",function(n) GFN(n) end,function(b,n)
		if n~="Default" then pcall(function() b.Font=Enum.Font[n] end) b:SetAttribute("kf",true) end
	end)
	head(pG,"Camera")
	tg(pG,"Custom FOV","Overrides your field of view","fovOn",function(v)
		local c=workspace.CurrentCamera
		if v then fv0=fv0 or c.FieldOfView elseif fv0 then c.FieldOfView=fv0 fv0=nil end
	end)
	X.LK="fovOn" nb(pG,"FOV",nil,"fovVal",1,120) X.LK=nil
	tg(pG,"Infinite Zoom","Lets you zoom out forever","zoom",function(v)
		if v then zBk=zBk or LP.CameraMaxZoomDistance LP.CameraMaxZoomDistance=1e5
		elseif zBk then LP.CameraMaxZoomDistance=zBk zBk=nil end
	end)
	nb(pG,"Gravity",nil,"grav",0,nil,function(n) workspace.Gravity=n end)
	btnRow(pG,"Reset Gravity","Copy Place ID",function() NB.grav(G0) end,function()
		if setclipboard then pcall(setclipboard,tostring(game.PlaceId)) showToast("Copied!") end
	end)
	btnRow(pG,"Copy Job ID","Copy Game Name",function()
		if setclipboard then pcall(setclipboard,game.JobId) showToast("Copied!") end
	end,function()
		if setclipboard then pcall(setclipboard,game.Name) showToast("Copied!") end
	end)
	head(pG,"Interface")
	tg(pG,"Hide Game UI","Hides the game's own menus","hideUI",setHide)
	tg(pG,"Hide Name Tags","Hides player name tags","noTags",setTags)
	tg(pG,"Mute Game","Silences the game's sounds","mute",setMute)
	head(pG,"Info")
	local pinRow=row(pG,30)
	pinLbl=N("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.fromOffset(10,0),TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,TextTruncate=Enum.TextTruncate.AtEnd},pinRow,"t")
	pinLbl.Text="Players: "..#P:GetPlayers().."/"..P.MaxPlayers.."  |  ID "..game.PlaceId
end

local PT={}
do
	local bk,lt={}, nil
	local function ap(o)
		if o:IsA("Terrain") then return end
		if o:IsA("BasePart") then
			if bk[o]==nil then bk[o]={"p",o.Material,o.Reflectance,o.CastShadow} end
			o.Material=Enum.Material.SmoothPlastic o.Reflectance=0 o.CastShadow=false
		elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") or o:IsA("Beam") then
			if bk[o]==nil then bk[o]={"e",o.Enabled} end o.Enabled=false
		elseif o:IsA("Decal") or o:IsA("Texture") then
			if bk[o]==nil then bk[o]={"d",o.Transparency} end o.Transparency=1
		end
	end
	local function rs(o,v)
		if v[1]=="p" then o.Material=v[2] o.Reflectance=v[3] o.CastShadow=v[4]
		elseif v[1]=="d" then o.Transparency=v[2]
		else o.Enabled=v[2] end
	end
	local potConn
	PT.on=function()
		local tr2=workspace.Terrain
		lt={gs=Lt.GlobalShadows,w={tr2.WaterWaveSize,tr2.WaterWaveSpeed,tr2.WaterReflectance},fx={}}
		pcall(function() lt.q=settings().Rendering.QualityLevel settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
		pcall(function() Lt.GlobalShadows=false tr2.WaterWaveSize=0 tr2.WaterWaveSpeed=0 tr2.WaterReflectance=0 end)
		for _,e in ipairs(Lt:GetChildren()) do if e:IsA("PostEffect") then lt.fx[e]=e.Enabled e.Enabled=false end end
		task.spawn(function()
			local d=workspace:GetDescendants()
			for i=1,#d do if not F.pot then return end pcall(ap,d[i]) if i%300==0 then RS.Heartbeat:Wait() end end
		end)
		potConn=workspace.DescendantAdded:Connect(function(o) pcall(ap,o) end)
		cn(potConn)
	end
	PT.off=function()
		if potConn then potConn:Disconnect() potConn=nil end
		local snap=bk bk={}
		task.spawn(function()
			local i=0
			for o,v in pairs(snap) do pcall(rs,o,v) i=i+1 if i%300==0 then RS.Heartbeat:Wait() end end
		end)
		if lt then
			pcall(function() Lt.GlobalShadows=lt.gs end)
			pcall(function() if lt.q then settings().Rendering.QualityLevel=lt.q end end)
			pcall(function() local t=workspace.Terrain t.WaterWaveSize,t.WaterWaveSpeed,t.WaterReflectance=lt.w[1],lt.w[2],lt.w[3] end)
			for e,v in pairs(lt.fx) do pcall(function() e.Enabled=v end) end
			lt=nil
		end
	end
end

local wmL=N("TextLabel",{Size=UDim2.fromOffset(360,18),Position=UDim2.fromOffset(8,6),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Visible=false,ZIndex=30,Text=""},gui,"at")
local fpl=N("TextLabel",{Size=UDim2.fromOffset(150,22),Position=UDim2.new(1,-160,0,8),TextSize=13,Visible=false,Active=true},gui,"bar") cr(fpl,6)
drag(fpl,fpl)
do
	local pP=page("Game","Performance")
	head(pP,"Performance")
	tg(pP,"Potato Mode","Strips textures, shadows and effects (undone when off)","pot",function(v) if v then PT.on() else PT.off() end end)
	tg(pP,"Show FPS","Live FPS counter","fps",function(v) fpl.Visible=v end)
	X.LK="fps" tg(pP,"Show Ping","Adds ping to the counter","ping") X.LK=nil
	nb(pP,"FPS Cap",nil,"fpsCap",10,1000,function(n) if setfpscap then pcall(setfpscap,n) end end)
end

local fpT,fpN=0,0
HB[#HB+1]=function(dt)
	if F.fb then pcall(function() Lt.Brightness=2 Lt.ClockTime=14 Lt.GlobalShadows=false Lt.Ambient=rgb(178,178,178) Lt.OutdoorAmbient=rgb(178,178,178) end) end
	if F.tod and not F.fb then Lt.ClockTime=F.todVal end
	if F.nofog then Lt.FogEnd=1e6 end
	if F.fovOn then workspace.CurrentCamera.FieldOfView=F.fovVal end
	fpT=fpT+dt fpN=fpN+1
	if fpT>=.5 then
		if F.fps then
			local f=math.floor(fpN/fpT+.5)
			local pg=""
			if F.ping then
				local o,v=pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
				if o then pg=" | "..math.floor(v).." ms" end
			end
			fpl.Text=f.." FPS"..pg
			fpl.TextColor3=(f>=50) and GREEN or ((f>=30) and rgb(255,200,60) or RED)
		end
		pinLbl.Text="Players: "..#P:GetPlayers().."/"..P.MaxPlayers.."  |  ID "..game.PlaceId
		fpT,fpN=0,0
	end
end

EXIT[#EXIT+1]=function()
	F.aim=false F.trig=false F.esp=false F.fps=false
	pcall(function() RS:UnbindFromRenderStep("MidniteAim") end)
	clrE()
	if F.pot then pcall(PT.off) F.pot=false end
	pcall(GFN,"Default")
	pcall(setMute,false)
	pcall(setHide,false)
	pcall(setTags,false)
	pcall(function() workspace.Gravity=G0 end)
	pcall(function() if fv0 then workspace.CurrentCamera.FieldOfView=fv0 end end)
	pcall(function() if zBk then LP.CameraMaxZoomDistance=zBk end end)
	pcall(function() if fbBk then for k,x in pairs(fbBk) do Lt[k]=x end end end)
	pcall(function() if fogBk then Lt.FogEnd=fogBk end end)
	pcall(function() if todBk then Lt.ClockTime=todBk end end)
	fpl.Visible=false
end

dockAdd("aim","Aimbot") dockAdd("esp","ESP") dockAdd("pot","Potato") dockAdd("fps","FPS")
end
local part2ok,part2err=pcall(part2)
if not part2ok then warn("[Midnite] Aim/Visuals/Game tabs failed: "..tostring(part2err)) end

-- ===== Settings pages =====
do
	local sUI=page("Looks","UI")
	head(sUI,"Look")
	ch(sUI,"UI Style","Color theme (17 styles)",UIN,"ui",function(n) applyTheme(n) end)
	ch(sUI,"Font","Menu font (auto-picked: Jura)",FL,"fn",function(n) applyFont(n) end,function(b,n) pcall(function() b.Font=Enum.Font[n] end) b:SetAttribute("kf",true) end)
	swatches(sUI)
	tg(sUI,"Rainbow Accent","Cycles your accent color","rainbow",function(v) if not v then applyAcc(S.acc) end end)
	local hf=row(sUI,40) lbl(hf,"Custom Color","R,G,B or #HEX",.38)
	local hbx=N("TextBox",{Size=UDim2.new(.36,0,0,22),Position=UDim2.new(.4,0,.5,-11),Text="",PlaceholderText="#FF00AA",ClearTextOnFocus=false,TextSize=11},hf,"inp") cr(hbx,5)
	local hap=N("TextButton",{Size=UDim2.fromOffset(40,22),Position=UDim2.new(1,-46,.5,-11),Text="Set",TextSize=11},hf,"a") cr(hap,5)
	hap.TextColor3=Color3.new(1,1,1)
	hap.Activated:Connect(function()
		local s=hbx.Text:gsub("%s","")
		local hx=s:match("^#?(%x%x%x%x%x%x)$")
		local c
		if hx then c=rgb(tonumber(hx:sub(1,2),16),tonumber(hx:sub(3,4),16),tonumber(hx:sub(5,6),16))
		else local r,g,b=s:match("^(%d+)[,;](%d+)[,;](%d+)$") if r then c=rgb(math.min(255,tonumber(r)),math.min(255,tonumber(g)),math.min(255,tonumber(b))) end end
		if c then if F.rainbow then TG.rainbow(false,true) end applyAcc(c) end
	end)
	ch(sUI,"Language","Translates tab names",LANGS,"lang",function() rebuildSubs() end)
	head(sUI,"Menu")
	tg(sUI,"Sounds","Click sounds","snd")
	tg(sUI,"Quick Buttons","Floating button dock","quick",function() dockUpd() end)
	tg(sUI,"Watermark","FPS, ping, time and player count at the top","wm")
	tg(sUI,"Welcome Screen","Greets you with your profile when the menu opens","welcome")
	btnRow(sUI,"Reset to Midnite","Random Accent",function()
		SETS.ui("Midnite",true)
		applyAcc(ACCS[1])
		SETS.bgStyle("Midnite Wave",true)
	end,function()
		applyAcc(ACCS[math.random(#ACCS)])
	end)

	local sLk=page("Looks","Look")
	head(sLk,"Background")
	bgTiles(sLk)
	local pr=row(sLk,40) lbl(pr,"Photo ID","Paste an image asset ID for the Photo style",.4)
	local pbx=N("TextBox",{Size=UDim2.new(.55,-8,0,22),Position=UDim2.new(.45,0,.5,-11),Text=F.bgImg or "",PlaceholderText="rbxassetid://...",ClearTextOnFocus=false,TextSize=11,TextTruncate=Enum.TextTruncate.AtEnd},pr,"inp") cr(pbx,5)
	pbx.FocusLost:Connect(function() F.bgImg=pbx.Text updBg() end)
	nb(sLk,"Background Speed","Speed of the animated background",
		"bgSpeed",0,10)
	head(sLk,"Effects")
	ch(sLk,"Menu Effects","Particles drawn over the menu",FXS,"fx",function(n) setFx(n) end)
	nb(sLk,"Effect Amount","How many particles (1-60)","fxN",1,60,function() setFx(F.fx) end)
	nb(sLk,"Effect Speed","Particle speed multiplier","fxSpeed",0,10)
	head(sLk,"Shape & Opacity")
	sl(sLk,"Menu Opacity","trans",0,.85,function() updBg() end)
	sl(sLk,"Corner Scale","radMul",0,2,function() applyTheme(F.ui) end)

	local sSv=page("Looks","Save")
	head(sSv,"Config file")
	btnRow(sSv,"Load Config","Save Config",function() loadCfg(true) end,function() saveCfg() end)

	local sPr=page("Looks","Profile")
	head(sPr,"Your profile")
	local card=row(sPr,74)
	local av=N("ImageLabel",{Size=UDim2.fromOffset(52,52),Position=UDim2.fromOffset(8,11),Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"},card,"inp") cr(av,26)
	N("TextLabel",{Size=UDim2.new(1,-72,0,18),Position=UDim2.fromOffset(68,10),Text=LP.DisplayName,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},card,"t")
	N("TextLabel",{Size=UDim2.new(1,-72,0,16),Position=UDim2.fromOffset(68,30),Text="@"..LP.Name,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},card,"dm")
	local gName=N("TextLabel",{Size=UDim2.new(1,-72,0,16),Position=UDim2.fromOffset(68,50),Text="Playing: "..game.Name,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},card,"dm")
	task.spawn(function()
		local o,i=pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
		if o and i and i.Name then gName.Text="Playing: "..i.Name end
	end)
end

do
	do
	local TP_WP={}
	local pW2=page("Tools","Waypoints")
	head(pW2,"Waypoints")
	local wl=N("TextLabel",{Size=UDim2.new(1,-8,0,20),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Text="Saved: 0",LayoutOrder=ord()},pW2,"dm")
	btnRow(pW2,"Set Waypoint","Go To Last",function()
		local r=root() if r then TP_WP[#TP_WP+1]=r.CFrame wl.Text="Saved: "..#TP_WP end
	end,function()
		local r=root() if r and #TP_WP>0 then r.CFrame=TP_WP[#TP_WP] end
	end)
	btnRow(pW2,"Clear Waypoints","Copy Position",function() TP_WP={} wl.Text="Saved: 0" end,function()
		local r=root() if r and setclipboard then setclipboard(tostring(r.Position)) showToast("Copied!") end
	end)

	local pCT=page("Tools","Click TP")
	head(pCT,"Click Teleport")
	tg(pCT,"Click Teleport","Tap or click the world to teleport there","ctp")
	N("TextLabel",{Size=UDim2.new(1,-8,0,30),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Text="Clicks on this menu are ignored.",TextSize=11,LayoutOrder=ord()},pCT,"dm")

	local pSv=page("Tools","Server")
	head(pSv,"Server")
	local info=N("TextLabel",{Size=UDim2.new(1,-8,0,64),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextSize=11,LayoutOrder=ord()},pSv,"dm")
	local function refresh()
		info.Text=("Game: %s\nPlayers: %d / %d\nJob ID: %s"):format(game.Name,#P:GetPlayers(),P.MaxPlayers,game.JobId)
	end
	refresh()
	btnRow(pSv,"Refresh","Copy Job ID",refresh,function()
		if setclipboard then setclipboard(game.JobId) showToast("Copied!") end
	end)
end
cn(UIS.InputBegan:Connect(function(i,g)
	if g or not F.ctp then return end
	if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
	local cam=workspace.CurrentCamera
	local loc=i.UserInputType==Enum.UserInputType.Touch and Vector2.new(i.Position.X,i.Position.Y) or UIS:GetMouseLocation()
	local ray=cam:ViewportPointToRay(loc.X,loc.Y)
	local rp2=RaycastParams.new() rp2.FilterType=Enum.RaycastFilterType.Exclude
	rp2.FilterDescendantsInstances={LP.Character}
	local hit=workspace:Raycast(ray.Origin,ray.Direction*1000,rp2)
	local r=root()
	if hit and r then r.CFrame=CFrame.new(hit.Position+Vector3.new(0,3,0)) end
end))
local function sendChat(msg)
	return pcall(function()
		local tcs=game:GetService("TextChatService")
		if tcs.ChatVersion==Enum.ChatVersion.TextChatService then
			tcs.TextChannels.RBXGeneral:SendAsync(msg)
		else
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
		end
	end)
end
do
	local pC=page("Troll","Chat")
	head(pC,"Chat")
	local mrow=row(pC,40) lbl(mrow,"Message","What gets sent to chat",.36)
	local mb=N("TextBox",{Size=UDim2.new(.6,-8,0,22),Position=UDim2.new(.4,0,.5,-11),Text=F.spamMsg,PlaceholderText="type a message",ClearTextOnFocus=false,TextSize=11,TextTruncate=Enum.TextTruncate.AtEnd},mrow,"inp") cr(mb,5)
	mb.FocusLost:Connect(function() F.spamMsg=mb.Text end)
	tg(pC,"Chat Spam","Sends the message on a timer","spam")
	nb(pC,"Spam Delay","Seconds between messages","spamDelay",.5,60)
	btnRow(pC,"Send Once","Stop Spam",function() sendChat(F.spamMsg) end,function() if TG.spam then TG.spam(false) end end)

	local pMv=page("Troll","Movement")
	head(pMv,"Movement (client side)")
	tg(pMv,"Auto Jump","Jumps on repeat","aj")
	tg(pMv,"Bunny Hop","Auto jump with a speed boost","bh",function(v) if not v then local h=hum() if h and not F.walk then h.WalkSpeed=16 end end end)
	tg(pMv,"Random Walk","Wanders in random directions","rw")
	btnRow(pMv,"Sit","Stand Up",function() local h=hum() if h then h.Sit=true end end,function() local h=hum() if h then h.Sit=false h.Jump=true end end)

	local spamT,rwT,rwDir=0,0,Vector3.zero
	cn(RS.Heartbeat:Connect(function(dt)
		local h=hum()
		if F.spam and F.spamMsg~="" then
			spamT=spamT-dt
			if spamT<=0 then spamT=F.spamDelay sendChat(F.spamMsg) end
		end
		if h and h.Health>0 then
			local grounded=h.FloorMaterial~=Enum.Material.Air
			if (F.aj or F.bh) and grounded then h.Jump=true end
			if F.bh and not F.walk then h.WalkSpeed=40 end
			if F.rw then
				rwT=rwT-dt
				if rwT<=0 then rwT=1.5 local a=math.random()*6.283 rwDir=Vector3.new(math.cos(a),0,math.sin(a)) end
				h:Move(rwDir,false)
			end
		end
	end))
end

local pN=page("New","Changelog")
	head(pN,"Changelog")
	N("TextLabel",{Size=UDim2.new(1,-16,0,0),AutomaticSize=Enum.AutomaticSize.Y,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Text="Every update is listed here, newest first. Each new change goes at the top.",TextSize=11,LayoutOrder=ord()},pN,"dm")
	local NEWS={
		{"Midnite 3.1 (latest)",{
			"Glass Look (Looks > UI): see-through panels with a light border and rounder corners.",
			"Preview panel to the right of the menu: when you open a section, it shows a picture of what that feature does (aimbot circle, ESP box, skeleton, silent aim, bots, chams, crosshair, lighting).",
			"New Black theme in Looks > UI (pure black, for OLED screens).",
		}},
		{"Midnite 3.0",{
			"Aim > Bots (bot icon): Target Bots lets the aimbot lock onto bots as well as players.",
			"Visuals > ESP > Bots: Bot ESP puts an orange glow on bots.",
			"Player > Teleport and Player > Haunt each have a Bots list you can tap.",
		}},
		{"Midnite 2.9",{
			"Redesign: a Welcome to MidNite header across the top with your avatar, name and a live FPS / ping line. The tab name moved to the right side under the window buttons.",
			"Fixed: the Auto Clicker froze games. It now clicks on its own timed loop, capped at 15 clicks per second.",
			"Fixed: the purple tab indicator now scrolls with the sidebar, so it stays on the selected tab.",
			"Fixed: switching tabs crashed when the icon bounce ran.",
			"Fixed: Silent Aim now hooks when the menu starts (it's on by default).",
		}},
		{"Midnite 2.6",{
			"Fixed: Silent Aim no longer moves your camera. It now only reroutes actual shots (fired right after a click, along your view), not the camera's own raycasts.",
		}},
		{"Midnite 2.5",{
			"New Silent Aim tab: a circle that reroutes shots to a target without moving your camera. Auto picks whoever is closest to the center; Manual lets you tap a player. A card shows their avatar, name, HP and distance. On by default.",
			"Silent Aim needs an executor that supports hookmetamethod, and only works in games whose shots use Raycast. Some games won't respond.",
			"New Misc tab: Auto Clicker (clicks per second), Player Inspector (account age, UserId, distance, team), and a Chat Log of the last 15 messages.",
		}},
		{"Midnite 2.4",{
			"Sidebar tabs scroll now, so the menu can grow.",
			"Every tab got new sections: Player > Extras (sprint, ghost, freeze, camera), Aim > Advanced (horizontal only, jitter, min distance), Visuals > Post FX (bloom, sun rays, blur, color correction, screen tint), Game > Extras (hide other players, copy server link), Troll > Screen FX (flash, shake, jitter), Tools > Stopwatch.",
			"Settings > Looks gets Interface (rebindable menu key, animation speed, click volume, reset spots) and Extras (sidebar glow, watermark).",
		}},
		{"Midnite 2.3",{
			"Whitelist section under Aim: tap players to make the aimbot ignore them.",
			"New effect: Matrix.",
			"Sidebar icon bounces when you switch tabs.",
		}},
		{"Midnite 2.2",{
			"Welcome screen on open: shows Welcome!, your avatar, display name, username, account age and the game you're in.",
			"Click ripple on every button.",
			"New Tools tab: Waypoints (set, go to, clear, copy position), Click Teleport, and Server info.",
			"New effects: Leaves and Glitch.",
			"Outline wrench icon for Tools.",
		}},
		{"Midnite 2.1",{
			"Every number setting now has a slider as well as a number box, and the number changes while you drag.",
		}},
		{"Midnite 2.0",{
			"Menu is now stacked: each tab opens its sections top to bottom, with the arrow on each header to open or close it.",
			"Tabs fade in when you switch between them.",
			"Sections slide open and closed, and the arrow turns as they move.",
			"Notifications slide in, and the sidebar glow breathes.",
			"Aimbot: Deadzone and Engage Delay added.",
			"Visuals > ESP: Chams added (colored glow on players through walls).",
		}},
		{"Midnite 1.9",{
			"Death Protection fixed: you're held up in the sky, then sent back down once your HP reaches the Back Down value.",
			"Aimbot Smoothness and Prediction have number boxes, and the slider is still there.",
			"New background patterns: Checker, Waves, Starfield, Stripes, each with a preview.",
			"Outlined emoji icons: Looks is now a hand making an OK sign, and Troll is a laughing face.",
			"New Troll tab: Chat Spam and Send Once, plus Auto Jump, Bunny Hop, Random Walk and Sit. These run on your side only.",
		}},
		{"Midnite 1.8",{
			"Color wheel: pick a background style and the wheel rolls down so you can change its color.",
			"Tabs are sorted by usefulness: Player, Aim, Visuals, Game, Looks, New. Sub-tabs are sorted too.",
			"Outlined icons for each tab. Settings is now called Looks.",
			"Death Protection (Player > Main): whenever you drop under the HP you set, you get teleported up into the sky.",
			"New: Night Vision (Visuals > World).",
		}},
		{"Midnite 1.7",{
			"Fixed: the menu can be dragged by its top bar and sidebar, not just the logo.",
		}},
		{"Midnite 1.6",{
			"New tab: this changelog, so you can see what changed.",
			"Background tiles now show real previews: grid, scanlines, rings, glow and a photo icon.",
			"Photo background: paste an image asset ID under the tiles.",
			"Tab indicator: a purple line and glow slide to the tab you're on.",
			"Tab icons sit on the right and no longer overlap names.",
			"Fly follows where you look. No arrow buttons, no E/Q.",
			"Player lists show each player's avatar headshot.",
			"New: Watermark (FPS, ping, time, player count). Settings > UI.",
			"New: Jump Power toggle and value. Player > Main.",
			"New: ESP Health Bar. Visuals > ESP.",
		}},
		{"Midnite 1.5",{
			"Renamed to Midnite. Purple default theme, Michroma M logo, Jura font picked automatically.",
			"Animated Midnite Wave background, plus Color Cycle and Aurora.",
			"Background tile picker and a Reset to Midnite button.",
			"Effects: Embers and Orbs. Themes: Violet, Obsidian and Ember.",
		}},
		{"Midnite 1.4",{
			"Background styles, 13 UI styles, accent swatches, and opacity and corner sliders.",
			"Particle effects: Snow, Rain, Stars, Bubbles, Fireflies, Sparks and Confetti.",
		}},
		{"Midnite 1.3",{
			"Full menu restored: all tabs, floating dock, save and load, character changer, potato mode and FPS counter.",
		}},
	}
	for _,e in ipairs(NEWS) do
		head(pN,e[1])
		for _,item in ipairs(e[2]) do
			N("TextLabel",{Size=UDim2.new(1,-16,0,0),AutomaticSize=Enum.AutomaticSize.Y,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Text="•  "..item,TextSize=12,LayoutOrder=ord()},pN,"t")
		end
	end
end

dockAdd("fly","Fly") dockAdd("walk","Walk") dockAdd("noclip","Noclip") dockAdd("inf","Inf Jump") dockAdd("spin","Spin") dockAdd("afk","Anti-AFK")

local chT=0
cn(RS.Heartbeat:Connect(function(dt)
	if sGlow then sGlow.BackgroundTransparency=.72+.12*math.sin(os.clock()*2) end
	chT=chT+dt
	if chT<.5 then return end
	chT=0
	for _,pl in ipairs(P:GetPlayers()) do if pl~=LP and pl.Character then
		local hl=pl.Character:FindFirstChild("MidniteCham")
		if F.cham and not hl then
			hl=Instance.new("Highlight") hl.Name="MidniteCham" hl.FillColor=S.acc hl.OutlineColor=Color3.new(1,1,1) hl.FillTransparency=.6 hl.Adornee=pl.Character hl.Parent=pl.Character
		elseif not F.cham and hl then hl:Destroy() end
	end end
end))
local dpT,dpUp,dpOrigin=0,false,nil
cn(RS.Heartbeat:Connect(function(dt)
	local h,r=hum(),root()
	if not h or not r then dpUp=false return end
	if h.Health<=0 then dpUp=false r.Anchored=false return end
	if dpUp then
		if h.Health>=F.dpBack or not F.dp then
			r.Anchored=false
			if dpOrigin then r.CFrame=dpOrigin end
			dpUp=false
			showToast("Death protection: back down")
		else
			r.Anchored=true
			r.AssemblyLinearVelocity=Vector3.zero
		end
		return
	end
	if not F.dp then return end
	dpT=dpT-dt
	if h.Health<F.dpHp and dpT<=0 then
		dpT=1
		dpOrigin=r.CFrame
		dpUp=true
		r.CFrame=r.CFrame+Vector3.new(0,F.dpH,0)
		r.AssemblyLinearVelocity=Vector3.zero
		r.Anchored=true
		showToast("Death protection: sent you up")
	end
end))
local wmN,wmAcc=0,0
cn(RS.Heartbeat:Connect(function(dt)
	wmN=wmN+1 wmAcc=wmAcc+dt
	if wmAcc<.5 then return end
	local fps=math.floor(wmN/wmAcc+.5) wmN=0 wmAcc=0
	if F.ready then
		local ping=0
		pcall(function() ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
		heroStat.Text="@"..LP.Name.."  |  "..fps.." FPS  |  "..ping.." ms"
	end
	wmL.Visible=(F.wm and F.ready) and true or false
	if F.wm then
		local ping=0
		pcall(function() ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
		local clock=""
		pcall(function() clock=os.date("%H:%M") end)
		wmL.Text=string.format("MIDNITE  |  %d FPS  |  %d ms  |  %s  |  %d players",fps,ping,clock,#P:GetPlayers())
	end
end))
cn(RS.Heartbeat:Connect(function()
	if F.jp then local h=hum() if h then h.UseJumpPower=true h.JumpPower=F.jpVal end end
end))

do
	local PRI={Main=1,Aimbot=1,ESP=1,UI=1,Changelog=1,Teleport=2,Crosshair=2,Target=2,Performance=2,Look=2,Haunt=3,World=3,Trigger=3,Save=3,Profile=4}
	for _,c in ipairs(CATS) do table.sort(c.s,function(a,b) return (PRI[a] or 9)<(PRI[b] or 9) end) for i,sn in ipairs(c.s) do local s=SECS[c.n..'/'..sn] if s then s.hdr.LayoutOrder=i*2-1 s.p.LayoutOrder=i*2 end end end
	CI=1 rebuildSubs()
end

-- ===== more tabs (Midnite 2.4) =====
local function fxInst(name,on,cls)
	local e=Lt:FindFirstChild(name)
	if on then
		if not e then e=Instance.new(cls) e.Name=name e.Parent=Lt end
		e.Enabled=true
	elseif e then e:Destroy() end
end
local screenTint=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(1,.4,.8),BackgroundTransparency=1,ZIndex=0},gui)
local flashFrame=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ZIndex=0},gui)
local extraT=0
cn(RS.Heartbeat:Connect(function(dt)
	local h,r=hum(),root()
	if h and h.Health>0 then
		if F.sprint and UIS:IsKeyDown(Enum.KeyCode.LeftShift) then h.WalkSpeed=F.sprintSpd end
		if F.jit and r then r.CFrame=r.CFrame+Vector3.new((math.random()-.5)*.15,0,(math.random()-.5)*.15) end
	end
	if r and F.freeze then if not F.frozenCF then F.frozenCF=r.CFrame end r.CFrame=F.frozenCF else F.frozenCF=nil end
	screenTint.BackgroundTransparency=F.tint and (1-F.tintOp) or 1
	flashFrame.BackgroundTransparency=(F.flash and math.floor(os.clock()*8)%2==0) and .6 or 1
	extraT=extraT+dt
	if extraT>=.5 then
		extraT=0
		if F.hideOthers then
			for _,q in ipairs(P:GetPlayers()) do if q~=LP and q.Character then
				for _,p in ipairs(q.Character:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=1 end end
			end end
		end
	end
end))
cn(RS.RenderStepped:Connect(function()
	if F.shake then workspace.CurrentCamera.CFrame=workspace.CurrentCamera.CFrame*CFrame.Angles((math.random()-.5)*.02,(math.random()-.5)*.02,0) end
end))

do -- Player > Extras
	local pX=page("Player","Extras")
	head(pX,"Movement")
	tg(pX,"Sprint (hold Shift)","Runs at the sprint speed while Shift is held","sprint")
	nb(pX,"Sprint Speed","Walk speed while sprinting","sprintSpd",16,200)
	tg(pX,"Ghost Mode","Makes your character see-through on your screen","ghost",function(v)
		local c=LP.Character if not c then return end
		for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=v and .65 or 0 end end
	end)
	tg(pX,"Freeze Position","Holds you in place (client side)","freeze")
	head(pX,"Camera")
	btnRow(pX,"Reset Camera","Fix Zoom",function() local h=hum() if h then workspace.CurrentCamera.CameraSubject=h end end,function() LP.CameraMaxZoomDistance=128 end)
end

do -- Aim > Advanced
	local pAd=page("Aim","Advanced")
	head(pAd,"Aim tuning")
	tg(pAd,"Horizontal Only","Only turns left and right, never up and down","aimHoriz")
	nb(pAd,"Jitter","Random shake added to aim (looks more human)","aimJit",0,10)
	nb(pAd,"Min Distance","Ignore targets closer than this (studs)","aimMin",0,500)
	head(pAd,"Crosshair")
	tg(pAd,"Crosshair Spin","Spins the FOV circle","spinFov")
end

do -- Visuals > Post FX
	local pPf=page("Visuals","Post FX")
	head(pPf,"Lighting effects")
	tg(pPf,"Bloom","Soft glow around bright things","bloom",function(v) fxInst("MidniteBloom",v,"BloomEffect") end)
	nb(pPf,"Bloom Strength","How strong the glow is","bloomStr",0,5,function(n) local b=Lt:FindFirstChild("MidniteBloom") if b then b.Intensity=n end end)
	tg(pPf,"Sun Rays","Light beams from the sun","sunrays",function(v) fxInst("MidniteRays",v,"SunRaysEffect") end)
	tg(pPf,"Blur","Blurs the game behind the menu","blur",function(v) fxInst("MidniteBlur",v,"BlurEffect") end)
	tg(pPf,"Color Correction","Saturation and contrast","cc",function(v) fxInst("MidniteCC",v,"ColorCorrectionEffect") end)
	nb(pPf,"Saturation","-1 is grey, 0 is normal, 2 is vivid","ccSat",-1,2,function(n) local c=Lt:FindFirstChild("MidniteCC") if c then c.Saturation=n end end)
	nb(pPf,"Contrast","Higher is punchier","ccCon",-1,2,function(n) local c=Lt:FindFirstChild("MidniteCC") if c then c.Contrast=n end end)
	head(pPf,"Screen overlay")
	tg(pPf,"Screen Tint","Colored wash over the game (your screen only)","tint")
	nb(pPf,"Tint Strength","How strong the wash is","tintOp",0,1)
end

do -- Game > Extras
	local pGx=page("Game","Extras")
	head(pGx,"Players")
	tg(pGx,"Hide Other Players","Makes everyone else see-through (your screen only)","hideOthers",function(v)
		if not v then for _,q in ipairs(P:GetPlayers()) do if q~=LP and q.Character then
			for _,p in ipairs(q.Character:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=0 end end
		end end end
	end)
	head(pGx,"Share")
	btnRow(pGx,"Copy Game Link","Copy Server Link",function()
		if setclipboard then pcall(setclipboard,"https://www.roblox.com/games/"..game.PlaceId) showToast("Copied!") end
	end,function()
		if setclipboard then pcall(setclipboard,"roblox://placeId="..game.PlaceId.."&gameInstanceId="..game.JobId) showToast("Copied!") end
	end)
end

do -- Troll > Screen FX
	local pTs=page("Troll","Screen FX")
	head(pTs,"Screen (client side)")
	tg(pTs,"Screen Flash","Flickers the screen white","flash")
	tg(pTs,"Shake Camera","Shakes your camera","shake")
	tg(pTs,"Jitter","Tiny random wiggle of your character","jit")
end

do -- Tools > Stopwatch
	local pSw=page("Tools","Stopwatch")
	head(pSw,"Stopwatch")
	local r1=row(pSw,40)
	local swL=N("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.fromOffset(8,0),TextSize=18,TextXAlignment=Enum.TextXAlignment.Left,Text="00:00.00"},r1,"at")
	local swRun,swT=false,0
	cn(RS.Heartbeat:Connect(function(dt)
		if swRun then swT=swT+dt end
		swL.Text=string.format("%02d:%05.2f",math.floor(swT/60),swT%60)
	end))
	btnRow(pSw,"Start / Stop","Reset",function() swRun=not swRun end,function() swRun=false swT=0 end)
end

do -- Looks > Interface
	local pI=page("Looks","Interface")
	head(pI,"Controls")
	local kRow=row(pI,36) lbl(kRow,"Menu Key","Click the key, then press a new one",.5)
	local kb=N("TextButton",{Size=UDim2.fromOffset(120,24),Position=UDim2.new(1,-128,.5,-12),Text=F.menuKey,TextSize=11},kRow,"inp") cr(kb,6)
	local waiting=false
	kb.Activated:Connect(function() waiting=true kb.Text="Press a key..." end)
	cn(UIS.InputBegan:Connect(function(i)
		if waiting and i.UserInputType==Enum.UserInputType.Keyboard then
			waiting=false
			if i.KeyCode~=Enum.KeyCode.Unknown then F.menuKey=i.KeyCode.Name end
			kb.Text=F.menuKey
		end
	end))
	SETS.menuKey=function(n) F.menuKey=n kb.Text=n end
	nb(pI,"Animation Speed","1 is normal, higher is faster","animSpd",.2,3)
	nb(pI,"Click Volume","Volume of the click sounds","vol",0,1)
	head(pI,"Layout")
	btnRow(pI,"Reset Menu Spot","Reset Dock Spot",function() main.Position=UDim2.new(.5,0,.5,0) end,function() dock.Position=UDim2.new(0,8,.5,-70) end)
end

do -- Looks > Extras
	local pLx=page("Looks","Extras")
	head(pLx,"Effects")
	tg(pLx,"Sidebar Glow","The breathing glow behind the selected tab","sglow",function(v) sGlow.Visible=v end)
	head(pLx,"Watermark")
	tg(pLx,"Show Watermark","Same as the toggle in UI, here for quick access","wm")
end

-- ===== Silent Aim tab + Misc tab (Midnite 2.5) =====
local function saPick()
	if F.saMode=="Manual" then
		local t=F.saTarget
		if t and t.Parent and t.Character and t.Character:FindFirstChild("Head") then return t end
		return nil
	end
	local cam=workspace.CurrentCamera
	local ctr=cam.ViewportSize/2
	local best,bd
	for _,p in ipairs(P:GetPlayers()) do
		if p~=LP and p.Character and not(F.wl and F.wl[p.UserId]) then
			local hd=p.Character:FindFirstChild("Head")
			local hm=p.Character:FindFirstChildOfClass("Humanoid")
			if hd and hm and hm.Health>0 then
				local sp,on=cam:WorldToViewportPoint(hd.Position)
				if on and sp.Z>0 then
					local d=(Vector2.new(sp.X,sp.Y)-ctr).Magnitude
					if d<=F.saFov and (not bd or d<bd) then best,bd=p,d end
				end
			end
		end
	end
	return best
end

-- reroute shots: when the game asks for a raycast from the camera, point it at the target's head
local saHooked=false
local saLastClick=0
cn(UIS.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		saLastClick=os.clock()
	end
end))
-- Only reroute real shots: made right after a click, aimed along your view, and long enough to be a bullet.
-- Ignoring other raycasts (like the camera's wall-check) stops the camera from drifting.
local function saHook()
	if saHooked then return end
	pcall(function()
		if not hookmetamethod or not getnamecallmethod or not newcclosure then return end
		saHooked=true
		local old
		old=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
			local m=getnamecallmethod()
			if F.sa and m=="Raycast" and self==workspace and not checkcaller() and os.clock()-saLastClick<.25 then
				local origin,dir=...
				local cam=workspace.CurrentCamera
				if typeof(origin)=="Vector3" and typeof(dir)=="Vector3" and dir.Magnitude>80
					and dir.Unit:Dot(cam.CFrame.LookVector)>.9 then
					local p=saPick()
					local hd=p and p.Character and p.Character:FindFirstChild("Head")
					if hd then
						local args={...}
						args[2]=(hd.Position-origin).Unit*dir.Magnitude
						return old(self,table.unpack(args,1,select("#",...)))
					end
				end
			end
			return old(self,...)
		end))
	end)
end

local saFovF=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(240,240),BackgroundTransparency=1,Visible=false,ZIndex=0},gui)
cr(saFovF,200)
local saFovSt=Instance.new("UIStroke") saFovSt.Thickness=1.5 saFovSt.Parent=saFovF reg(saFovSt,"as")

local acT=0
task.spawn(function()
	while true do
		task.wait(1/math.clamp(F.acCps,1,15))
		if F.ac then pcall(mouse1click) end
	end
end)
cn(RS.Heartbeat:Connect(function(dt)
	saFovF.Visible=F.sa
	saFovF.Size=UDim2.fromOffset(F.saFov*2,F.saFov*2)
end))

do -- Silent Aim > Setup
	local pSa=page("Silent Aim","Setup")
	head(pSa,"Silent aim")
	tg(pSa,"Silent Aim","Reroutes shots to the target in the circle, no camera movement","sa",function(v) if v then saHook() end end)
	nb(pSa,"Silent FOV","Radius of the silent aim circle","saFov",10,800)
	head(pSa,"Target")
	btnRow(pSa,"Auto (default)","Manual pick",function() F.saMode="Auto" end,function() F.saMode="Manual" end)
	N("TextLabel",{Size=UDim2.new(1,-8,0,30),TextWrapped=true,Text="Auto picks whoever is closest to the center of the circle. Manual uses the player you tap below.",TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=ord()},pSa,"dm")
	local _,saPaint=plist(pSa,function() return F.saTarget end,function(p) F.saTarget=p F.saMode="Manual" end,false)
	HOOK[#HOOK+1]=saPaint
end

do -- Silent Aim > Target card
	local pCd=page("Silent Aim","Target")
	head(pCd,"Current target")
	local card=N("Frame",{Size=UDim2.new(1,-8,0,70),BackgroundTransparency=1,LayoutOrder=ord()},pCd)
	local cardBg=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.row},card,"row") cr(cardBg,10)
	local av=N("ImageLabel",{Size=UDim2.fromOffset(52,52),Position=UDim2.fromOffset(9,9),BackgroundTransparency=1},cardBg) cr(av,26)
	local nameL=N("TextLabel",{Size=UDim2.new(1,-80,0,20),Position=UDim2.fromOffset(70,10),TextXAlignment=Enum.TextXAlignment.Left,TextSize=14,Text="No target",TextTruncate=Enum.TextTruncate.AtEnd},cardBg,"t")
	local infoL=N("TextLabel",{Size=UDim2.new(1,-80,0,30),Position=UDim2.fromOffset(70,30),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextSize=11,TextWrapped=true,Text=""},cardBg,"dm")
	local shownFor
	cn(RS.Heartbeat:Connect(function()
		local t=F.saMode=="Manual" and F.saTarget or saPick()
		if not t or not t.Parent then
			nameL.Text="No target" infoL.Text="" av.Image="" shownFor=nil
			return
		end
		if shownFor~=t then
			shownFor=t
			av.Image="rbxthumb://type=AvatarHeadShot&id="..t.UserId.."&w=150&h=150"
		end
		local hm=t.Character and t.Character:FindFirstChildOfClass("Humanoid")
		local hr=t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		local me=root()
		local dist=(hr and me) and math.floor((hr.Position-me.Position).Magnitude) or 0
		nameL.Text=t.DisplayName.."  (@"..t.Name..")"
		infoL.Text=string.format("HP %d/%d   |   %d studs   |   %s",hm and math.floor(hm.Health) or 0,hm and math.floor(hm.MaxHealth) or 0,dist,F.saMode)
	end))
end

do -- Misc > Clicker
	local pCk=page("Misc","Clicker")
	head(pCk,"Auto clicker")
	tg(pCk,"Auto Clicker","Clicks for you at the speed below","ac")
	nb(pCk,"Clicks per second","How fast it clicks","acCps",1,30)
end

do -- Misc > Inspector
	local pIn=page("Misc","Inspector")
	head(pIn,"Player inspector")
	local infoRow=row(pIn,70)
	local infoT=N("TextLabel",{Size=UDim2.new(1,-16,1,-8),Position=UDim2.fromOffset(8,4),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,TextSize=12,Text="Tap a player below"},infoRow,"t")
	local function showInfo()
		local p=F.inspect
		if not p or not p.Parent then infoT.Text="Tap a player below" return end
		local me=root()
		local hr=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		local dist=(hr and me) and math.floor((hr.Position-me.Position).Magnitude).." studs" or "unknown"
		infoT.Text=string.format("%s (@%s)\nUserId: %d\nAccount age: %d days\nDistance: %s\nTeam: %s",p.DisplayName,p.Name,p.UserId,p.AccountAge,dist,p.Team and p.Team.Name or "none")
	end
	local _,inPaint=plist(pIn,function() return F.inspect end,function(p) F.inspect=p showInfo() end,false)
	HOOK[#HOOK+1]=inPaint
	cn(RS.Heartbeat:Connect(function(dt)
		if F.inspect and (not F.inspT or os.clock()-F.inspT>.5) then F.inspT=os.clock() showInfo() end
	end))
end

do -- Misc > Chat Log
	local pCl=page("Misc","Chat Log")
	head(pCl,"Recent chat (last 15)")
	local chatLines={}
	local chatL=N("TextLabel",{Size=UDim2.new(1,-16,0,0),AutomaticSize=Enum.AutomaticSize.Y,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextSize=11,Text="No messages yet",LayoutOrder=ord()},pCl,"dm")
	local function addChat(s)
		table.insert(chatLines,1,s)
		while #chatLines>15 do table.remove(chatLines) end
		chatL.Text=table.concat(chatLines,"\n")
	end
	local function watch(p)
		pcall(function() p.Chatted:Connect(function(msg) addChat(p.DisplayName..": "..msg) end) end)
	end
	for _,p in ipairs(P:GetPlayers()) do watch(p) end
	cn(P.PlayerAdded:Connect(watch))
	pcall(function()
		game:GetService("TextChatService").MessageReceived:Connect(function(m)
			addChat((m.TextSource and m.TextSource.Name or "?")..": "..(m.Text or ""))
		end)
	end)
	btnRow(pCl,"Clear Log","Copy Log",function() chatLines={} chatL.Text="No messages yet" end,function() if setclipboard then pcall(setclipboard,table.concat(chatLines,"\n")) showToast("Copied!") end end)
end

-- ===== Bots (v3.0) =====
do
	F.tBots=F.tBots or false
	F.botEsp=F.botEsp or false
	local botCache,botT={},0
	local proxyOf,nextId={},0
	local function botProxy(m)
		local px=proxyOf[m]
		if not px then
			nextId=nextId+1
			px={Character=m,Name=m.Name,DisplayName=m.Name,UserId=-nextId}
			proxyOf[m]=px
		end
		return px
	end
	local function isBot(m)
		return m:IsA("Model") and m~=LP.Character and m:FindFirstChildOfClass("Humanoid")
			and m:FindFirstChild("HumanoidRootPart") and not P:GetPlayerFromCharacter(m)
	end
	local function scanBots()
		local out={}
		for _,d in ipairs(workspace:GetDescendants()) do
			if #out>=60 then break end
			if isBot(d) then out[#out+1]=d end
		end
		return out
	end
	-- the aimbot asks this for its target list: players, plus bots when Target Bots is on
	G.midniteTargets=function()
		local list={}
		for _,p in ipairs(P:GetPlayers()) do list[#list+1]=p end
		if F.tBots then
			for _,m in ipairs(botCache) do list[#list+1]=botProxy(m) end
		end
		return list
	end

	cn(RS.Heartbeat:Connect(function(dt)
		botT=botT+dt
		if botT<.5 then return end
		botT=0
		botCache=scanBots()
		for _,m in ipairs(botCache) do
			local hl=m:FindFirstChild("MidniteBotHL")
			if F.botEsp and not hl then
				hl=Instance.new("Highlight") hl.Name="MidniteBotHL"
				hl.FillColor=rgb(255,140,40) hl.OutlineColor=Color3.new(1,1,1) hl.FillTransparency=.5
				hl.Adornee=m hl.Parent=m
			elseif not F.botEsp and hl then hl:Destroy() end
		end
	end))

	-- a list of the bots that are around right now; rebuilt when the list changes
	local function botPicker(pg,onPick)
		local holder=N("Frame",{Size=UDim2.new(1,-8,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=ord()},pg)
		local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,4) lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Parent=holder
		local key="~"
		local function refresh()
			local k=""
			for _,m in ipairs(botCache) do k=k..m:GetFullName() end
			if k==key then return end
			key=k
			for _,c in ipairs(holder:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
			if #botCache==0 then
				N("TextLabel",{Size=UDim2.new(1,0,0,20),Text="No bots found right now",TextSize=11,LayoutOrder=1},holder,"dm")
				return
			end
			for i,m in ipairs(botCache) do
				local px=botProxy(m)
				local b=N("TextButton",{Size=UDim2.new(1,0,0,28),Text=m.Name,TextSize=12,LayoutOrder=i+1},holder,"row") cr(b,6)
				b.Activated:Connect(function() onPick(px) end)
			end
		end
		refresh()
		local t=0
		cn(RS.Heartbeat:Connect(function(dt) t=t+dt if t<1 then return end t=0 refresh() end))
	end

	-- Aim > Bots
	local pAB=page("Aim","Bots")
	head(pAB,"Bots")
	local hdr=SECS["Aim/Bots"] and SECS["Aim/Bots"].hdr
	if hdr then X.icon(hdr,"bot",16,UDim2.fromOffset(10,10)) end
	tg(pAB,"Target Bots","Lets the aimbot lock onto bots as well as players","tBots")
	N("TextLabel",{Size=UDim2.new(1,-8,0,30),TextWrapped=true,Text="Bots are any character models in the world that aren't a player.",TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=ord()},pAB,"dm")

	-- Visuals > ESP
	local pVE=page("Visuals","ESP")
	head(pVE,"Bots")
	tg(pVE,"Bot ESP","Orange glow on bots","botEsp")

	-- Player > Teleport and Player > Haunt
	local pTp=page("Player","Teleport")
	head(pTp,"Bots (tap to teleport)")
	botPicker(pTp,function(px) F.tpSel=px tpTo(px) end)
	local pHa=page("Player","Haunt")
	head(pHa,"Bots (tap to haunt)")
	botPicker(pHa,function(px) if F.hAll then TG.hAll(false,true) end hauntPick(px) end)
end

-- ===== v3.1: glass look, previews, black theme =====
do
	F.glass=F.glass or false

	local function applyGlass(v)
		F.glass=v and true or false
		F.trans=F.glass and .25 or 0
		F.radMul=F.glass and 1.6 or 1
		applyTheme(F.ui)
		mSt.Color=F.glass and Color3.new(1,1,1) or S.acc
		mSt.Transparency=F.glass and .5 or .3
	end

	-- the preview panel, sitting to the right of the menu with a pointer back at it
	local PV=N("Frame",{Size=UDim2.fromOffset(196,236),Visible=false,ZIndex=40},gui,"bg")
	cr(PV,16)
	local pvStroke=Instance.new("UIStroke") pvStroke.Thickness=1 pvStroke.Transparency=.4 pvStroke.Parent=PV reg(pvStroke,"as")
	local pvTitle=N("TextLabel",{Size=UDim2.new(1,-16,0,22),Position=UDim2.fromOffset(10,8),Text="Preview",TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=41},PV,"at")
	local pointer=N("TextLabel",{Size=UDim2.fromOffset(16,22),Position=UDim2.fromOffset(-12,100),Text="◀",TextSize=16,ZIndex=41},PV,"at")
	local stage=N("Frame",{Size=UDim2.fromOffset(176,186),Position=UDim2.fromOffset(10,36),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.25,ZIndex=41},PV)
	cr(stage,12)

	local content={}
	local function clear() for _,c in ipairs(content) do c:Destroy() end content={} end
	local function add(cls,props)
		local o=Instance.new(cls) o.BorderSizePixel=0 o.ZIndex=42
		for k,v in pairs(props) do o[k]=v end
		o.Parent=stage content[#content+1]=o
		return o
	end
	local function round(o,r)
		local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=o
	end
	local function circle(o) round(o,99) end
	local function ring(cx,cy,r,col,th)
		local f=add("Frame",{Size=UDim2.fromOffset(r*2,r*2),Position=UDim2.fromOffset(cx-r,cy-r),BackgroundTransparency=1})
		circle(f)
		local st=Instance.new("UIStroke") st.Thickness=th or 1.5 st.Color=col or S.acc st.Parent=f
		return f
	end
	local function seg(ax,ay,bx,by,col)
		local dx,dy=bx-ax,by-ay
		local len=math.sqrt(dx*dx+dy*dy)
		return add("Frame",{Size=UDim2.fromOffset(len,2),Position=UDim2.fromOffset((ax+bx)/2-len/2,(ay+by)/2-1),Rotation=math.deg(math.atan2(dy,dx)),BackgroundColor3=col or S.acc})
	end
	local function figure(col)
		local h=add("Frame",{Size=UDim2.fromOffset(26,26),Position=UDim2.fromOffset(72,39),BackgroundColor3=col}) circle(h)
		local b=add("Frame",{Size=UDim2.fromOffset(40,48),Position=UDim2.fromOffset(65,68),BackgroundColor3=col}) round(b,10)
		add("Frame",{Size=UDim2.fromOffset(8,40),Position=UDim2.fromOffset(56,70),BackgroundColor3=col}) round(content[#content],4)
		add("Frame",{Size=UDim2.fromOffset(8,40),Position=UDim2.fromOffset(106,70),BackgroundColor3=col}) round(content[#content],4)
		add("Frame",{Size=UDim2.fromOffset(14,34),Position=UDim2.fromOffset(67,118),BackgroundColor3=col}) round(content[#content],5)
		add("Frame",{Size=UDim2.fromOffset(14,34),Position=UDim2.fromOffset(89,118),BackgroundColor3=col}) round(content[#content],5)
	end
	local function label(text,x,y,col)
		return add("TextLabel",{Size=UDim2.fromOffset(170,16),Position=UDim2.fromOffset(x,y),BackgroundTransparency=1,Text=text,TextSize=11,TextColor3=col or Color3.new(1,1,1),TextStrokeTransparency=.5})
	end

	local KINDS={}
	KINDS.aim=function()
		figure(Color3.fromRGB(210,210,220))
		ring(88,93,64,S.acc,1.5)
		local dot=add("Frame",{Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(85,90),BackgroundColor3=S.acc}) circle(dot)
		seg(88,93,88,50,S.acc)
		label("FOV circle + target",0,156,Color3.new(1,1,1))
	end
	KINDS.esp=function()
		figure(Color3.fromRGB(150,150,165))
		local box=add("Frame",{Size=UDim2.fromOffset(60,128),Position=UDim2.fromOffset(58,34),BackgroundTransparency=1})
		round(box,4)
		local st=Instance.new("UIStroke") st.Thickness=1.5 st.Color=S.acc st.Parent=box
		add("Frame",{Size=UDim2.fromOffset(3,128),Position=UDim2.fromOffset(52,34),BackgroundColor3=Color3.fromRGB(60,230,110)})
		label("Name",0,14,Color3.new(1,1,1))
		label("42m",0,166,Color3.fromRGB(200,200,210))
	end
	KINDS.skel=function()
		local j={head={85,52},neck={85,68},hips={85,110},shL={68,74},shR={102,74},hL={60,104},hR={110,104},kL={74,138},kR={96,138},fL={72,160},fR={98,160}}
		local pairs_={{"head","neck"},{"neck","hips"},{"neck","shL"},{"shL","hL"},{"neck","shR"},{"shR","hR"},{"hips","kL"},{"kL","fL"},{"hips","kR"},{"kR","fR"}}
		for _,p in ipairs(pairs_) do seg(j[p[1]][1],j[p[1]][2],j[p[2]][1],j[p[2]][2],S.acc) end
		for _,k in pairs(j) do local d=add("Frame",{Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(k[1]-3,k[2]-3),BackgroundColor3=Color3.new(1,1,1)}) circle(d) end
		label("Skeleton",0,166,Color3.new(1,1,1))
	end
	KINDS.silent=function()
		ring(88,93,62,S.acc,1.5)
		figure(Color3.fromRGB(210,210,220))
		seg(88,170,88,58,Color3.fromRGB(255,220,60))
		label("Shots rerouted",0,156,Color3.new(1,1,1))
	end
	KINDS.bot=function()
		figure(Color3.fromRGB(255,140,40))
		label("BOT",0,14,Color3.fromRGB(255,140,40))
		label("Bots are targetable",0,166,Color3.new(1,1,1))
	end
	KINDS.cham=function()
		ring(88,95,70,S.acc,6)
		figure(Color3.fromRGB(190,130,255))
		label("Chams glow",0,166,Color3.new(1,1,1))
	end
	KINDS.white=function()
		figure(Color3.fromRGB(60,230,110))
		label("Ignored by aimbot",0,14,Color3.fromRGB(60,230,110))
	end
	KINDS.cross=function()
		seg(88,20,88,70,S.acc) seg(88,110,88,160,S.acc)
		seg(20,93,70,93,S.acc) seg(110,93,156,93,S.acc)
		ring(88,93,22,S.acc,1)
		label("Crosshair",0,166,Color3.new(1,1,1))
	end
	KINDS.world=function()
		local sun=add("Frame",{Size=UDim2.fromOffset(40,40),Position=UDim2.fromOffset(120,20),BackgroundColor3=Color3.fromRGB(255,220,120)}) circle(sun)
		add("Frame",{Size=UDim2.fromOffset(176,60),Position=UDim2.fromOffset(0,126),BackgroundColor3=Color3.fromRGB(40,36,60)})
		label("Lighting",0,166,Color3.new(1,1,1))
	end
	KINDS.theme=function()
		local cols={C.bg,C.bar,C.row,S.acc}
		for i,c in ipairs(cols) do
			local sw=add("Frame",{Size=UDim2.fromOffset(74,74),Position=UDim2.fromOffset(8+((i-1)%2)*84,8+math.floor((i-1)/2)*84),BackgroundColor3=c}) round(sw,12)
		end
		label("Theme colors",0,166,Color3.new(1,1,1))
	end

	local MAP={["Aim/Aimbot"]="aim",["Aim/Advanced"]="aim",["Aim/Target"]="aim",["Aim/Trigger"]="aim",["Aim/Whitelist"]="white",["Aim/Bots"]="bot",
		["Visuals/ESP"]="esp",["Visuals/Extra ESP"]="skel",["Visuals/Crosshair"]="cross",["Visuals/World"]="world",["Visuals/Post FX"]="world",
		["Silent Aim/Setup"]="silent",["Silent Aim/Target"]="silent",["Looks/UI"]="theme",["Looks/Look"]="theme"}
	G.midnitePreview=function(key)
		if not key or not MAP[key] then PV.Visible=false clear() return end
		clear()
		pvTitle.Text=key:gsub("/"," > ")
		KINDS[MAP[key]]()
		PV.Visible=true
		PV.BackgroundTransparency=1
		tw(PV,.25,{BackgroundTransparency=F.glass and .25 or 0})
	end
	cn(RS.Heartbeat:Connect(function()
		if PV.Visible and main then
			PV.Position=UDim2.fromOffset(main.AbsolutePosition.X+main.AbsoluteSize.X+16,main.AbsolutePosition.Y+70)
		end
	end))

	do
		local pU=page("Looks","UI")
		tg(pU,"Glass Look","Frosted see-through panels with rounder corners (iPhone-style)","glass",function(v) applyGlass(v) end)
	end
end

-- ===== particles + loops =====
local tm,rbT=0,0
local function fxStep(dt)
	if F.fx=="None" then return end
	local sp=F.fxSpeed
	for i=1,F.fxN do
		local p=PART[i]
		if p and p.f.Visible then
			local wig=(F.fx=="Snow") and math.sin(tm+p.ph)*8 or 0
			p.x=p.x+p.vx*dt*sp
			p.y=p.y+p.vy*dt*sp
			if F.fx=="Stars" then p.f.BackgroundTransparency=.3+.6*(.5+.5*math.sin(tm*2+p.ph)) end
			if F.fx=="Glitch" and math.random()<.04 then resetP(p,true) end
			if p.x<-20 or p.x>W+20 or p.y<-20 or p.y>H+20 then resetP(p,false) end
			p.f.Position=UDim2.fromOffset(p.x+wig,p.y)
		end
	end
end
cn(RS.Stepped:Connect(function()
	if (F.noclip or F.fly) and LP.Character then
		for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
	end
end))
cn(RS.Heartbeat:Connect(function(dt)
	tm=tm+dt
	local h,r=hum(),root()
	if h and F.walk and not F.fly then h.WalkSpeed=F.walkVal*F.walkMulti end
	if F.spin and not F.fly and r then r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(F.spinSpeed*F.spinMulti),0) end
	if F.rainbow then rbT=rbT+dt if rbT>.1 then rbT=0 applyAcc(Color3.fromHSV((tm*.25)%1,.8,1)) end end
	if main.Visible then
		bgPaint(dt)
		fxStep(dt)
	end
	if F.hP and r then
		local t=F.hP.Character and F.hP.Character:FindFirstChild("HumanoidRootPart")
		if t then
			local pos
			if F.hOrbit then local a=tm*F.hSpeed pos=t.Position+Vector3.new(math.cos(a)*F.hDist,F.hH,math.sin(a)*F.hDist)
			else pos=(t.CFrame*CFrame.new(0,0,0)*CFrame.new(0,F.hH,F.hDist)).Position end
			if (pos-t.Position).Magnitude<.05 then r.CFrame=CFrame.new(pos) else r.CFrame=CFrame.lookAt(pos,t.Position) end
			r.AssemblyLinearVelocity=Vector3.zero
		end
	end
	for _,f in ipairs(HB) do pcall(f,dt,tm) end
end))
cn(UIS.JumpRequest:Connect(function() if F.inf then local h=hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end))
cn(LP.Idled:Connect(function()
	if F.afk then pcall(function() local v=game:GetService("VirtualUser") v:CaptureController() v:ClickButton2(Vector2.new()) end) end
end))
cn(LP.CharacterAdded:Connect(function() task.wait(1) if F.fly then startFly() end end))

-- ===== exit confirm =====
local function shutdown()
	stopFly()
	for _,k in ipairs({"walk","noclip","inf","spin","afk","tpAll","hAll"}) do F[k]=false end
	pcall(runTpAll,false) pcall(runHauntAll,false)
	for _,f in ipairs(EXIT) do pcall(f) end
	local h=hum() if h then h.WalkSpeed=16 workspace.CurrentCamera.CameraSubject=h end
	for _,c in ipairs(CN) do pcall(function() c:Disconnect() end) end
	G.Midnite=nil
end
local exOv=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Visible=false,ZIndex=50,Active=true},main)
local exD=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(240,130),ZIndex=51},exOv,"bg") cr(exD,12)
local exS=Instance.new("UIScale") exS.Scale=0 exS.Parent=exD
local exSt=Instance.new("UIStroke") exSt.Color=RED exSt.Thickness=1.5 exSt.Parent=exD
local q1=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1},exD)
N("TextLabel",{Size=UDim2.new(1,0,0,36),Position=UDim2.fromOffset(0,16),Text="Are you sure?",TextSize=20,TextColor3=RED},q1)
local yes=N("TextButton",{Size=UDim2.fromOffset(96,34),Position=UDim2.fromOffset(18,76),BackgroundColor3=rgb(215,45,45),Text="Yes",TextSize=14},q1) cr(yes,8)
local no=N("TextButton",{Size=UDim2.fromOffset(96,34),Position=UDim2.fromOffset(126,76),BackgroundColor3=rgb(45,190,95),Text="No",TextSize=14},q1) cr(no,8)
local q2=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},exD)
N("TextLabel",{Size=UDim2.new(1,0,0,50),Position=UDim2.fromOffset(0,8),Text=":(",TextSize=40},q2)
local bar=N("Frame",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,72),Size=UDim2.fromOffset(180,4)},q2,"row") cr(bar,2)
local barF=N("Frame",{Size=UDim2.new(0,0,1,0)},bar,"a") cr(barF,2)
N("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.fromOffset(0,86),Text="Turning off scripts..",TextSize=12},q2,"dm")
exitB.Activated:Connect(function()
	q1.Visible=true q2.Visible=false exOv.Visible=true exS.Scale=0
	tw(exOv,.2,{BackgroundTransparency=.5}) tw(exS,.3,{Scale=1},BACK)
end)
no.Activated:Connect(function()
	tw(exS,.15,{Scale=0}) tw(exOv,.15,{BackgroundTransparency=1})
	task.delay(.16,function() exOv.Visible=false end)
end)
yes.Activated:Connect(function()
	q1.Visible=false q2.Visible=true barF.Size=UDim2.new(0,0,1,0)
	tw(barF,2.4,{Size=UDim2.new(1,0,1,0)},Enum.EasingStyle.Linear)
	task.delay(2.6,function()
		shutdown()
		tw(exS,.2,{Scale=0}) tw(mS,.2,{Scale=0})
		task.delay(.3,function() gui:Destroy() end)
	end)
end)

-- ===== menu show / hide + M box =====
local lbx=N("TextButton",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(44,44),Position=UDim2.fromOffset(40,110),Text="M",TextScaled=true,Visible=false,AutoButtonColor=false},gui,"a") cr(lbx,8)
pcall(function() lbx.Font=Enum.Font.Michroma end)
lbx:SetAttribute("kf",true)
local lbP=Instance.new("UIPadding") lbP.PaddingTop=UDim.new(.18,0) lbP.PaddingBottom=UDim.new(.18,0) lbP.Parent=lbx
local lbSt=Instance.new("UIStroke") lbSt.Thickness=1.5 lbSt.Color=C.line lbSt.Parent=lbx
HOOK[#HOOK+1]=function()
	local c=S.acc
	lbx.TextColor3=(0.299*c.R+0.587*c.G+0.114*c.B>.55) and Color3.new(0,0,0) or Color3.new(1,1,1)
	lbSt.Color=C.line
end
drag(lbx,lbx)
local busy=false
local function hideMenu()
	if busy or not main.Visible then return end
	busy=true sfx(.8)
	tw(mS,.2,{Scale=0},Enum.EasingStyle.Back)
	task.delay(.2,function()
		main.Visible=false lbx.Size=UDim2.fromOffset(0,0) lbx.Visible=true
		tw(lbx,.25,{Size=UDim2.fromOffset(44,44)},BACK)
		busy=false
	end)
end
local function showMenu()
	if busy or main.Visible then return end
	busy=true sfx(1.3)
	tw(lbx,.15,{Size=UDim2.fromOffset(0,0)})
	task.delay(.15,function()
		lbx.Visible=false main.Visible=true mS.Scale=0
		tw(mS,.3,{Scale=1},BACK)
		busy=false
	end)
end
hideB.Activated:Connect(hideMenu)
lbx.Activated:Connect(showMenu)
cn(UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode==Enum.KeyCode[F.menuKey] then if main.Visible then hideMenu() else showMenu() end end
end))

-- ===== shared export + stop =====
G.Midnite={P=P,RS=RS,UIS=UIS,TS=TS,HS=HS,Lt=Lt,LP=LP,F=F,S=S,C=C,TG=TG,NB=NB,SETS=SETS,DKT=DKT,HB=HB,EXIT=EXIT,CN=CN,REG=REG,HOOK=HOOK,NOSAVE=NOSAVE,
	N=N,cr=cr,reg=reg,tw=tw,applyTheme=applyTheme,applyAcc=applyAcc,gui=gui,main=main,root=root,hum=hum,toast=showToast,LD=loadCfg}
G.MidniteStop=function()
	for _,f in ipairs(EXIT) do pcall(f) end
	stopFly()
	runTpAll(false) runHauntAll(false)
	for _,c in ipairs(CN) do pcall(function() c:Disconnect() end) end
	pcall(function() if fbBk then for k,x in pairs(fbBk) do Lt[k]=x end end end)
	pcall(function() gui:Destroy() end)
	G.Midnite=nil
end

local function showWelcome()
	local w=N("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(290,176),BackgroundColor3=C.bg,GroupTransparency=1,ZIndex=120},gui,"bg")
	cr(w,14)
	local ws=Instance.new("UIStroke") ws.Thickness=1.5 ws.Parent=w reg(ws,"as")
	local sc=Instance.new("UIScale") sc.Scale=.8 sc.Parent=w
	local title=N("TextLabel",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,12),Text="Welcome!",TextSize=22,ZIndex=121},w,"at")
	pcall(function() title.Font=Enum.Font.Michroma end) title:SetAttribute("kf",true)
	local av=N("ImageLabel",{Size=UDim2.fromOffset(64,64),Position=UDim2.fromOffset(16,56),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150",ZIndex=121},w)
	cr(av,32)
	N("TextLabel",{Size=UDim2.new(1,-100,0,22),Position=UDim2.fromOffset(92,56),Text=LP.DisplayName,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=121},w,"t")
	N("TextLabel",{Size=UDim2.new(1,-100,0,16),Position=UDim2.fromOffset(92,80),Text="@"..LP.Name,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=121},w,"dm")
	N("TextLabel",{Size=UDim2.new(1,-100,0,16),Position=UDim2.fromOffset(92,98),Text="Account age: "..tostring(LP.AccountAge).." days",TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=121},w,"dm")
	N("TextLabel",{Size=UDim2.new(1,-24,0,16),Position=UDim2.fromOffset(16,132),Text="Playing: "..game.Name,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=121},w,"dm")
	local bb=N("Frame",{Size=UDim2.new(1,-32,0,4),Position=UDim2.fromOffset(16,156),ZIndex=121},w,"inp") cr(bb,2)
	local bf=N("Frame",{Size=UDim2.new(0,0,1,0),ZIndex=122},bb,"a") cr(bf,2)
	tw(w,.35,{GroupTransparency=0})
	tw(sc,.45,{Scale=1},BACK)
	tw(bf,2.4,{Size=UDim2.new(1,0,1,0)},Enum.EasingStyle.Linear)
	task.delay(2.6,function()
		tw(w,.4,{GroupTransparency=1}) tw(sc,.4,{Scale=.9})
		task.delay(.45,function() w:Destroy() tw(mS,.5,{Scale=1},BACK) end)
	end)
end
-- ===== init =====
-- auto-pick the sleek font: use Jura if this executor/game has it, otherwise the first available
if not pcall(function() return Enum.Font[F.fn] end) then F.fn=FL[1] or "SourceSans" end
applyTheme(F.ui)
applyFont(F.fn)
setFx("None")
applyAcc(S.acc)
showKey(CURP or "Player/Main")
loadCfg(false)
task.wait(.8)
ldc:Disconnect()
tw(ldr,.35,{GroupTransparency=1})
task.delay(.4,function() ldr:Destroy() end)
if F.sa then saHook() end
F.ready=true
if F.welcome then showWelcome() else tw(mS,.5,{Scale=1},BACK) end
updBg()
dockUpd()
end)
if not ok then fail(err) end
