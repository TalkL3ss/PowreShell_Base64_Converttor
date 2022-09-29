param ([bool]$Decode = $true)
Function BrowseForFiles($initialDirectory, [switch]$SaveAs,$DefFile,[bool]$Decode)
{   
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	if ($SaveAs) {
		$OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	} else {
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	}
	
	$OpenFileDialog.initialDirectory = $initialDirectory
	if ($SaveAs -and $Decode) {
        $OpenFileDialog.title = "Save As Decoded Base64"
		$OpenFileDialog.filter = "All files (*.*)| *.*"
	} elseif ($Decode) {
        $OpenFileDialog.title = "Open To Decoded Base64"
		$OpenFileDialog.filter = "All txt files (*.txt)| *.txt"
	} elseif ($SaveAs) {
        $OpenFileDialog.title = "Save As Encoded Base64"
        $OpenFileDialog.filter = "All files (*.txt)| *.txt"
    } else {
        $OpenFileDialog.title = "Open File To Encode Base64"
        $OpenFileDialog.filter = "All txt files (*.*)| *.*"
    }
	$OpenFileDialog.filename = $DefFile
	$OpenFileDialog.ShowDialog() | Out-Null
	$FileName = $OpenFileDialog.filename
	$FileName
} #end function BrowseForFiles

if ($Decode) {
    $FileToOpen = (BrowseForFiles -Decode $true)
    $SaveAsFile = (BrowseForFiles -SaveAs -DefFile $FileToOpen.replace(".txt","") -Decode $true )
    [IO.File]::WriteAllBytes($SaveAsFile, [Convert]::FromBase64String([IO.File]::ReadAllLines($FileToOpen)))
} else {
    $FileToOpen = (BrowseForFiles -Decode $false)
    $SaveAsFile = (BrowseForFiles -SaveAs -DefFile $FileToOpen".txt" -Decode $false)
    [IO.File]::WriteAllLines($SaveAsFile, [convert]::ToBase64String([IO.File]::ReadAllBytes($FileToOpen)))
    cat $SaveAsFile | clip
}
