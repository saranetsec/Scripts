﻿[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_PAFW.xml'

$childxpath = "/devices/entry/device-group/entry/address/entry[ip-netmask[not(contains(text(),'-'))]]"
#$childxpath
#$xml.SelectNodes('/devices/entry/device-group/entry/address/entry/*[@*[contains(text(),'/')]]') 
$node = $xml.SelectNodes($childxpath) | ForEach-Object {
    #New-Object -Type PSObject -Property
     [PSCustomObject]@{
     #$IPadd_Count = ($_.'ip-netmask').Count
     #$IPRange_Count = ($_.'ip-range').Count
        Name = $_.name
        IP_Address = $_.'ip-netmask' -join ';'
        #IP_Address_Count = $IPadd_Count
        #IP_Range = $_.'ip-range' -join ';'
        #IP_Range_Count= $IPRange_Count
    }
} | Export-Csv 'C:\Users\sa001704\Documents\IP_CIDR_addresses_Only.csv' -NoType