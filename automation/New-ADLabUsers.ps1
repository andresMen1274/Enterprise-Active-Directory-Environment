Import-Module ActiveDirectory

#Base domain path
$DomainDN = "DC=ActiveDirectory,DC=local"

#Create Organizational Units This creates a list of strings that contain the OU's names
$OUs = @("IT", "SOC", "HR", "Security")

#Create each OU
foreach ($OU in $OUs){
    if(-not(Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" -ErrorAction SilentlyContinue)){
        New-ADOrganizationalUnit -Name $OU -Path $DomainDN
        Write-Host "Created OU: $OU"
    }
}
#Create Security groups
$Groups = @("IT_admin", "SOC_admin", "HR_admin", "Security_admin")

#Iterate through the list and created a active driectory group
foreach($Group in $Groups){
    if(-not(Get-ADGroup -Filter "Name -eq '$Group'" -ErrorAction SilentlyContinue)){
        New-ADGroup `
            -Name $Group `
            -GroupScope Global `
            -GroupCategory Security `
            -Path "OU=Security,$DomainDN"
        Write-Host "Security Group created: $Group"
    }
}

#Create Users
$Users = @(
    @{First="Alice"; Last="Johnson"; Username="ajohnson"; OU="IT"; Group="IT_admin"}
    @{First="Bob"; Last="Watson"; Username="bwatson"; OU="SOC"; Group="SOC_admin"}
    @{First="Juan"; Last="Sanchez"; Username="jsanchez"; OU="HR"; Group="HR_admin"}
    @{First="Joe"; Last="Apple"; Username="japple"; OU="Security"; Group="Security_admin"}
)

$DefaultPassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force


foreach($User in $Users){
    $UserPath = "OU=$($User.OU),$DomainDN"
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.Username)'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -GivenName $User.First `
            -Surname $User.Last `
            -Name "$($User.First) $($User.Last)" `
            -SamAccountName $User.Username `
            -UserPrincipalName "$($User.Username)@ActiveDirectory.local" `
            -Path $UserPath `
            -AccountPassword $DefaultPassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Add-ADGroupMember -Identity $User.Group -Members $User.Username

        Write-Host "Created user: $($User.Username) and added to $($User.Group)"
    }
}