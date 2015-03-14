# Introduction #

Here we'll go through the steps of writing your own JNI library to use with the Android platform. We'll also touch on setting up your Android app editing environment using Eclipse.



# Overview #

Before you create your Android JNI file you need a working project, and before that you need a working development environment. In this tutorial we'll briefly cover setting up your eclipse IDE for java development, and we'll go on to cover Android JNI/NDK.

JNI stands for 'Java Native Interface' and NDK stands for 'Native Development Kit'. We'll use the two terms somewhat interchangeably but they could also be used to define very specific and different things. JNI could be used to define all Java applications that use native code, whereas NDK would be more related to the Android system in specific.  [top](JNITutorial#Introduction.md)

# Setup Environment #

Here we'll start looking at Eclipse and Android plugins. Awesomeguy was programmed on a debian-based linux computer. Instructions for installing software are generally written with a linux operating system in mind. However, Android apps can be successfully written on Windows computers, and all of the tools mentioned here have windows equivalents.  [top](JNITutorial#Introduction.md)

### File Folder Organization ###

If you're using linux, all your data should be kept in your home directory. You _can_ put things in your Desktop directory, but it's not encouraged. The linux setup that the author uses includes a 'bin' directory in the 'home' directory. All the development tools and folders were placed there. This lessened the clutter of the 'home' directory. Also, the author used the 'bash' command interpreter. The '.bashrc' file was edited so that a PATH variable included the user's 'bin' directory. This way scripts could be written that automated difficult tasks. The scripts were placed in the user's 'bin' folder, and were therefore included in the user's path.

