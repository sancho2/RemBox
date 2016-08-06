# RemBox
RemBox is an FBEdit Addin

Thank you for looking at RemBox. 
RemBox is an AddIn for FBEdit.exe. 
This addin creates a documentation box in the currently open code page within the FBEdit IDE. 
The documentation box contains the date and time. 
The documention box looks like this:  

'-----------------------------------------------------------------------------------------  
' 08-04-2016 - 22:03:17 (mm/dd/yyyy)                                                      
'                                                                                         
'-----------------------------------------------------------------------------------------  

The cursor is left within the box to enable you to type a title.
This addin is useful for titling new code files and even procedures.
   
Source Code Notes:   
The source code for the RemBox dll is modified from the source code of addin called AdvEdit that is included in the FBEdit download.    
If you intead on compiling this source code follow these steps:   
1. Create a folder for the project.    
2. Place the RemBox.bas, RemBox.bi, RemBox.rc, and RemBox.fbp files in that folder.    
3. Create a sub folder within the project folder called Res.   
4. Place the RemBox.bmp file in this folder.   
5. Load the project file in FBEdit. The build options should all be set correctly.   
6. Compile the file. It will create the file RemBox.dll in the project directory.  

