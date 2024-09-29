-- Scripts to execute
local notify = 1 --Set to 1 or 0 to enable/disable desktop notification
local exec = {
	set = {
		light = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'",
		dark = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
	},
	get = 'gsettings get org.gnome.desktop.interface color-scheme',
	notif = 'notify-send "Theme Schedule" "Season: %s, Time: %s, Mode: %s"'
}

-- Get current theme
local cur, cur_f = nil, io.popen(exec.get)
cur = cur_f:read('*a')
cur_f:close()

-- Timers (by season):
local dawn, dusk, season
local function m()
	return tonumber(os.date('%m'))
end

if (m() == 12) or (m() <= 02) then
	dawn = 08.30
	dusk = 16.30
	season = 'Winter'
end

if (m() >= 03) and (m() <= 05) then
	dawn = 06.30
	dusk = 18.30
	season = 'Spring'
end

if (m() >= 06) and (m() <= 08) then
	dawn = 05.30
	dusk = 21.30
	season = 'Summer'
end

if (m() >= 9) and (m() <= 11) then
	dawn = 07.30
	dusk = 19.30
	season = 'Autumn'
end

-- Calculation
local HM = tonumber(os.date('%H.%M'))
print(season, HM, dawn, dusk)

if (HM >= dawn) and (HM < dusk) and cur:match('dark') then
	os.execute(exec.set.light)
	print 'Color Mode: Light (dawn)'
	if notify==1 then
		os.execute(string.format(exec.notif, season, HM, 'Light'))
	end

elseif (HM > dawn) and (HM >= dusk) and cur:match('light') then
	os.execute(exec.set.dark)
	print 'Color Mode: Dark (dusk)'
	if notify==1 then
		os.execute(string.format(exec.notif, season, HM, 'Dark'))
	end
end

os.exit()
