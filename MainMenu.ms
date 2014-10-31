/*
	Welcome to the modular maxscript menu!
*/

-- Check for existing instance and destroy it, genToolsMain modularMenu
try( 	cui.UnRegisterDialogbar modularMenu) catch()
if classOf ::modularMenu == RolloutClass do DestroyDialog ::modularMenu

/*

		Variables!
		
*/
	menuName = getFileNameFile (getThisScriptFilename())
	-- check for a folder specific to this menu in the users scripts folder, creates if nonexistant
	rootFolder = (getDir #userScripts) + "\\" + menuName
	if doesFileExist rootFolder != true do (	makeDir rootFolder	)
	preferencesIni = rootFolder + "\\" + menuName + "Preferences.ini" 
	rolloutIni = rootFolder + "\\RolloutPreferences.ini"
		
	-- get the folder this script is in
	scriptFolder = getFileNamePath (getThisScriptFilename())
	sourceFolder = scriptFolder + "source\\"
	modulesFolder = "modules\\"
	
	-- some empty arrays and variables needed for the menu
	modules = #()
	modulesDir = #()
	subMenuBuffer = 60
	bottomBtnHeight = 26
	
	-- height and width are arbitrary but by default width is similar to the width of the max side menus
	menuWidth = 184
	menuHeight = 760

 /*
		Main Menu!
*/

rollout modularMenu "Modular Menu" width:menuWidth height:menuHeight
(
	--- Main UI
	ImgTag mainLogo "" pos:[0,0] bitmap:(BitMap menuWidth 20)
	checkbutton chbShowA "cat a" pos:[32,32] width:53 height:21 checked:true across:2
	checkbutton chbShowB "cat b" pos:[88,32] width:53 height:21 checked:false
	subRollout roSubA "" pos:[0,56] width:menuWidth height:(menuHeight - 50)
	subRollout roSubB "" pos:[0,56] width:menuWidth height:(menuHeight - 50) visible:false
	button prefsbtn "Preferences" pos:[160,32] width:22 height:20 images:#("source/Images/Pref_Icons.bmp", "undefined", 2, 1, 2, 1, 1)
	--- Functions
	fn repositionUI =
	(
		-- repositions the sub rollouts heights to fill the menu, also if you have bottom aligned buttons use this funt to stick to the bottom
		roSubA.height = menuHeight - subMenuBuffer
		roSubB.height = menuHeight - subMenuBuffer
	)
	on modularMenu open do
	(		
		mainLogo.bitmap = (openBitmap (sourceFolder + "/Images/header.bmp"))
		repositionUI()
		
		-- gets all the maxscript files in the modules directory and loops through them
		modulesDir = getFiles (sourceFolder + modulesFolder + "*.ms")
		for i in modulesDir do
		(
			-- fileIn's the only real option, 'include' will not take anything other than a string literal
			fileIn i
			rolloutName = getFilenameFile i
			append modules (rolloutName as string)
			
			-- more intergration or catagories/different menus will come but for now if a module file has
			--  a category of "GT_Export" it will be on the second menu
			try(a = (execute rolloutName).cat)catch()
			if a == "GT_Export" then
			(
				AddSubRollout modularMenu.roSubB (execute rolloutName)
			)
			else
			(
				AddSubRollout modularMenu.roSubA (execute rolloutName)
			)
			
			-- the modules have persistant rolled up state saved to an ini file when the menu closes
			rolled = getIniSetting rolloutIni rolloutName "rolledUp" 
			if rolled != "" then
			(
				(execute rolloutName).open = rolled as booleanClass
			)
			else
			(
				-- if no state is found closed is the default state, change this to true if you want them open by default
				(execute rolloutName).open = false
			)
		)
		format "modules : %\n" modules
	)
	on modularMenu close do
	(
		for i in modules do
		(
			setIniSetting rolloutIni i "rolledUp" ((execute i).open as string)
		)
	)
	
	on modularMenu resized size do
	(
		menuHeight = size.y
		repositionUI()
	)

	-- the menu will contain procedural menus but for now it just has two, below handels the switching between the two
	on chbShowA changed state do
	(
		chbShowB.state = not state
		modularMenu.roSubA.visible = state
		modularMenu.roSubB.visible = not state
	)
	on chbShowB changed state do
	(
		chbShowA.state = not state
		modularMenu.roSubA.visible = not state
		modularMenu.roSubB.visible = state
	)
	
	-- this will have a prefrences pannel but for now the prefs button just rolls up all the modules
	on prefsbtn pressed do
	(
		for i in modules do
		(
			(execute i).open = false
		)
	)
)


/*
		Generate the Dialog!
*/

-- below handels the creation of the rollout, it's dockable and resizable by default
-- the default max height is the height of the users screen, you can change this to an arbitrary value 
createDialog modularMenu menuWidth  style:#(#style_toolwindow, #style_sysmenu, #style_minimizebox)
cui.RegisterDialogBar modularMenu style:#(#cui_dock_vert, #cui_floatable, #cui_handels) minSize:[menuWidth, 350] maxSize:[menuWidth,systemTools.GetScreenHeight() ]
