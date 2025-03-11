[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_BW_PAFW.xml'
$keys = Import-Csv 'C:\Users\sa001704\Documents\BW_Candidate_Sgs_raw.csv' | select -ExpandProperty Candidate_Security_Groups
#$keystring = $keys -split ';' | ForEach-Object {$_ -replace '"',''}
#$keystring
#ForEach ($sgs in $keys) {
#$sgs
$childxpath = "/devices/entry/device-group/entry/post-rulebase/security/rules/entry/*[contains(text(),'g_TD-ZH7-10.88.136.14-CMC')]"
#$childxpath = "//*[contains(@member='g_TD-ZH7-10.88.136.14-CMC')]"
#$childxpath
#$childxpath = "/root/*/*[./child='$childnode']"
## Get node:
#$node = $xml.SelectSingleNode($childxpath, $null)
$node = $xml.SelectNodes($childxpath)
$node
$node.ParentNode.Name
## Get Parent Node Name

#foreach ($parent in $parentnode) {
#$parentxpath = '/devices/entry/device-group/entry/address-group/'+$parent 
#$parentxpath
#$node.ParentNode.Static.Member
# ForEach-Object { $parent = $xml.SelectSingleNode($parentxpath) 


## Show selected node name:
#Write-Host $node.name + $node.name.Count 
    #New-Object -Type PSObject -Property
    #$Output =New-Object -TypeName PSObject -Property @{
     [PSCustomObject] $([ordered]@{
        Candidate_SG = $sgs
        Candiadate_Rule_Name = $parentnode -join ';'
        Candidate_Source_Members = $node.source.member -join ';'
        Candidate_Dest_Members = $node.destination.member -join ';'
        #Candidate_Address_Group_Members = $node.ParentNode.Static.Member -join ';'
        No_of_SGs = $node.ParentNode.Name.Count 
        Total_Members = ($node.ParentNode.Static.Member).Count
    }) | Export-Csv 'C:\Users\sa001704\Documents\BW_candidate_rules.csv' -NoType -Append
    #}
#}
#} 