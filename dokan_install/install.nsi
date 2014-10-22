!define VERSION "0.6.1"

!include LogicLib.nsh
!include x64.nsh
!include WinVer.nsh

Name "DokanLibraryInstaller ${VERSION}"
OutFile "DokanInstall_${VERSION}.exe"

InstallDir $PROGRAMFILES32\Dokan\DokanLibrary
RequestExecutionLevel admin
LicenseData "licdata.rtf"
ShowUninstDetails show

Page license
Page components
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

; GetWindowsVersion 4.0 (2014-08-25)
;
; Based on Yazno's function, http://yazno.tripod.com/powerpimpit/
; Update by Joost Verburg
; Update (Macro, Define, Windows 7 detection) - John T. Haller of PortableApps.com - 2008-01-07
; Update (Windows 8 detection) - Marek Mizanin (Zanir) - 2013-02-07
; Update (Windows 8.1 detection) - John T. Haller of PortableApps.com - 2014-04-04
; Update (Windows 2008, 2008R2, 2012 and 2012R2 detection) - Francisco Simoões Filho franksimoes@gmail.com - 2014-08-25
;
; Usage: ${GetWindowsVersion} $R0
;
; $R0 contains: 95, 98, ME, NT x.x, 2000, XP, 2003, Vista, 2008, 7, 2008R2,
;                8, 2012, 8.1, 2012R2 or '' (for unknown)
Function GetWindowsVersion
 
  Push $R0
  Push $R1
 
  ClearErrors
 
    ;--Key check if  Windows is Client ou Server.
    ReadRegStr $R2 HKLM \
               "SOFTWARE\Microsoft\Windows NT\CurrentVersion" InstallationType
 
    ; windows NT family
    ReadRegStr $R0 HKLM \
               "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
    StrCmp $R0 "" lbl_not_winnt
    goto lbl_winnt
    ;IfErrors 0 lbl_winnt
 
    lbl_not_winnt:
    ; we are not NT
    ReadRegStr $R0 HKLM \
               "SOFTWARE\Microsoft\Windows\CurrentVersion" VersionNumber
 
    ; if empty 'VersionNumber' Erro
    StrCmp $R0 "" lbl_error
 
 
  StrCpy $R1 $R0 1
  StrCmp $R1 '4' 0 lbl_error
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '4.0' lbl_win32_95
  StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98
 
  lbl_win32_95:
    StrCpy $R0 '95'
  Goto lbl_done
 
  lbl_win32_98:
    StrCpy $R0 '98'
  Goto lbl_done
 
  lbl_win32_ME:
    StrCpy $R0 'ME'
  Goto lbl_done
 
  lbl_winnt:
 
  StrCpy $R1 $R0 1
 
  StrCmp $R1 '3' lbl_winnt_x
  StrCmp $R1 '4' lbl_winnt_x
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '5.0' lbl_winnt_2000
  StrCmp $R1 '5.1' lbl_winnt_XP
  StrCmp $R1 '5.2' lbl_winnt_2003
  StrCmp $R1 '6.0' lbl_winnt_vista_2008
  StrCmp $R1 '6.1' lbl_winnt_7_2008R2
  StrCmp $R1 '6.2' lbl_winnt_8_2012
  StrCmp $R1 '6.3' lbl_winnt_81_2012R2 lbl_error
 
 
  lbl_winnt_x:
    StrCpy $R0 "NT $R0" 6
  Goto lbl_done
 
  lbl_winnt_2000:
    Strcpy $R0 '2000'
  Goto lbl_done
 
  lbl_winnt_XP:
    Strcpy $R0 'XP'
  Goto lbl_done
 
  lbl_winnt_2003:
    Strcpy $R0 '2003'
  Goto lbl_done
 
  ;----------------- Family - Vista / 2008 -------------
  lbl_winnt_vista_2008:
    StrCmp $R2 'Client' go_vista
    StrCmp $R2 'Server' go_2008
 
    go_vista:
      Strcpy $R0 'Vista'
      Goto lbl_done
 
    go_2008:
      Strcpy $R0 '2008'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 7 / 2008R2 -------------
  lbl_winnt_7_2008R2:
    StrCmp $R2 'Client' go_7
    StrCmp $R2 'Server' go_2008R2
 
    go_7:
      Strcpy $R0 '7'
      Goto lbl_done
 
    go_2008R2:
      Strcpy $R0 '2008R2'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 8 / 2012 -------------
  lbl_winnt_8_2012:
    StrCmp $R2 'Client' go_8
    StrCmp $R2 'Server' go_2012
 
    go_8:
      Strcpy $R0 '8'
      Goto lbl_done
 
    go_2012:
      Strcpy $R0 '2012'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 8.1 / 2012R2 -------------
  lbl_winnt_81_2012R2:
    StrCmp $R2 'Client' go_81
    StrCmp $R2 'Server' go_2012R2
 
    go_81:
      Strcpy $R0 '8.1'
      Goto lbl_done
 
    go_2012R2:
      Strcpy $R0 '2012R2'
      Goto lbl_done
  ;-----------------------------------------------------
 
  lbl_error:
    Strcpy $R0 '666'
    goto lbl_done
 
 
  lbl_done:
  Pop $R1
  Exch $R0
 
 
