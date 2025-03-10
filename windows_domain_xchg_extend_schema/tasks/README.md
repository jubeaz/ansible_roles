https://learn.microsoft.com/fr-fr/exchange/plan-and-deploy/prepare-ad-and-domains?view=exchserver-2019


# Extend schema

## output
```powershell
PS C:\Users\Administrator> d:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataON /PrepareSchema

Microsoft Exchange Server 2019 Cumulative Update 15 Unattended Setup

Copying Files...
File copy complete.  Setup will now collect additional information needed for installation.


Performing Microsoft Exchange Server Prerequisite Check

 Prerequisite Analysis ... COMPLETED

Configuring Microsoft Exchange Server

 Extending Active Directory schema ... COMPLETED

The Exchange Server setup operation completed successfully.
```
## fichier log
C:\ExchangeSetupLogs\ExchangeSetup.log
```
Running <C:\Windows\system32\ldifde.exe> with arguments <-i -s "haas01.haas.local" -f "C:\Windows\Temp\ExchangeSetup\Setup\Data\SchemaVersion.ldf" -j "C:\Users\Administrator\AppData\Local\Temp\2" -c "<SchemaContainerDN>" "CN=Schema,CN=Configuration,DC=haas,DC=local">.

[02/25/2025 04:20:42.0671] [1] Ending processing Install-ExchangeOrganization
[02/25/2025 04:20:42.0671] [0] The Exchange Server setup operation completed successfully.

[02/25/2025 04:20:42.0671] [0] CurrentResult console.ProcessRunInternal:205: 0
[02/25/2025 04:20:42.0671] [0] CurrentResult launcherbase.maincore:90: 0
[02/25/2025 04:20:42.0671] [0] CurrentResult console.startmain:52: 0
[02/25/2025 04:20:42.0671] [0] CurrentResult SetupLauncherHelper.loadassembly:452: 0
[02/25/2025 04:20:42.0671] [0] CurrentResult main.run:235: 0
[02/25/2025 04:20:42.0671] [0] The registry key, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ExchangeServer\V15\Setup, wasn't found.
[02/25/2025 04:20:42.0671] [0] CurrentResult setupbase.maincore:396: 0
[02/25/2025 04:20:42.0671] [0] End of Setup
[02/25/2025 04:20:42.0671] [0] **********************************************
```

## AD Check
`CN=ms-Exch-Schema-Version-Pt,CN=Schema,CN=Configuration,DC=haas,DC=local` attribue `rangeUpper` value defined according to Excehange version

# Prepare Active Directory 

## output
```
PS C:\Users\Administrator> d:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataON /PrepareAD /OrganizationName:"Haas Corp"

Microsoft Exchange Server 2019 Cumulative Update 15 Unattended Setup

Copying Files...
File copy complete.  Setup will now collect additional information needed for installation.


Performing Microsoft Exchange Server Prerequisite Check

 Prerequisite AnalysisSetup will prepare the organization for Exchange Server 2019 by using 'Setup /PrepareAD'. No Exchange Server 2016 roles have been detected in this topology. Aft
er this operation, you will not be able to install any Exchange Server 2016 roles.
Setup will prepare the organization for Exchange Server 2019 by using 'Setup /PrepareAD'. No Exchange Server 2013 roles have been detected in this topology. After this operation, you
 will not be able to install any Exchange Server 2013 roles.


Configuring Microsoft Exchange Server

 Organization Preparation ... COMPLETED

The Exchange Server setup operation completed successfully.
```

## fichier log
C:\ExchangeSetupLogs\ExchangeSetup.log
```
[02/25/2025 04:50:18.0913] [2] Active Directory session settings for 'Set-SetupOnlyOrganizationConfig' are: View Entire Forest: 'True', Configuration Domain Controller: 'haas01.haas.local', Preferred Global Catalog: 'haas01.haas.local', Preferred Domain Controllers: '{ haas01.haas.local }'
[02/25/2025 04:50:18.0913] [2] User specified parameters:  -ObjectVersion:'16763' -DomainController:'haas01.haas.local'
[02/25/2025 04:50:18.0913] [2] Beginning processing Set-SetupOnlyOrganizationConfig
[02/25/2025 04:50:18.0928] [2] Searching objects of type "ADOrganizationConfig" with filter "$null", scope "SubTree" under the root "$null".
[02/25/2025 04:50:18.0928] [2] Previous operation run on domain controller 'haas01.haas.local'.
[02/25/2025 04:50:18.0928] [2] Processing object "Haas Corp".
[02/25/2025 04:50:18.0928] [2] Saving object "Haas Corp" of type "ADOrganizationConfig" and state "Changed".
[02/25/2025 04:50:18.0928] [2] Previous operation run on domain controller 'haas01.haas.local'.
[02/25/2025 04:50:18.0928] [2] Ending processing Set-SetupOnlyOrganizationConfig
[02/25/2025 04:50:18.0928] [1] Finished executing component tasks.
[02/25/2025 04:50:18.0928] [1] Ending processing Install-ExchangeOrganization
[02/25/2025 04:50:18.0928] [0] The Exchange Server setup operation completed successfully.

[02/25/2025 04:50:18.0928] [0] CurrentResult console.ProcessRunInternal:205: 0
[02/25/2025 04:50:18.0928] [0] CurrentResult launcherbase.maincore:90: 0
[02/25/2025 04:50:18.0928] [0] CurrentResult console.startmain:52: 0
[02/25/2025 04:50:18.0928] [0] CurrentResult SetupLauncherHelper.loadassembly:452: 0
[02/25/2025 04:50:18.0928] [0] CurrentResult main.run:235: 0
[02/25/2025 04:50:18.0928] [0] The registry key, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ExchangeServer\V15\Setup, wasn't found.
[02/25/2025 04:50:18.0928] [0] CurrentResult setupbase.maincore:396: 0
[02/25/2025 04:50:18.0928] [0] End of Setup
[02/25/2025 04:50:18.0928] [0] **********************************************
```

## AD Check


`CN=Microsoft Exchange System Objects,DC=haas,DC=local` attribue `objectVersion` value defined according to Excehange version
`CN=Haas Corp,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=haas,DC=local` attribue `objectVersion` value defined according to Excehange version


