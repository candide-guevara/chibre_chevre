; Inno Setup script of the Windows installer, run by .github/workflows/windows.yml
; after `flutter build windows --release`:
;
;   iscc /DAppVersion=1.0.4 windows\installer\chibre.iss
;
; It packs build\windows\x64\runner\Release (where the workflow also copies the
; Visual C++ runtime DLLs) into Output\chibre-setup.exe.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#define AppName "Chibre Chèvre"
#define AppExe "chibre.exe"
#define Repo "https://github.com/candide-guevara/chibre_chevre"
#define BuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{6F2C8E1A-4B7D-4E39-9C5A-2D8B7F0E6A41}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=candide-guevara
AppPublisherURL={#Repo}
AppSupportURL={#Repo}/issues
AppUpdatesURL={#Repo}/releases
AppCopyright=MIT License, (c) 2026 candide-guevara
DefaultDirName={autopf}\Chibre Chevre
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=Output
OutputBaseFilename=chibre-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
Compression=lzma2/max
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; Needed to install in Program Files and to add the firewall rule.
PrivilegesRequired=admin
WizardStyle=modern

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
; Lets the game be found and joined on the local network without the firewall
; prompt (UDP broadcast discovery and TCP), whatever the network's profile.
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""{#AppName}"""; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""{#AppName}"" dir=in action=allow program=""{app}\{#AppExe}"" enable=yes profile=any"; Flags: runhidden
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent runasoriginaluser

[UninstallRun]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""{#AppName}"""; Flags: runhidden; RunOnceId: "RemoveFirewallRule"
