-- Backup files from home dir to: ~/Downloads/backups/

-- {...} (files)
-- 1 (full dir)

local backup_data = {
	['.bashrc']=1,
	['.ascii']=1,
	['.config'] = {
		['vivaldi/Default'] = {
			'mainmenu.json',
			'Bookmarks',
			'Notes',
			'Preferences',
			'Shortcuts'
		},
		geany=1,
		qimgv=1,
		dconf=1
	},
	Documents=1
}

--os.execute = print
for root_dir, root_dt in pairs(backup_data) do
	os.execute('mkdir ~/Downloads/backups')
	if type(root_dt) == 'table' then
		for dir, dt in pairs(root_dt) do
			os.execute(string.format(
				'mkdir -pv ~/Downloads/backups/%s/%s',
				root_dir, dir
			))

			if type(dt) == 'table' then
				for _, file in ipairs(dt) do
					os.execute(string.format(
						'cp -rpn ~/%s/%s/%s ~/Downloads/backups/%s/%s/',
						root_dir, dir, file, root_dir, dir
					))
				end

			else
				os.execute(string.format(
					'cp -rpn ~/%s/%s ~/Downloads/backups/%s/',
					root_dir, dir, root_dir
				))
			end
		end

	else
		os.execute(string.format(
			'cp -rpn ~/%s ~/Downloads/backups/',
			root_dir
		))
	end
end

os.execute('dir -a ~/Downloads/backups')
