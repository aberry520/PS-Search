function Search-FilesCurrentDirectory ($foundFiles) {
    $fileCount = 0
    if ($foundFiles.Count -eq 0){
        # Prompt for file location
        $directory = Read-Host "Enter the directory path to search in (leave blank to search in the current directory)"
        if (-not $directory) { $directory = Get-Location }
    
        # Prompt for search term
        $searchPattern = Read-Host "Enter the search term"
    
        # Prompt for start date
        $startDate = Read-Host "Enter the start date (MM/DD/YYYY) (leave blank for no start date)"
        $startDate = if ($startDate) { [datetime]::ParseExact($startDate, "MM/dd/yyyy", $null) } else { $null }
    
        # Prompt for end date
        $endDate = Read-Host "Enter the end date (MM/DD/YYYY) (leave blank for no end date)"
        $endDate = if ($endDate) { [datetime]::ParseExact($endDate, "MM/dd/yyyy", $null).AddHours(23).AddMinutes(59) } else { $null }
    
        # Capture start time
        $startTime = Get-Date
        
        # Get all matching files
        $files = Get-ChildItem -Path $directory -File -Recurse | Where-Object {
            ($startDate -eq $null -or $_.CreationTime -ge $startDate) -and
            ($endDate -eq $null -or $_.CreationTime -le $endDate)
        }
        $totalFiles = $files.Count
        Write-Host "`n`nStarting search in $totalFiles files..."
        $files | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
    
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                # Store file name with creation date for display, but just the file name for subsequent searches
                $foundFiles += [PSCustomObject]@{
                    FileName = $_.Name
                    CreationDate = $_.CreationTime.ToString('yyyy/MM/dd HH:mm:ss')
                    FullName = $_.FullName
                }
            }
        }

    } else {
        # Write-Host $foundFiles
        # Prompt for search term
        $searchPattern = Read-Host "Enter the search term"
        # $files = $foundFiles.Count
        $filteredSearch = @()
        # Capture start time
        $startTime = Get-Date
        $foundFiles | ForEach-Object {
            $fileCount++
            Write-Host $_
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $filteredSearch += $_
            }
        }
        $foundFiles = $filteredSearch
    }

    # Sort the results by CreationDate in ascending order (oldest first)
    $foundFiles = $foundFiles | Sort-Object -Property CreationDate -Descending

    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($foundFiles.Count -gt 0) {
        Write-Host "Files containing '$searchPattern':"
        # $foundFiles | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FullName)" }
        # Write-Host $foundFiles
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "Search complete. Time taken: $elapsedTime.`nFiles found: $($foundFiles.Count)`nSearch: '$searchPattern'"
    return $foundFiles
}

function Search-FilesByDirectory ($foundFiles) {
    $fileCount = 0
    if ($foundFiles.Count -eq 0){
        # Prompt for file location
        $directory = Read-Host "Enter the directory path to search in (leave blank to search in the current directory)"
        if (-not $directory) { $directory = Get-Location }
    
        # Prompt for search term
        $searchPattern = Read-Host "Enter the search term"
    
        # Prompt for start date
        $startDate = Read-Host "Enter the start date (MM/DD/YYYY) (leave blank for no start date)"
        $startDate = if ($startDate) { [datetime]::ParseExact($startDate, "MM/dd/yyyy", $null) } else { $null }
    
        # Prompt for end date
        $endDate = Read-Host "Enter the end date (MM/DD/YYYY) (leave blank for no end date)"
        $endDate = if ($endDate) { [datetime]::ParseExact($endDate, "MM/dd/yyyy", $null).AddHours(23).AddMinutes(59) } else { $null }
    
        # Capture start time
        $startTime = Get-Date
        
        # Get all matching files
        $files = Get-ChildItem -Path $directory -File -Recurse | Where-Object {
            ($startDate -eq $null -or $_.CreationTime -ge $startDate) -and
            ($endDate -eq $null -or $_.CreationTime -le $endDate)
        }
        $totalFiles = $files.Count
        Write-Host "`n`nStarting search in $totalFiles files..."
        $files | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
    
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                # Store file name with creation date for display, but just the file name for subsequent searches
                $foundFiles += [PSCustomObject]@{
                    FileName = $_.Name
                    CreationDate = $_.CreationTime.ToString('yyyy/MM/dd HH:mm:ss')
                    FullName = $_.FullName
                }
            }
        }

    } else {
        # Write-Host $foundFiles
        # Prompt for search term
        $searchPattern = Read-Host "Enter the search term"
        # $files = $foundFiles.Count
        $filteredSearch = @()
        # Capture start time
        $startTime = Get-Date
        $foundFiles | ForEach-Object {
            $fileCount++
            Write-Host $_
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $filteredSearch += $_
            }
        }
        $foundFiles = $filteredSearch
    }

    # Sort the results by CreationDate in ascending order (oldest first)
    $foundFiles = $foundFiles | Sort-Object -Property CreationDate -Descending

    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($foundFiles.Count -gt 0) {
        Write-Host "Files containing '$searchPattern':"
        # $foundFiles | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FullName)" }
        # Write-Host $foundFiles
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "Search complete. Time taken: $elapsedTime.`nFiles found: $($foundFiles.Count)`nSearch: '$searchPattern'"
    return $foundFiles
}

