<#
.SYNOPSIS
    Searches the user's My Documents

.DESCRIPTION
    Script to searches the user's Documents/ My Documents
    folder based on the user profile. The results are logged to a CSV and the most
    recently modified file is opened.

.EXAMPLE
     # basic use
     Search-Documents -FileSearchTerm "essay"

.EXAMPLE
    # for use at the command line
    powershell -w h -NoP -NonI -Exec Bypass $ex = iwr https://raw.githubusercontent.com/SandmanV2/TriggerCMDFun/main/SearchDocuments.ps1?dl=1; $cm = -Join ($ex,'Search-Documents -FileSearchTerm "letter"'); Invoke-Expression $cm

.INPUTS
    String

.NOTES
    Author:  Joshua Mckeever
#>
param(
    [Parameter(Mandatory = $true)] [String] $FileSearchTerm
)
$Now = Get-Date -Format "MMddyyyy-HHmm"

$SearchResults = Get-ChildItem -Path "$env:UserProfile\Documents" -Recurse | Where-Object Name -like "*$FileSearchTerm*" | Select Name, LastWriteTime, Directory | Sort-Object LastWriteTime -Descending
$ExportFile = "C:\Users\Public\Documents\$FileSearchTerm-$Now.csv"

# save search results to public folder and open file
$SearchResults | Export-Csv "$ExportFile" -NoTypeInformation
Invoke-Item $ExportFile

# open mmost recently modified file
$SearchResults | Select Name, Directory -First 1 | ForEach-Object {
    $FileName = $_.Name
    $FileDir = $_.Directory
    $FullFile = "$FileDir" + "\" + "$FileName"

    Invoke-Item "$FullFile"
    }
