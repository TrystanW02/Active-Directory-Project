Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "      A) Collect new Baseline?"
Write-Host ""
Write-Host "      B) Begin monitoring files with saved Baseline?"
Write-Host ""

$test = Read-Host - Prompt "Please enter 'A' or 'B'"

Write-Host "User entered $($response)"

# Hashing function
Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

# Erase baseline file if it already exist
Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt

    if ($baselineExists) {
        # Delete it
        Remove-Item -Path .\baseline.txt
    }
}

if ($userinput -eq "A".ToUpper()) {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate Hash from the target files and store in baseline.txt
    Write-Host "Calculating Hashes, making new baseline.txt file" -ForegroundColor Cyan

    # Collect all files in the target folder
    $files = Get-ChildItem -Path .\Files

    # For each file, calculate the hash and write to baseline.txt
    foreach ($f in $files) {
       $hash = Calculate-File-Hash $f.FullName
       "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }
}
elseif ($userinput -eq "B".ToUpper()) {
    
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
}
    foreach ($f in $filePathsAndHashes) {
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }

    # Begin (continuously) monitoring files with saved Baseline
    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files

        # For each file, calculate the hash and write to baseline.txt
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

            # Notify if new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                # A new file has been created!
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else {

                #Notify if a new file has been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    # File has not changed
                }
                else {
                    # File has been compromised! Notify the user!
                    Write-Host "$($hash.Path) has been changed!" -ForegroundColor Yellow
                }
            }
        }
        
        foreach ($key in $fileHashDictionary.Keys) {
                $baselineFilesStillExists = Test-Path -Path $key
                if (-Not $baselineFilesStillExists) {
                    # One of the baseline files must have been deleted, notify the user
                    Write-Host "$($key) has been deleted!" -ForegroundColor Red

                }
        }   
    }
            


