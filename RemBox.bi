#Define IDB_RemBox 100
'#Define IDB_RemBox  100

Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES ptr
Dim Shared lpFunctions As ADDINFUNCTIONS ptr
Dim Shared lpData As ADDINDATA ptr
Dim Shared hSubMnu As HMENU
Dim Shared hMenu As HMENU

' Below are id's for the commands.
Dim Shared IDRemBox As Integer

