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
            Write-Host "1. New Search this Directory" 
        }
        2 { 
            Write-Host "2. New Search enter Directory" 
        }
        3 { 
            Write-Host "3. Search given filepaths"
        }
        9 {
            Write-Host "`n`nGood Bye`n`n"
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
