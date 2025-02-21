# links
https://www.anoopcnair.com/sccm/

# Download Installation media 
[link](https://www.microsoft.com/fr-fr/evalcenter/download-microsoft-endpoint-configuration-manager)


# install server
https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/configs/site-and-site-system-prerequisites

 https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/install/prerequisite-checker
 C:\setup\cd.retail.LN\SMSSETUP\BIN\X64\prereqchk.exe /NOUI /PRI /SQL eli.haas.local /SDK bran.haas.local /MP bran.haas.local /DP bran.haas.local /SCP bran.haas.local
 Search for keyword "Warning;" and "Error;" in "c:\ConfigMgrPrereq.log"


 https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/install/command-line-options-for-setup
 Setup Command Line is "C:\SETUP\CD.RETAIL.LN\SMSSETUP\BIN\X64\SETUPWPF.EXE"  /SCRIPT C:\SETUP\CONFIGMGRAUTOSAVE.INI 
 Search for keyword "ERROR:", "WARNING:" in "c:\ConfigMgrSetup.log"
 https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/install/command-line-script-file

# install console

 C:\setup\cd.retail.LN\SMSSETUP\BIN\X64\prereqchk.exe /NOUI /ADMINUI
 Search for keyword "Warning;" and "Error;" in "c:\ConfigMgrPrereq.log"