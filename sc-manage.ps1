"1. Initializing script"

### Directories configuration

# Core PATH for screenshots
$mainDirectory = "Example\Directory\For\Screenshots"

# Optional: The script will look for screenshots in this directory
$workingDirectory = $mainDirectory

# A directory for archiving screenshots from previous sessions
$archiveDirectory = $mainDirectory + "\Archive" 

"2. Retrieving working directory for unarchived screenshots"

$filesToMove = Get-ChildItem -Path $workingDirectory -File | sort CreationTime

"3. Initializing the procedure of moving available files"

ForEach ($file in $filesToMove) { 
	
	### Directory: \Archive\YYYY

	# Folder name calculated from the file's modification time 
	# | screenshots will be transfered to separate folders [recommended]
	
	$year = $file.LastWriteTime.Date.ToString('yyyy') 
	
	# Folder name based on the current year 
	# | every available screenshot will be transfered to 
	# | a single folder named by user's current year
	
	# $year = (Get-Date -UFormat "%Y") 

	# Checking if a directory exists
	$path = $archiveDirectory + "\" + $year + "\"
	If (!(test-path $path)) {
		New-Item -ItemType Directory -Force -Path $path | Out-Null
	}

	# Fetching the highest index number of an archived screenshot 
	$getLast = Get-ChildItem -Path $path -File | sort {$_.BaseName -replace "\D+" -as [Int]} | Select-Object -Last 1

	# Checking whether the targeted folder contains other screenshots
	If (!$getLast) { 
		$getLast = 1
	} 
	Else { 
		$getLast = [int]$getLast.BaseName 
		$getLast += 1
	}
	
	# Calculating the full path of a targeted directory with unified file extensions
	$newName = $path + $getLast + $file.Extension.ToLower()

	" | Moving " + $file.Name + " to " + $newName
	Move-Item -Path $file.FullName -Destination $newName
}

"4. Terminating"

# If needed for debugging
# Read-Host -Prompt "Press Enter to exit"