# Function to create a folder on the desktop
function CreateFolder {
    param(
        [string]$FolderName
    )

    # Get the full path to the desktop folder
    $DesktopFolder = [System.IO.Path]::GetFullPath([System.Environment]::GetFolderPath("Desktop"))

    # Combine desktop path with the given folder name
    $folderPath = Join-Path -Path $DesktopFolder -ChildPath $FolderName

    # Create the folder if it doesn't exist
    New-Item -Path $folderPath -ItemType Directory -Force | Out-Null

    # Return the path of the created folder
    Write-Output $folderPath
}

# Function to download files from URLs and extract them if necessary
function FetchFiles {
    param(
        [string[]]$Url,
        [string]$FolderPath
    )

    # Define the default file name
    $fileName = "Ninja Guide.pdf"
    
    # Define the full file path
    $filePath = Join-Path -Path $FolderPath -ChildPath $fileName

    # Download the file from the first URL
    Invoke-WebRequest -Uri $Url[0] -OutFile $filePath

    # If more than one URL is provided, download the second file
    if($Url.Count -gt 1) {
        Invoke-WebRequest -Uri $Url[1] -OutFile (Join-Path -Path $FolderPath -ChildPath "Unity Assets.zip")
    }
    
    # Check if the downloaded file is a zip file and extract it
    if ($fileName -like "*.zip") {
        Expand-Archive -Path $filePath -DestinationPath $FolderPath -Force
        # Remove the original zip file
        Remove-Item -Path $filePath -Force
    }
}

# Create folders for each belt guide
$redBeltFolder = CreateFolder -FolderName "Red Belt Sensei Guide"
$purpleBeltFolder = CreateFolder -FolderName "Purple Belt Sensei Guide"
$brownBeltFolder = CreateFolder -FolderName "Brown Belt Sensei Guide"

# URLs for files corresponding to each belt
$redBeltFileUrl = @(
    "https://drive.google.com/uc?export=download&id=1-WIsNMimae92zMhCttaY5DBAGapCS1lD", 
    "https://drive.google.com/uc?export=download&id=1-xUzUYd0Ug_8V53moRrnwfhwwx3dZRfx"
)
$purpleBeltFileUrl = @(
    "https://drive.google.com/uc?export=download&id=1tT3ijci6KGDHTBFGt0M8OfnRWi7rgZXh"
)
$brownBeltFileUrl = @(
    "https://drive.google.com/uc?export=download&id=1wUDs3f2WBuqc9-VM6NYhHyyXbpDZWoJz", 
    "https://drive.google.com/uc?export=download&id=1yTIdNwCVQdgou0eXfXZwDvEsZE2dYELn"
)

# Download files into respective folders
FetchFiles -Url $redBeltFileUrl -FolderPath $redBeltFolder
FetchFiles -Url $purpleBeltFileUrl -FolderPath $purpleBeltFolder
FetchFiles -Url $brownBeltFileUrl -FolderPath $brownBeltFolder
