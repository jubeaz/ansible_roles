#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

# https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmboundary
#  sccm_boundary_to_boundarygroup:
#   boundary_group: "boundary group name"
#   site_code: "code"
#   state: "present" (absent/present)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false

$boundaryGroupName = Get-AnsibleParam -obj $params -name "boundary_group" -type "str" -failifempty $true
$siteCode = Get-AnsibleParam -obj $params -name "site_code" -type "str" -failifempty $true
$state = Get-AnsibleParam -obj $params -name "state" -type "str" -default "present" -validateset "absent", "present"
$server = Get-AnsibleParam -obj $params -name "server" -type "str" -failifempty $true

$result = @{
    changed = $false
}

Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1") -force
$sc = Get-PSDrive -PSProvider CMSITE
if ($null -eq $sc) {
    New-PSDrive -Name $siteCode -PSProvider "CMSite" -Root $server -Description "primary site"
}
Set-Location ($siteCode +":")

($boundary_group_list = Get-CMBoundary -BoundaryGroupName $boundaryGroupName) | out-null
($boundaryGroup = Get-CMBoundaryGroup -Name $boundaryGroupName) | out-null
($boundaries = Get-CMBoundary | where {$_.BoundaryType -eq 3}) | out-null

$boundaries_present = @{}
foreach  ($b in $boundaries){
    $boundaries_present[$b.DisplayName] = $false
}

foreach  ($b in $boundary_group_list){
    if ($boundaries_present.ContainsKey($b.DisplayName )) {
        $boundaries_present[$b.DisplayName] = $true
    }
}

if ($state -eq "absent") {
    foreach  ($bname in $boundaries_present.Keys){
        if ($boundaries_present[$bname]) {
            Remove-CMBoundaryFromGroup -BoundaryGroupId $boundaryGroup.GroupID -BoundaryName $bname -WhatIf:$check_mode | out-null
            $result.changed = $true
        }
    }
} elseif ($state -eq "present") {
    foreach  ($bname in $boundaries_present.Keys){
        if (-not $boundaries_present[$bname]) {
            try {
                Add-CMBoundaryToGroup -BoundaryName $bname -BoundaryGroupId $boundaryGroup.GroupID -WhatIf:$check_mode | out-null
                $result.changed = $true
            } catch {
            }
        }
    }
}

Exit-Json -obj $result