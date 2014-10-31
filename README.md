Modular Maxscript Toolbar
==================================================
Just a simple maxscript set up which will allow for modular toolbar creation.
Tried to focus it on simplicity and do as much as it can with as little as possible.

I seem to make a douzen or so simple tools atleast with ever new project, 
so it just made sense to try and make an environment for easy mantainance
and scalability.

Just make a rollout file in the modules folder and when you load the toolbar 
it'll be there!


Use
=======
- git clone or download the zip
- run 3Ds Max
- drag the mainMenu.ms into your max window
- it should appear

If/when you want to add your own tools:
- make a new maxscript file in the modules folder
- create a rollout in the file
(best practice to keep it the same width as the toolbar)
- save and load up your mainMenu and if you don't get an
error you should see your new module in the menu


Still to come
=======
- procedural submenu based on a category variable in the modules
- responsive UI
- procedural moduls based on scripts found in the scripts folder

License
=======
MIT licensed, so you can do what you want with it, modifier, redistribut, what ever
credit/linking back is always appriciated :)

