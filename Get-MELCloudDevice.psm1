﻿function Get-MELCloudDevice {
<#
.Synopsis
   Displays various information about each of your MELCloudDevice(es).  
.EXAMPLE
   Get-MELCloudDevice -ContextKey <Your_ContextKey>
.INPUTS
   ContextKey
.OUTPUTS
    DeviceID    BuildingID      DeviceName          MacAddress            SerialNumber
    --------    ----------      ----------          ----------            ------------
    <DeviceID> <BuildingID> <NameOfYourDevice> <MacAddressOfYourDevice>  <10-digit S/N>
.NOTES
   Author:     Freddie Christiansen
   Website:    https://www.cloudpilot.no
   LinkedIn:   https://www.linkedin.com/in/freddie-christiansen-64305b106
.LINK
   https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/
#>
    [CmdletBinding()]

param(
  
    [Parameter(Mandatory = $True,
    ValueFromPipeline = $False,
    HelpMessage = "Enter your ContextKey")]
    [Alias('CT')]
    [string[]]$ContextKey

)

BEGIN {}



PROCESS {



        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = "https://app.melcloud.com/Mitsubishi.Wifi.Client/User/ListDevices"


        $Header = @{ 
        
        "Accept"="application/json, text/javascript, */*; q=0.01"
        "Referer"="https://app.melcloud.com/"
        "X-MitsContextKey"="$ContextKey"
        "X-Requested-With"="XMLHttpRequest"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"
        "Sec-Fetch-Mode"="cors"
        
        }
    
        
        

        
    try {


       

       $Devices = Invoke-WebRequest -Uri $Uri -Headers $Header -Method GET

       $Info =  $Devices.Content | ConvertFrom-Json | ConvertTo-Json -Depth 6 | ConvertFrom-Json
        
      #   Write-Host "Got info $Info"
        
      ## Web PSCore likes this:
       $FirstDevice = $Info.Structure.Devices[0]
      #  Write-Host "Got firstdevice $FirstDevice1"

      #  $InfoValueCount = $Info.value.Count
      #  $DevicesCount = $Info.value[0].Structure.Devices.Count
      #  Write-Host "LOOK-DeviceCount: $InfoValueCount  and $DevicesCount"
      #  Write-Host "LOOK-Info: $Info"
      #  $FirstDevice = $Info.value[0].Structure.Devices[0]
       
      #  Write-Host "LOOK-First: $FirstDevice"
       $Properties = @{

         DeviceID = $FirstDevice.DeviceID
         BuildingID = $FirstDevice.BuildingID
         DeviceName = $FirstDevice.DeviceName
         MacAddress = $FirstDevice.MacAddress
         SerialNumber = $FirstDevice.SerialNumber
         }


         # Write-Host "LOOK-Props: $Properties"
     $obj = New-Object -TypeName PSObject -Property $Properties
     
     
   #   Write-Host "LOOK-Obj: $obj"
    Write-Output $obj

      #  foreach ($Devices in $Devices.Content) { 

      # #  $Info.value.Structure.Devices | select DeviceID,BuildingID, DeviceName, MacAddress, SerialNumber


       
      # #  $obj = New-Object -TypeName PSObject -Property $Properties
       


      #  }
    }

    catch {
    
    
        Write-Warning "An unexpected error occurred. Please verify your ContextKey and try again."
    
    }

       
 }



END {}


}