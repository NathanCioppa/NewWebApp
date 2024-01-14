function Test-ValidFileName {
    param([string]$FileName)

    $IndexOfInvalidChar = $FileName.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars())

    return $IndexOfInvalidChar -eq -1
}

Write-Host "This script will create a new directory containing an HTML file with an attached JavaScript file.`n"

$outputName = "newWebApp"
$outputPath = "C:\Users\nacio\Documents\Programs\Web Apps"
$htmlFileName = "index"
$jsFileName = $htmlFileName


$nameResponse = Read-Host "New project name"
if($nameResponse.Trim() -ne "") {$outputName = $nameResponse}
Write-host $outputName -ForegroundColor Magenta

Do {
    Write-Host "`nWould you like to use the default settings?"
    Write-Host "["-NoNewline 
    Write-Host "Y" -ForegroundColor Green -NoNewLine
    Write-Host " / "  -NoNewline 
    Write-Host "N" -ForegroundColor Red -NoNewLine
    Write-Host "]" -NoNewLine
    $defaults = Read-Host " [D to view defaults]"
    if($defaults -eq "d") {
        Write-Host ""
        Write-Host "-Target directory ~~~~~~~~~~~~ "-NoNewline
        Write-Host "$outputPath" -ForegroundColor Blue
        Write-Host "-New HTML and JS file names ~~ "-NoNewLine 
        Write-Host "$htmlFileName`n" -ForegroundColor Magenta
    }
} until ( 'y', 'n' -contains $defaults )


if($defaults -eq "n"){
    Write-Host "Respond to following questions to change project settings. Press " -NoNewline
    Write-Host "[Enter] " -ForegroundColor Yellow -NoNewline
    Write-host "on any question to use default the setting."

    $invalid = $false
    Do {
        if($invalid) {
            Write-Host "Could not find path `"$response`" Enter a valid path or press [Enter] to use the default path." -ForegroundColor Red 
        }
        $response = Read-Host "Target directory path"
        $response = $response.Trim(" ", "`"")
        
        $invalid = $true
        if($response -eq "") {$response = $outputPath}
    } until (Test-Path -Path $response)

    $outputPath = $response
    Write-host $outputPath -ForegroundColor Blue

    
    $invalid = $false
    Do {
        if($invalid) {
            Write-Host "File name `"$response`" contains characters that are not allowed. Enter a name without special characters or press [Enter] to use the default name." -ForegroundColor Red
        }
        $response = Read-Host "HTML file name (without extension)"
        $response = $response.Trim()

        $invalid = $true
        if($response -eq "") {$response = $htmlFileName}
    } until (Test-ValidFileName $response)

    $htmlFileName = $response
    Write-host $htmlFileName -ForegroundColor Magenta


    $invalid = $false
    Do {
        if($invalid) {
            Write-Host "File name `"$response`" contains characters that are not allowed. Enter a name without special characters or press [Enter] to use the default name." -ForegroundColor Red
        }
        $response = Read-Host "JavaScript file name (without extension)"
        $response = $response.Trim()
        
        $invalid = $true
        if($response -eq "") {$response = $jsFileName}
    } until (Test-ValidFileName $response)

    $jsFileName = $response
    Write-host $jsFileName -ForegroundColor Magenta
}


$outputPath = "$outputPath\$outputName"

$identicalFileNameNumber = 0
$testOutputPath = $outputPath
while(Test-Path -Path $testOutputPath) {
    $identicalFileNameNumber++
    $testOutputPath = $outputPath+"($identicalFileNameNumber)"
}
$outputPath = $testOutputPath

New-Item -ItemType directory -Path "$outputPath"
New-Item -ItemType file -Path "$outputPath\$htmlFileName.html"
New-Item -ItemType file -Path "$outputPath\$htmlFileName.css"
New-Item -ItemType file -Path "$outputPath\$jsFileName.js"

$htmlBoilerplate = "<!DOCTYPE html>
<html lang=`"en`">
<head>
    <meta charset=`"UTF-8`">
    <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">
    <title>$outputName</title>
    <link rel=`"stylesheet`" href=`"$htmlFileName.css`">
    <script src=`"$jsFileName.js`"></script>
</head>
<body>
    Created by script: `"$PSCommandPath`"
</body>
</html>"

"$htmlBoilerplate" | Out-File "$outputPath\$htmlFileName.html"

if($identicalFileNameNumber -eq 0){
    Write-host "`n$outputName "-NoNewline -ForegroundColor Magenta
} else {
    Write-host "`n$outputName($identicalFileNameNumber) "-NoNewline -ForegroundColor Magenta
}
Write-host "successfully created at "-NoNewLine 
Write-host "$outputPath" -ForegroundColor Blue