function New-UserFiles ($files) {
    $filteredFiles = @()
    # Prompt for search term
    $searchPattern = Read-Host "Enter the search term"
    # Capture start time
    $startTime = Get-Date
        
    # Get all matching files
    $foundFiles = $files | ForEach-Object { Get-Item $_ }

    $totalFiles = $files.Count
    Write-Host "`n`nStarting search in $totalFiles files..."
    $foundFiles | ForEach-Object {
        $fileCount++
        
        # Update progress without printing new line
        if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
            Write-Host "$fileCount / $totalFiles" -NoNewline
            Write-Host "`r" -NoNewline
        }

        # Search using Select-String (faster than Get-Content)
        if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
            # Store file name with creation date for display, but just the file name for subsequent searches
            $filteredFiles += [PSCustomObject]@{
                FileName = $_.Name
                CreationDate = $_.CreationTime.ToString('yyyy/MM/dd HH:mm:ss')
                FullName = $_.FullName
            }
        }
    }
    # Sort the results by CreationDate in ascending order (oldest first)
    $filteredFiles = $filteredFiles | Sort-Object -Property CreationDate -Descending

    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($filteredFiles.Count -gt 0) {
        Write-Host "Files containing '$searchPattern':"
        $filteredFiles | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FullName)" }
        # Write-Host $foundFiles
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "Search complete. Time taken: $elapsedTime.`nFiles found: $($filteredFiles.Count)`nSearch: '$searchPattern'"
    return $filteredFiles
}

# Main program loop
Write-Host "


██████╗░░██████╗░░░░░░░██████╗███████╗░█████╗░██████╗░░█████╗░██╗░░██╗
██╔══██╗██╔════╝░░░░░░██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██║░░██║
██████╔╝╚█████╗░█████╗╚█████╗░█████╗░░███████║██████╔╝██║░░╚═╝███████║
██╔═══╝░░╚═══██╗╚════╝░╚═══██╗██╔══╝░░██╔══██║██╔══██╗██║░░██╗██╔══██║
██║░░░░░██████╔╝░░░░░░██████╔╝███████╗██║░░██║██║░░██║╚█████╔╝██║░░██║
╚═╝░░░░░╚═════╝░░░░░░░╚═════╝░╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝
"

while ($true) {
    Write-Host "
    
    ============================================
    |                                          |
    |           PS-Search Main Menu            |
    |        -------------------------         |
    |                                          |
    |    1. New Search this Directory          |
    |    2. New Search enter Directory         |
    |    3. Search given filepaths             |
    |    9. Exit                               |
    |                                          |
    ============================================
"
    
    $choice = Read-Host "Enter your choice (1-4)"

    switch ($choice) {
        1 { 
            Search-FilesCurrentDirectory @() 
        }
        2 { 
            Search-FilesByDirectory @()
        }
        3 { 
            $UserFiles = read-host "Enter file paths seperated by commas"
            New-UserFiles $UserFiles -split ','
        }
        9 {
            Write-Host "
░██████╗░░█████╗░░█████╗░██████╗░██████╗░██╗░░░██╗███████╗
██╔════╝░██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝██╔════╝
██║░░██╗░██║░░██║██║░░██║██║░░██║██████╦╝░╚████╔╝░█████╗░░
██║░░╚██╗██║░░██║██║░░██║██║░░██║██╔══██╗░░╚██╔╝░░██╔══╝░░
╚██████╔╝╚█████╔╝╚█████╔╝██████╔╝██████╦╝░░░██║░░░███████╗
░╚═════╝░░╚════╝░░╚════╝░╚═════╝░╚═════╝░░░░╚═╝░░░╚══════╝
"
            exit
        }
        default { Write-Host "


        **************************************************************
        **                                                          **
        **  Invalid choice. Please enter a number between 1 and 4.  **
        **                                                          **
        **************************************************************
        " }
    }
}