If you're using Windows, you should probably place downloaded packages at the root of the '`c:\`' directory. This does not apply to software that has built-in installers. Such software installs itself. Packages that don't have installers should go in '`c:\`' because then you can refer to the package on the command line easily without concern for spaces in the names of the folders or files. This is sometimes a concern if you use cigwin and mingw. Also, even if you're not concerned with spaces in your directory names, placing folders and files at the root of the '`c:\`' directory makes all references to them shorter (there is less typing involved).  [top](JNITutorial#Introduction.md)

### Java ###

You will need a working version of Java on your computer to compile Android code. Sometimes you can run into problems if the version of Java you are using is not the official java. Oracle is the company responsible for the official java download at the time of this writing.

For distributions of linux that use complex packaging systems, java can usually be downloaded as a package. In a debian-based linux system, more than one version of Java is available. The command `update-alternatives` may be employed to make sure that the correct java implementation is being used on your system after the java packages are downloaded.

You are interested in java 'jre' and java 'jdk', as well as anything else they require to operate correctly. Java 'jre' is the 'Java Runtime Environment' and it allows you to run Java programs. Java 'jdk' is the 'Java Development Kit' and it allows you to compile Java programs.

Java linux packages install to special directories reserved for programs and their associated files. You do not have to worry about where your system puts the Java packages as it installs them. Similarly Java Windows installers place the java software where it needs to be, and you usually don't need to worry about its location.  [top](JNITutorial#Introduction.md)

### Eclipse ###

At the time of this writing, if you go to the Eclipse IDE web site, you'll find that the most recent version of Eclipse is 'Eclipse Helios' version 3.6.1 however that version won't work with the Android Development Kit. The link for the eclipse home page is:

http://www.eclipse.org/

The main reason for using a specific version of Eclipse is because of the compatibility with the Android development software. In the future this software will certainly be updated, so later versions of Eclipse may work for you.   [top](JNITutorial#Introduction.md)

#### Download Eclipse ####

Go to the eclipse home page and click the button for downloads. Do not download Eclipse Helios on this page. Look for a link for 'Older Versions'. Awesomeguy was written on 'Galileo' version 3.5.2.

For linux users the file that you download will be called something like '`eclipse-java-galileo-SR2-linux-gtk.tar.gz`'. Set the eclipse `tar.gz` package aside.  [top](JNITutorial#Introduction.md)

#### Unpack Eclipse ####

Unpacking Eclipse on a linux system can be accomplished using a gtk application like 'file-roller' or you can use the 'tar' command from the command line. We'll cover the command line option. First place the 'tar.gz' file that you downloaded in the location that you want Eclipse to actually be in. Then type the command below.

```
tar xvzf eclipse-java-galileo-SR2-linux-gtk.tar.gz
```

You can use tab completion to make sure that you're spelling the name of the Eclipse download correctly. The 'tar' program will unpack the 'tar.gz' file and place the Eclipse folder in the current directory. After this is done you will have a directory named 'eclipse' and also the original downloaded file in your directory. You can dispose of the original download, or save it somewhere for safe keeping as you like.

If you are using Windows, unpack the eclipse folder in the '`c:\`' directory. You will want to make a shortcut on the desktop to the eclipse executable.  [top](JNITutorial#Introduction.md)

#### Running Eclipse ####

Assuming that you are still in the directory where you unpacked eclipse, and assuming the eclipse program is installed in a directory called 'eclipse', and assuming you're on a linux operating system, you can run eclipse by typing 'eclipse/eclipse' at the command line. You might want to make a launcher of some kind on your desktop, but doing so is beyond the scope of this wiki.

If you are on a Windows operating system, the name of the eclipse executable is 'eclipse.exe' and the name of the eclipse folder will vary with the exact version you've downloaded. Still, the concept for starting the executable is the same. You type some variation on the following
```
c:\path\to\eclipse\eclipse.exe 
```

You will want to make a Desktop shortcut to the eclipse executable on Windows.

Make sure you can write and compile java code on Eclipse before moving on to the next step.  [top](JNITutorial#Introduction.md)

### Android SDK ###

The link to the Android SDK download page is below. It is very helpful to read on line all the Android documentation possible. The 'developer.android.com' site is a source for instructions for beginners and experienced users alike.

http://developer.android.com/sdk/index.html

On the site you will find Android SDK packages for Windows, Mac, and Linux. Choose the package that's right for you.  [top](JNITutorial#Introduction.md)

#### Download Android SDK ####

The Windows package is called 'android-sdk\_r07-windows.zip'. The linux package is called 'android-sdk\_r07-linux\_x86.tgz'. The windows package is 'zip' compressed and the linux package is 'tgz' compressed. After you have downloaded one of the packages that matches your system, set it aside for the next step.

You can also chack the MD5 check sum to see if your download completed without corrupting data. The MD5 sum is shown on the page next to the download link.  [top](JNITutorial#Introduction.md)

#### Unpack Android SDK ####

Move the compressed file to the directory where the file will reside. I put the files in the '`~/bin`' folder. Unpack with the tools provided by your operating system. In this tutorial we will use the 'tar' command. The command for unpacking the linux package is below. You can use tab completion to ensure that you are spelling the name right.

```
tar xvzf android-sdk_r07-linux_x86.tgz
```

When this is done there will be a folder named 'android-sdk-linux\_x86' in your destination folder. The directory 'android-sdk-linux\_x86/tools' should be added to your path at this time. This requires you edit your '.bashrc' file again. For simplicity I renamed the folder 'android-sdk-linux\_x86' to 'android-sdk-linux' so that when I was editing my '.bashrc' file I had less typing to do. The lines in the '.bashrc' file look like this.
```
if [ -d /home/myname/bin/android-sdk-linux/tools ] ; then
    PATH=${PATH}:/home/myname/bin/android-sdk-linux/tools
fi
```
For a Windows setup, you might simply place the unpacked folder in the '`c:\`' location and then create a desktop shortcut to the executables in the 'tools' sub directory as needed.  [top](JNITutorial#Introduction.md)

#### SDK And Eclipse ####

Information about the Eclipse plugin for Android development can be found at the following location.

http://developer.android.com/sdk/eclipse-adt.html

Instructions on this site explain installing the Eclipse ADT for Eclipse Ganymede and Eclipse Galileo. We will focus on Galileo. The basic concept is that we need to give a URL to Eclipse so it can search for and download the proper plugin. The URL is below. Copy and Paste it into the URL field of the dialog specified.

`https://dl-ssl.google.com/android/eclipse/`

