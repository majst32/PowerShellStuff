function process-ADOrganizationalUnit {
    param (
        [string]$OUDistName,
        [string]$Filler
        )
    
    $OUName = $OUDistName.split(",",2)[0] #splits the name from the parent
    $OUParent = $OUDistName.split(",",2)[1] #leaves the parent
    
    #You would put the try/catch block here instead of the write-host 
    #new-ADOrganizationalUnit -identity $OUName -path $OUParent
    
    write-host "$Filler$OUName"
    
    $NextOU = Get-ADOrganizationalUnit -filter * -SearchBase $OUDistName -SearchScope OneLevel | Select-Object DistinguishedName
    if (!($NextOU -eq $Null)) {
        foreach ($Line in $NextOU){
            $Filler = $Filler + "     "
            process-ADOrganizationalUnit -OUDistName $Line.DistinguishedName -filler $Filler
            }
        }
    }

$pdcefrom = (Get-ADDomainController -Server "DC1.company.pri" -Filter {OperationMasterRoles -like 'PDCEmulator'}).hostname 
$ADNameSource = (Get-ADDomain -Server "DC1.company.pri" ).name 
#$pdceto = (Get-ADDomainController -Server "testdc2.test2.net" -Filter {OperationMasterRoles -like 'PDCEmulator'}).hostname 
#$ADNameDestination = (Get-ADDomain -Server "testdc2.test2.net").name 
$credentialForestFrom = (Get-Credential) 
#$credentialForestTo = (Get-Credential) 
 
$OFS = ',' 
#$domain = (get-addomain -Server $pdceto -Credential $credentialForestTo).Distinguishedname 
$domain2 = (get-addomain -Server $pdcefrom -Credential $credentialForestfrom).Distinguishedname 
[Array]$data = "" 
[array]$data = (Get-ADOrganizationalUnit -SearchBase $domain2 -searchScope OneLevel -filter * -Server $pdcefrom -Credential $credentialForestFrom ).Distinguishedname 
[array]::Reverse($data) 

foreach($line in $data){ 
    $OUName = $line.split(",",2)[0] #this works and splits the name from the parent
    $OUParent = $line.split(",",2)[1] #this works and leaves the parent
    $Filler = ""
    process-ADOrganizationalUnit -OUDistName $Line -Filler $Filler
    }
