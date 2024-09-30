local root = {'/media/Pixiv', '~/Downloads/Pixiv_new'}
local session_start = os.date()
print 'Pixiv artwork batch tagging script'
print(os.date('%A %d, %B (%m) - %H:%M:%S'))
print '\nWhen entering id only, start it with "/" (slash)'
print 'Tags are written as plain words separated by whitespaces'
print '(Leave id or tags field empty to exit)\n'

print [[Write down meta tags to prevent this script from
prompting required tags for each image, or leave that field empty
]]

print 'Meta tags: '
local m_tags = io.read()
local m_tagset = {}
for tag in m_tags:gmatch('[%a%d%p]+') do
	table.insert(m_tagset, '-keywords+='..tag)
end
m_tags = table.concat(m_tagset, ' ')
m_tagset = nil

--os.execute = print

local function loop()
	print 'Pixiv id or link:'
	local id = io.read():match('.*/(%d+)')
	if not id then return end

	-- Set tags
	local tags
	if (not m_tags) or (m_tags == '') then
		io.write 'Tags: '
		tags = io.read()
		if (not tags) or (tags == '') then
			return
		end

		local tagset = {}
		for tag in tags:gmatch('[%a%d%p]+') do
			table.insert(tagset, '-keywords+='..tag)
		end
		tags = table.concat(tagset, ' ')
	else
		tags = m_tags
	end

	-- Get image(s); find tags; apply tags
	for _, path in ipairs(root) do
		local get = io.popen(string.format(
			'find %s -type f -name "%s*"',
			path, id
		))
		local img = get:read('*a') or ''
		get:close()

		if img:match(id) then
			img = img:match('/[%a%d%p]+')

			local get_tags = io.popen('exiftool -q -m -P '..img..' -p \'$keywords\'')
			local tags_found = get_tags:read('*a')
			get_tags:close()

			if tags_found and (tags_found ~= '') and (tags_found ~= '\n') then
				print '\nThis image contains tags:'
				print('	'..tags_found..'Proceed? (N/y)')
				local answer = io.read()

				if answer == 'y' then
					os.execute(string.format(
						'exiftool -P -overwrite_original %s $(readlink -f %s)',
						tags, img
					))
				end
			else
				os.execute(string.format(
					'exiftool -P -overwrite_original %s $(readlink -f %s)',
					tags, img
				))
			end
		end
	end

	print(''); loop()
end

loop()
os.exit()
