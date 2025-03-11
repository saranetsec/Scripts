[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_BW_PAFW.xml'
Import-Module Indented.Net.IP
 
$ipcheck = @('10.88.136.0/24','10.88.139.0/24','10.88.137.0/24','10.88.145.128/26','10.88.146.128/27','10.88.146.32/27','10.88.146.64/27','10.88.144.192/26')
## XPath:

#$srclist
foreach ($srclist in $ipcheck){

$childxpath = "/devices/entry/device-group/entry/address/entry[ip-netmask[not(contains(text(),'-'))]]"
#$childxpath = "/devices/entry/device-group/entry/address/entry"
#$xml.SelectNodes('/devices/entry/device-group/entry/address/*') | ForEach-Object {
#$node =
$xml.SelectNodes($childxpath) | ForEach-Object {

 $Name = $_.name
 $SG_IP = $_.'ip-netmask'
 $SG_IP_Range = $_.'ip-range'
 
#if ($ipadd -ne ""){
#if ($SG_IP -ne $null){
#if ($SG_IP -eq '10.88.0.0/16') {
#Write-Host $Name  " Matching with " $SG_IP
#}
#$srclist
$checkmatch = Test-SubnetMember -SubjectIPAddress $SG_IP -ObjectIPAddress $srclist
$checkmatch01 = Test-SubnetMember -SubjectIPAddress $srclist -ObjectIPAddress $SG_IP
 #Write-Host "Entering...."
#}

#else{
#$SG_IP
#Write-Host $Name  "Having an IP range"  $SG_IP_Range "while checking " $srclist -ForegroundColor Red
#}

if ($checkmatch -eq "True" -or $checkmatch01 -eq "True") {
#$checkmatch
#$Name
 [PSCustomObject]@{
        Candidate_Network = $srclist
        Candidate_IP = $SG_IP
        Candidate_Security_Groups = $Name
        #Candidate_SG_Group = $Group_Name -join ';'
        #Candidate_SG_Group_Members = $Group_Members -join ';'
        #No_of_SGs = $node.name.Count 
    } | Export-Csv 'C:\Users\sa001704\Documents\BW_candidate_sgs_170225_0515pm.csv' -NoType -Append
 #Write-host $Name  "with IP Address"  $SG_IP  "is matching with"  $srclist -ForegroundColor Green
 $childgroupxpath = "/devices/entry/device-group/entry/address-group/entry/static[member[contains(.,'$Name')]]"
 #$childgroupxpath
  $xml.SelectNodes($childgroupxpath) | ForEach-Object {
 
 $Group_Name = $_.ParentNode.Name
 $Group_Members = $_.member

 #$groupcheckmatch = Test-SubnetMember -SubjectIPAddress $Name -ObjectIPAddress $srclist
 #Write-host $Group_Name "having "  $Group_Members
 [PSCustomObject]@{
        Candidate_Network = $srclist
        Candidate_IP = $SG_IP
        Candidate_Security_Groups = $Name
        Candidate_SG_Group = $Group_Name -join ';'
        Candidate_SG_Group_Members = $Group_Members -join ';'
        #No_of_SGs = $node.name.Count 
    } | Export-Csv 'C:\Users\sa001704\Documents\BW_candidate_sg_groups_170225_0515pm.csv' -NoType -Append
}
}
}
}
Start-Sleep 60
$sg_group_import = Import-Csv 'C:\Users\sa001704\Documents\BW_candidate_sg_groups_170225_0515pm.csv'  | select -ExpandProperty Candidate_SG_Group -Unique
foreach ($sg_group_list in $sg_group_import){

 $secondchildgroupxpath = "/devices/entry/device-group/entry/address-group/entry/static[member[contains(.,'$sg_group_list')]]"
 #$childgroupxpath
  $xml.SelectNodes($secondchildgroupxpath) | ForEach-Object {
 
 $SG_Group_Name = $_.ParentNode.Name
 $SG_Group_Members = $_.member
 #$SG_Group_Name
 #$SG_Group_Members
  [PSCustomObject]@{
       # Candidate_Network = $srclist
        Candidate_SG = $sg_group_list
        Candidate_Security_Groups = $SG_Group_Name
        #No_of_SGs = $node.name.Count 
    } | Export-Csv 'C:\Users\sa001704\Documents\BW_candidate_sg_groups_2ndlevel_18022025.csv' -NoType -Append
}
}
