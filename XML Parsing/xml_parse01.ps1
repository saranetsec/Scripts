[xml]$xml = Get-Content 'C:\Users\sa001704\Documents\CBA_PAFW.xml'

$xml.SelectNodes('/devices/entry/device-group/entry/address-group/*') | ForEach-Object {

    #New-Object -Type PSObject -Property
     [PSCustomObject]@{
     $Mem_Count = ($_.static.member).Count
        Name = $_.name
        Members = $_.static.member -join ';'
        Total_Members = $Mem_Count
    }
} | Export-Csv 'C:\Users\sa001704\Documents\address_groups.csv' -NoType