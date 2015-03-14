# Introduction #

This document is supposed to explain how levels are constructed for the game.

# Details #

I plan to outline how to create new Awesomeguy levels here. Awesomeguy levels are incorporated in an 'awesomeguy.xml' file, and currently to use custom levels you need to build your own xml file and then include it in the Eclipse Java project (which can be downloaded from this site. See: [http://code.google.com/p/awesomeguy/source/checkout](http://code.google.com/p/awesomeguy/source/checkout)) and then make your own version of Awesomeguy from that. Soon a way will be made for the awesomeguy.xml file that you create to be loaded automatically from the android phone's sdcard. When that change has been made to the program this file will be updated. It is obvious that building the entire Eclipse Java project for Awesomeguy yourself just to incorporate your own levels in the game is a bit much for most readers, but for programmers the process wouldn't bee so difficult, and in any case the technical reader might find description of the process gives some incite into how the Awesomeguy game works in general. [top](ConstructingLevels#Introduction.md)

### Tools and Programs ###

The process requires that you have a working version of the 'Mappy' program. This program works well under Windows and in Linux under WINE. It can be found at [www.tilemap.co.uk](http://www.tilemap.co.uk/). Mappy is free.

A copy of the Awesomeguy tilesheet is needed. This can be found in the SVN repository of the program, in the folder awesomeguy/res/drawable. The file to use is any one of the 'png' files that start with the 'tiles' prefix. It may be necessary to check out the entire project in order to download this file. The tile may also be available on the Awesomeguy download page. See: [http://code.google.com/p/awesomeguy/downloads/list](http://code.google.com/p/awesomeguy/downloads/list)

A good text editor is required for the editing of the output of the Mappy program. It is also required for the constructing of the basic awesomeguy xml file before the Mappy data is added to it.

The 'sed' command was used to edit the Mappy data. The 'sed' command may not be available on all systems. On Windows systems it may be necessary to install cygwin or mingw to use 'sed'.  [top](ConstructingLevels#Introduction.md)

### Basic Structure ###

Since the file that we are trying to create is an xml file, it has a somewhat strict structure. Below is an example of the structure of the file if only two levels were added.

```
<?xml version="1.0" ?>
<game>
<level number="1">
<horizontal>64</horizontal>
<vertical>32</vertical>
<tiles_level>
	... this is where your mappy data
	goes for level 1 ...
</tiles_level>
<tiles_objects>
	... this is where your mappy data
	goes for level 1 ...
</tiles_objects>
<last_level>false</last_level>
</level>

<level number="2">
<horizontal>64</horizontal>
<vertical>32</vertical>
<tiles_level>
	... this is where your mappy data
	goes for level 2 ...
</tiles_level>
<tiles_objects>
	... this is where your mappy data
	goes for level 2 ...
</tiles_objects>
<last_level>true</last_level>
</level>

</game>
```

The data that's stored in the xml file in the spaces between the tiles\_level tags and between the tiles\_objects tags is in the form of comma separated values. These tables of comma separated values are large and are not shown in the listing above.

Note that the original awesomeguy.xml file holds ten levels, and at this time your xml file must hold ten levels also. For this reason someone looking to experiment with a single level might have better luck editing the original xml file with a text editor rather than try to create all ten required levels all at once.

Also note that there is a place in each level definition block for the horizontal and vertical dimensions of the level. It is important to fill these tags with the correct info from the Mappy program. They cannot be left blank and they cannot have the wrong value. Also note that the number of entries in the tiles\_level tags must be the same as the number of entries in the tiles\_objects tags. The Awesomeguy program uses the 'horizontal' and 'vertical' attributes in the xml file to turn the comma separated values into two identically sized tables. These tables are used by the game to draw the background of each level.  [top](ConstructingLevels#Introduction.md)

# Editing Your Level #

The first step to making a level is to know what your finished level will be like before you start. Make a sketch or diagram to work from, or develop a detailed plan in your head. One consideration is the size of the level. The level cannot be larger than 96 x 96 tiles, but it cannot be smaller than 32 tiles horizontal and 24 tiles vertical. If your map is smaller than this it will not display correctly on the screen and the game may crash.  [top](ConstructingLevels#Introduction.md)

### The Tilesheet ###

The tilesheet that has been created for Awesomeguy is very simple. There are three kinds of tiles. Firstly there are the colorful tiles that represent blocks and platforms and ladders. These are the vast majority of the tiles.

Then there are the blocks that are used strictly on the 'objects' array. These have special meaning for the game. There are approximately 12 of them. Eleven of them are located at the very bottom-right of the tilesheet. Their meanings will be discussed below. The twelfth one is located at tile nuber 5, and when it's used it represents the starting point for the main character. It's only separated from the other 11 because the tilesheet has evolved slightly over time and the tile in question was the first _special_ tile. It was given index number 5 and then that index number was not changed over time. The other special tiles were added later.

The third group of tiles is the number tiles. These tiles have all the info needed to print the numbers 0 through 9 and the two words 'level' and 'score'. Some versions of the program use this info to print the score on the screen. When creating levels for Awesomeguy you should generally avoid these tiles.  [top](ConstructingLevels#Introduction.md)

### Setting Up Mappy ###

Mappy is a complicated program and we only use a small portion of its functionality when we edit our levels. To start the editing process the first step is to start Mappy and go to the 'file' pull-down menu. Choose the 'New Map' option. The program displays a dialog window at this point. The window says 'Mappy: New Map (easy)'. Values in this dialog must be changed. The dialog says: 'Each tile is 32 pixels wide and 32 pixels high.' This must be changed so that the numbers '32' are replaced with the numbers '8'. Remember that each of our tiles is 8x8.

Do not dismiss the 'New Map' dialog yet. We must enter the ultimate size of our map in the spaces provided before we move on. The default says 'I want my map to be 100 tiles wide and 100 tiles high'. If we leave these values at their default the game will not run. The values must be lowered to at least 96, but you may decide to make them much lower than that. Remember these values because you need to use them in the xml file inside the 'horizontal' and 'vertical' tags.

The 'New Map' dialog also has settings for Colors, which are in the form of radio buttons for 'True Color' or 'Paletted (8 bit)' color. For our purposes the default works fine. Click 'OK'. Another dialog pops up to remind you to load the tilesheet. That's the next step.

Go to the 'File' pull-down menu again and select the 'Import...' option. A box opens that allows you to specify which file to use as your tilesheet. Use the 'tiles1.png' file that you download from the Awesomeguy Downloads site. See: http://code.google.com/p/awesomeguy/downloads/list . If you are having trouble using ping files with Mappy, go to the Mappy site and follow instructions there for adding ping support to your Mappy installation. See: http://www.tilemap.co.uk/pngfiles.html .  [top](ConstructingLevels#Introduction.md)

### Using Mappy ###

At this point we start editing the actual layers that will become our game arrays. When we get to this step the Mappy program automatically creates one blank map layer for us. It is called 'Layer 0' in the 'Layer' menu. We can use this layer for the 'level' array that we need for our game. Later we'll add another layer for the 'objects' array. Before we do anything else, though, this might be a good time to save the Mappy file that we've created so far. This gives us a chance to name the file. Simple names are best, but it really doesn't matter what you name it. Mappy files have the '.fmp' filename extension.

The object of our editing right now is to add all the blocks that go into how the level looks _without_ rings or prizes or goals. Essentially you have to imagine that you are adding colorful bricks that we will later turn into hard surfaces. You can add ladders at this stage also. Do not add any monsters or special characters. These blocks are going to be what the player sees. They do not effect what actually happens in the game, so if you use blocks that are designed for special purposes the player will be confused. They will not work properly.

To place a block on layer 0, select the block from the right-hand panel of the Mappy editor and move the cursor over the left hand panel. The left hand panel represents your array editing area. Click anywhere here to place the block on the screen. When you've created a screen that has all the visible architectural elements (walls and floors and ladders and pillars) you can go on to the next stage.  [top](ConstructingLevels#Introduction.md)

### Adding A Layer ###

Go to the 'Layer' menu and select the 'Add Layer' option. The editor screen on the left may seem to go blank at this point. You are now working with two layers. By default the new layer is called 'New layer'. To switch between layers, go to the 'Layer' menu and select the layer that you are interested in. The active layers should be printed in bold type, and the one that you are editing should have a check mark next to it. You should have two layers now called 'layer 0' and 'New layer'. The second layer is for editing the 'objects' array.

Your goal at this point is to place blocks on the screen from the tilesheet that will tell the game how to represent the visual information that you placed on 'layer 0'. This is a short description of the meaning of each block.

  * The starting position of the main character. This block looks like an 'x' and is in position 5.
  * The starting position for floating platforms. This block looks like a 'p' and is in position 437.
  * The symbol for an extra life. This block is green with a red dot and is in position 438.
  * The symbol for instant death. This block looks like a bunch of vertical black lines and is in position 439.
  * The symbol for a gold brick. This block looks like a gold square with a tan dot and is in position 440.
  * The special marker block. This block looks like a 'M' and is in position 441.
  * The 'solid object' marker. This block looks like a number of black and white squares and is in position 442.
  * The start position for a monster. This block looks like a red and white swirl and is in position 443.
  * The ladder block. This block looks like several horizontal black lines and is in position 444.
  * The checkpoint block. This block looks like a golden key and is in position 445.
  * The goal block. This block looks like a white diamond shape and is in position 446.
  * The ring block. This block looks like a red circle and is in position 447.

> [top](ConstructingLevels#Introduction.md)

### Onion Skin ###

The most common task when working on the 'objects' layer is the placement of the 'solid' block. This is the one that looks like a bunch of nested black squares. The goal is to place on of these blocks in every location that needs to be interpreted as a solid wall or floor. This is difficult because when you go to the 'Layer' menu and select 'Layer 0' you can see the drawings of all these floors and walls, but you cannot see them when you select 'New Layer' from the same menu. The solution is to select 'New Layer' (the layer that is to represent the 'objects' array) and then to enable the 'Onion Skin' function. This function is located at the bottom of the same 'Layer' menu in Mappy.

Go to the 'Layer' menu and select 'Onion Skin'. A small dialog box comes up with two checkboxes and a field for a number. The first checkbox is 'Enable Onion Skin'. This is the option we're interested in. Check this checkbox. The other checkbox is 'Edit layer in front' and this should remain checked. The numeric input field has the number 0 in it and it should remain the same. After you click OK you should be able to see the tiles that you placed on the 'Layer 0' layer, and at the same time place new tiles on the 'New Layer' layer.

With Mappy set up in this way you can edit the 'Layer 0' layer for visual elements, and then switch to the 'New Layer' layer for structural elements. When editing the 'New Layer' layer you will be able to see what you added for visual display, and therefore you'll be able to place your 'New Layer' blocks correctly. Be careful, though, as in this setup the 'New Layer' and 'Layer 0' look very much like each other. Remember there is a bold check mark next to the name of the level that you are working on if you pull down the 'Layer' menu. Also the layer name is printed above the left hand panel, along with information about what block the cursor is hovering above.  [top](ConstructingLevels#Introduction.md)

### Finish Editing ###

There are only a few things that are strictly necessary for a level to be complete. There must be an entry in the 'objects' array for the character's start position. This is tile number 5. There must be an entry in the 'objects' array for the level's goal, the object that, when encountered, brings the character to the next level. If just these two things are placed on the 'New Layer' layer the game will play.  [top](ConstructingLevels#Introduction.md)

#### Solid Objects ####

You will want to add other elements. Adding solid walls and floors is a two step process. First you draw the wall on 'Layer 0' and then you cover the exact same boxes -- with the solid object tile -- on the 'New Layer' layer.  [top](ConstructingLevels#Introduction.md)

#### Rings ####

Rings, the objects that you gather to accumulate points, go on the 'objects' layer. They are automatically printed on the Awesomeguy screen by the program. Extra lives and gold bricks are the same way, as are checkpoints.  [top](ConstructingLevels#Introduction.md)

#### Ladders ####

Ladders are like solid objects. You must first copy a symbol on the 'Layer 0' layer for the ladder, and then you copy the ladder object tile to the 'New Layer' layer in the same exact place. The ladder tile can be any tile at all, but tile 257 is used commonly. The ladder objects tile looks like a set of horizontal black and white lines.  [top](ConstructingLevels#Introduction.md)

#### Monsters ####

Monsters can be placed on a level by simply putting the 'monster' block on the objects level, but they have a special behavior. The monster block defines the starting location of the monster sprite. The monster sprite travels to the right until it comes to the end of the platform it's on or until it comes to an obstacle. Then it turns around. For this reason you want to make sure you place your monsters on a platform, not floating in the air. If you put them floating in the air they think that they must turn around constantly and as a result they don't go anywhere, they just constantly switch from left-facing image to right-facing image without stopping. If you place a monster on a solid platform and you want to impede it's movement you can place a marker on the 'objects' layer that tells the monster sprite to turn around when it is encountered. This marker looks like a white box with an M in it and is located at tile position 441. Marker tiles do not appear on the screen.  [top](ConstructingLevels#Introduction.md)

#### Floating Platforms ####

Floating platforms are like monsters in many ways except they're supposed to be placed in the air. When their tile is placed on the 'objects' layer a moving platform will appear in the game. The tile will slowly move to the right until it encounters a solid object and then it moves to the left in the same way. The invisible marker block -- with an M in it -- can also be used with floating platforms. The marker serves as an instruction to the platform to stop moving in one direction and start moving in the other.  [top](ConstructingLevels#Introduction.md)

### Text Files ###

The Mappy program is then used to convert the images on the screen to text files representing the maps for the two layers. The tilesheet is already incorporated into Awesomeguy, so we are not concerned with saving this material. Go to the 'File' menu and select the 'Export As Text...' option. A dialog box will open up for this purpose.

The text file that we are trying to produce is essentially composed of three major parts. There will be a C type array for the 'Layer 0' layer, there will be another C type array for the 'New Layer' layer, and optionally there will be a colormap. The colormap is unimportant to us, so we either edit it out using a text editor, or we disable it entirely in the 'Export As Text...' dialog box.

The settings on this dialog box can be left the same, for the most part. You might want to uncheck the checkbox labled 'Colour Map'. This will disable the printing of the color map to your text file. You might want to make sure that the radio button for 'All Layers' is selected, as well as the radio button for '2D format'. The '1D format' radio button can be experemented with as well.

For this explanation a small level will be created in Mappy of the size of 5x5 named 'test.fmp'. Remember that for the actual game the horizontal tile measurement must be at least 32 and the vertical tile measurement must be at least 24. Also the '1D format' radio button is checked and the 'Colour Map' checkbox is unchecked. The resulting text file will be named 'test.TXT' by the Mappy program. See the listing below.

```
const short test_map0[25] = {
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
113, 113, 113, 113, 113,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0

};

const short test_map1[25] = {

0, 5, 0, 0, 0,
0, 0, 0, 0, 446,
442, 442, 442, 442, 442,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0

};
```

This is the total contents of the file. The file has to be edited and the edited parts need to be placed in the xml file.  [top](ConstructingLevels#Introduction.md)

### Text Editor ###

The Mappy program puts the two arrays that we're interested in in C style arrays. The array labeled 'test\_map0' is going to be used as the 'level' array in Awesomeguy, and the array labeled 'test\_map1' is going to be used as the 'objects' array in Awesomeguy. The xml file uses comma separated values, so we use a text editor to copy and paste the numbers from the text file into the xml file in a large block. The game ignores white space but doesn't ignore curly braces, semicolons or letters. For example, for the level array we edit the file down to the following block:

```
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
113, 113, 113, 113, 113,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0
```

Then we edit the objects data down to the following block:

```
0, 5, 0, 0, 0,
0, 0, 0, 0, 446,
442, 442, 442, 442, 442,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0
```

The xml file, therefore, would look like this:

```
<?xml version="1.0" ?>
<game>
<level number="1">
<horizontal>5</horizontal>
<vertical>5</vertical>
<tiles_level>
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
113, 113, 113, 113, 113,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0
</tiles_level>
<tiles_objects>
0, 5, 0, 0, 0,
0, 0, 0, 0, 446,
442, 442, 442, 442, 442,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0
</tiles_objects>
<last_level>false</last_level>
</level>

<level number="2">
<horizontal>64</horizontal>
<vertical>32</vertical>
<tiles_level>
	... this is where your mappy data
	goes for level 2 ...
</tiles_level>
<tiles_objects>
	... this is where your mappy data
	goes for level 2 ...
</tiles_objects>
<last_level>true</last_level>
</level>

</game>
```

We also changed the 'horizontal' and 'vertical' tags to hold sensible values. You must edit each level you create and add it to your xml file in the same way.  [top](ConstructingLevels#Introduction.md)

### Sed ###

If you decide to 'Export As Text' using the '2D format' your arrays will look like this:

```
const short test_map0[5][5] = {

{ 0, 0, 0, 0, 0 },

{ 0, 0, 0, 0, 0 },

{ 113, 113, 113, 113, 113 },

{ 0, 0, 0, 0, 0 },

{ 0, 0, 0, 0, 0 }

};
```

You can use a text editor to edit the array down to a text block that looks like this:

```
{ 0, 0, 0, 0, 0 },

{ 0, 0, 0, 0, 0 },

{ 113, 113, 113, 113, 113 },

{ 0, 0, 0, 0, 0 },

{ 0, 0, 0, 0, 0 }

```

Then you can insert the text block into the xml file like this:

```
<?xml version="1.0" ?>
<game>
<level number="1">
<horizontal>64</horizontal>
<vertical>32</vertical>
<tiles_level>
{ 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0 },
{ 113, 113, 113, 113, 113 },
{ 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0 }
</tiles_level>
<tiles_objects>
{ 0, 5, 0, 0, 0 },
{ 0, 0, 0, 0, 446 },
{ 442, 442, 442, 442, 442 },
{ 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0 }
</tiles_objects>
<last_level>false</last_level>
</level>

<level number="2">
<horizontal>64</horizontal>
<vertical>32</vertical>
<tiles_level>
	... this is where your mappy data
	goes for level 2 ...
</tiles_level>
<tiles_objects>
	... this is where your mappy data
	goes for level 2 ...
</tiles_objects>
<last_level>true</last_level>
</level>

</game>
```

Since the xml file does not contain any other curly braces, you can run the entire xml file through a program like 'sed' to remove all the curly braces from the arrays. Here the file 'raw.xml' represents the listing above. The commands look like this:

```
sed s/{// raw.xml > raw2.xml
sed s/}// raw2.xml > awesomeguy.xml
```

Then, when you're certain that the changes have been made properly, you can delete raw.xml and raw2.xml :

```
rm raw.xml raw2.xml
```

Finally, if you want you can use the search and replace functions of your favorite text editor to erase the curly braces instead of sed if you find that easier.  [top](ConstructingLevels#Introduction.md)

# Finished Level #

At this point you have a finished awesomeguy.xml file. To use it download the Awesomeguy project from code.google.com and set it up in your Android ready Eclipse IDE. Replace the awesomeguy.xml file that is packaged in the /res/xml folder.

In early versions of the game you must change the number of levels that the game recognizes to the number in your xml file. This can be done by going to the GameValues Class and editing the line that reads like this at the beginning of the file. The declaration can be found under the commented line `/* game progress */`.

```
	public static int NUM_ROOMS = 10;
```

Build the project and run it on your android device. If the line above is commented out, do not worry about editing it. You have a later version of the game and the change is not necessary.  [top](ConstructingLevels#Introduction.md)