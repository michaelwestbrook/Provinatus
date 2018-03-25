$ModName = "Provinatus"
$ModDir = "$env:USERPROFILE\Documents\Elder Scrolls Online\live\AddOns\$ModName"
Remove-Item -Path "$ModDir" -Recurse
New-Item -Path "$ModDir" -itemtype directory -force
Copy-Item -Path "$pwd\*" -Exclude @("deploy", ".git", "images", "esoui-changelog.txt", "esoui-readme.txt") -Force -Recurse -Destination "$ModDir"
Write-Host "Copied $pwd\* to $ModDir"