#Include Once "windows.bi"
#Include Once "win/richedit.bi"
#Include Once "win/commctrl.bi"

Const INC_FILE_PATH As String = "C:\Program Files (x86)\FreeBASIC(1.04)\FBEdit(1.04)\Inc\"
#Include "C:\Program Files (x86)\FreeBASIC(1.04)\FBEdit(1.04)\Inc\RAEdit.bi"
#Include "C:\Program Files (x86)\FreeBASIC(1.04)\FBEdit(1.04)\Inc\Addins.bi"

#Include "RemBox.bi"

Declare Sub DrawRemBox()

Sub AddToMenu(ByVal id As Integer,ByVal sMenu As String)

	AppendMenu(hSubMnu,MF_STRING,id,sMenu)

End Sub

Sub UpdateMenu(ByVal id As Integer,ByVal sMenu As String)
	Dim mii As MENUITEMINFO

	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_TYPE
	mii.fType=MFT_STRING
	'mii.dwTypeData=@sMenu
	mii.dwTypeData=Cast(ZString Ptr, @sMenu)
	SetMenuItemInfo(lpHandles->hmenu,id,FALSE,@mii)

End Sub

Sub AddAccelerator(ByVal fvirt As Integer,ByVal akey As Integer,ByVal id As Integer)
	Dim nAccel As Integer
	Dim acl(500) As ACCEL
	Dim i As Integer

	nAccel=CopyAcceleratorTable(lpHandles->haccel,NULL,0)
	CopyAcceleratorTable(lpHandles->haccel,@acl(0),nAccel)
	DestroyAcceleratorTable(lpHandles->haccel)
	' Check if id exist
	For i=0 To nAccel-1
		If acl(i).cmd=id Then
			' id exist, update accelerator
			acl(i).fVirt=fvirt
			acl(i).key=akey
			GoTo Ex
		EndIf
	Next i
	' Check if accelerator exist
	For i=0 To nAccel-1
		If acl(i).fVirt=fvirt And acl(i).key=akey Then
			' Accelerator exist, update id
			acl(i).cmd=id
			GoTo Ex
		EndIf
	Next i
	' Add new accelerator
	acl(nAccel).fVirt=fvirt
	acl(nAccel).key=akey
	acl(nAccel).cmd=id
	nAccel=nAccel+1
Ex:
	lpHandles->haccel=CreateAcceleratorTable(@acl(0),nAccel)

End Sub

Sub AddToolbarButton(ByVal id As Integer,ByVal idbmp As Integer)
	Dim tbab As TBADDBITMAP
	Dim tbbtn As TBBUTTON

	tbab.hInst=hInstance
	tbab.nID=idbmp
	'MessageBox(NULL, Str(idbmp), "idbmp", MB_OK)
	tbbtn.iBitmap=SendMessage(lpHandles->htoolbar,TB_ADDBITMAP,1,Cast(LPARAM,@tbab))

	tbbtn.idCommand=id
	tbbtn.fsState=TBSTATE_ENABLED
	tbbtn.fsStyle=TBSTYLE_BUTTON
	SendMessage(lpHandles->htoolbar,TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)
	SendMessage(lpHandles->htoolbar,TB_INSERTBUTTON,-1,Cast(LPARAM,@tbbtn))
	lpData->tbwt=lpData->tbwt+24

End Sub

Function GetString(ByVal id As Integer) As String
''	Dim buff As ZString*256
'
''	buff=
'	Return lpFunctions->FindString(lpData->hLangMem,"AdvEdit",Str(id))
'
Return ""
End Function

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND,ByVal hInst As HINSTANCE) As ADDINHOOKS ptr Export
	Dim buff As ZString*256
	Dim mii As MENUITEMINFO

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Add "Advanced" sub menu to "Edit" menu.
	'hSubMnu=CreatePopupMenu
	hMenu = CreateMenu
	
	buff=GetString(10000)
	If buff="" Then
		buff="RemBox"
	EndIf

	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=  MIIM_SUBMENU

	GetMenuItemInfo(lpHANDLES->hmenu,10021,FALSE,@mii)
	'AppendMenu(mii.hSubMenu,MF_STRING,Cast(Integer,hSubMnu),buff)
	IDRemBox = SendMessage(hWin, AIM_GETMENUID, 0,0)
	AppendMenu(mii.hSubMenu,MF_STRING,IDRemBox, @buff)    'StrPtr("Base Calc"))'AppendMenu(mii.hSub

'	' Add quick run button to toolbar
	'AddToolbarButton(IDRemBox,100)
	AddToolbarButton(IDRemBox,100)
'	' Get toolbar button tooltip
'	szQuickRun=GetString(10009)
'	If szQuickRun="" Then
'		szQuickRun="Quick run"
'	EndIf
'
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND Or HOOK_MENUENABLE
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer Export
	Dim en As Integer

	Select Case uMsg
		Case AIM_COMMAND
				Select Case LoWord(wParam)
					Case IDRemBox
						DrawRemBox() 
   
						'						
						'
				End Select
			'EndIf
			Return FALSE
			'
		'Case AIM_GETTOOLTIP
		'	If wParam=IDM_MAKE_QUICKRUN Then
		'		Return Cast(Integer,@szQuickRun)
		'	EndIf
			'
		Case AIM_MENUENABLE
			en=MF_BYCOMMAND Or MF_GRAYED
			If lpHandles->hred<>0 And lpHandles->hred<>lpHandles->hres Then
				If GetWindowLong(lpHandles->hred,GWL_ID)<>IDC_HEXED Then
					en=MF_BYCOMMAND Or MF_ENABLED
				EndIf
			EndIf
			EnableMenuItem(hSubMnu, IDRemBox, en)
			'
	End Select
	Return FALSE

End Function
Sub DrawRemBox()
	'
	Dim s As String
	Dim z As ZString * 92
	Dim As Integer l, li, chars
	Dim cr As charrange

	s = Date() + " - " + Time() + " (mm/dd/yyyy)"
	chars = Len(s)

	SendMessage(lpHandles->hred,EM_EXGETSEL,0,Cast(LPARAM,@cr))
	z = "'" + String(89, "-") + Chr(13) + Chr(10)
	sendmessage(lpHandles->hred, EM_REPLACESEL, TRUE, Cast(LPARAM, @z))

	z = "' " + s + String(88 - chars, " ") + Chr(13) + Chr(10)
	sendmessage(lpHandles->hred, EM_REPLACESEL, TRUE, Cast(LPARAM, @z))

	z = "'" + String(89, " ") + Chr(13) + Chr(10)
	sendmessage(lpHandles->hred, EM_REPLACESEL, TRUE, Cast(LPARAM, @z))

	z = "'" + String(89, "-") + Chr(13) + Chr(10)
	sendmessage(lpHandles->hred, EM_REPLACESEL, TRUE, Cast(LPARAM, @z))

	l = SendMessage(lpHandles->hred,EM_LINEFROMCHAR,-1,0)
	li = SendMessage(lpHandles->hred,EM_LINEINDEX, l - 2, 0)
	'messagebox(NULL, "li targeted " + Str(li), "", mb_ok)						

	cr.cpMin = li + 2
	cr.cpMax = li + 2
	SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@cr))


End Sub
