-- Scripts to execute
local exec = {
	dawn = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'",
	dusk = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
}

-- Timers (by season):
local dawn, dusk
local function m()
	return tonumber(os.date('%m'))
end

if (m() >= 01) and (m() <= 03) then
	dawn = 08.30
	dusk = 16.30
	print 'Season: Winter'
end

if (m() >= 04) and (m() <= 06) then
	dawn = 06.30
	dusk = 18.30
	print 'Season: Spring'
end

if (m() >= 07) and (m() <= 09) then
	dawn = 05.30
	dusk = 21.30
	print 'Season: Summer'
end

if (m() >= 10) and (m() <= 12) then
	dawn = 07.30
	dusk = 19.30
	print 'Season: Autumn'
end

-- Calculation
local HM = tonumber(os.date('%H.%M'))
print(HM, dawn, dusk)

if (HM >= dawn) and (HM < dusk) then
	os.execute(exec.dawn)
	print 'Color Mode: Light (dawn)'
else
	os.execute(exec.dusk)
	print 'Color Mode: Dark (dusk)'
end
os.exit()
