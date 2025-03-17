#.DESCRIPTION
# This script needs to be run on with either VMware PowerCli snappin or module and an
# account that has appropriate rights to connecting using Powercli
# To install PowerCli module run
# Install-Module -Name VMware.PowerCLI
# Install-Module -Name VMware.PowerCLI –Scope CurrentUser

#.PARAMETER VCServer
#Mandatory Variable for VMware vCenter server.

#.PARAMETER Export
#Mandatory Variables for Export location.

#.EXAMPLE
# .\VMware_PortGroupReport.ps1 -VCServer vcenter.domain.local -ConsoleOnly

#.EXAMPLE
# .\VMware_PortGroupReport.ps1 -VCServer vcenter.domain.local -ReportExport c:\temp

## Ignore Certificate warning and dosable CEIP
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

## VCenter Connection
$VCServer = "vcenter-vsan.vrack.vsphere.local"
$ReportExport ="C:\Users\Administrator\Downloads\"

#Connect-VIServer -Server $VCServer -ErrorAction SilentlyContinue -ErrorVariable ErrorProcess;
connect-VIServer  $VCServer -ErrorAction SilentlyContinue -ErrorVariable ErrorProcess;
if($ErrorProcess){
    Write-Warning "Error connecting to vCenter Server $VCServer error message below"
    Write-Warning $Error[0].Exception.Message
    $Error[0].Exception.Message | Out-File $ReportExport\ConnectionError.txt
exit
    }

else
{

## Create results array
$results = @()

## Get distributed port groups
$portGroups = Get-VDPortgroup

## Loop through each port group
foreach ($port in $portGroups) {

Write-Host "Checking VMs on $($port)" -foreground green

## Get port group view and add addtionaly properties
$networks = Get-View -ViewType Network -Property Name -Filter @{"Name" = $($port.name)}
$networks | ForEach-Object{($_.UpdateViewData("Vm.Name","Vm.Guest.IpAddress","Vm.Runtime.Host.Name","Vm.Runtime.Host.Parent.Name","vm.Runtime.PowerState"))}

## Loop through each view
foreach ($network in $networks){

## Get VM's
$vms = $network.LinkedView.Vm

## Check if any data in VMS variable
if ($vms){

## Loop through VM's
foreach ($vm in $vms){

## Create hash table for properties
$properties = @{
VMName = $vm.name
IP_Address = $vm.Guest.IpAddress
PortGroup = $network.Name
Host = $vm.Runtime.LinkedView.Host.Name
Cluster = $vm.Runtime.LinkedView.Host.LinkedView.Parent.Name
PowerStatus = $vm.Runtime.PowerState
}

## Export results
$results += New-Object pscustomobject -Property $properties
    }
}

## for any networks that have no VMs
else {

## Create hash table for properties
$properties = @{
VMName = "No VMs"
IP_Address = "N/A"
PortGroup = $network.Name
Host = "N/A"
Cluster = "N/A"
PowerStatus = "N/A"  
}

## Export results
$results += New-Object pscustomobject -Property $properties
        }
    }
}


## Export resutls 
if ($ReportExport){
$results | Select-Object VMName, IP_Address, PortGroup, Host, Cluster, PowerStatus | 
Export-csv $ReportExport\$VCServer-PortGroupExport_new01.csv -NoTypeInformation
    }
}