Note: clicking on this URL does not install the Android Eclipse plugin. The proper steps are listed below. You need internet access to perform these steps.

  1. Start up Eclipse
  1. Select the **Help** menu
  1. From that menu select the **Install New Software** option
  1. From the **Available Software** dialog click **Add...**
  1. The **Add Site** dialog will appear
  1. Enter a name in the **Name** field (something like 'Android Plugin')
  1. Enter this URL in the **Location** field
  1. Click **OK**
  1. Go back to the **Available Software** dialog. You should see options for **Developer Tools**
  1. Click the checkbox next to **Developer Tools**
  1. Click **Next**
  1. An **Install Details** dialog is displayed
  1. Read Licensing Agreements and accept dependencies, ultimately installing the software.
  1. Click **Next** and **Finish**

Eclipse will ultimately ask you if it can restart itself. Do this now. After installing the plugin you must configure it. Instructions for configuring the plugin for Eclipse can be found on the same page as the plugin installation instructions themselves. They are repeated here for convenience.

  1. Start up Eclipse
  1. Select the **Window** menu
  1. Select **Preferences...** from the menu
  1. Select **Android** from the left panel to show the Android preferences
  1. Configure **SDK Location** by clicking **Browse...** and browsing to your sdk directory.
  1. Click **Apply** and **OK**