FunctionEnd
 
 
!macro GetWindowsVersion OUTPUT_VALUE
	Call GetWindowsVersion
	Pop `${OUTPUT_VALUE}`
!macroend
 
!define GetWindowsVersion '!insertmacro "GetWindowsVersion"'

!macro X86Files os

  SetOutPath $PROGRAMFILES32\Dokan\DokanLibrary
 
    File ..\dokan\readme.txt
    File ..\dokan\readme.ja.txt
    File ..\dokan\dokan.h
    File ..\license.gpl.txt
    File ..\license.lgpl.txt
    File ..\license.mit.txt
    File ..\dokan\objchk_${os}_x86\i386\dokan.lib
    File ..\dokan_control\objchk_${os}_x86\i386\dokanctl.exe
    File ..\dokan_mount\objchk_${os}_x86\i386\mounter.exe

  SetOutPath $PROGRAMFILES32\Dokan\DokanLibrary\sample\mirror

    File ..\dokan_mirror\makefile
    File ..\dokan_mirror\mirror.c
    File ..\dokan_mirror\sources
    File ..\dokan_mirror\objchk_${os}_x86\i386\mirror.exe

  SetOutPath $SYSDIR

    File ..\dokan\objchk_${os}_x86\i386\dokan.dll

!macroend

/*
!macro X64Files os

  SetOutPath $PROGRAMFILES64\Dokan\DokanLibrary

    File ..\dokan\readme.txt
    File ..\dokan\readme.ja.txt
    File ..\dokan\dokan.h
    File ..\license.gpl.txt
    File ..\license.lgpl.txt
    File ..\license.mit.txt
    File ..\dokan\objchk_${os}_amd64\amd64\dokan.lib
    File ..\dokan_control\objchk_${os}_amd64\amd64\dokanctl.exe
    File ..\dokan_mount\objchk_${os}_amd64\amd64\mounter.exe

  SetOutPath $PROGRAMFILES64\Dokan\DokanLibrary\sample\mirror

    File ..\dokan_mirror\makefile
    File ..\dokan_mirror\mirror.c
    File ..\dokan_mirror\sources
    File ..\dokan_mirror\objchk_${os}_amd64\amd64\mirror.exe

  ${DisableX64FSRedirection}

  SetOutPath $SYSDIR

    File ..\dokan\objchk_${os}_amd64\amd64\dokan.dll

  ${EnableX64FSRedirection}

!macroend
*/

!macro DokanSetup
  ExecWait '"$PROGRAMFILES32\Dokan\DokanLibrary\dokanctl.exe" /i a' $0
  DetailPrint "dokanctl returned $0"
  WriteUninstaller $PROGRAMFILES32\Dokan\DokanLibrary\DokanUninstall.exe

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName" "Dokan Library ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "UninstallString" '"$PROGRAMFILES32\Dokan\DokanLibrary\DokanUninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "NoRepair" 1

