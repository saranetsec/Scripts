[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_BW_PAFW.xml'
$keys = Import-Csv 'C:\Users\sa001704\Documents\BW_Candidate_SG_Raw_130225.csv' | select -ExpandProperty Candidate_Security_Groups
ForEach ($sgs in $keys) {
$childxpath = "/devices/entry/device-group/entry/post-rulebase/security/rules/entry[contains(.,'$sgs')]"
#$childxpath = "/devices/entry/device-group/entry/post-rulebase/security/rules/entry[@member[substring(., string-length(.) - string-length($sgs) + 1) =  $sgs]"
#substring($s, string-length($s) - string-length($suffix) + 1) =  $suffix
## Get node:
#$node = $xml.SelectSingleNode($childxpath)
#$node
#$node.source.member
#$node.destination.member
#$node
#$node.action
#$node.'log-start'
#$childxpath
$xml.SelectNodes($childxpath) | ForEach-Object {
if ($_.source.member -eq $sgs) {
$srcmatch = "True"
#Write-Host $sgs "Matching with rule " $node.name "under source"
}
elseif ($_.destination.member -eq $sgs) { 
$dstmatch = "True"

#Write-Host $sgs "Matching with rule " $node.name "under destination"
}
elseif ($_.source.member -eq $sgs -and $_.destination.member -eq $sgs) { 
$bothmatch = "True"

#Write-Host $sgs "Matching with rule " $node.name "under both source & destination"
}
else {
Write-host $sgs "Not maching with any rules"

}

if ($srcmatch -eq "True" -or $dstmatch -eq "True" -or $bothmatch -eq "True") {
#Write-Host "Matching rules"
#$node.ParentNode.name
#$parentnode = $node.ParentNode.Name
#$_.name
## Get Parent Node Name

 $result = New-Object psobject -Property $([ordered]@{
     #[PSCustomObject] $([ordered]@{
     #[PSCustomObject] @{
        Candidate_SG = $sgs
        Candidate_Rule = $_.name
        Rule_Source_Members_Name = $_.source.member -join ';'
        Rule_Source_Members_Count = ($_.source.member).count
        Rule_Dest_Members_Name = $_.destination.member -join ';'
        Rule_Dest_Members_Count = ($_.destination.member).count
        Rule_Service = $_.service.member -join ';'
        Rule_Services_Count = ($_.service.member).count
        Rule_Action = $_.action
        Rule_Application = $_.application.member -join ';'
        Rule_Logging = $_."log-start"     
    }) | Export-Csv 'C:\Users\sa001704\Documents\BW_candidate_rules_all_170225.csv' -NoType -Append
    }
}
}

