# Introduction #

Awesomeguy is a computer game originally developed for another hand held game system that I am attempting to port to the Android platform.

# Details #

The format of the Awesomeguy game is that of a simple platform game, in some ways like the original “Donkey Kong” or “Super Mario Brothers”. The Nintendo DS version has two screens of 192x256 pixels each. During gameplay one of the screens was generally used as a splash screen. The game also makes use of four directional keys and two special keys -- one of which is the 'jump' key. [top](Awesomeguy#Introduction.md)

The android phone that the game was developed for had no "D-pad". For the android version, two separate View objects were required during regular game play. One View was for display of the game screen, the equivalent of the main screen from the Nintendo game, and the other View was the emulated "D-pad". The "D-pad" was emulated using TouchButtons on the touch screen and also an alternative where movement instructions were taken from the trackball. The DS version of the game uses several large int arrays for keeping track of the appearance of each level in the game. In order to port the levels to the android version, the same sort of array was used in the android code. In this way the android version can use the exact same level definition info. The android version also uses an ArrayList to keep track of sprite data, though sprites are not hardware supported in java. One ArrayList is used for all types of sprites. The DS version makes use of a set of four tiles that are used to paint the levels from the predefined level array on the game screen. The same tile set was used in the android version, but software was used to emulate the DS's hardware tiling system. For these reasons the android version of the game is slower to play than the homebrew DS version.

### Tilesheets ###

Tilesheets are very important to the Awesomeguy game. Tilesheets do not exist natively in the Java language, so they must be simulated for the Android phone using code. The basic concept behind tilesheets is complex. A tilesheet is made up of many 8x8 squares. Each square is referred to as a tile. The tilesheet itself can contain many hundreds of tiles. The game uses the tilesheet to draw the background that the user sees as they play the game. Rather than paint a different background for each level, a map is used. The map is a matrix, and each number in this 2D matrix represents an 8x8 tile from the tilesheet.

This cuts down on memory usage. Rather than save to a file the entire drawing of the background of some level, the programmer saves the matrix, or map, which is smaller but represents the same picture. The game system on which the Awesomeguy game was developed used a tilesheet/map system similar to the one described, only it was implemented on the hardware level. In order to make Awesomeguy look exactly like the original, the tilesheets from the original game were copied and imported to the Android app, and the tiling system was emulated in software.

Awesomeguy uses two map arrays for each level, and it uses four tile sheets. The tilesheets are shared by all levels of the game, and they are nearly identical.

The first map array holds a definition for the background of the level that is much the same as the one discussed above. This is a map of the visible background of the level that's being played. The second map array is identical in size to the first one. It holds information about what each picture in the other map means to the program and the character. Where the first map shows a solid wall, the second map holds a number that tells the program that the character may not pass through it. Walls in the first array can be many colors and patterns as chosen from the tilesheet, but in the second array, just one number corresponds to all wall objects. The first array is visible while the second array is never seen. The first array is referred to as the 'level' or 'tile' array, and the second array is referred to as the 'objects' array. Remember, the two arrays are always the same size.

The way the four tilesheets work is relatively simple. They are identical in size and content except for the images imbedded in the tilesheet of the rings. The rings are prizes in the game and when you get one you get points. There are four tilesheets so that the rings can be animated and made to look like they are turning. The difference in the ring images is the only difference in the four tilesheets. To make the rings look like they are moving the tilesheets are swapped during game play. This swapping happens in the  JNI functions.  [top](Awesomeguy#Introduction.md)

### Tilemaps ###

Another important component in the Awesomeguy game is the set of map arrays collectively known as tilemaps. These large 2 dimensional arrays contain the data that is used to decide what gets painted on the background screen and where it gets painted. The tilesheets are divided up into 8x8 squares. Every square gets a number, and those numbers populate the tilemaps. One of the tilemap's indexes represents the x axis, and another represents the y axis. The matrix then can cover a 2D plane with values. If the programmer wants to put a ladder in the upper left hand corner, he or she takes a 8x8 square representing a ladder from the tilesheet and places it in the tilemap at the location with the 0,0 indexes. The screen is defined this way, so that the upper-right has high x values and low y values, the lower-left has high y values and low x values, and the lower-right has both high x and y values. This reflects the numbering of pixels on a computer screen, but in this model each pixel is a complete tile from the tilesheet.

Tilesheets are not numbered with two indexes. Tilesheet 8x8 squares are numbered with a single index. For this reason it's difficult to change the size of a tilesheet once it has been established. A tilesheet containing 8x8 squares in a pattern of 3 tiles by 5 tiles would have tiles numbered 0 to 14. A tilemap element contains one of these numbers. One number typically represents 'nothing' or 'no contents', while another number might represent a solid object (like a wall) and another number might symbolize the tile that contains the image for a ladder.

For Awesomeguy there are two identical tilemaps. One holds all the information mentioned above. It holds designations for where to place tiles that show images of walls and ladders and floors. The second tilemap holds extra information that the game needs. This info includes the starting location of the main character, the starting location of each monster, further information about the location of walls and floors, the location of floating platforms, and the location of all the rings and prizes on the level. It holds the code for the checkpoint character and the level goal character and also the code for a special tile that causes instant death when it is touched. The two tilemaps are called the 'level' tilemap and the 'object' tilemap. They are exactly the same size, and an element at a certain x/y location on one map refers to the same spot on the screen as that x/y location on the other map. The two maps can be laid on top of each other.

The reason for two maps is so that one map, the 'level' map, can be responsible for drawing the image of the background, while the other map, the 'object' map, is responsible for telling the program how to treat that particular set of elements. Only some of the 'object' map elements result in an actual object being drawn on the screen. Rings, for example, are drawn on the screen until the player gets them. Similarly, not all 'level' objects are solid objects. Some, like some of the pillars, are only for outward appearances. [top](Awesomeguy#Introduction.md)

### Sprites ###

Aside from the tilesheets and tilemaps described above, the game uses several sprite images. For these images small 'png' files were used. There are four images of the main character and two images of the monster for each direction. That means four monster images in total, two left and two right. The multiple images are used to animate the main character and the monsters. Each of the 'png' images has an alpha channel (a transparent area) and is indexed to a 256 color palette. The size of the images is unimportant on the android phone, but for the Nintendo DS it was dictated by the hardware. For this reason the monster sprite uses only the top half of the png image, which is 16 pixels by 16 pixels. The main character is also 16 x 16, but it uses the space more evenly. [top](Awesomeguy#Introduction.md)

### Software Tools ###

Several pieces of software were used when making Awesomeguy. Awesomeguy was programmed on a Linux computer. The graphic images in the game were all edited on Gimp, the Gnome Image Manipulation Program. The source code for Awesomeguy was edited using the Eclipse IDE for java. The C library used for the Awesomeguy Java Native Interface (JNI) was edited using Gedit, a Gnome text editor. The tilemaps, the large arrays that define the appearance of each level, were edited first using a Windows program called 'Mappy', and then further edited using Gedit and the command line tool 'sed'. The Wine (Wine Is Not An Emulator) program loader was employed to allow Mappy to work on a Linux platform. Instructions for using Mappy to create level definitions will accompany this document. [top](Awesomeguy#Introduction.md)


---


# AndroidManifest xml #

The AndroidManifest.xml file has entries for each of the game's activities. In the xml entry for the SplashScreen activity, the values for 'clearTaskOnLaunch' are set to 'true', and the values for 'launchMode' are set to 'singleTask'. This arrangement is shown in the following snippet. The 'clearTaskOnLaunch' option is what allows the game to always restart with the Splash Screen regardless of what state it was in when it was stopped. This option was used in each of the activities in the xml file.

```
<activity android:name=".SplashScreen"
android:label="@string/app_name"
android:clearTaskOnLaunch="true"
android:launchMode="singleTask">
```

For each of the activities of the application I put 'clearTaskOnLaunch' as one of the xml parameters (as noted above).

```
<activity android:name=".Menu"
android:clearTaskOnLaunch="true">
```


# SplashScreen java #

When the game starts the user is presented with a splash screen that dismisses itself when the user presses the screen or when a certain amount of time has passed. The splash screen activity performs certain tasks when it displays. One thing that it does is initializing the database that holds the player scores. It also creates a new blank player record for storing high scores and user preferences. (It doesn't give this new record a user name -- that's saved for if the user decides to do so). Then it sets the default starting level to '1'. This way if the game is started without the user expressing their preference, the starting room number will be '1'.  [top](Awesomeguy#Introduction.md)

# Menu java #

The next thing that the user sees is a menu. This menu allows the user to view a 'help' or 'credits' file, enter 'options' that effect game play and the way scores are saved, go to a 'players' selection screen, or simply 'play game'.  The last option forwards the user to the actual game. Each of the options on the menu launches another android Activity. The AndroidManifest.xml file is set up to ensure that the game starts over at the splash screen whenever it exits normally.   [top](Awesomeguy#Introduction.md)



# GameStart java #

Game play is handled by the GameStart.java activity. The first thing that happens in the activity is that the screen is drawn. Layout of the screen is handled using code and not an xml file. The screen is roughly divided into two sections. There is a top panel for the actual display of the game while the user is playing, and there is the area below the top screen which is where buttons appear for controlling the movement of the game's main character. The top screen is an instantiation of a Panel.java class, which is a SurfaceView. Layout elements are all assembled in the 'onCreate()' method of the GameStart activity. One of the first things that's done when assembling the Views on the screen is to measure the size of the display. This is done with code like this:

```
Display display = ((WindowManager) getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();    	
int mDimension = display.getWidth();
```

### GamePad ###

The width dimension is used to size the game screen and the touch buttons. A separate inner class is used to construct the touch button part of the screen. This class is called 'GamePad' and it returns an entire TableLayout already filled with all the necessary buttons. Two types of buttons are used, one called a BlankButton and one called a TouchButton. Both kinds of buttons are inner classes in the GameStart.java file, and they both extend the android 'Button' type. The TouchButton also implements the 'View.OnTouchListener' interface, which allows the program to respond to user input.   [top](Awesomeguy#Introduction.md)

### onPause() ###

The 'onPause()' method of the GameStart.java activity waits for the game loop to exit. The 'onPause()' method sends a message to the InnerGameLoop thread to exit all loops, and then the 'join()' command waits for the thread to finish. It also saves the high scores for the current player to the high score database.  [top](Awesomeguy#Introduction.md)

### onResume() ###

The 'onResume()' method of the GameStart.java activity begins by retrieving from the SharedPreferences the user record for the current user. This is so that if the user made changes to their game play experience using the 'Players' menu or the 'Options' menu, then those changes could be referenced in the 'GameStart' activity. The method 'onResume()' also finishes the job of building the game controls and adding them to the View that the game is displayed in. It also starts a separate thread called the InnerGameLoop. This Thread is a inner java class which is found in the body of the GameStart class. It is used to help process user input and direct the SurfaceView to refresh when it is necessary. The 'onResume()' method also instantiates a new InitBackground.java class. This class loads the definition information for each new level. Info about the shape of each level and the placement of various objects in the game (like rings and lives) are loaded in this object. [top](Awesomeguy#Introduction.md)

### TouchButton ###

Next in the GameStart.java class is the inner class that describes the object called TouchButton. The TouchButton extends the regular android Button class and is used in the 'getGamePad( int x )' method when the game's movement and jump buttons are created. Five times this variant of the android Button class is used. The TouchButton class implements 'View.onTouchListener', which allows the buttons to detect pressure from the touch screen. The touch buttons use the MotionEvent.ACTION\_DOWN and MotionEvent.ACTION\_UP constants in the 'onTouch()' method to detect key presses. Then the value for the key (up, down, left, right, etc.) is passed to the functions that process this key input, functions that are part of the MovementValues and the Panel classes respectively.

There is one particularly useful constructor in the TouchButton class. There are seven parameters to the constructor. They set the button's context, background resource, width, and height. They also set the values in the TouchButton that show which 'direction' the button represents (a constant for up, down, left, right, and B) and an optional string that can be used for identification purposes. The TouchButton is also set up to receive input from the trackball. All TouchButton buttons are listening for trackball input. The code to include trackball input is incorporated in the 'View.OnKeyListener()' object, which is an anonymous class in the TouchButton constructor code.  [top](Awesomeguy#Introduction.md)

### BlankButton ###

Another inner class in the GameStart.java file is the 'BlankButton'. This button is the same height and width of the TouchButton, but has no event listeners. It's used to fill in the spaces between the more important TouchButtons in 'getGamePad(int num)'  [top](Awesomeguy#Introduction.md)

### mHandler ###

Next in the GameStart.java class is the inner class defining the Handler 'mHandler'. This class sets up a queue for processing events in the program. It's especially useful for updating the Panels that contain the graphical information for the game. These panels can only be updated from the thread that started them, so the InnerGameLoop thread, described below, can only request that the screen be redrawn by using this queue device as it exists in a separate thread. Message objects are sent by different classes in the application to the Handler, which puts each message on the queue -- usually in the order they were recieved. Types of messages are defined as static final ints at the beginning of the GameStart class. It also has a use when we are trying to launch an AlertDialog from inside the InnerGameLoop. This too can only be done from the original thread of the GameStart activity. [top](Awesomeguy#Introduction.md)

### InnerGameLoop ###

The last complete class in the GameStart class is the InnerGameLoop class. This is an inner class extending a Thread. The 'run()' method contains the code that allows for progress in the game during game play.

The 'run()' method starts by initializing some values and instantiating some classes that are used later in the game. Then it starts a loop that executes as long as the game continues to be played. This 'play again' loop allows the user to automatically return to the beginning of the game when and if they run out of lives. This loop sets the starting level to '1' usually. (Normal game play starts with room 1, but a different starting room can be specified in the Options activity.) The 'run()' method records the value of the players previous score, then it sets the score of the current player to '10' since all games start with that score. The old score is remembered so that we can later tell if the player has beat their old score when  the game is over. Then we can save their new high score in the database table for high scores.

Then the 'run()' method starts another loop that is responsible for advancing the player to the next level as the player completes the level that they are at. This loop allows the player to replay a level when they fail (die) if they have at least one life left. If they have no lives left the loop does not advance the player to the next level, but instead passes them over to the code at the end of the game (which tallies scores and checks to see if the player belongs on the high score table). Code in this loop also calls code responsible for initializing the level and placing all the objects and obstacles for a given level in the array that the graphics panel uses for displaying such things.

Another loop, inside the two mentioned above, is responsible for processing the actual user input and screen redrawing. This is the actual 'game play' loop. Every time through this loop a signal in the form of a Message is sent to the Handler, where the SurfaceView with the main game graphics in it is refreshed. This refreshing is done by the 'invalidate()' method, which must be called on that SurfaceView object from the Handler. In this loop is also a call to a game speed regulating function.

After the two inner loops exit, the program determines weather or not a player wants to continue playing, or weather they want to stop playing using an AlertDialog. If the second option is chosen, the alert dialog directs the user to another screen (not the GameStart activity) using an Intent. Otherwise, the program loops to the beginning of the first while statement. The three loop statements incorporate a boolean variable that, when set to true allows for the loops to continue, and when set to false exits the three loops. This is so that the game can be exited cleanly when the activity is quitting.

The InnerGameLoop class has two other methods. One is a public method called 'setGameRunning()' which sets the boolean described above that allows the various loops in the thread to exit. The other method is called 'gameSpeedRegualtor()' which is used to make sure that the periodic invalidate messages from the 'game play' loop are not issued too frequently. [top](Awesomeguy#Introduction.md)

### getSavedRoom() / saveRoom() ###

Two methods in the GameStart.java file which are used by the 'onPause()' and 'onResume()' methods are 'saveRoomNo()' and 'getSavedRoom()'. These methods use the SharedPreferences android class to save the last room/level played by the user. They also load the room/level value from SharedPreferences for use in game play. As mentioned above, the desired starting level can be set in the Options activity. These two methods are not part of the InnerGameLoop class.

### getLevelList() ###

This method uses the ParseXML class from the InitBackground.java file to create an ArrayList of the levels in the awesomeguy.xml file. It calls setXmlPullParser() and then getXmlList() in succession. It returns the ArrayList that contains the ID numbers of the levels in the order that they must be used to advance through the game. It is nearly identical to the function of the same name found in the Options.java file.

### onCreateDialog() ###

The last part of GameStart.java, aside from some simple setters and getters, is the 'onCreateDialog(int id)' function. This is where the AlertDialog that asks the user if they want to continue playing the game is.

# InitBackground java #

This class contains all the information needed to make a map that the Panel.java class uses to display the successive levels. The levels consist of a set of two dimensional arrays of 96x96 elements each.  One array is called the 'level' array and the other array is called the 'objects' array. The 'level' array defines the appearance of the background while the 'objects' array defines the how the game interprets solid objects and other objects like 'goals' and 'prizes'. The 'objects' array also describes the starting position of the player and all of the monsters.

Awesomeguy uses a tile system to display the different levels in the game. A tileset is loaded into the game at startup. The tileset is cut apart by the JNI in the Panel into 8x8 pixel squares. The squares are then placed on the screen in a pattern that is dictated by the 'level' array from the InitBackground class. This is how the appearance of every level is established. At the same time the second array, the 'objects' array, designates how each 8x8 square is treated by the game. This makes it possible to define 'solid' objects like walls and platforms. A square in the 'objects' array can be solid, or not solid. It can be a ladder, a prize (giving the player points), a goal (to advance to the next level), or a checkpoint (to mark how many levels the player has conquered). The array also holds the information for where all the monsters on the level are when the level starts, and the starting location of the player. The tile arrays can be a maximum of 96x96, and a position on one array directly coincides with the same position on the other array. Position (5,3) on the 'level' array holds information that is paired with position (5,3) on the 'objects' array. Each set of 'level' and 'object' arrays defines a complete Awesomeguy level. The arrays can be smaller than 96x96.

The arrays themselves can be created with a program called 'Mappy' that can be run on the Windows platform or on WINE if you are using Mac or Linux. Details for using Mappy are beyond the scope of this document, but essentially the Mappy program has a graphical editor where you can design the contents of the Awesomeguy level, and then you can output the two arrays to a text file in a C like format.

To include the arrays in the InitBackground.java class you edit the text file slightly and then copy and paste the array into the java xml file called awesomeguy.xml. Code to read the arrays from the xml file is located in the InitBackground.java file, along with the methods to decode the xml into the integer arrays that are required by the game. The xml file is located in the folder 'xml' that can be found in the project's 'res' folder.

The constructor takes a 'GameValues' object as a parameter. It also instantiates a 'ParseXML' object. The 'ParseXML' object is used later to extract the game information from the xml file.  In total there are four classes in the InitBackground.java file. One is InitBackground itself. Another is the ParseXML class. The last two are the LevelList class and the LevelData class. LevelList is just an ArrayList of LevelData objects, as described below.  [top](Awesomeguy#Introduction.md)

### initLevel() ###

The first method in the InitBackground class is the constructor. The second method is the 'initLevel()' method. This method is called after the two arrays have been established. The method first determines the starting point of the player by going through all the cells in the 'objects' table. Then the method determines the starting point of each of the monsters that might be on the level. As it finds these starting locations it adds each one to the ArrayList that has been set aside for sprites. This ArrayList is located in the GameValues object. It does the same for the floating platforms. The last thing that this method does is to call the function 'setStartingScrollPosition()'.  [top](Awesomeguy#Introduction.md)

### setStartingScrollPosition() ###

The next method is 'setStartingScrollPosition()' and it's job is to set the x and y scroll variables to their correct starting positions reflecting where the player actually starts from. The player cannot be off the screen when the level starts. If the player starts in the upper left-hand corner, as in the first level, then this function does nothing. If the player starts in the lower right hand of the level, as in the third level, then the function scrolls the background so that the player is visible when the game starts. [top](Awesomeguy#Introduction.md)

### setLevel() ###

The next method in the class is called 'setLevel(int num)' and it takes an int as a parameter. The 'setLevel(int num)' function calls the xml parser and passes to the parser the num variable, which represents the level that the game requires next. The setLevel(int num) function is called before every level, and it's job is to pass the desired level number to the xml parser.

Sometimes we want the xml parser to look to the sdcard for the awesomeguy.xml file. If this is the case it is also possible that the awesomeguy.xml file isn't there, or that some other problem comes up while the file is being looked for. For this reason the xml parser function that looks for the xml can be called twice. If the first try with the parser fails, the parser function is run again. The second time it only checks the xml file that ships with the program. This way it is sure to find some xml file when it's time to play the game.  [top](Awesomeguy#Introduction.md)

### ParseXML ###

This is the Class in InitBackground that is responsible for finding the xml file that the program uses and also parsing it and extracting the important array information. It also has a method for creating a list of the contents of an xml file, so that the game program and the user can choose what level they want to play.

### setXmlPullParser() ###

This method takes as a parameter a boolean called mLookForXml. It returns a boolean which is true on success. The method has a central if() statement. When the mLookForXml variable is false the 'setXmlPullParser()' method sets up the ParseXML class to read all subsequent data from the game's internal xml resource. When the mLookForXml variable is true it sets up the class to read all subsequent data from the root directory of the sdcard. [top](Awesomeguy#Introduction.md)

### getXmlList() ###

This function returns the LevelList that the Options.java activity uses for displaying the various levels available, and returns that list from whatever xml resource the ParseXML class is set up to read from. It doesn't read the array information, so that info could be corrupt or even missing and the xml's list of levels would still show up on the Options.java page. This function is also used by the GameStart.java file to reconstruct the list for the purposes of advancing through the different levels as the player finishes each one.

### parseLevelXml() ###

The xml parser method -- parseLevelXml(int num) -- takes the contents of the two arrays that are defined in the xml of the application and copies them to the area in the 'GameValues' object where all other parts of the program will look for that info during actual game play. The method uses 'if()' statements and 'while()' loops. Together they navigate through the xml and produce two strings of comma separated values. One string is for the visual information (called the mTiles String for this function) and one string is for the object information (called the mObjects String for this function). The two strings of comma separated values must contain exactly the same number of integers.

Then the xml parsing program uses a java StringTokenizer to convert the comma separated values to the arrays used by the game.  [top](Awesomeguy#Introduction.md)

### LevelList and LevelData ###

LevelList is an inner class used to construct an ArrayList of objects for the xml parsing function 'getXmlList()' to return. It has a method to add an object to the list, to return an ArrayList of Strings from the list, to return the size of the list and to return the number portion of a given indexed entry on the list.

The object that the LevelList class is meant to work with is the LevelData class. It too is an inner class in InitBackground, and it is composed of two public data members. One member is a String called mText, and one member is an Ineger called mNum.

The ArrayList of String elements returned by LevelList is used in the Options.java page. There it is converted to a regular array, and is passed to the ArrayAdapter in it's constructor. There it is used as the text that goes on the Spinner's dropdown menu. The method that converts the ArrayList of Strings to a regular array is part of the standard ArrayList, called 'toArray()'.

# GameValues java #

This class is mostly for holding variables that are used throughout the program that need to be in a central place and somewhat organized. It contains the two 2D arrays, 'level' and 'objects'. It also contains two variables that allow the game to function if the 2D arrays are smaller than 96x96. It contains constants for every kind of object that could be defined in the 'objects' array. It contains game progress variables, like 'room' for current room number, and booleans for weather the level is over or the game is over. It also contains the ArrayList for sprites, like the monsters, in the game. Most of the rest of the class is filled with setters and getters for these variables.  [top](Awesomeguy#Introduction.md)

# MovementValues java #

This class contains variables used for determining the movement of the main character from the input collected from the user. This input could be in the form of button presses on the screen or in some cases movement of the android trackball. It also holds the values of the scrollx and scrolly variables. Most of the class is made up of setters and getters, but there are two methods worth explaining. The 'getDirectionLR()' method returns a value for the user's input that eliminates the possibility that the 'left' and 'right' keys could be pressed at the same time. When the two keys are pressed together they cancel each other out. The method 'getDirectionUD()' works the same way for 'up' and 'down' keys. The class is also supposed to make it easier for the programmer to increase the distance that the player's character moves after a single button press. The default is three pixels, but conceivably this could be changed to another number easily. Trial and error would determine the final value.  [top](Awesomeguy#Introduction.md)

# SpriteInfo java #

The array list in the GameValues class that stores sprite information is populated with SpriteInfo objects. The SpriteInfo class contains information that might be useful to any part of the game that might want to display a sprite. Some of the info that's available in this class isn't used by all the sprites. The class is mostly filled with private int and boolean members and the setters and getters that are used to access them. The only special methods in the class are those that not only set the sprite info, but also increment or decrement it as well. The data members include resource ID, x and y position, width and height (not to be confused with BoundingBox), position on the screen, the sprite's true bounding box info, variables for weather or not the sprite is jumping and/or is animated. Also weather the sprite is 'facing right', weather it's visible, weather it's 'active' and what it's animation index is. [top](Awesomeguy#Introduction.md)

# BoundingBox java #

BoundingBox.java has data and variables that help the game display and work with sprites. It contains private variables for the x and y location of the sprite in question, as well as variables called 'left', 'right', 'top', and 'bottom'. These values are ints and they define the portion of the printed sprite that's considered when the sprite is checked for collision with an object on the screen. This would be important when the player comes into contact with a ladder or a platform, for example. The bounding box of the sprite is defined by these four variables.

A simple constructor defines a default BoundingBox that has zero in all it's data members. Another constructor gives values to the four important data members (leaving the x and y as zero).  [top](Awesomeguy#Introduction.md)

### makeSpriteBox() ###

The next method in the class is a BoundingBox factory called 'makeSpriteBox()'. It takes a 'SpriteInfo' object as one input variable, and an x and y value as the other two. It is assumed for this method that Sprites can have various different dimensions depending on what kind of object they are. In practice, only the player's object is used by this factory.

### makeBlockBox() ###

This is followed by another BoundingBox factory called 'makeBlockBox()'. It only takes x and y as inputs, because we can assume that all blocks have the same dimensions and the same bounding box, 8x8.

### collisionSimple() ###

The next three methods are used to check weather one bounding box is actually in collision with another. This would happen if the two boxes touched or overlapped. That is what the three methods test. They are named 'collisionSimple(BoundingBox a)', 'collitionSimple(BoundingBox a, BoundingBox b)', and 'collisionHelper(BoundingBox a, BoundingBox b)'. One is a convenience function, one is a helper function. Therefore there is essentially only one method that actually does collision detection, the version 'collisionSimple(BoundingBox a, BoundingBox b)'. [top](Awesomeguy#Introduction.md)

### getCenterBlock() ###

The last function of substance in the BoundingBox file is one called 'getCenterBlock(BoundingBox a)'. This function returns the int that is associated with the block that is directly in the center of the BoundingBox specified. It is used to find the block directly below the player during game play. The screen coordinates and the map coordinates are not the same, and the difference between the two needs to be addressed. The player's coordinates are 8 times bigger than the player's position on the map. The player also has dimensions that are stored in it's bounding box, and these have to be considered when you try to determine weather the player is standing on a block, for example. The rest of the file is filled with setters and getters for the various private integers in the class. [top](Awesomeguy#Introduction.md)

# Panel java #

When the game is being played, one instance of the Panel.java class is displayed on the android screen. The top screen always displays the level of the game that is being played. The Panel.java class is a SurfaceView, and a SurfaceView is an extended View. Views are the basic building blocks of user interfaces in android apps. They are used to hold text, buttons, and other user interface items but they also have an 'onDraw(...)' method for drawing 2D graphics in their borders. SurfaceViews have the same 'onDraw(...)' method. In the SurfaceView 'onDraw(...)' method is a Canvas object, which is important for doing this drawing.

Awesomeguy originally used two separate methods for drawing the game's graphics on the screen. With one method the game used pure Java to draw it's components. With the other method the game used a special C library, called a JNI library. JNI stands for "Java Native Interface". The JNI code will be discussed later. Because of speed considerations the purely Java graphics engine for Awesomeguy was removed and only the JNI version was retained.  [top](Awesomeguy#Introduction.md)

### Drawing ###

In this game when graphics were being displayed by Java we used the Canvas 'drawBitmap(...)' function repeatedly inside the 'onDraw()' method. Each of the tiles we put on the screen and also each of the sprite images uses the 'drawBitmap(...)' function. This was very slow. A View also has a 'scrollTo(...)' method that allows the drawing being done to be scrolled inside the boundaries of the View. This is inherited by the SurfaceView and is used by the game's Panel class. When we are using JNI functions to display the game's graphics, the program uses 'drawBitmap(...)' and 'scrollTo(...)' much less. It uses 'drawBitmap(...)' once for every time the screen is refreshed. The JNI code loads the game's graphics when the Panel class is instantiating, not during game play. In the JNI the graphic images, in the form of arrays, are copied to an area of memory that represents the game screen. Then, once in every refresh, the screen array is converted to a bitmap and printed in it's entirety to the game screen where the player can see it. This is an improvement over the Java version that drew to the screen hundreds of small bitmaps to make the final visible game screen. The JNI code will be discussed in detail later.

During the GameStart Activity there is always a Panel on the screen that is displaying the game's graphics. When the panel is invalidated by the GameStart code, the screen is re-drawn and the game takes into account all the changes that have happened during the period of inactivity. One of the main roles of the GameStart code is just to invalidate the Panel class. If this loop of invalidation happens quickly enough the game's elements seem to be animated. Invalidating the Panel cannot be done from a thread that did not start the Panel - android will return an error on the debugger console and the program will quit. This is why the GameStart Activity contains a 'mHandler'. This is a device provided by the android operating system for updating the Panel without being in it's thread. It is a queue.  [top](Awesomeguy#Introduction.md)

### Panel() Constructor ###

The first method in the Panel class is the constructor. In the constructor we pass six items. The first is a Context object, which we immediately 'super' to the default constructor with the line 'super(context);'. The next item passed in the constructor is a reference to the GameValues object, which stores the 'level' and 'object' arrays, as well as the ArrayList for the SpriteInfo objects. The next thing in the constructor signature is a reference to the GameStart object, which is the Panel's parent. The next thing in the constructor signature is the MovementValues object, which holds all info collected from the user about where he or she would like the game's character to move. Finally the Record of the current user (their high scores, etc.) and the screen display width are passed in the constructor. Inside the constructor several variables are initialized, including several Bitmap objects, a Paint object, and the initial values of the scroll variables. The arrays for the JNI code that hold the data from the various bitmaps are loaded here. The array data is also passed to the JNI library here.  [top](Awesomeguy#Introduction.md)

### onDraw() ###

The second method in the Panel class is the 'onDraw(...)' method. The method takes one parameter, the Canvas object for the SurfaceView class, which the android system passes to the function automatically. The programer must override the 'onDraw(...)' method, using the canvas supplied by the android OS to draw the content that he or she desires.

The 'onDraw(...)' method proceeds to draw the game info. First it passes the current 'score' and 'lives' values to the JNI library with a method called 'setScoreLives(...)'. Then it calls four functions. The four calls are 'checkRegularCollision()', 'checkPhysicsAdjustments()', 'collisionWithMonsters()' and 'scrollBg()'. These four methods are somewhat self explanatory, but they will be described in the section below. Essentially they figure out where the character is on the level, and if he's encountered any obstacles. As a result the GameValues values represent the new position of the character and the new position of the background.

Next the 'animateItems()' function is called. This function is part of the Panel class. It helps to animate the main sprite and the monster sprites by skipping a few frames before every change in the sprite image. Without the 'animateItems()' function the sprites would be animated almost too fast to see. There are four images for the main character and four images of the monster character (two for left and two for right).

Next the canvas is used to draw the black background on the entire contents of the SurfaceView. Then, three lines print the JNI library's output on the screen.

```
	mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
	mTempJNI = Bitmap.createBitmap(mMap, 0, 0, 256, 192, mMatrix, false);
	canvas.drawBitmap(mTempJNI, 0, 0, null);
```

The first line takes the output of the code `drawLevel(newBG + 1)` and turns it into a bitmap called mMap. The function 'drawLevel(...)' is part of the JNI library. It returns an array of java int data. 'Bitmap.createBitmap(...)' turns this data array into a proper bitmap.

The second line takes the mMap bitmap and doubles it's size so that it fits better on larger screens. The mMatrix object is where you specify the size you want the resulting bitmap to be. We choose to double the size.

The last line, 'canvas.drawBitmap(mTempJNI, 0, 0, null)' prints the new Bitmap on the screen. This is how we get our JNI array to show on the screen. The crucial line is the 'createBitmap(...)' function that takes a java array as one of it's parameters.


Lastly in the onDraw() method a group of statements checks to see if the game is over and if the 'score' and 'lives' have changed. Since the JNI code keeps track of these things separately this code is necessary.  [top](Awesomeguy#Introduction.md)

### setInitialBackgroundGraphics() ###

This function is called by the Handler in GameStart.java when the level is starting. It sets the scrollX and scrollY variables, which dictate the scroll position of the game screen during play. This basically sets the scroll position that the background is set to if the awesomeguy sprite is not in the upper left hand corner when the game starts. The function also initializes the awesomeguy character's sprite. This entails clearing out the ArrayList that the sprites are stored in and saving the character as the very first entry in a new list. Then the character's sprite is adjusted for it's proper starting position, and the global Panel.java variables for the character's x and y position are set. These two variables are called guyX and guyY.  [top](Awesomeguy#Introduction.md)

### setGameValues() / getGameValues() ###

This simple setter/getter pair is used to reset the Panel.java global 'mGameV', or return a pointer to the one that the Panel.java class is already using. A reference to a GameValues class is also passed to the Panel.java class in the constructor.

### setPanelScroll() ###

This function is used repeatedly to set the scrollX and scrollY variables during game play. Since it's called with every refresh of the Panel SurfaceView, it is also used for other purposes. The setGuyPosition() function called here, with parameters that include the character's x and y position, the screen's scrollX and scrollY, and the animation index for the main character.  [top](Awesomeguy#Introduction.md)

### animateItems() ###

This function keeps track of two indexes for animating the character sprite and also the tilesheet animation. There are eight possible values for the tilesheets and four for the main character.


### checkPhysicsAdjustments() ###

This code is used by both the Java and the JNI versions of the program. The lines in this function check weather or not the main character is falling, jumping, running, climbing, etc., and they are only concerned with the contents of the 'objects' tilemap table. The code takes the user input and figures out weather the character can move in the direction desired. Gravity is implemented here, so that the character has a tendency to move twords the bottom of the screen (if that movement is not impeded by obstacles). It's probably because gravity is implemented here that the method has the name that it does.

Other methods are called in this code, and the order they're called in is sometimes important. Methods that check collision with blocks are called here. This way the character can stand on platforms. Jumping is also handled here, as is climbing on ladders. [top](Awesomeguy#Introduction.md)

### collisionWithBlocks() ###

This method is called by the 'checkPhysicsAdjustments()' function. It attempts to anticipate every possible interaction the main character can have with blocks and define an action to take to address that contact. For this reason the method is long, and contains lines that duplicate the basic principle of the lines above them, differing only in the direction the character is traveling in when it comes in contact with these blocks. Also found here are the lines of code that allow the character to 'hop' or 'skip' over a single block if it is alone in their path. This way the character can climb a gradual increase in height without jumping.

Blocks, in the context of this function, are defined in the 'objects' tilemap table only. Here, as in the 'checkPhysicsAdjustments()' method, the 'level' tilemap table is unimportant. [top](Awesomeguy#Introduction.md)

### collisionWithPlatforms() ###

This method is also called by the 'checkPhysicsAdjustments()' function. It concerns itself with what happens when the main character comes into contact with a floating platform. The function looks at the list of sprites and determines which sprites in the list represent floating platforms. Then it goes through this portion of the sprite list checking the position of the sprite with respect to the position of the character. Specifically, if the BoundingBox of the main character intersects the bounding box of the platform, the 'canFall' variable is set to false, and the character is moved, by adjusting it's x variable, in the same direction as the platform.

The interesting thing to note here is that the JNI has a separate list of sprites, and the JNI is responsible for putting these sprites on the screen. Therefore the list of platform sprites that the JNI has must be synchronized somehow with the list that the Java 'collisionWithPlatforms()' function uses. This is done with a series of JNI methods that appear in the code like this:

```
	/* loop through platform sprite records */
	for (i = mGameV.getPlatformOffset() + 1 ; i <=  mGameV.getPlatformNum() ; i ++) {
		j = i ; //j could be adjusted here
		/* get info from JNI on platform position */
		SpriteInfo mTempSprite = new SpriteInfo( 0, 8, 0, 40);
		    
		mTempSprite.setMapPosX(this.getSpriteX(j));
		mTempSprite.setMapPosY(this.getSpriteY(j));
		if(this.getSpriteFacingRight(j) == 1) mFacingRight = true;
		else mFacingRight = false;
		mTempSprite.setFacingRight(mFacingRight);

		/* code skipped here for brevity */

	}
```

The methods 'getSpriteX()', 'getSpriteY()', and 'getSpriteFacingRight()' all return info on a given sprite. The methods are passed an index number, the index number of the sprite for which we want information, and they return from the JNI the integer value that corresponds to the requested values for the sprite struct from the JNI's sprite list array (as opposed to the Java ArrayList of SpriteInfo objects).

Because the Java ArrayList of SpriteInfo objects contains sprites for the main character as well as the monsters that might be visible on a level, the for(...) loop uses mGameV.getPlatformOffset() and mGameV.getPlatformNum() to help define the index numbers that the function focuses on. These two variables are set when the level is initialized and the platform SpriteInfo objects are placed in the ArrayList.

In the ArrayList for sprites in the Java code the first record is the main character's sprite. The second record starts a list of all the monsters on the level. The last monster is followed by all the moving platforms on the level. The GameValues Object includes variables for the start and end of the monster portion of the list, and also variables for the start and end of the platform portion of the list. In the JNI code, the sprite struct is stored in an array. The contents of this array are similar to the ArrayList in the Java code, except the main character doesn't appear in the list. It holds just monsters and platforms, and the main character's sprite is kept in a separate struct all on it's own. When querying the JNI for sprite info we have to be aware of the difference between the two lists and that is why the 'j' variable is included in the listing above. [top](Awesomeguy#Introduction.md)

### scrollBg() ###

This method takes into account the size of the level and the size of the actual screen, as well as the position of the character and which direction he intends to move, and produces the scroll position of the background and the new position of the character.

It has if() blocks for movement in each of the four dimensions. Inside the if() blocks it is determined weather or not the character moves (when traveling near the edges of the screen) or if the background moves, giving the character the _appearance_ of movement. In the latter case, the background can be moved only if it is bigger than the screen that's displayed, and only if the edge of the background is not aligned with the edge of the screen alreay. [top](Awesomeguy#Introduction.md)

### checkRegularCollisions() ###

Here we create a BoundingBox for the guy character. Then we loop through the 'objects' array and make a BoundingBox for each cell in the array. We check to see if the character is in collision with any of the squares in the array. If it is we see what kind of object it is and then act accordingly.

For a ring, we give the character a certain amount of points and then we erase the ring's object number from the array, making it disappear. If it is the goal we end the level and play a sound.

To make the code more efficient, we don't check the whole array every time the screen refreshes. Instead we check the array elements that immediately surround the character.

```
int i,j;

for (j =  mGuySprite.getMapPosX() / 8 -1; j <  mGuySprite.getMapPosX() / 8 + 3; j ++ ) { 
	for (i = mGuySprite.getMapPosY() / 8 - 1; i < mGuySprite.getMapPosY() / 8 + 3; i ++ ) { 
		if(j >= 0 && j < mGameV.getMapH()  && i >= 0 && i < mGameV.getMapV()) {

			if (mGameV.getObjectsCell(j,i)  != 0 ) { 


				BoundingBox testMe = BoundingBox.makeBlockBox(j,i);

				boolean test = BoundingBox.collisionSimple(guyBox, testMe);



				/********  solid block *****/
				if (test && mGameV.getObjectsCell(j, i) == mGameV.mBlock) {
					blockTest = true;

				}
				/******** ladder **********/
				if (test && mGameV.getObjectsCell(j,i) == mGameV.mLadder) {
					ladderTest = true;

				}
				/****** more tests here ******/
			} // if block

		} // indexes OK?
		else {

			/* some boundary checking tests here */

		}
	} // i block
} // j block


```

### Panel java Setters and Getters ###

In this group of methods are 'setKeyB()', 'setGuySprite()', 'getHighScore()', 'setHighScores()', 'isEnableSounds()', and 'setEnableSounds()'. Their use is somewhat obvious, though it might be good to note that 'KeyB' is the jump key. [top](Awesomeguy#Introduction.md)

### readKeys() ###

There are two functions called 'readKeys()' with slightly different signatures. The simpler of the two is also the longer function. It looks like this:

```
	public  void readKeys() {		


		/* set x and y as determined by game pad input */
		x=0;
		y=0;

		changeX = false;
		changeY = false;

		if(mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) {

			x =  (int) + (mMovementV.getHMove() * mXMultiplier);
			changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) {
			x =   (int) - (mMovementV.getHMove() * mXMultiplier);
			changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_UP) {
			y =  (int) - (mMovementV.getVMove() * mYMultiplier);
			changeY = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) {
			y =  (int) + (mMovementV.getVMove() * mYMultiplier);
			changeY = true;
			//keyB = false;
		}
		

	}
```

The idea is to take the MovementValues direction information and translate it into x and y, where x and y are not the x and y value of the  character on the screen, but instead x and y are the direction and amount that the character would like to move _in\_addition\_to_ their current position. This is the meaning of the global values for x and y in the Panel.java object. Most importantly, this is the meaning of x an y to the 'checkPhysicsAdjustments()' and 'scrollBg()' functions.

The readKeys function also utilizes two variables called mYMultiplier and mXMultiplier. These variables can be set to numbers higher than one if the mode of input, like the trackball, is less sensitive than the touchbuttons on the screen. This is exactly what the second 'readKeys()' method does. It takes an input and uses it to set the mXMultiplier and mYMultiplier values. [top](Awesomeguy#Introduction.md)

### playSounds() ###

This function is called every time the screen refreshes. It calls the three JNI functions 'getSoundOw()', 'getSoundPrize()', and 'getSoundBoom()'. These functions return a value of 1 if the JNI has come across a situation where a sound must be played. The sounds are called 'ow', 'prize', and 'boom' respectively. This way the JNI can figure out what sounds need to be played while the Java is responsible for actually playing the sounds. [top](Awesomeguy#Introduction.md)

### addMonstersJNI() ###

This function is called before the level is actually played, when the various arrays are being populated. It is used to go through the ArrayList of SpriteInfo objects and pass that info on to the JNI library. Once the JNI library has the info it reconstructs the list as an array of structs. Three pieces of info are passed to the JNI, the object's x and y coordinates and the starting animation index for the object. This is done using the JNI function 'addMonster(...)'. The function is actually called from the GameStart.java InnerGameLoop. [top](Awesomeguy#Introduction.md)

### addPlatformsJNI() ###

This function does for floating platforms what the 'addMonsterJNI()' function does for monsters. This function is also only called from the GameStart.java InnerGameLoop. [top](Awesomeguy#Introduction.md)

### JNI Declarations ###

Here in the Panel.java class we find declarations for all the JNI functions used in the program. These declarations basically provide a mechanism for communicating with the JNI. We will go into the JNI later in this document.

```
	public native void setLevelData( int [] a_map, int [] b_map,int width, int height);
	public native void setObjectsDisplay(int map_x, int map_y, int value);
	public native void setGuyData(int [] a, int [] b, int [] c, int [] d);
	public native void setMonsterData(int [] a, int [] b, int [] c, int [] d);
	public native void setMovingPlatformData(int []a);
	public native void inactivateMonster(int num);
	public native void setTileMapData( int [] a, int [] b, int [] c, int [] d);
	public native void addMonster(int map_x, int map_y, int animate_index);
	public native void addPlatform(int map_x, int map_y);
	public native void setGuyPosition(int x, int y, int scrollx, int scrolly, int animate);
	public native void setScoreLives(int score, int lives);
	public native void setMonsterPreferences(int monsters, int collision);
	public native void setScreenData(int screenH, int screenV);
	public native int[] drawLevel(int num);
	public native int getSoundBoom();
	public native int getSoundOw();
	public native int getSoundPrize();
	public native int getEndLevel();
	public native int getScore();
	public native int getLives();
	public native void incrementJniScore(int num);
	public native int getSpriteX(int num);
	public native int getSpriteY(int num);
	public native int getSpriteFacingRight(int num);
	static {
		System.loadLibrary("awesomeguy");
	}
```

Of special interest we note the last entry in the list, the line `System.loadLibrary("awesomeguy");` which actually loads the library for us, and the line about half way through that actually returns an array of ints: `public native int[] drawLevel(int num);`. [top](Awesomeguy#Introduction.md)

# Players java #

The Players.java file is an activity, and appears on the screen when an appropriately named button is selected from the Menu.java screen. It has an associated xml file, called 'players.xml'.

### onCreate() ###

The first method in the Players.java file loads the mHighScores object from SharedPreferences. This is really the current score record for the current player. It does not necessarily get saved to the high score table. Then it loads an int from shared preferences that represents the current value for the number of high score records awesomeguy should keep in it's sqlite database. Then the RecordAdapter is instantiated. The RecordAdapter is an inner class that extends the Android class 'ArrayAdapter'. It is used to display the list of current high scores. It's described later.

### ListView ###

Next we need to discuss the ListView and the RecordAdapter. The block of code associated with the ListView is below.

```
        mAadapter = new RecordAdapter(this, R.layout.players, mNames);
        /* ... skip ... */
        setListAdapter(mAadapter);
        ListView lv = getListView();
        lv.setTextFilterEnabled(true);
        lv.setOnItemClickListener(new OnItemClickListener () {
        	
        	@Override
        	 public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        		mRec = mNames.get(position);

        		AlertNumRecords mAlert = new AlertNumRecords(Players.this,mHighScores,mRec);
        		mRec.setNumRecords(mAlert.alertUser());
        		mHighScores = mRec;

        		Toast.makeText(Players.this, "Player Selected: " + mHighScores.getName(), Toast.LENGTH_SHORT).show();
        		SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
            		mHighScores.setNewRecord(false);
        		mHighScores.addToPreferences(preferences);
               		mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                
                	/* save num of high scores */
                	SharedPreferences.Editor mSave = mPreferences.edit();
                	mSave.putInt(Options.SAVED_NUM_SCORES, mHighScores.getNumRecords());
                	mSave.commit();
                	mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");
                
                	/* save num of high scores for player */

                	mScores.updateNumOfRecords(mHighScores.getNumRecords());
                
                	/* adjust number of high scores shown */
                	mScores.pruneScoresList();
        	 }
        	
        	
        });
```

The xml entry for this code in the players.xml file is below. It's very simple.

```
	<ListView android:id="@id/android:list" android:layout_width="fill_parent"
		android:layout_height="fill_parent" android:background="#000000"
		android:layout_weight="1" android:drawSelectorOnTop="false" />

```

The start of the Players.java listing shows the adapter being instantiated. This takes as parameters a list of the high scores that's retrieved from the database and the Android ID for the players.xml resource. Then the file addresses the ListView. There is only one list view per activity. This is why 'setListAdapter()' and 'getListView()' do not refer to the list's resource number. A reference for the ListView is gotten in the line `ListView lv = getListView();` and it's 'OnItemClickListener' is set. The OnItemClickListener is an anonymous class that listens for clicks on items in the list that is displayed on the screen. To  make the class do what you want you must override the 'onItemClick(...)' method. This overriding of the 'onItemClick(...)' method is the bulk of the listing above.

'mNames', the array of high scores from the instantiation of the RecordAdapter, is visible inside the 'onItemClick(...)' code block. The first thing we do is use the 'position' variable to get the record that the user clicked on. This is the most important line in the 'onItemClick(...)' method.

The next thing we do is instantiate a class that sends the user a special alert. We want the user to know when the number of records that the game saves (the number of high scores) changes, and when it does we want the user to specifically OK that change. This is what the AlertNumRecords class does. After this alert we change the temporary 'mRec' object into the permanent 'mHighScores' object.

Then we send a Toast message that says we have changed the selected player to the new player's name.

Then we save the player's record to preferences. This way other activities in the program know what the player's name is, etc. Then we change the text message on the Players.java screen that says what the current player's name is. This is accomplished with the line `mPlayerText.setText("Player Chosen: " +mHighScores.getName());`

Then we save the number of high scores that the game puts in the database again. This second operation saves the number to the Awesomeguy SharedPreferences, not the Awesomeguy database. This is so that the number of high scores is persistent when you stop and restart the entire app. Immediately after that we set the text that prints to the screen a user readable rendition of how many high scores are being saved. This is accomplished with a line that reads `mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");`.

Then we pass the nuber of high scores saved to the Scores.java object. Finally, since the number of scores has possibly changed, we make sure the number of scores in the database is the same as the number in preferences with a function called 'pruneScoresList()'.

The following code makes the items in the list respond to a long click.

```
        /* long click code */
        lv.setLongClickable(true);
        lv.setOnItemLongClickListener(new OnItemLongClickListener () {
        	
        	public boolean onItemLongClick (AdapterView<?> parent, View view, int position, long id) {
        		Toast.makeText(Players.this, "Player - Num Records: " + mNames.get(position).getNumRecords() + 
        				" Record ID: " + mNames.get(position).getRecordIdNum(), Toast.LENGTH_LONG).show();

        		return true;
        	}
        });
```

This code first turns on long clicks, then it calls 'setOnItemLongClickListener()' which takes an anonymous inner class as its parameter. 'OnItemLongClickListener' has a method which you must override to use long clicks. The method is called 'onItemLongClick(...)' and in this case it just sets up a Toast message used for debugging. The message shows the database ID number along with the number of records that that user would have the Awesomeguy program save in it's database. The idea is that every user can have a preference as to how many records are saved to the database while they are playing the game.

### EditText ###

There is a single EditText field in the xml sheet for this activity.

```
        /* edit text field*/
        final EditText edittext = (EditText) findViewById(R.id.edittext_name);
        edittext.setOnKeyListener(new OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
                    (keyCode == KeyEvent.KEYCODE_ENTER)) {
                  // Perform action on key press
                  mRec = new Record();
                  mRec.setName(edittext.getText().toString().trim());
                  mRec.setNumRecords(mHighScores.getNumRecords());
                  if ( isNameTaken(mNames, mRec.getName())) {
                      Toast.makeText(Players.this, "This name is already taken: " + edittext.getText(), Toast.LENGTH_LONG).show();

                  }
                  else {
                      Toast.makeText(Players.this, "Player Selected: " + edittext.getText(), Toast.LENGTH_SHORT).show();
                      mHighScores = mRec;
                      mHighScores.setNewRecord(true);
                	  
                      mHighScores.addToPreferences(mPreferences);
                      mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                      mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");
                      SharedPreferences.Editor edit = mPreferences.edit();
                      edit.putInt(Options.SAVED_ROOM_NUM, mHighScores.getLevel());
                      edit.commit();
                  }
                  return true;
                }
                return false;
            }
            
            
        });
```
This is the part of the players.xml file that is responsible for putting the EditText object on the screen. It's very simple. Since there can be more than one EditText item on the screen at a time, the android ID parameter is very important. In the java code from Players.java this EditText item is called 'edittext\_name'.
```
	<EditText android:id="@+id/edittext_name" android:textSize="16sp"
	android:textStyle="bold" android:layout_width="fill_parent"
	android:layout_height="wrap_content" />
```
The first part of the java code creates an EditText object and assigns it to the 'edittext\_name' object that is found in the xml. This allows us to listen for changes to the EditText object and react to them. The next part takes the new 'edittext' object and sets an 'OnKeyListener' for it. 'OnKeyListener' is an anonymous inner class. In the 'OnKeyListener' class we override the 'onKey(...)' method. This is where the bulk of our work is done.

First we have an if() statement that allows our code to respond only when the enter key is pressed. This is accomplished with the 'getAction()' method and the two constants 'KeyEvent.ACTION\_DOWN' and 'KeyEvent.KEYCODE\_ENTER'.

Then we create an empty score Record called 'mRec'. We set the name of 'mRec' to the string that the user typed at the EditText prompt. This is done with the code 'edittext.getText().toString().trim()'. Then we set the number of records that the Record object uses to the current number of records. (This is the number of records that the database holds.)

Then we have a test where we determine if the name that the user just specified is already taken. If it is the user is notified. If not the temporary 'mRec' Record is transferred to the permanent mHighScores record, and the 'mNewRecord' boolean flag is set to true.

The mHighScores object is then saved to SharedPreferences, and the 'mPlayerText' and 'mNumPlayers' text is set using 'setText(...)' methods. These two TextViews will be discussed below.

Lastly in the EditText code, we make sure that the room that the game starts on is also the room that is specified by the 'mHighScores.getLevel()' code. This is almost always the case as the 'mHighScores' object is a new object. In any case we save it using the SharedPreferences mechanism.

### Button ###

This is the code for the button that appears at the bottom of the list of players on the players.xml file.

```
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_players);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	Intent StartGameIntent = new Intent(Players.this,GameStart.class);
        		startActivity(StartGameIntent);

            }
        });
```

The xml from the players.xml file is below. Since there can be more than one button on a page the ID for the button is important.

```
	<Button android:layout_width="fill_parent"
		android:layout_height="wrap_content" xmlns:android="http://schemas.android.com/apk/res/android"
		android:id="@+id/button_players" android:text="Go To Game" />
```

First we associate the Button object with the xml code found on the players.xml sheet. Then we assign the button an 'OnClickListener'. The 'OnClickListener' is an anonymous inner class. Inside the 'OnClickListener' we override the 'onClick(...)' method. What we want to have happen here is for program control to pass from the activity we're in to the 'GameStart' activity. The activity is mentioned in our AndroidManifest.xml file, so all we have to do is create an Intent and then call the 'startActivity(Intent)' method on that Intent.

### TextViews ###

There are two TextViews in the players.xml file.

```
        mNumPlayers = (TextView) findViewById(R.id.text_num_message);
        mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");
        
        mPlayerText = (TextView) findViewById(R.id.text_player_name);
        mPlayerText.setText("Player Chosen: " +mHighScores.getName());
```

The xml for these elements is also straightforward. The ID strings for these elements are important, and also it should be noted that the formatting for the text is found in the xml, not in the java code.
```
	<TextView android:text=" This is where you choose from a list of high scores."

		android:id="@+id/text_num_message" android:layout_width="wrap_content"
		android:layout_height="wrap_content">
	</TextView>
	<TextView android:text=" Player Chosen: "
        android:textSize="16sp"
         android:textStyle="bold"
        android:id="@+id/text_player_name" android:layout_width="wrap_content"
        android:layout_height="wrap_content">
    </TextView>
```

In the code, the first thing we do is associate the TextView objects, which are global, with the Android ID for each of them. The IDs are 'text\_num\_message' and 'text\_player\_name'. As you can see the 'text\_num\_message' is used to show how many database objects are being maintained by the game, and 'text\_player\_name' is used to show the name of the player that has either been selected from the high score list, or has been typed in using the EditText element.

### pruneScoresList() ###

This is a call to the code in the Scores.java file that goes about ensuring that the database holds no more than the allotted number of high score records. It is called at various times in the Players.java file.
```
        mScores.pruneScoresList();
```

This ends the 'onCreate(...)' outline.

### onResume() ###

Here we use the SharedPreferences mechanism to load the current score Record into the 'mHighScores' object. We also load the 'mPreferredNumRecords' int from SharedPreferences in a similar way. Then we create a new Scores object and pass it the newly retrieved 'mHighScores' Record. This code is listed below.

```
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);
        
        mScores = new Scores(this, mHighScores);
```

Then we retrieve all the high scores and populate the 'mNames' ArrayList with the new information. After that we let the ArrayAdapter know that the dataset has changed so that it can redraw the list. This way if the list has changed, due to a high score being saved or due to pruning by the 'pruneScoresList()' method, the Players.java activity will display the right information.
```
    	ArrayList<Record> temp = mScores.getHighScoreList(mHighScores.getNumRecords());
        this.mNames.clear();
        this.mNames.addAll(temp);
    	
    	mAadapter.notifyDataSetChanged();
```

Lastly in the 'onResume()' method we prune the database. If there were any items removed we notify the user.
```
    int num = mScores.pruneScoresList();
    if (num > 0) {
    	Toast.makeText(Players.this, num + " scores were removed from High Score List!!", Toast.LENGTH_LONG).show();
    }
```

### isNameTaken() ###

This method is not listed here. It checks an ArrayList to see if any member's name String matches the name String given in the method's invocation. It returns a true or false.

### RecordAdapter ###

This inner class extends ArrayAdapter. It is used by the ListView described above and is instantiated in the 'onCreate(...)' method with the line below. 'mAadapter' is a global variable.
```
        mAadapter = new RecordAdapter(this, R.layout.players, mNames);
```
The RecordAdapter itself is used so that we can customize the layout of the individual items in the ListView. In our case, we didn't want a single String in the ListView, we wanted three, and we also wanted the ability to format the three strings separately.

What you have to do is create a small layout file for your ArrayAdapter. This xml file is then inflated by a 'LayoutInflater', after which you may manipulate it as any other xml file. One of these xml instances is placed in the ListView layout for each row or element in the list. The code for all of this specialization is found in the RecordAdapter's overridden 'getView(...)' method. Our 'getView(...)' method is listed here.
```
    	@Override
        public View getView(int position, View convertView, ViewGroup parent) {
    		
    		LayoutInflater inflater = (LayoutInflater)mContext.getSystemService (Context.LAYOUT_INFLATER_SERVICE);
    		convertView = inflater.inflate(R.layout.data_row, null);
    		Record mRec = mList.get(position);
    		mPosition = position;
    		
    		TextView mName = (TextView) convertView.findViewById(R.id.text_name);
    		TextView mScore = (TextView) convertView.findViewById(R.id.text_score);
    		TextView mLevel = (TextView) convertView.findViewById(R.id.text_level);
    		
    		mName.setText("Name: " + mRec.getName() );
    		mScore.setText("Score: "+ mRec.getScore());
    		mLevel.setText("Last Checkpoint: Level " + mRec.getLevel());
    		
    		
    		
    		return convertView;
    	}
```
The RecordAdapter's 'getView(...)' method returns the view that is to become one of the elements in the list that the user sees.

The first thing we do in the method is create a 'LayoutInflater'. Then we use the inflater to inflate the mini xml file and pass the pointer for the newly inflated file to the View that we are going to return at the end of the method. In our case the xml file is called 'data\_row'. Our job then is to modify this View to contain the info we want. Then we return the View.

The elements in 'data\_row' are called 'text\_name', 'text\_score', and 'text\_level'. The full xml file is below.

```
<?xml version="1.0" encoding="utf-8"?>
 <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
     android:layout_height="?android:attr/listPreferredItemHeight"
     android:layout_width="fill_parent"
     >
     <ImageView
        android:id="@+id/icon"
        android:layout_width="wrap_content"
        android:layout_height="fill_parent"
        android:layout_marginRight="6dip"
        android:src="@drawable/guy_icon" />
          <LinearLayout
     
 xmlns:android="http://schemas.android.com/apk/res/android"
     android:layout_height="wrap_content"
     android:layout_width="fill_parent"
     android:orientation="vertical">

     <TextView android:id="@+id/text_name"
         android:textSize="16sp"
         android:textStyle="bold"
         android:layout_width="fill_parent"
         android:layout_height="wrap_content"/>
    <TextView android:id="@+id/text_score"
         android:textSize="16sp"
         android:textStyle="bold"
         android:layout_width="fill_parent"
         android:layout_height="wrap_content"/>
    <TextView android:id="@+id/text_level"
         android:textSize="16sp"
         android:textStyle="bold"
         android:layout_width="fill_parent"
         android:layout_height="wrap_content"/>
 </LinearLayout>
 </LinearLayout> 
```
It's good to note when you go to the Players.java page and look at the list of high scores, there is an icon next to every name. This icon is specified in the 'data\_row' file. The rest of the file is for formatting and used to specify the three text views that are used in 'getView(...)' to print the name, score, and last checkpoint level on the screen.

### AlertNumRecords ###

This class defines a method that displays an alert dialog to the screen. The dialog has two choices, on that allows you to select the _old_ number of records, and one that allows you to select the _new_ number of records.

```
   /* Inner class for making alert message about number of high scores */
   public static class AlertNumRecords {
	   
	   Record mRec = new Record();
	   Record mHighScores = new Record();
	   int mPreferredNumRecords;
	   Context mParent;
	   
	   public AlertNumRecords(Context parent, Record mHighScores, Record mRec) {
		   this.mHighScores = mHighScores;
		   this.mRec = mRec;
		   this.mPreferredNumRecords = mHighScores.getNumRecords();
		   mParent = parent;
	   }
	   
	   public int alertUser() {
	       	if ( mPreferredNumRecords != mRec.getNumRecords() ) {
	   	    	AlertDialog.Builder builder = new AlertDialog.Builder(mParent);
	   	    	String mAMessage = new String("Your old preference for 'Number of High Score Records' is " + mHighScores.getNumRecords());
	   	    	String mPositive = new String("Choose " + mHighScores.getNumRecords() + " records.");
	   	    	String mNegative = new String("Choose " + mRec.getNumRecords() + " records.");
	   	    	builder.setMessage(mAMessage)
	   	    	       .setCancelable(false)
	   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {

	   	    	        	   mRec.setNumRecords(mHighScores.getNumRecords());
	   	    	        	   dialog.cancel();
	   	    	        	   
	   	    	           }
	   	    	       })
	   	    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {
	   	    	        	   	
	   	    	                dialog.cancel();
	   	    	           }
	   	    	       });
	   	    	AlertDialog alert = builder.create();
	   	    	alert.show();
	       	}
       /* regardless which the user chooses, copy mRec */
       mHighScores = mRec;
       return mHighScores.getNumRecords() ;
       }
   }
```
Important to the process of creating an alert dialog are the 'AlertDialog.Builder' class,
```
AlertDialog.Builder builder = new AlertDialog.Builder(mParent);
```
... the 'AlertDialog' that is created using the line:
```
AlertDialog alert = builder.create();
```
... and the line that actually shows the dialog on the screen:
```
alert.show();
```
... much of the rest of the 'alertUser()' method is taken up by statements that inform the builder what to put into the actual alert dialog that is going to be created.

# Options java #

This activity is meant to allow the user to set all sorts of variables that are used when playing the game. Most often the results of changes that the user makes are saved as part of the user's high score record, and they are reset when the user chooses a different high score record to play as. The class uses 'SharedPreferences' to save values to be used by other activities in the program. There are three methods in the Options.java class, which are the overridden 'onCreate(...)', 'onPause()', and 'onResume()'. The first thing in the 'onCreate(...)' method is the retrieval from SharedPreferences of the current score record and the retrieval of the number of records to store in the database. Also retrieved at this point is a boolean value representing weather or not to look for an alternate 'awesomeguy.xml' file on the sdcard. This boolean is called 'mLookForXml' in the Options.java activity. The Options activity's contents are also set to the 'options.xml' layout file with the 'setContentView(...)' statement. This code is shown below.
```
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

        mHighScores.getFromPreferences(preferences);
        
        if (mHighScores.isNewRecord()) {
        	mHighScores.setNumRecords(preferences.getInt(SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY));
        }
        mLookForXml = preferences.getBoolean(SAVED_LOOK_FOR_XML, false);
        
        setContentView(R.layout.options);
```

### TextView ###

The java code for setting a TextView that is a part of the activity's xml follows. Basically we have to use 'findViewById(...)' to attach the TextView object that we instantiate to the segment of the xml that actually displays something for the user to read.
```
        final TextView textview_name = (TextView) this.findViewById(R.id.player_name_options);
        textview_name.setText("Player Name: " + mHighScores.getName());
```
In this example we print the current user's high score name on the screen so that they can see what user they're playing as. The xml element ID is important. It's called 'player\_name\_options'. In the xml, the text for the TextView is unimportant, as it's replaced when the activity is started.
```
	<TextView

		android:text="This is where you would show the player name. "

		android:id="@+id/player_name_options" android:layout_width="wrap_content"

		android:layout_height="wrap_content" android:textSize="16sp"

		android:textStyle="bold">

	</TextView>
```

### CheckBox ###

There are several CheckBoxes in the Options.java file. We will discuss one here in detail. This is the code for the Checkbox that enables and disables sound playback.
```
        final CheckBox checkbox_sounds = (CheckBox) findViewById(R.id.checkbox_sounds );
        checkbox_sounds.setChecked(mHighScores.isSound());
        
        checkbox_sounds.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Sound Selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setSound(true);
                } else {
                    Toast.makeText(Options.this, "Sound Not selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setSound(false);
                }
            }
        });
```

One of the first things we do with the CheckBox is instantiate a CheckBox object and associate it with the xml element. In this case the xml ID is 'checkbox\_sounds'. The xml itself is pretty simple. This is the listing.

```
	<CheckBox android:id="@+id/checkbox_sounds"
		android:layout_width="wrap_content" android:layout_height="wrap_content"
		android:text="Play Game Sounds" />
```
In the java code, we set the CheckBox to the value that the high score Record holds with the code 'checkbox\_sounds.setChecked(mHighScores.isSound());'. This makes it so that the visual representation of the CheckBox matches the coded value. Then we listen for changes from the user using an 'OnClickListener' anonymous inner class. Inside the inner class we set the 'mHighScores' boolean for sound playback to a value that corresponds to the user's input. Then we show a Toast message as feedback that the preference was actually stored.

There are other CheckBoxes on the Options.java page, which include settings for weather the XML Parser will search for XML on the sdcard, weather the monster images are displayed on the screen, and weather the main character can be affected by those monsters when he comes in contact with them. These other CheckBoxes are very similar to the 'checkbox\_sounds' CheckBox, except for the one that concerns the XML Parser. That one will be discussed in a little more detail below.

### RadioButton ###

For the Options.java file there are three core parts to the RadioButton. They are the xml code, the OnClickListener, and the supporting code where the OnClickListener is associated with the xml. The xml listing is here.
```
	<RadioGroup android:layout_width="fill_parent"
		android:layout_height="wrap_content" android:orientation="vertical">
		<RadioButton android:id="@+id/radio_players_five"
			android:layout_width="wrap_content" android:layout_height="wrap_content"
			android:text="Five High Scores" />
		<RadioButton android:id="@+id/radio_players_ten"
			android:layout_width="wrap_content" android:layout_height="wrap_content"
			android:text="Ten High Scores" />
		<RadioButton android:id="@+id/radio_players_fifty"
			android:layout_width="wrap_content" android:layout_height="wrap_content"
			android:text="Fifty High Scores" />
	</RadioGroup>
```
Note that each RadioButton in the RadioGroup has a separate ID. For this example they are 'radio\_players\_five', 'radio\_players\_ten', and 'radio\_players\_fifty'. The 'OnClickListener' section is below.
```
        final OnClickListener radio_players = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
                
                if(rb.getId() == R.id.radio_players_ten) mHighScores.setNumRecords(Record.RADIO_PLAYERS_TEN);
                if(rb.getId() == R.id.radio_players_five) mHighScores.setNumRecords(Record.RADIO_PLAYERS_FIVE);
                if(rb.getId() == R.id.radio_players_fifty) mHighScores.setNumRecords(Record.RADIO_PLAYERS_FIFTY);
                SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
                SharedPreferences.Editor out = preferences.edit();
                out.putInt(SAVED_NUM_SCORES, mHighScores.getNumRecords());
                out.commit();
                
            }
        };
```
Here the RadioButton 'rb' is declared, and it's ID is compared to the ID for each of the RadioButtons from the xml. In if() blocks like this one code is performed when a button is chosen. `if(rb.getId() == R.id.radio_players_ten) mHighScores.setNumRecords(Record.RADIO_PLAYERS_TEN);`

Below is the final section of the RadioButton code, where OnClickListeners are associated with the various buttons.
```
        final RadioButton radio_players_five = (RadioButton) findViewById(R.id.radio_players_five);
        if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_FIVE) radio_players_five.setChecked(true);
        final RadioButton radio_players_ten = (RadioButton) findViewById(R.id.radio_players_ten);
        if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_TEN) radio_players_ten.setChecked(true);
        final RadioButton radio_players_fifty = (RadioButton) findViewById(R.id.radio_players_fifty);
        if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_FIFTY) radio_players_fifty.setChecked(true);
        
        radio_players_five.setOnClickListener(radio_players);
        radio_players_ten.setOnClickListener(radio_players);
        radio_players_fifty.setOnClickListener(radio_players);
```
This section is also where the starting value of the set of RadioButtons is established. The code to do this is in statements like: `if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_FIVE) radio_players_five.setChecked(true);`.

### Spinner ###

A spinner is included on the Options page that lets you specify what level (or room) you want to start your game at. Since there are ten levels to the game there are ten options on the drop-down spinner. There's also a CheckBox that lets you direct the game to look for an awesomeguy.xml file on the sdcard. This way new rooms/levels can be added to the game simply by placing the appropriate xml file on the sdcard. The spinner object along with the XML Parser and the CheckBox work together. I will describe the Spinner here first. The code for the Spinner follows.
```
        /** spinner for picking starting level **/
        mList = new InitBackground.LevelList();
        final Spinner spinner = (Spinner) findViewById(R.id.room_spinner);
        mList = mParser.getLevelList(mLookForXml);
        
        
        adapter = new ArrayAdapter(this, android.R.layout.simple_spinner_item, mList.getStrings().toArray());
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(
                new OnItemSelectedListener() {
                    public void onItemSelected(
                            AdapterView<?> parent, View view, int position, long id) {
                    	Toast.makeText(Options.this, "Level " +(position + 1) + " selected", Toast.LENGTH_SHORT).show();
                    	mRoomNumSelected = position + 1;
                    }

                    public void onNothingSelected(AdapterView<?> parent) {
                    	Toast.makeText(Options.this, "Default level selected", Toast.LENGTH_SHORT).show();
                    }
                });
```
The xml for the spinner object from the Options.xml follows.
```
	<Spinner android:id="@+id/room_spinner"
		android:layout_height="wrap_content" android:layout_width="fill_parent"
		android:drawSelectorOnTop="true" android:prompt="@string/room_prompt">
	</Spinner>
```
In the Spinner code we use an ArrayAdapter, similar to the one that was used on the Players.java page. On the Players.java page we used a specially designed ArrayAdapter that we called a RecordAdapter. In the RecordAdapter we used our own xml to format the data that was to appear in the list. Here we don't do that. We use a stock spinner DropDownViewResource ('simple\_spiner\_dropdown\_item') and a stock ArrayAdapter 'simple\_spinner\_item' for the format of the spinner as it appears when it's not dropped down.

The adapter and spinner are separate items that have separate properties that must be set by the Spinner code. Then the adapter is passed to the spinner. The adapter also takes an array as one of it's parameters. This array is an array of Strings, and represents the text that is to be printed on each row of the drop down array. The array will be discussed in the 'InitBackground' section of the documentation, under LevelList and LevelData.

The code also shows an 'OnItemSelectedListener' which has a 'onItemSelected(...)' method. This is where we place our code to respond to one of the drop down items being selected. We show a Toast message and then we set a global variable to the index number of the chosen item.

There is also a method 'onNothingSelecte(...)' which only shows a Toast message.

There is a CheckBox on the Options.java page that lets the user specify if Awesomeguy is meant to search for a level definition xml file on the sdcard. The idea here is that when the option is selected the program looks for the file, and if it finds it it reads from it. If it doesn't find it, it reverts back to the xml file shipped with the game. Whenever this option is changed, then, the Spinner must be repopulated so that the user can choose one of the levels as their starting level. This is the code for that CheckBox.

```
        final CheckBox checkbox_xml = (CheckBox) findViewById(R.id.checkbox_xml );
        checkbox_xml.setChecked(mLookForXml); // hard code 'false'...
        checkbox_xml.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Searching For XML", Toast.LENGTH_SHORT).show();
                    mLookForXml = true;
                    
                } else {
                    Toast.makeText(Options.this, "Not Searching For XML", Toast.LENGTH_SHORT).show();
                    mLookForXml = false;
                    
                }
                mList = mParser.getLevelList(mLookForXml);
                adapter = new ArrayAdapter(Options.this, android.R.layout.simple_spinner_item, mList.getStrings().toArray());
                adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                spinner.setAdapter(adapter);
                adapter.notifyDataSetChanged();
            }
        });
```

Inside the 'onClick()' method is placed code that repopulates 'mList', and instantiates a new 'adapter' and 'spinner'. Then it calls the method 'adapter.notifyDataSetChanged();' which tells the spinner to redraw itself. This code is executed regardless of which CheckBox option is chosen.

### onPause() ###

This is the code for the 'onPause()' method.
```
    @Override
    public void onPause() {

        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        
        /* save mHighScores so other activities can see it */
    	mHighScores.addToPreferences(preferences);
    	
    	/* save desired starting room num */
    	SharedPreferences.Editor edit = preferences.edit();
        edit.putInt(SAVED_ROOM_NUM, mRoomNumSelected);
        edit.putBoolean(SAVED_LOOK_FOR_XML, mLookForXml);
        edit.commit();
        
        /* save all other options to player's personal record if it's not 'anonymous' */
        if (!mHighScores.isNewRecord()) mScores.updateOptions(mHighScores.getRecordIdNum());
        
	    super.onPause();
    }
```
First we establish the SharedPrefernces object, then we use it to save the 'mHighScores' record and the preferences for what room number we want to start with, and weather or not we're looking on the sdcard for the alternate xml file.

Then, if the current score record, 'mHighScores', is not an anonymous record we use the database to save all the info that could have been changed on the Options page that's not strictly speaking the score. This would be the various options like 'Enable Monster Collision' and 'Play Game Sound', etc.

### onResume() ###

Here we use SharedPreferences to load the 'mHighScores' record. The code to do this is
```
    	SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(preferences);
```

# Record java #

The Record.java class is the class that represents a single high score in the database. It also represents the various preferences of the current user. When saving this information the preferences and high score are saved together. This way when a player picks a high score from the Player's page they are also picking a profile of the preferences that they want to use when playing the game. The following preferences are part of the Record object.

  * boolean NewRecord - used by Scores.java to tell if this is an anonymous player
  * int RecordIdNum - corresponds to the database ID number for this record
  * int Level - highest checkpoint achieved
  * int Score - actual high score
  * int Lives (not used much)
  * int Cycles (not used much)
  * String Name - player name
  * int GameSpeed - player's game speed preference
  * int NumRecords - number of records the player prefers in the high score table
  * boolean Sound - weather or not player wants sound playback enabled or disabled
  * boolean EnableMonsters - weather or not the player wants monsters in the game
  * boolean EnableCollision - weather or not collision with monsters can kill the player

The class is mostly made up of setters and getters, but there are three functions which could use explanation.

### addToPreferences() ###

This function adds the contents of the given Record to SharedPreferences. For it to work a SharedPrefernces object must be created and then passed to the function.
```
     public void addToPreferences( SharedPreferences preferences) {
    	 SharedPreferences.Editor out = preferences.edit();
    	 out.putString("mNewRecord",new Boolean(mNewRecord).toString());
    	 out.putInt("mRecordIdNum", mRecordIdNum);
    	 out.putString("mName",mName);
         out.putInt("mLevel",mLevel);
         out.putInt("mScore",mScore);
         out.putInt("mLives",mLives);
         out.putInt("mCycles",mCycles);
         out.putInt("mSave1",mSave1);
         out.putInt("mGameSpeed",mGameSpeed);
         out.putInt("mNumRecords",mNumRecords);
         out.putString("mSound",new Boolean(mSound).toString());
         out.putString("mEnableJNI",new Boolean(mEnableJNI).toString());
         out.putString("mEnableMonsters",new Boolean(mEnableMonsters).toString());
         out.putString("mEnableCollision",new Boolean(mEnableCollision).toString());
         out.commit();
     }
```
The function converts booleans to text values using the Boolean wrapper class.

### getFromPreferences() ###

This function is used to extract values from SharedPreferences. Again, for it to work a SharedPreferences object must be created and then passed to the function when it is called. Internally the function saves booleans as Strings, so it uses the Boolean wrapper class  to convert the saved value to a regular boolean. Getting values from preferences is slightly easier than putting them to preferences since no Editor object is needed and there is no 'commit();' line.

```
     public void getFromPreferences(SharedPreferences in) {
    	 mNewRecord = new Boolean(in.getString("mNewRecord","false")).booleanValue();
    	 mRecordIdNum = in.getInt("mRecordIdNum", 0);
    	 mName = in.getString("mName","anonymous");
         mLevel = in.getInt("mLevel",1);
         mScore = in.getInt("mScore",10);
         mLives = in.getInt("mLives",3);
         mCycles = in.getInt("mCycles",0);
         mSave1 = in.getInt("mSave1",0);
         mGameSpeed = in.getInt("mGameSpeed",16);
         mNumRecords= in.getInt("mNumRecords",RADIO_PLAYERS_FIFTY);
         mSound = new Boolean(in.getString("mSound","")).booleanValue();
         mEnableJNI = new Boolean(in.getString("mEnableJNI","")).booleanValue();
         mEnableMonsters = new Boolean(in.getString("mEnableMonsters","")).booleanValue();
         mEnableCollision = new Boolean(in.getString("mEnableCollision","")).booleanValue();
     }
```

### listInLog() ###

This method prints the entire contents of the 'mHighScores' record to the debugger log.

# Scores java #

This is the java class where we handle all the database activity. It's composed of the Scores.java class and an inner class called 'ScoreOpenHelper'. 'ScoreOpenHelper' is an 'SQLiteOpenHelper' class. It's used to establish an empty database on the android phone if needed. It's also used to return a readable or writeable database, depending on which is called for.

The first methods in the Scores.java class are the constructor and a setter that allows you to set the 'mHighScores' record currently in use in the Scores object. The constructor takes an activities context as a parameter. This is important to the 'ScoreOpenHelper'.

Several of the methods in Scores.java simply return a String which can easily be read as an sql statement. Most times in the class when a database query is required a raw query is used. These Strings are fed into the raw query.

### getHighScoreList() ###

This method returns an ArrayList of Records, and has the job of querying the database and creating a Cursor, iterating through the result set one row at time. At each row the Cursor is used to extract values which are placed in a temporary record. The temporary record is ultimately added to the ArrayList before the list is returned at the end of the function.

```
	public ArrayList<Record> getHighScoreList(int num) {
		// NOTE: if 'num' is negative, all records are returned
		ArrayList<Record> mList = new ArrayList<Record>();
		mOpenHelper = new ScoreOpenHelper(mContext);
		mDatabase = mOpenHelper.getReadableDatabase();
		Cursor c;
		if (num < 0 ) {
			c = mDatabase.rawQuery(this.getSelectAllRecordsString(), null);
		}
		else {
			c = mDatabase.rawQuery(this.getSelectNumOfRecordsString(num), null);
		}
		if (c.getCount() == 0) return mList;
		c.moveToFirst();
		for (int i = 0; i < c.getCount(); i ++ ) {
			Record mTempRec = new Record();
			mTempRec.setRecordIdNum(c.getInt(c.getColumnIndex("id")));
			mTempRec.setNewRecord(new Boolean(c.getString(c.getColumnIndex("new_record"))).booleanValue());
			mTempRec.setName(c.getString(c.getColumnIndex("name")));
			mTempRec.setLevel(c.getInt(c.getColumnIndex("level")));
			mTempRec.setScore(c.getInt(c.getColumnIndex("score")));
			mTempRec.setLives(c.getInt(c.getColumnIndex("lives")));
			mTempRec.setCycles(c.getInt(c.getColumnIndex("cycles")));
			mTempRec.setSave1(c.getInt(c.getColumnIndex("save")));
			mTempRec.setGameSpeed(c.getInt(c.getColumnIndex("game_speed")));
			mTempRec.setNumRecords(c.getInt(c.getColumnIndex("num_records")));
			mTempRec.setSound(new Boolean(c.getString(c.getColumnIndex("sound"))).booleanValue());
			mTempRec.setEnableJNI(new Boolean(c.getString(c.getColumnIndex("enable_jni"))).booleanValue());
			mTempRec.setEnableMonsters(new Boolean(c.getString(c.getColumnIndex("enable_monsters"))).booleanValue());
			mTempRec.setEnableCollision(new Boolean(c.getString(c.getColumnIndex("enable_collision"))).booleanValue());
			mList.add(mTempRec);
			c.moveToNext();
			
		}
		c.close();
		mDatabase.close();
		return mList;
	}
```

The first thing we do in 'getHighScoreList(...)' is create a number of objects. We create an ArrayList of Records, a 'ScoreOpenHelper', a Cursor, and a readable database object, called 'mDatabase'. Notice how we use the 'ScoreOpenHelper' to create the readable database object.

Then we use an if() statement to check what the calling method specified in the method's parameters for the integer 'num'. If 'num' is negative, then we want to return the entire database table, and if 'num' is positive we want to return the top of the table limiting the result set to 'num' results.

To do this we use two separate queries. Both are defined later in the class. One specifies all the rows in the table, and the other specifies only a certain number of entries. The both return data in order sorted by the high score field. This allows them to be displayed with the highest score at the top of the list. Raw queries are used at this point, so the queries look like regular sql statements.

The names of the two functions that return the sql statements for these raw queries are 'getSelectAllRecordsString()' and 'getSelectNumOfRecordsString(int num)'. They are explained below. Performing the raw query on the database returns a cursor object. The cursor object is manipulated to obtain the values from the database rows.

The next thing we do is move to the beginning of the cursor ('c.moveToFirst()') and then we go through the cursor using a for() loop to populate a temporary Record with data from the database. We add the record to the ArrayList at the end of each loop. After the loop is over we close the Cursor and the readable database and return the ArrayList of Records.

It should be noted that SQLite, the database we're using, doesn't handle booleans as a data type. Boolean values must be stored as a String or an integer. I chose to store them as Strings, so when I read from the database a boolean value I use a Boolean wrapper class to determine weather the stored value is positive or negative.

### insertRecordIfRanks() ###

This method is used by the GameStart.java class, when the 'onPause()' method is called, to store the current player's high score. It only does this under certain conditions, like weather or not the player is anonymous and weather or not the score is higher than the lowest score in the table.

```
	public void insertRecordIfRanks(Record mHighScores) {
		String query = new String();
		Record mLowestScore = new Record();

		
		/* first check if record is 'anonymous' -- if so, exit !! */
		if(mHighScores.getName().contentEquals(mLowestScore.getName())) return;
		
		
		ArrayList<Record> test = this.getHighScoreList(mHighScores.getNumRecords());
		if (test.size() > 0) {
			mLowestScore = test.get(test.size() - 1);
		}
		
		if (mHighScores.getScore() > mLowestScore.getScore() || test.size() < mHighScores.getNumRecords()) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			
			mHighScores.listInLog();
			
			if(mHighScores.isNewRecord()) {
				//set new record to false
				//set ID Num
				
				long i = mDatabase.insert(TABLE_NAME, null, this.getInsertContentValues());
				
				
				mHighScores.setRecordIdNum((int)i);
				mHighScores.setNewRecord(false);
				
				mHighScores.listInLog();
				
			}
			else  {
				query = this.getUpdateScoreLevelString(mHighScores.getRecordIdNum());
				Cursor c = mDatabase.rawQuery(query, null);
				int i = c.getCount();

				c.close();
				
			}
			mDatabase.close();
		}
	}
```

In the first part of the method the String for the query is instantiated, along with a blank score Record called 'mLowestScore'. This Record is used for comparison in the next segment where we use an if() statement to check if the 'mHighScores' record has had it's name changed. If it hasn't then we assume the user doesn't want to save their high score.

Next the 'test' ArrayList is created, and it is populated with data from the Scores method 'getHighScoreList(...)'. When we populate the ArrayList we ask for the number of records that the user has specified that it wants in the database. This number is returned by the code 'mHighScores.getNumRecords()'.

Next we see if the size of the returned ArrayList is greater than zero. If it is greater, then the 'mLowestScore' Record is set to the value of the last element in this list. That will now be the lowest score.

Next we have a complicated if() statement that actually determines if the 'mHighScores' object belongs in the database. It tests weather the score to be saved is greater than the lowest score, or if the size of the database table is smaller than the number of records that the program currently allows. If either of these is true we want to save something to the database. Exactly how we do that is determined in the next set of if-else statements. In preparation for this code we use the 'ScoreOpenHelper' to get a writeable database.

The inner if-else statements in this portion of 'insertRecordIfRanks(...)' tests to see if the Record is a new record, or if it is an old Record. A new record has never been saved to the database, while an old record already has an entry in the database. A new record needs an 'insert' statement, while an old record needs an 'update' statement.

In the case of a new record we take the writeable database and perform an insert on it. This insert is not a raw query. The advantage of not using a raw query at this stage is that the 'mDatabase.insert(...)' command returns the row ID number for the data we just inserted in the database table. We need this ID number so that we can update data to this database record in the future. After we've performed the 'insert()' method we change the values in 'mHighScores' so that this Record object has a proper 'mRecordIdNum' and so that 'mNewRecord' is set to false.

Adding the proper 'mRecordIdNum' and 'mNewRecord' values allows the program to treat the record as an old record in the future. This way if the player gets a score on the high score table, and then proceeds to play the game again, they can beat their previous score and have their new score recorded.

If the 'mHighScores' record is not a new record, then we want to update the database values using the raw query 'getUpdateScoreLevelString(int num)'. This function takes the 'mRecordIdNum' as its parameter. As it's name implies, it updates the score and the level values of an already existing database entry.

### updateNumberOfRecords() ###

This method acts on the current 'mHighScores' record and updates it's 'mNumOfRecords' field in the SQLite database. It uses the 'getUpdateNumOfRecords(...)' String and a 'rawQuery(...)'. It does not alter any other data.

### updateOptions() ###

This method updates all the various options that are associated with a high score Record without actually changing the high score or the checkpoint level. It uses the method 'getUpdateOptionsString(...)'.

### pruneScoreList() ###

This method is used to keep the high score list the right size. It does this by getting a copy of the table in the form of an ArrayList, and then using a for() loop to go through the list where it exceeds the proper number of records, and deleting the records using their ID numbers to identify them.

```
	public int pruneScoresList() {
		ArrayList<Record> mList = this.getHighScoreList(-1);
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		int num = 0;
		if (mHighScores.getNumRecords() < mList.size()) {
			num = mList.size() - mHighScores.getNumRecords();
			for (int i = mHighScores.getNumRecords(); i < mList.size(); i ++) {
				int j = mList.get(i).getRecordIdNum();
				Cursor c = mDatabase.rawQuery("DELETE FROM "+ TABLE_NAME + " WHERE id=" + j, null);
				c.getCount();
				c.close();

			}
		}
		mDatabase.close();
		return num;
	}
```

The methos uses a raw query, but instead of calling another function to define the String that the query uses, it is contained in the raw query itself.

### getInsertString() ###

This method is not used, except for testing. It returns a String used for inserting an entire record into the database using a raw query. The reason it's not used it that the raw query mechanism does not return the index number of the record that was just inserted.

### getSelectNumOfRecordsString() ###

As it's name implies, this method returns a String which contains the sql to request that a list of records be returned not exceeding a certain number. The records are sorted by score.

### getSelectAllRecordsString() ###

This method returns a String. This String contains the sql to query the database for all records in the table. The records are arranged in descending order by score.

### getUpdateScoreLevelString() ###

This method returns a String which contains the sql to update the score and level information for a particular row in the database. The row in question is identified by its ID number.

### getUpdateNumberOfRecordsString() ###

This method returns a String that contains the sql to update the 'mNumRecords' field in the game's database for a particular ID.

### getUpdateOptionsString() ###

This method returns a String that contains the sql to update the various options that the game allows you to set for a particular row in the database, given the ID of the row. It does not change the level or high score values.

### getInsertContentValues() ###

This method creates a ContentValues object and fills it with the info needed to create a new record in the database using a 'insert()' function (not a raw query function).

### ScoreOpenHelper ###

This class extends the class SQLiteOpenHelper. It's constructor takes a reference to a Context object and calls the 'super(...)' constructor, passing it the Context, the database name, and the database version number. These are all defined at the beginning of Scored.java. (the super constructor also takes a null parameter).

The remainder of the class is shown here.

```
		@Override
		public void onCreate(SQLiteDatabase db) {
			db.execSQL(getCreateTableString());
		}
		
		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			Log.w("Scores", "Upgrading database, this will drop tables and recreate.");
			db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
			onCreate(db);
		}
		
		public String getCreateTableString() {
			return new String(
					" CREATE TABLE " +
					TABLE_NAME + " " +
					" ( id INTEGER PRIMARY KEY , " +
					" new_record TEXT , " +
					" name TEXT , " +
					" level INTEGER , " +
					" score INTEGER , " +
					" lives INTEGER , " +
					" cycles INTEGER , " +
					" save INTEGER , " +
					" game_speed INTEGER , " +
					" num_records INTEGER , " +
					" sound TEXT , " +
					" enable_jni TEXT , " +
					" enable_monsters TEXT , " +
					" enable_collision TEXT  " +
					" ) "
					);
		}
```

### onCreate() ###

This method is called if the 'ScoreOpenHelper' class ever has to create the  database from scratch. It does this automatically if it has to. The method is overridden and takes a SQLiteDatabase as it's parameter. When overriding this function do not change it's signature. The sole contents of the method is the line 'db.execSQL(getCreateTableString());' . The string in question is part of the 'ScoreOpenHelper' class and is described below.

### onUpgrade() ###

This feature attempts to determine when the database structure has been changed. When it has it drops the table and creates a new empty table in it's place. It presupposes that the programmer change the variable 'DATABASE\_VERSION' whenever the table needs to be refreshed.

### getCreateTableString() ###

This function returns a string that establishes the structure of the database table when it is created or changed. SQLite databases do not have a boolean data type, so either a String (TEXT) or an Integer (INTEGER) must be used. In this program a TEXT field is used for boolean data.

# SoundPoolManager java #

This class is used to manage the playback of sound effects used in the game. Its most important component is the 'SoundPool' object. The manager class defines several int constants, one for each of the sounds that comes up in the game.
```
    public static final int SOUND_BOOM = 0;
    public static final int SOUND_GOAL = 1;
    public static final int SOUND_OW = 2;
    public static final int SOUND_PRIZE = 3;
```
The constructor only has one parameter, which is used to pass the current context from the activity that calls the SoundPoolManager to the SoundPool, where it's used in the 'load()' and 'play' methods.

### init() ###

The init method of the SoundPoolManager is listed below.
```
    public void init() {
            if (enabled) {
                    Log.d(TAG, "Initializing new SoundPool");

                    release();
                    soundPool = new SoundPool(2,AudioManager.STREAM_NOTIFICATION, 0);
                    this.mSoundOw = soundPool.load(context, R.raw.ow, 1);
                    this.mSoundBoom = soundPool.load(context, R.raw.boom, 1);
                    this.mSoundGoal = soundPool.load(context, R.raw.goal, 1);
                    this.mSoundPrize = soundPool.load(context, R.raw.prize, 1);
                    
                    Log.d(TAG, "SoundPool initialized");
            }
    }
```
This method initializes a new SoundPool (for what would seem the second time) then it assigns the result of the code segment 'soundPool.load( context, R.raw.ow, 1)' to the variable 'mSoundOw'. This variable 'mSoundOw' is used later to actually play the sound. This is the process that is followed as each sound is loaded into the SoundPool.

### release() ###

The code for the 'release()' method is below.
```
    public void release() {
            if (soundPool != null) {
                    Log.d(TAG, "Closing SoundPool");
                    soundPool.release();
                    soundPool = null;
                    Log.d(TAG, "SoundPool closed");
                    return;
            }
    }
```

### playSound() ###

The 'playSound()' method is used to play whatever sound the game requires. The function takes an int as a parameter, which should match one of the constants defined at the start of the class.

```
    public void playSound(int sound) {
            if (soundPool != null && mPlaySounds) {
                    Log.d(TAG, "Playing Sound " + sound);
                    AudioManager mgr = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
                    int streamVolume = mgr.getStreamVolume(AudioManager.STREAM_MUSIC);
                    
                    
                    if (sound == SOUND_BOOM) {
                    	soundPool.play(this.mSoundBoom, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_GOAL) {
                    	soundPool.play(this.mSoundGoal, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_OW) {
                    	soundPool.play(this.mSoundOw, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_PRIZE) {
                    	soundPool.play(this.mSoundPrize, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    
            }
    }
```
In the code, if() statements are used to determine which sound effect is being specified by the calling function, and then the 'SoundPool' play(...) method is called.

### setEnabled() ###

The 'setEnabled(boolean enabled)' method is a simple setter method that passes a boolean value to the SoundPoolManager class. The method sets two global variables. One global that it sets is called 'mPlaySounds', and the other is called 'enabled'.

# Help java and Credits java #

These classes are almost identical and not very lengthy. The Help.java code is included here in it's entirety.
```
package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.os.Bundle;

public class Help extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.help);      
              
    }
}
```
Basically all the interesting material from these activities is included in their xml files. This is an example of the help.xml file.
```
<?xml version="1.0" encoding="utf-8"?>
<ScrollView 
xmlns:android="http://schemas.android.com/apk/res/android"
android:layout_height="wrap_content"
android:layout_width="fill_parent" 
android:orientation="vertical" 
android:scrollbars="vertical" 
android:scrollbarAlwaysDrawVerticalTrack="true"
>

<RelativeLayout
android:id="@+id/widget32"
android:layout_width="fill_parent"
android:layout_height="fill_parent"
xmlns:android="http://schemas.android.com/apk/res/android"
android:isScrollContainer="true" android:scrollbarAlwaysDrawVerticalTrack="true">

<TextView android:text="THE STORY: 
..."

android:background="@drawable/background"
android:textColor="#000000"
android:textSize="16sp"
android:textStyle="bold"
android:id="@+id/TextView01" 
android:layout_width="wrap_content" 
android:layout_height="wrap_content" >
</TextView>
</RelativeLayout>
</ScrollView>
```
In this listing the text from the TextView has been shortened. Most important after the text itself is probably the ScrollView element. It allows the text to scroll on the screen.

---

# In Closing #

Awesomeguy is a first attempt at programming an app for the Android phone. It is programmed in Java and uses the Eclipse IDE and Google Code's SVN repositories for version control. It also uses a JNI library to render it's graphical display. Information about this JNI library should be available from this wiki when it is completed.