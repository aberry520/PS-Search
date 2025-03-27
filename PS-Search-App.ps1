function Search-FilesCurrentDirectory ($files) {
    if ($files) {
        # Prompt for search term
        $searchPattern = Read-Host "Enter Search"
        
        # Capture start time
        $startTime = Get-Date
        
        $fileCount = 0
        $totalFiles = $files.Count
        Write-Host "`n`nSearching $totalFiles files..."
        
        
        $filteredFiles = @()
        # Loop through each file and search for the pattern 
        $files | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
        
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $filteredFiles += $_
            }
        }
        $files = $filteredFiles
    }
    else {     
        # Get file location        
        $directory = Get-Location
        Write-Host "Searching in current directory: $directory"
        
        # Prompt for search term
        $searchPattern = Read-Host "Enter Search"
        
        # Prompt for start date
        $startDate = Read-Host "Start Date (MM/DD/YYYY)"
        $startDate = if ($startDate) { [datetime]::ParseExact($startDate, "MM/dd/yyyy", $null) } else { $null }
        
        # Prompt for end date
        $endDate = Read-Host "End Date (MM/DD/YYYY)"
        $endDate = if ($endDate) { [datetime]::ParseExact($endDate, "MM/dd/yyyy", $null).AddHours(23).AddMinutes(59) } else {$null }
        
        # Capture start time
        $startTime = Get-Date
            
        # Get all matching files
        $foundFiles = Get-ChildItem -Path $directory -File -Recurse | Where-Object {
            ($startDate -eq $null -or $_.CreationTime -ge $startDate) -and
            ($endDate -eq $null -or $_.CreationTime -le $endDate)
        }
    
        $fileCount = 0
        $totalFiles = $foundFiles.Count
        Write-Host "`n`nSearching $totalFiles files..."
            
        # Loop through each file and search for the pattern 
        $foundFiles | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
        
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $files += [PSCustomObject]@{
                    FileName = $_.Name
                    CreationDate = $_.CreationTime.ToString('yyyy/MM/dd HH:mm:ss')
                    FullName = $_.FullName
                }
            }
        }
    }


    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($files.Count -gt 0) {
        $files | Sort-Object -Property CreationDate | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FileName)" }
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "`n`n`nTime: $elapsedTime.`nFiles found: $($files.Count)`nSearch: '$searchPattern'"
    return $files
}

function Search-FilesByDirectory ($files) {
       if ($files) {
        # Prompt for search term
        $searchPattern = Read-Host "Enter Search"
        
        # Capture start time
        $startTime = Get-Date
        
        $fileCount = 0
        $totalFiles = $files.Count
        Write-Host "`n`nSearching $totalFiles files..."
        
        
        $filteredFiles = @()
        # Loop through each file and search for the pattern 
        $files | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
        
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $filteredFiles += $_
            }
        }
        $files = $filteredFiles
    }
    else {     
        # Get file location        
        $directory = Read-Host "Enter directory path to search in"
        if (-not $directory) { $directory = Get-Location }
        
        # Prompt for search term
        $searchPattern = Read-Host "Enter Search"
        
        # Prompt for start date
        $startDate = Read-Host "Start Date (MM/DD/YYYY)"
        $startDate = if ($startDate) { [datetime]::ParseExact($startDate, "MM/dd/yyyy", $null) } else { $null }
        
        # Prompt for end date
        $endDate = Read-Host "End Date (MM/DD/YYYY)"
        $endDate = if ($endDate) { [datetime]::ParseExact($endDate, "MM/dd/yyyy", $null).AddHours(23).AddMinutes(59) } else {$null }
        
        # Capture start time
        $startTime = Get-Date
            
        # Get all matching files
        $foundFiles = Get-ChildItem -Path $directory -File -Recurse | Where-Object {
            ($startDate -eq $null -or $_.CreationTime -ge $startDate) -and
            ($endDate -eq $null -or $_.CreationTime -le $endDate)
        }
    
        $fileCount = 0
        $totalFiles = $foundFiles.Count
        Write-Host "`n`nSearching $totalFiles files..."
            
        # Loop through each file and search for the pattern 
        $foundFiles | ForEach-Object {
            $fileCount++
            
            # Update progress without printing new line
            if ($fileCount % 10 -eq 0 -or $fileCount -eq $totalFiles) {
                Write-Host "$fileCount / $totalFiles" -NoNewline
                Write-Host "`r" -NoNewline
            }
        
            # Search using Select-String (faster than Get-Content)
            if (Select-String -Path $_.FullName -Pattern $searchPattern -Quiet) {
                $files += [PSCustomObject]@{
                    FileName = $_.Name
                    CreationDate = $_.CreationTime.ToString('yyyy/MM/dd HH:mm:ss')
                    FullName = $_.FullName
                }
            }
        }
    }


    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($files.Count -gt 0) {
        $files | Sort-Object -Property CreationDate | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FileName)" }
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "`n`n`nTime: $elapsedTime.`nFiles found: $($files.Count)`nSearch: '$searchPattern'"
    return $files
}

