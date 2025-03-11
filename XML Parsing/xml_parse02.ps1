[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_PAFW.xml'

$ipcheck = @("10.88.136.","10.88.137.","10.88.139.")

## XPath:

foreach ($ipadd in $ipcheck) {
$ipadd
$childxpath = "/devices/entry/device-group/entry/address/entry[ip-netmask[contains(text(),'$ipadd')]]"
#$childxpath = "/root/*/*[./child='$childnode']"
## Get node:
#$node = $xml.SelectSingleNode($childxpath, $null)
$node = $xml.SelectNodes($childxpath)
## Show selected node name:
Write-Host $node.name + $node.name.Count 
    #New-Object -Type PSObject -Property
    #$Output =New-Object -TypeName PSObject -Property @{
     [PSCustomObject]@{
        Candidate_Network = $ipadd
        Candidate_Security_Groups = $node.name -join ';'
        No_of_SGs = $node.name.Count 
    } | Export-Csv 'C:\Users\sa001704\Documents\candidate_sgs.csv' -NoType -Append
} 