For Awesomeguy an SVN repository is used. Installing the SVN software on Eclipse is beyond the scope of this tutorial. Make sure you can create a new emulator and that you can start it and run your app on it using the Eclipse IDE. This will show weather your setup works.  [top](JNITutorial#Introduction.md)

### Android NDK ###

The site for downloading the Android NDK packages is below. As always, the documentation that can be found on the site and in the actual package itself is really great.

http://developer.android.com/sdk/ndk/index.html

As before, we'll focus our tutorial on the linux operating system. At this point in the tutorial it should be noted that the Android NDK for Windows requires the installation of 'cygwin' version 1.7 or higher. Installing 'cygwin' is beyond the scope of the tutorial. A link for installing and using 'cygwin' is enclosed here.

http://www.cygwin.com/

Cygwin is a linux-like environment for Windows.  [top](JNITutorial#Introduction.md)

#### Download Android NDK ####

At the time of this writing the linux NDK package is called 'android-ndk-r4b-linux-x86.zip'. The Windows NDK package is called 'android-ndk-r4b-windows.zip'. Download it from the site and set it aside.  [top](JNITutorial#Introduction.md)

#### Unpack Android NDK ####

For Windows move the 'android-ndk-r4b-windows.zip' file to the '`c:\`' directory. Unpack the zip file there. The documentation that comes with the windows android ndk package (located in the package at '`docs\INSTALL.TXT`') states that cygwin is needed for proper operation.

So far for linux we've placed the Android SDK in the '`~/bin`' folder. We'll do the same with the NDK software. Place the zipped file in the '`~/bin`' folder and unzip it with a tool like 'file-roller' or 'unzip'.

In order for the build tools to work from the command line you need to add the resulting folder to the PATH variable. Again, we'll edit '.bashrc'. Add these lines to the end of your '.bashrc' file.

```
if [ -d /home/myname/bin/android-ndk-r4b/ ] ; then
    PATH=${PATH}:/home/myname/bin/android-ndk-r4b/
fi
```

After the changes are made to your '.bashrc' file, close your terminal and open it again (or log out and log in again).  [top](JNITutorial#Introduction.md)

# Reading Documentation #

Some very good documentation comes as part of the Android NDK package. Also included in the NDK package are some good example files. There is also a wealth of documentation on line. On line, you can find documentation about native code development for java in general as well as specifically for Android phones.

A good place to start is the page that you download the NDK package from originally.

http://developer.android.com/sdk/ndk/index.html

Scroll down on this page for information on using the 'ndk-build' command for the first time. The documentation on this page also directs you to read the instructions that come with the ndk package. Look in the package under 'docs/OVERVIEW.TXT'.  [top](JNITutorial#Introduction.md)

# Basic Procedure #

The steps that you have to take to develop JNI libraries for Android phones are simple in principle. They are outlined below.

  * Install the JNI/NDK package from Google
  * Create your Android project
  * Make a JNI folder in your Android project root directory (called 'jni')
  * Put your JNI sources in the 'jni' folder
  * Create an 'Android.mk' file, and place it in the 'jni' folder
  * Optionally create an 'Application.mk' file, and place it in the 'jni' folder
  * Open a command line terminal and navigate to the root directory of your Android project.
  * Execute 'ndk-build', (if it's in your PATH variable) or execute '/path/to/command/ndk-build'
  * The 'ndk-build' command creates the binary for your library and puts it in the proper folder.
  * Switch to Eclipse, Refresh the 'Project Explorer View' (F5)
  * Rebuild the project
  * Run your project testing your JNI library.

The tutorial will now attempt to go through these steps. We will skip the 'Install the JNI/NDK' step as it's already been covered.  [top](JNITutorial#Introduction.md)

### Create Android Project ###

This step entails using Eclipse to create a new Android project. This project will have a folder in the Eclipse 'workspace' directory. The location of the 'workspace' directory and the project directory inside it should be known to you. The 'project' directory name is the name of your project to eclipse.

On a linux system the 'workspace' directory is commonly located in the user's home directory. The project is inside it. When this or other documentation refers to the project's root, for a project named 'projectname', they would be referring to the following path.

`/home/myname/workspace/projectname/`

This is important for steps where you create the 'jni' folder and where you call the 'ndk-build' script.  [top](JNITutorial#Introduction.md)

### Make JNI Folder ###

A folder named 'jni' (lowercase) must be created by you in the Eclipse project's root directory. In a linux system where the user is called 'myname' and the project is called 'projectname', this folder would be located in the 'projectname' folder, as referred to by the following path.

`/home/myname/workspace/projectname/jni/`

This would place a folder at the same level as the Eclipse/Java 'bin', 'src', and 'res' folders. It would also be at the same level as the 'AndroidManifest.xml' file. Inside this folder is where the source c or c++ documents need to be placed.

If you use Eclipse to create this folder, then you are done with this step. If you create the folder from the command line, don't forget to type F5 or click on 'Refresh' to let Eclipse register that there has been a change to the folder structure.  [top](JNITutorial#Introduction.md)

### JNI Sources ###

Here you work on the actual source files in c or c++. You will probably return to this step many times as your JNI library evolves. A large part of this how-to is focused on showing how c can be used to create a simple JNI library like the one used in the Awesomeguy program.

This document will explain the creation of a JNI library consisting of a single source file. Choose a name for your file and place it in the 'jni' folder. For this document the library will be called 'example' so the file will be called 'example.c'. On a linux system the path to the 'example.c' file will look something like the path shown below.

`/home/myname/workspace/projectname/jni/example.c`

After placing the file 'example.c' in the 'jni' folder you should refresh Eclipse so that it recognizes the new file. The file 'example.c' should be a simple text file. To edit the file you need a regular text editor. On linux systems, when viewing the project from Eclipse, if you double click on the file 'example.c' in the Project Explorer view, the system's text editor is automatically opened with 'example.c' loaded. You can then make changes and save and re-compile the source code.   [top](JNITutorial#Introduction.md)

### Create Android mk File ###

Before the NDK build tools will compile your code they need a 'Makefile' file. That's the purpose of the file 'Android.mk'. Because our project only uses a single source file for the JNI library, our 'Android.mk' file will be simple to write. Information on writing the 'Android.mk' file can be found in the 'docs' folder inside the 'android-ndk-r4b' folder. The most relevant document is the 'ANDROID-MK.TXT', and this document does a thorough job of explaining the parts of the file that are required.

An example 'Android.mk' file is shown below. This file is taken from the Awesomeguy project.

```
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := awesomeguy
LOCAL_CFLAGS    := -Werror
LOCAL_SRC_FILES := awesomeguy.c
LOCAL_LDLIBS    := -llog 

include $(BUILD_SHARED_LIBRARY)
```

For the purposes of this tutorial we'll leave most of the file as it is.

  * LOCAL\_PATH - this line should be left as it is since your source file ('example.c') is in the same directory as the 'Android.mk' file.
  * include $(CLEAR\_VARS) - this line should be left as it is. It is required.
  * LOCAL\_MODULE - this line should be changed to match your module name. For this tutorial we'll change it to 'example'. This name should not have any spaces in it as it will be made into the actual library's name ('libexample.so' for us).
  * LOCAL\_CFLAGS - This line can be left as it is. It is for compiler flags.
  * LOCAL\_SRC\_FILES - this line should be changed to 'example.c' since that's our source file.
  * LOCAL\_LDLIBS - leave this the same.
  * include $(BUILD\_SHARED\_LIBRARY) - leave this the same.

So our new 'Android.mk' file should look like this.

```
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := example
LOCAL_CFLAGS    := -Werror
LOCAL_SRC_FILES := example.c
LOCAL_LDLIBS    := -llog 

include $(BUILD_SHARED_LIBRARY)
```

The NDK build tools will compile the code, and then if there are no errors it will name the object code 'libexample.so' and place it in the Android project in a new folder that it creates especially for this purpose. The name of the folder is '`libs/armeabi/`'. The build tools also manage the creation of some other files that are necessary.

The name, 'libexample.so' comes from the 'LOCAL\_MODULE' line in the 'Android.mk' file, and it is the library name, but when referring to the module in the java code you refer to 'example' not 'libexample.so'.   [top](JNITutorial#Introduction.md)

### Go To Project Root ###

The project root is the base folder for the Eclipse Android project. It's found in the 'workspace' directory. It is _not_ the 'jni' folder, but instead its parent. Using the conventions we've been following for linux systems, the path to the project root directory would be the following.

`/home/myname/workspace/projectname/`

You want to 'cd' into this directory from the command line.  [top](JNITutorial#Introduction.md)

### Execute Build Command ###

The command to start the build scripts is called 'ndk-build'. The script for 'ndk-build' is located in the Android NDK package of software that you already downloaded. If you followed the tutorial so far, you would have placed the 'android-ndk-r4b' folder in your 'bin' directory, and then you would have added it to your path. If this is the case, simply type 'ndk-build' at the command line.

If you didn't put the 'android-ndk-r4b' folder in your PATH variable in the '.bashrc' file, then you can explicitly specify the path to the 'ndk-build' script when you invoke it. The command for this is shown below.  [top](JNITutorial#Introduction.md)


`/home/myname/bin/android-ndk-r4b/ndk-build`



### What Build Command Does ###

The ndk-build script compiles the source code for the Android project and places it in a directory where it can be included by the Eclipse build function in the final apk file.

The folder where the resulting binary library goes is the '`libs/armeabi/`' folder. Two other files are placed in that folder along with the JNI library that we are creating. They are created automatically, so we're not going to worry about them. One is the 'gdb.setup' file, and one is the 'gdbserver' file.   [top](JNITutorial#Introduction.md)

### Refresh Project Explorer View ###

The 'Project Explorer' is one of the Eclipse windows that is visible when doing standard editing on the default Java perspective. It is commonly on the left side of the Eclipse screen. It shows all the files and folders in a project. You can refresh the view by selecting a project and then pressing the `<F5>` key, or by right clicking on the project name and selecting 'Refresh' from the menu that is displayed.  [top](JNITutorial#Introduction.md)

### Rebuild Project ###

Like refreshing the project, you can rebuild the project by right clicking on the project name in the Project Explorer and then selecting 'Build Project' from the menu that's displayed. Some activities, like the 'Run' activity, automatically rebuild the project when the Eclipse IDE sees that the project has changed.  [top](JNITutorial#Introduction.md)

### Test Project ###

Test your project thoroughly. This step goes without saying.

# Writing JNI Sources #

For our purposes here we want to build a JNI library from a single c source file. It is possible to use c++ and several source files, but we're not going to do that.

We need to be able to write methods that can be called in java code. We need to be able to pass variables to the library and pass variables from the library to java.

We will assume that the JNI library that we're using is called 'libexample.so', and that the module name, as defined in the 'Android.mk' file is 'example'. We'll also assume that the package name for the Android project we're working on is something simple. We'll use this.

`org.testjni.android`

This means you have a line in your program files that looks like this.

```
package org.testjni.android;
```

It also means that there is a file folder structure in your Eclipse project under 'src' that looks like this.

`src/org/testjni/android/`

We'll assume that the Java file that we want to call the JNI from is called 'Game.java'.

In your JNI library source file you must '`#include`' the library 'jni.h'. Including the library would look like this. Including this library ensures that the source file you are working on will compile.

```
#include <jni.h>
```

> [top](JNITutorial#Introduction.md)

### Naming Functions ###

#### Example One ####

The naming conventions for these methods are fairly complex. The average JNI native function name is unwieldy and looks something like this:
```
JNIEXPORT void JNICALL 
Java_org_testjni_android_Game_someFunction(JNIEnv * env, jobject  obj)
{}
```

In this example the method body is empty. The java native method 'someFunction()' would call the c function above. The name for this c function can be broken down into parts. The first part is the information before the method name. This is listed below.
  1. the macro JNIEXPORT
  1. the return type for the method ('void' in this example)
  1. the macro JNICALL

After that comes the actual name of the method. The name can be broken down into parts. They are listed below. The parts are separated by underscores.
  1. the text '`Java_`'
  1. the text for the package name of the Android app, with the periods replaced by underscores
  1. the name of the class that the function will be part of
  1. the name of the function

This is followed by the two mandatory parameters '`JNIEnv * env`' and '`jobject obj`'. Other parameters for the function could have followed the mandatory ones listed above.  [top](JNITutorial#Introduction.md)

#### Example Two ####

```
JNIEXPORT int JNICALL 
Java_org_testjni_android_Game_someFunction(JNIEnv * env, jobject  obj)
{
return 3;
}
```

In this example the method body is the 'return' statement that returns the number 3. The java native method 'someFunction()' would call the c function above. Note that the return type is 'int' not 'void'. This is as you would expect from a c function.  [top](JNITutorial#Introduction.md)

#### Example Three ####

```
JNIEXPORT void JNICALL 
Java_org_testjni_android_Game_someFunction(JNIEnv * env, jobject  obj, jint x)
{
int xx = x;
return;
}
```

In this example the method body is not empty, but performs only a trivial task. The java native method 'someFunction(int x)' would call the c function above. In all examples the first two parameters to the c function are mandatory. The variables '`JNIEnv * env`' and '`jobject obj`' are included in all functions that are going to be called from the java code.

NOTE: You must '`#include`' the library '`jni.h`' at the beginning of your source file for these functions to compile right. That would look like this. Do not forget this step.

```
#include <jni.h>
```

> [top](JNITutorial#Introduction.md)

### Java Declaration ###

There are two parts to the java declaration for the example code that we are using for this explanation. One part loads the library, and another part makes reference to the method so that the other java code in the app can call it. The declaration looks like the code below.
```
static {
	System.loadLibrary("example");
}
```
This code has to be included in the Java class where the JNI is to be used. The second part of the java listing would look as follows.
```
public native void someFunction();
```
This line of code is like a java method declaration _without_ the body. This function is also 'public' so it can be called by methods of other classes if they have an instantiated version of the class 'Game'.

You should note that the c method declaration is different from the java declaration, but you need both, and the c version must include the package name and the java class name.  [top](JNITutorial#Introduction.md)

### Passing Arrays ###

One thing that was essential in the awesomeguy.c file was the passing of arrays between the JNI code and the Java code. In awesomeguy the bitmaps for the main character and the other graphic elements were converted to arrays in the java code and then passed to the JNI library during the class instantiation phase. When it was time to draw the actual screen, the JNI code assembled a large array that was passed back to the java code. In java the array was converted to a bitmap and displayed on the screen.  [top](JNITutorial#Introduction.md)

#### Arrays as Parameter ####

Here is an example of code actually used in the awesomeguy.c JNI file. It shows how a '`jintArray`', which is an array of integers, can be passed to a JNI library. It also shows the processing that's needed to access the data in the manner of a c int array.

Note that the first two parameters to the JNI method are always the same. They are '`JNIEnv * env`, and `jobject  obj`'. After that the method can be customized in different ways.

```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setTileMapData(JNIEnv * env, jobject  obj,
jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{
  //jsize a_len = (*env)->GetArrayLength(env, a_bitmap);
  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  //jsize b_len = (*env)->GetArrayLength(env, b_bitmap);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  //jsize c_len = (*env)->GetArrayLength(env, c_bitmap);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  //jsize d_len = (*env)->GetArrayLength(env, d_bitmap);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  setTileMapData(a, b, c, d );
}
```

There are lines in the above code that are purposely commented out. They demonstrate how to determine the size of the array that has been passed to the JNI library. In our program, we know the size of the arrays. We rely on the fact that the arrays are a given size representing their visual size when displayed on the screen.

There are three important aspects of the method above. They're listed below. For this explanation we'll focus on '`a_bitmap`'.

  1. The parameters in the function signature call for 'jintArray' elements to be passed to the method.
  1. The size of the 'jintArray' is determined by the line: '`jsize a_len = (*env)->GetArrayLength(env, a_bitmap);`'
  1. The actual array pointer to be used in c style code is found like this: '`jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);`'

The Java code that allows us to use this method is:

```
public native void setTileMapData( int [] a, int [] b, int [] c, int [] d);
```

> [top](JNITutorial#Introduction.md)

#### Arrays as Return Type ####

Arrays can be returned to the Java code from the JNI library. The process is involved. Below is a block of code from the Awesomeguy JNI library where we pass an integer to the method and return an entire array from the method.

```
JNIEXPORT jintArray JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_drawLevel(JNIEnv * env, jobject  obj,
jint animate)
{
	int j,k;
	jint size = SCREEN_WIDTH * SCREEN_HEIGHT;
	jint fill[size]; 
	jintArray graphic;
	drawLevel(animate);
	graphic = (*env)->NewIntArray(env, size);
	if(graphic == NULL) {
		LOGE("ARRAY NOT CREATED");
		return NULL;
	}
	for (j = 0; j < SCREEN_HEIGHT; j++) {
		for (k = 0; k < SCREEN_WIDTH ; k ++ ) {
			fill[ (j * SCREEN_WIDTH) + k ] = (jint) screen[j][k];
		}
	}
	
	
	(*env)->SetIntArrayRegion(env, graphic,0, size, fill);
	return graphic;
}
```

We'll try to go over the code step by step.

  1. The first thing to notice is the '`jintArray`' return type in the method signature.
  1. On the next line we pass a jint called 'animate' as a paramter.
  1. We declare two ints, 'j' and 'k' to be used as for() loop index variables.
  1. We declare a jint called 'size' that is the size of our array.
  1. We declare a c style array called `fill[]` that will hold our c data.
  1. We declare a special '`jintArray`' called 'graphic'. This object still needs to be initialized.
  1. We call the method that will populate the 2D 'screen' array. This method calls all the necessary drawing functions of our library.
  1. We initialize the `jintArray` with a special JNI method that uses both the 'env' object and the 'size' jint that we defined previously.
  1. We test if the 'graphic' object was properly created. If not we return null.
  1. Using 'j' and 'k' we populate the 'fill' array. The 'fill' array is 1 dimensional and the 'screen' array is 2 dimensional.
  1. Using the special '`SetIntArrayRegion()`' method we place the 'fill' data in the 'graphic' object. The variables 'size' and 'env' are also used in this method call.
  1. We return the 'graphic' object.

That covers the process we used to convert a c style array into a java array and pass it back to the java code. We only do this once in the entire library. Below is the code that must be included in the java to allow the JNI method to be called.

```
public native int[] drawLevel(int num);
```

> [top](JNITutorial#Introduction.md)