function New-UserFiles ($files) {
    $filteredFiles = @()
    # Write-Host $files
    # Prompt for search term
    $searchPattern = Read-Host "Enter the search term"
    # Capture start time
    $startTime = Get-Date
        
    # Get all matching files
    $foundFiles = $files | ForEach-Object { Get-ChildItem -Path "$($_)" -File }
    $totalFiles = $foundFiles.Count
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

    # Capture end time
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime

    # Display results
    if ($filteredFiles.Count -gt 0) {
        Write-Host "Files containing '$searchPattern':"
        $filteredFiles | Sort-Object -Property CreationDate | ForEach-Object { Write-Host "$($_.CreationDate), $($_.FullName)" }
    } else {
        Write-Host "No files contained '$searchPattern'."
    }

    Write-Host "Search complete. Time taken: $elapsedTime.`nFiles found: $($filteredFiles.Count)`nSearch: '$searchPattern'"
    return $filteredFiles
}









############################################################################################################
# Main program loop
Write-Host "

`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n
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
    |    4.                                    |
    |    5.                                    |
    |    0. Exit                               |
    |                                          |
    ============================================
"
    
    $choice = Read-Host "Enter your choice (1-4)"

    switch ($choice) {
        1 { 
            $searchResults = @()
            $filteredResults = @()
            $searchResults = Search-FilesCurrentDirectory $searchResults
            $one = $true
            while ($one){
                Write-Host "`n`nSearch in filtered results?`nY: yes`nN: no (new search)`nR: restart with original results`nPO: print out`nQ: quit to main menu`n"
                $userChoice = Read-Host "Enter your choice"
                switch ($userChoice) {
                    "Q" { $one = $false }
                    "Y" {
                        if ($filteredResults.Count -gt 0) {
                            Write-Host "filterd greater 0"
                            $filteredResults = Search-FilesCurrentDirectory $filteredResults
                        } else {
                            Write-Host "filterd less than or equal 0"
                            $filteredResults = Search-FilesCurrentDirectory $searchResults
                        }
                    }
                    "N" {
                        $filteredResults = @()
                        $searchResults = Search-FilesCurrentDirectory @()
                    }
                    "R" {
                        $filteredResults = @()
                        Write-Host "Restarting with original results..."
                        $filteredResults = Search-FilesCurrentDirectory $searchResults
                    }
                    "PO" {
                        if ($filteredResults.Count -eq 0){
                            $searchResults | ForEach-Object { Write-Host -NoNewline "$($_.FullName)," }
                            Write-Host  # To add a final newline after all the results
                        } else {
                            $filteredResults | ForEach-Object { Write-Host -NoNewline "$($_.FullName)," }
                            Write-Host  # To add a final newline after all the results
                        }
                    }
                    default {
                        Write-Host "Invalid choice. Please enter a valid option."
                    }
                }
            }
        }
        2 { 
            $searchResults = @()
            $filteredResults = @()
            $searchResults = Search-FilesByDirectory $searchResults
            $one = $true
            while ($one){
                Write-Host "`n`nSearch in filtered results?`nY: yes`nN: no (new search)`nR: restart with original results`nPO: print out`nQ: quit to main menu`n"
                $userChoice = Read-Host "Enter your choice"
                switch ($userChoice) {
                    "Q" { $one = $false }
                    "Y" {
                        if ($filteredResults.Count -gt 0) {
                            Write-Host "filterd greater 0"
                            $filteredResults = Search-FilesByDirectory $filteredResults
                        } else {
                            Write-Host "filterd less than or equal 0"
                            $filteredResults = Search-FilesByDirectory $searchResults
                        }
                    }
                    "N" {
                        $filteredResults = @()
                        $searchResults = Search-FilesByDirectory @()
                    }
                    "R" {
                        $filteredResults = @()
                        Write-Host "Restarting with original results..."
                        $filteredResults = Search-FilesCurrentDirectory $searchResults
                    }
                    "PO" {
                        if ($filteredResults.Count -eq 0){
                            $searchResults | ForEach-Object { Write-Host -NoNewline "$($_.FullName)," }
                            Write-Host  # To add a final newline after all the results
                        } else {
                            $filteredResults | ForEach-Object { Write-Host -NoNewline "$($_.FullName)," }
                            Write-Host  # To add a final newline after all the results
                        }
                    }
                    default {
                        Write-Host "Invalid choice. Please enter a valid option."
                    }
                }
            }
        }
        3 { 
            $UserFiles = Read-Host "Enter file paths separated by commas"
            $UserFilesArray = $UserFiles -split ',' | Where-Object { $_.Trim() -ne "" }
            $three = $true
            while ($three){
            New-UserFiles $UserFilesArray
            }
        }
        0 {
            Write-Host "`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n
    ░██████╗░░█████╗░░█████╗░██████╗░██████╗░██╗░░░██╗███████╗
    ██╔════╝░██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝██╔════╝
    ██║░░██╗░██║░░██║██║░░██║██║░░██║██████╦╝░╚████╔╝░█████╗░░
    ██║░░╚██╗██║░░██║██║░░██║██║░░██║██╔══██╗░░╚██╔╝░░██╔══╝░░
    ╚██████╔╝╚█████╔╝╚█████╔╝██████╔╝██████╦╝░░░██║░░░███████╗
    ░╚═════╝░░╚════╝░░╚════╝░╚═════╝░╚═════╝░░░░╚═╝░░░╚══════╝
`n`n`n`n`n`n`n`n`n`n
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