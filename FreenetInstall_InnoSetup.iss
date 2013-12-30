; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Freenet"
#define MyAppVersion "0.7.5 build 1455"
#define MyAppPublisher "freenetproject.org"
#define MyAppURL "https://freenetproject.org/"
#define MyAppExeName "freenet.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{3196C62F-9C7B-4392-88B4-05C037D05518}
AppName={#MyAppName}
UninstallDisplayName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=FreenetInstaller
SetupIconFile=FreenetInstaller_InnoSetup.ico
SolidCompression=yes
PrivilegesRequired=lowest
WizardImageFile=Wizard_FreenetInstall.bmp
WizardSmallImageFile=blue_bunny_package.bmp
;Space needed 650 Mo
ExtraDiskSpaceRequired=681574400
Compression=lzma2/ultra
InternalCompressLevel=ultra

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl,.\translations\Messages_fr.isl"

[Files]
Source: "FreenetInstaller_InnoSetup_library\FreenetInstaller_InnoSetup_library.dll"; DestDir: "{tmp}"; Flags: ignoreversion dontcopy
Source: "install_bundle\jre-online-installer.exe"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "install_node\bcprov-jdk15on-149.jar"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenet-ext.jar"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenet.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenet.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenet.jar"; DestDir: "{app}"; Flags: ignoreversion; AfterInstall: FreenetJarDoAfterInstall
Source: "install_node\freenetlauncher.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenetoffline.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\freenetuninstaller.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\installid.dat"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\installlayout.dat"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\README.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\seednodes.fref"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\update.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "install_node\licenses\LICENSE.Freenet"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "install_node\licenses\LICENSE.Mantissa"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "install_node\plugins\JSTUN.jar"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "install_node\plugins\KeyUtils.jar"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "install_node\plugins\Library.jar"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "install_node\plugins\ThawIndexBrowser.jar"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "install_node\plugins\UPnP.jar"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "install_node\updater\sha1test.jar"; DestDir: "{app}\wrapper"; Flags: ignoreversion
Source: "install_node\updater\startssl.pem"; DestDir: "{app}\wrapper"; Flags: ignoreversion
Source: "install_node\updater\wget.exe"; DestDir: "{app}\wrapper"; Flags: ignoreversion
Source: "install_node\wrapper\freenetwrapper.exe"; DestDir: "{app}\wrapper"; Flags: ignoreversion
Source: "install_node\wrapper\wrapper-windows-x86-32.dll"; DestDir: "{app}\wrapper"; Flags: ignoreversion
Source: "install_node\wrapper\wrapper.conf"; DestDir: "{app}\wrapper"; Flags: ignoreversion; AfterInstall: WrapperConfDoAfterInstall
Source: "install_node\wrapper\wrapper.jar"; DestDir: "{app}\wrapper"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"


[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "/welcome"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"

[ThirdParty]
UseRelativePaths=True

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "startwithwindows"; Description: "{cm:StartFreenetWithWindows}"; GroupDescription: "{cm:AdditionalOptions}"; Flags: unchecked

[CustomMessages]
english.JavaMissingPageCaption=Freenet requirements
english.JavaMissingPageDescription=Java dependency
english.JavaMissingText=Freenet requires the Java Runtime Environment, but your system does not appear to have an up-to-date version installed. You can install Java by using the included online installer, which will download and install the necessary files from the Java website automatically.
english.ButtonInstallJava=Install Java
english.JavaInstalled=Java has been installed on your system.
english.ErrorLaunchJavaInstaller=Can't launch Java Installer.%n%nError (%1): %2.
english.AdditionalOptions=Additional options:
english.StartFreenetWithWindows=Start Freenet on Windows startup

[Registry]
Root: "HKCU"; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Freenet"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletevalue; Tasks: startwithwindows

[Dirs]
Name: "{app}\install_node\licenses"
Name: "{app}\install_node\plugins"
Name: "{app}\install_node\updater"
Name: "{app}\install_node\wrapper"

[Code]
var
  JavaMissingPage: TWizardPage;
  bIsJavaInstalled: boolean;
  ButtonInstallJava: TNewButton;
  TextJavaMissing: TNewStaticText;

  sWrapperJavaMaxMemory, sFproxyPort, sFcpPort :string;

function IsPortAvailable(sIpAddress: ansistring; wPort: word): boolean;
external 'fIsPortAvailable@files:FreenetInstaller_InnoSetup_library.dll stdcall setuponly';

function MemoryTotalPhys(var NodeMaxMem: integer): boolean;
external 'fMemoryTotalPhys@files:FreenetInstaller_InnoSetup_library.dll stdcall setuponly';

function fCheckJavaInstall():boolean;
var
  JavaVersion : string;
begin
  if RegQueryStringValue(HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', JavaVersion) = true then  begin
    if CompareStr(JavaVersion,'1.6') >= 0  then begin
      bIsJavaInstalled := True;
    end else begin
      bIsJavaInstalled := False;
    end;
  end else begin
    bIsJavaInstalled := False;
  end;
  Result := bIsJavaInstalled;
end;

procedure ButtonInstallJavaOnClick(Sender: TObject);
var
  ErrorCode : Integer;
  sErrorCode: string;

begin
  ButtonInstallJava.Enabled := False;
  ExtractTemporaryFiles('{tmp}\jre-online-installer.exe');
  if not ShellExec('runas',ExpandConstant('{tmp}\jre-online-installer.exe'),'','',SW_SHOW,ewWaitUntilTerminated,ErrorCode) then begin
    sErrorCode := inttostr(ErrorCode);
    MsgBox(FmtMessage(CustomMessage('ErrorLaunchJavaInstaller'),[sErrorCode,SysErrorMessage(ErrorCode)]), mbError, MB_OK)
    ButtonInstallJava.Enabled := True;
  end else begin
    ButtonInstallJava.Enabled := True;
    if fCheckJavaInstall() then begin
      ButtonInstallJava.Visible := False;
      TextJavaMissing.Caption := CustomMessage('JavaInstalled');
      WizardForm.NextButton.Enabled :=  True;
    end;
  end;
end;

procedure FreenetJarDoAfterInstall();
var
  sConfigLines : array[0..4] of string;
begin
  sConfigLines[0] := 'fproxy.port=' + sFproxyPort;
  sConfigLines[1] := 'fcp.port=' + sFcpPort;
  sConfigLines[2] := 'pluginmanager.loadplugin=JSTUN;KeyUtils;ThawIndexBrowser;UPnP;Library';
  sConfigLines[3] := 'node.updater.autoupdate=true';
  sConfigLines[4] := 'End';
  SaveStringsToUTF8File(ExpandConstant('{app}\freenet.ini'), sConfigLines, False);
end;

procedure WrapperConfDoAfterInstall();
begin
  SaveStringToFile(ExpandConstant('{app}\wrapper\wrapper.conf'), '# Memory limit for the node' + #13#10 , True);
  SaveStringToFile(ExpandConstant('{app}\wrapper\wrapper.conf'), 'wrapper.java.maxmemory=' + sWrapperJavaMaxMemory + #13#10 , True);
end;

procedure InitializeWizard;
var
  iMemTotalPhys, iWrapperJavaMaxMemory, iFproxyPort, iFcpPort : integer;
begin
  bIsJavaInstalled := False;
  JavaMissingPage := CreateCustomPage(wpWelcome, CustomMessage('JavaMissingPageCaption'), CustomMessage('JavaMissingPageDescription'));

  TextJavaMissing := TNewStaticText.Create(JavaMissingPage);
  TextJavaMissing.Top := 10;
  TextJavaMissing.AutoSize := True;
  TextJavaMissing.WordWrap := True;
  TextJavaMissing.Parent := JavaMissingPage.Surface;
  TextJavaMissing.Caption :=  CustomMessage('JavaMissingText');
  TextJavaMissing.Width := ScaleX(400);

  ButtonInstallJava := TNewButton.Create(JavaMissingPage);
  ButtonInstallJava.Top := 80;
  ButtonInstallJava.Left := 150;
  ButtonInstallJava.Width := ScaleX(80);
  ButtonInstallJava.Height := ScaleY(30);
  ButtonInstallJava.Caption := CustomMessage('ButtonInstallJava');
  ButtonInstallJava.OnClick := @ButtonInstallJavaOnClick;
  ButtonInstallJava.Parent := JavaMissingPage.Surface;


  iFproxyPort := 8888;
  repeat
    if IsPortAvailable('127.0.0.1', iFproxyPort) then
      Break
    else begin
      iFproxyPort := iFproxyPort + 1;
      Continue;
    end;
  until iFproxyPort = 8888 + 256;
  sFproxyPort := IntToStr(iFproxyPort);

  iFcpPort := 9481;
  repeat
    if IsPortAvailable('127.0.0.1', iFcpPort) then
      Break
    else begin
      iFcpPort := iFcpPort + 1;
      Continue;
    end;
  until iFcpPort = 9481 + 256;
  sFcpPort := IntToStr(iFcpPort);

  MemoryTotalPhys(iMemTotalPhys);
  if iMemTotalPhys >= 2048 then
    iWrapperJavaMaxMemory := 512
  else if iMemTotalPhys >= 1024 then
    iWrapperJavaMaxMemory := 256
  else if iMemTotalPhys >= 512 then
    iWrapperJavaMaxMemory := 192
  else
    iWrapperJavaMaxMemory := 128;

  sWrapperJavaMaxMemory := InttoStr(iWrapperJavaMaxMemory);
 
  fCheckJavaInstall();
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if (CurPageID = JavaMissingPage.ID) then begin
    WizardForm.NextButton.Enabled := False;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  if (PageID = JavaMissingPage.ID) And (bIsJavaInstalled = True) then Result := True;
end;