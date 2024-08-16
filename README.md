A simple hangman game made with MASM, utilizing the Irvine32 library. It's not very featured and the code could be better, but for a simple semester project it's okay....I think..

To run it, you would either need to install Microsoft Visual Studio, create a blank C/C++ project and check MASM in the project properties and also add the path where Irvine is into additional libraries.

Or you could instal MASM from http://www.masm32.com, install it and download Irvine from its github repository and place the Irvine32.inc and Irvine32.lib files into the include and library folder of MASM. After that use any text editor or a dedicated IDE for MASM (Eg: SASM) and if you want to run the program, open cmd and navigate to the folder where your program is and type the following commands

\masm32\bin\ml /c /Zd /coff hangman.asm

\masm32\bin\Link /Subsystem:console E:\masm32\lib\kernel32.lib E:\masm32\lib\user32.lib E:\masm32\lib\gdi32.lib E:\masm32\lib\msvcrt.lib E:\masm32\lib\Irvine32.lib hangman.obj

Replace the E drive letter with the drive were MASM is installed, and if it's in a folder add that to the above command too.

If  you're facing any problems, try disabling Windows Defender and make sure that this program is in the same drive as where MASM is installed.
