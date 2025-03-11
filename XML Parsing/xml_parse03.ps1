[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_PAFW.xml'
$keys = Import-Csv 'C:\Users\sa001704\Documents\candidate_sgs.csv' | select -ExpandProperty Candidate_Security_Groups
$keystring = $keys -split ';' | ForEach-Object {$_ -replace '"',''}
#$keystring
ForEach ($sgs in $keystring) {
#$sgs
$childxpath = "/devices/entry/device-group/entry/address-group/entry/static[member[contains(text(),'$sgs')]]"
#$childxpath = "/root/*/*[./child='$childnode']"
## Get node:
#$node = $xml.SelectSingleNode($childxpath, $null)
$node = $xml.SelectNodes($childxpath)
## Get Parent Node Name
$parentnode = $node.ParentNode.Name
#foreach ($parent in $parentnode) {
#$parentxpath = '/devices/entry/device-group/entry/address-group/'+$parent 
#$parentxpath
#$node.ParentNode.Static.Member
# ForEach-Object { $parent = $xml.SelectSingleNode($parentxpath) 

## Show selected node name:
#Write-Host $node.name + $node.name.Count 
    #New-Object -Type PSObject -Property
    #$Output =New-Object -TypeName PSObject -Property @{
     [PSCustomObject]@{
        Candidate_IP_Address = $sgs
        Candidate_Address_Groups = $node.ParentNode.Name -join ';'
        Candidate_Address_Group_Members = $node.ParentNode.Static.Member -join ';'
        No_of_SGs = $node.ParentNode.Name.Count 
        Total_Members = ($node.ParentNode.Static.Member).Count
    } | Export-Csv 'C:\Users\sa001704\Documents\candidate_address_groups.csv' -NoType -Append
    }
#}
#} 