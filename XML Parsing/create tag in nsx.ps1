#$filepath = Import-csv -Path "C:\Users\sa001704\Scripts\vCener_TagAssignment_per4.csv"
$vmname = "UPP2SWEB018" 
$scopevalue = "App_ICMS" #Update this value
$scopevalue1 = "Server Function"
#$vmtaglistonly = Import-Csv -Path $filepath | Where-Object {($_."Category" -eq $scopevalue)}| Select-Object -ExpandProperty TagName -Unique
$vmtaglistonly = Import-Csv -Path C:\Users\sa001704\Scripts\vCener_TagAssignment_per4.csv | Where-Object {($_."TagName" -eq $scopevalue -and $_."VMName" -eq $vmname)} | Select-Object  VMName,TagName,Category -Unique
$vmtaglistonly1 = Import-Csv -Path C:\Users\sa001704\Scripts\vCener_TagAssignment_per4.csv | Where-Object {($_."Category" -eq $scopevalue1 -and $_."VMName" -eq $vmname)} | Select-Object VMName,TagName,Category -Unique
#$vmtaglistonly
#$vmtaglistonly1
$vmlist = Import-Csv -Path C:\Users\sa001704\Scripts\vCener_TagAssignment_per4.csv |  Where-Object {($_."Category" -eq $scopevalue -and $_."VMName" -eq $vmname)} | Select-Object VMName,TagName -Unique
#$vmlist
foreach ($vm in $vmlist) {
Write-Host $vm.VMName + $vm.TagName

}
foreach ($category1 in $vmtaglistonly1) {
    Write-Host $category1.VMName + $category1.TagName
}
