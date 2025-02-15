      [CmdletBinding()]
      param (
          [string]$Filter,

          [String]$FileFindingList,

          [String]$FileCriteria,

          [String]$FileOut
      )
      Function Compare-FindingList{
          param (
              [Parameter(Mandatory=$true)]
              [array]$FindingList,
              [Parameter(Mandatory=$true)]
              [array]$CriteriaList
          )
          foreach ($Criteria in $CriteriaList){
              $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Criteria.ID}
              If ($tmp -eq $null -or ($tmp -is [array] -and $tmp.Length -gt 1)) {
                Throw  "Problem with findings $($Criteria.ID) either null or duplicate"
              }       
          }
          foreach ($Finding in $FindingList){
              $tmp = $CriteriaList | Where-Object -FilterScript {$_.ID -eq $Finding.ID}
              If ($tmp -eq $null -or ($tmp -is [array] -and $tmp.Length -gt 1)) {
                Throw  "Problem with critera $($Finding.ID) either null or duplicate"
              }       
          }
          return $true
      }

      Function New-MergedFindingsList{
          param (
              [Parameter(Mandatory=$true)]
              [array]$FindingList,
              [Parameter(Mandatory=$true)]
              [array]$CriteriaList
          )

          $Merged = @()
          foreach ($Criteria in $CriteriaList){
              $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Criteria.ID}
              foreach ($property in $tmp.PSObject.Properties) {
                  if ($Criteria.PSObject.Properties[$property.Name] -eq $null) {
                      #write-host "Adding property $($property.Name) with value $($property.Value)"
                      $Criteria | Add-Member NoteProperty $property.Name  $property.Value
                  }
                  else {
                      #write-host "Setting $($property.Name)  $($property.Value)"
                      $Criteria.PSObject.Properties[$property.Name].Value =   $property.Value
                  }
              }
              $Merged += $Criteria
              #write-host $Criteria
          }
          return $Merged
      }

      Function Get-FilteredFindingList {
          param (
              [Parameter(Mandatory=$false)]
              [scriptblock]$Filter,
              [Parameter(Mandatory=$true)]
              [String]$FileFindingList,
              [Parameter(Mandatory=$true)]
              [String]$FileCriteria
          )
          #$FindingList = Import-Csv -Path $FileFindingList -Delimiter ","
          $csvContent = Invoke-WebRequest -Uri $FileFindingList -UseBasicParsing
          $csvString = $csvContent.Content
          $FindingList = ConvertFrom-Csv -InputObject $csvString
          $CriteriaList = Import-Csv -Path $FileCriteria -Delimiter ","
          $CompareResult = Compare-FindingList -FindingList $FindingList -CriteriaList $CriteriaList
          if ($CompareResult -eq $false){
              Throw  "List are not equals"
          } 
          $ResultList = New-MergedFindingsList -FindingList $FindingList -CriteriaList $CriteriaList
          write-host $ResultList.Length
          #foreach ($Result in $ResultList){
          #  write-host $Result
          #}
          write-host $Filter
          If ($Filter) {
              $FilteredList = $ResultList | Where-Object -FilterScript $Filter
              If ($FilteredList -eq $null -or $FilteredList.Length -eq 0) {
                Throw  "Search filter return nothing"
              } 
          }
          write-host $FilteredList.Length
          #foreach ($Result in $ResultList){
          #  write-host $Result
          #}
          $CriteriaList = @()
          foreach ($Result in $FilteredList){
              $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Result.ID}
              $CriteriaList += $tmp
          }
          return $CriteriaList
      }


      Function New-FilteredFindingList {
          param (
              [Parameter(Mandatory=$false)]
              [scriptblock]$Filter,
              [Parameter(Mandatory=$true)]
              [String]$FileFindingList,
              [Parameter(Mandatory=$true)]
              [String]$FileCriteria,
              [Parameter(Mandatory=$true)]
              [String]$FileOut
          )
          $fl = Get-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria
          $fl | Export-CSV $FileOut -NoTypeInformation
      }
      $scriptBlock = [scriptblock]::Create($Filter)
      New-FilteredFindingList -Filter $scriptBlock -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut
# .\gs.ps1 '{ $_.DC -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.Category -ne "Windows Firewall"}' 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv' 'C:\Hardenkitty\critera\cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv' 'C:\Hardenkitty\findings_dc_machine.csv'
