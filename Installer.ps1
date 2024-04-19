# Function to create folder on desktop
function CreateFolder {
    param(
        [string]$FolderName
    )
    $DesktopFolder = [System.IO.Path]::GetFullPath([System.Environment]::GetFolderPath("Desktop"))
    $folderPath = Join-Path -Path $DesktopFolder -ChildPath $FolderName
    New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
    Write-Output $folderPath
}

# Function to download and unzip file into folder
# Function to download and unzip file into folder
function FetchFiles {
    param(
        [string[]]$Url,
        [string]$FolderPath
    )
    $fileName = "Ninja Guide.pdf"
    $filePath = Join-Path -Path $FolderPath -ChildPath $fileName
    Invoke-WebRequest -Uri $Url[0] -OutFile $filePath

    if(0 + 1 -lt $Url.Count) {
        Invoke-WebRequest -Uri $Url[0] -OutFile (Join-Path -Path $FolderPath -ChildPath "Unity Assets.zip")
    }
    
    # Check if the file is a zip file and unzip it
    if ($fileName -like "*.zip") {
        Expand-Archive -Path $filePath -DestinationPath $FolderPath -Force
        Remove-Item -Path $filePath -Force
    }
}


# Create folders
$redBeltFolder = CreateFolder -FolderName "Red Belt Sensei Guide"
$purpleBeltFolder = CreateFolder -FolderName "Purple Belt Sensei Guide"
$brownBeltFolder = CreateFolder -FolderName "Brown Belt Sensei Guide"

# Download files into folders
$redBeltFileUrl = @("https://drive.google.com/uc?export=download&id=1-WIsNMimae92zMhCttaY5DBAGapCS1lD", "https://drive.google.com/uc?export=download&id=1-xUzUYd0Ug_8V53moRrnwfhwwx3dZRfx")
$purpleBeltFileUrl = @("https://drive.google.com/uc?export=download&id=1tT3ijci6KGDHTBFGt0M8OfnRWi7rgZXh")
$brownBeltFileUrl = @("https://drive.google.com/uc?export=download&id=1wUDs3f2WBuqc9-VM6NYhHyyXbpDZWoJz", "https://drive.google.com/uc?export=download&id=1yTIdNwCVQdgou0eXfXZwDvEsZE2dYELn")

FetchFiles -Url $redBeltFileUrl -FolderPath $redBeltFolder
FetchFiles -Url $purpleBeltFileUrl -FolderPath $purpleBeltFolder
FetchFiles -Url $brownBeltFileUrl -FolderPath $brownBeltFolder