!macroend

!macro X86Driver os
  SetOutPath $SYSDIR\drivers
    File ..\sys\objchk_${os}_x86\i386\dokan.sys
!macroend

!macro X64Driver os
  ${DisableX64FSRedirection}

  SetOutPath $SYSDIR\drivers

    File ..\sys\objchk_${os}_amd64\amd64\dokan.sys

  ${EnableX64FSRedirection}
!macroend


Section "Dokan Library x86" section_x86
  ${GetWindowsVersion} $R0
/*
  ${If} $R0 == '2012R2'
    !insertmacro X86Files "win8"
  ${ElseIf} $R0 == '8.1'
    !insertmacro X86Files "win8"
  ${ElseIf} $R0 == '2012'
    !insertmacro X86Files "win8"
  ${ElseIf} $R0 == '8'
    !insertmacro X86Files "win8"
*/
  ${If} $R0 == '7'
    !insertmacro X86Files "win7"
  ${ElseIf} $R0 == '2008R2'
    !insertmacro X86Files "win7"
  ${ElseIf} $R0 == 'Vista'
    !insertmacro X86Files "wlh"
  ${ElseIf} $R0 == '2008'
    !insertmacro X86Files "wlh"
  ${ElseIf} $R0 == '2003'
    !insertmacro X86Files "wnet"
  ${ElseIf} $R0 == 'XP'
    !insertmacro X86Files "wxp"
  ${EndIf}
SectionEnd

Section "Dokan Driver x86" section_x86_driver
  ${GetWindowsVersion} $R0
/*
  ${If} $R0 == '2012R2'
    !insertmacro X86Driver "win8"
  ${ElseIf} $R0 == '8.1'
    !insertmacro X86Driver "win8"
  ${ElseIf} $R0 == '2012'
    !insertmacro X86Driver "win8"
  ${ElseIf} $R0 == '8'
    !insertmacro X86Driver "win8"
*/
  ${If} $R0 == '7'
    !insertmacro X86Driver "win7"
  ${ElseIf} $R0 == '2008R2'
    !insertmacro X86Driver "win7"
  ${ElseIf} $R0 == 'Vista'
    !insertmacro X86Driver "wlh"
  ${ElseIf} $R0 == '2008'
    !insertmacro X86Driver "wlh"
  ${ElseIf} $R0 == '2003'
    !insertmacro X86Driver "wnet"
  ${ElseIf} $R0 == 'XP'
    !insertmacro X86Driver "wxp"
  ${EndIf}
  !insertmacro DokanSetup
SectionEnd

Section "Dokan Driver x64" section_x64_driver
  ${GetWindowsVersion} $R0
/*
  ${If} $R0 == '2012R2'
    !insertmacro X64Driver "win8"
  ${ElseIf} $R0 == '8.1'
    !insertmacro X64Driver "win8"
  ${ElseIf} $R0 == '2012'
    !insertmacro X64Driver "win8"
  ${ElseIf} $R0 == '8'
    !insertmacro X64Driver "win8"
*/
  ${If} $R0 == '7'
    !insertmacro X64Driver "win7"
  ${ElseIf} $R0 == '2008R2'
    !insertmacro X64Driver "win7"
  ${ElseIf} $R0 == 'Vista'
    !insertmacro X64Driver "wlh"
  ${ElseIf} $R0 == '2008'
    !insertmacro X64Driver "wlh"
  ${ElseIf} $R0 == '2003'
    !insertmacro X64Driver "wnet"
  ${EndIf}
  !insertmacro DokanSetup
SectionEnd

/*
Section "Dokan Library x64" section_x64
  ${If} ${IsWin7}
    !insertmacro X64Files "win7"
  ${ElseIf} ${IsWinVista}
    !insertmacro X64Files "wlh"
  ${ElseIf} ${IsWin2008}
    !insertmacro X64Files "wlh"
  ${ElseIf} ${IsWin2003}
    !insertmacro X64Files "wnet"
  ${EndIf}
SectionEnd
*/

