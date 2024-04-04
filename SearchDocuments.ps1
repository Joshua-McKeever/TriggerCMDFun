function Search-Documents {
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
}

Search-Documents -FileSearchTerm "essay"
