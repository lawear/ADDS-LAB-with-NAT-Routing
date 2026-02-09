# Path to text file and target OU
$TXTPath = ""
$OU = "OU=Users,OU=Westchester,OU=New York,OU=Pawplicity,DC=pawplicity,DC=com"

# Import the data
$UserData = Import-Csv -Path $TXTPath

foreach ($User in $UserData) {
    # .Trim() removes accidental spaces from your text file
    $First = $User.FirstName.Trim()
    $Last = $User.LastName.Trim()
    $SAM = $User.UserName.Trim()
    
    $FullName = "$First $Last"
    $UPN = "$SAM@pawplicity.com"

    # Create the user
    New-ADUser -Name $FullName `
               -GivenName $First `
               -Surname $Last `
               -SamAccountName $SAM `
               -UserPrincipalName $UPN `
               -Path $OU `
               -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) `
               -ChangePasswordAtLogon $true `
               -Enabled $true `
               -ProtectedFromAccidentalDeletion $false  # Set to $true later for production

    Write-Host "Success: Created $FullName (Delete Protection: OFF)" -ForegroundColor Cyan
}