Section "Uninstall"
  ExecWait '"$PROGRAMFILES32\Dokan\DokanLibrary\dokanctl.exe" /r a' $0
  DetailPrint "dokanctl.exe returned $0"

  RMDir /r $PROGRAMFILES32\Dokan\DokanLibrary
  RMDir $PROGRAMFILES32\Dokan
  Delete $SYSDIR\dokan.dll

  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
      Delete $SYSDIR\drivers\dokan.sys
    ${EnableX64FSRedirection}
  ${Else}
    Delete $SYSDIR\drivers\dokan.sys
  ${EndIf}

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary"

  IfSilent noreboot
    MessageBox MB_YESNO "A reboot is required to finish the uninstallation. Do you wish to reboot now?" IDNO noreboot
    Reboot
  noreboot:


SectionEnd

Function .onInit
  IntOp $0 ${SF_SELECTED} | ${SF_RO}
  ${If} ${RunningX64}
    SectionSetFlags ${section_x86} $0
    SectionSetFlags ${section_x86_driver} ${SF_RO}  ; disable
    SectionSetFlags ${section_x64_driver} $0
  ${Else}
    SectionSetFlags ${section_x86} $0
    SectionSetFlags ${section_x86_driver} $0
    SectionSetFlags ${section_x64_driver} ${SF_RO}  ; disable
  ${EndIf}

  ; Windows Version check

  ${If} ${RunningX64}
    ${GetWindowsVersion} $R0
    ${If} $R0 == '2012R2'
    ${ElseIf} $R0 == '8.1'
    ${ElseIf} $R0 == '2012'
    ${ElseIf} $R0 == '8'
    ${ElseIf} $R0 == '7'
    ${ElseIf} $R0 == '2008R2'
    ${ElseIf} $R0 == 'Vista'
    ${ElseIf} $R0 == '2008'
    ${ElseIf} $R0 == '2003'
    ${Else}
      MessageBox MB_OK "Your OS is not supported. Dokan library supports Windows 2003, Vista, 2008, 2008R2 and 7 for x64."
      Abort
    ${EndIf}
  ${Else}
    ${GetWindowsVersion} $R0
    ${If} $R0 == 'XP'
    ${ElseIf} $R0 == '2012R2'
    ${ElseIf} $R0 == '8.1'
    ${ElseIf} $R0 == '2012'
    ${ElseIf} $R0 == '8'
    ${ElseIf} $R0 == '7'
    ${ElseIf} $R0 == '2008R2'
    ${ElseIf} $R0 == 'Vista'
    ${ElseIf} $R0 == '2008'
    ${ElseIf} $R0 == '2003'
    ${Else}
      MessageBox MB_OK "Your OS is not supported. Dokan library supports Windows XP, 2003, Vista, 2008 and 7 for x86."
      Abort
    ${EndIf}
  ${EndIf}

  ; Previous version
  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
      IfFileExists $SYSDIR\drivers\dokan.sys HasPreviousVersionX64 NoPreviousVersionX64
      ; To make EnableX64FSRedirection called in both cases, needs duplicated MessageBox code. How can I avoid this?
      HasPreviousVersionX64:
        MessageBox MB_OK "Please unstall the previous version and restart your computer before running this installer."
        Abort
      NoPreviousVersionX64:
    ${EnableX64FSRedirection}
  ${Else}
    IfFileExists $SYSDIR\drivers\dokan.sys HasPreviousVersion NoPreviousVersion
    HasPreviousVersion:
      MessageBox MB_OK "Please unstall the previous version and restart your computer before running this installer."
      Abort
    NoPreviousVersion:
  ${EndIf}


FunctionEnd

Function .onInstSuccess
  IfSilent noshellopen
    ExecShell "open" "$PROGRAMFILES32\Dokan\DokanLibrary"
  noshellopen:
FunctionEnd

