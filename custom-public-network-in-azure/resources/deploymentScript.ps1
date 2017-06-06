<#
 .SYNOPSIS
    Deploy a Ethereum Network

 .DESCRIPTION
    Deploy a Ethereum Network

 .PARAMETER pathToProfile
    Path to the profile containing the log in information.

 .PARAMETER resourceGroupName
    Name of the resource group.

 .PARAMETER resourceGroupLocation
    Location of the resource group.

 .PARAMETER storageName
    Name of the storage account.

 .PARAMETER vnetName
    Name of the virtual network.
#>


param(
 [Parameter(Mandatory=$True)]
 [string]
 $pathToProfile,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $storageName,

 [Parameter(Mandatory=$True)]
 [string]
 $vnetName
)


#Login
Try {
    Select-AzureRmProfile -Path $pathToProfile;
}
Catch {
    Login-AzureRmAccount;
    Save-AzureRmProfile -Path $pathToProfile;
}

# C:\temp\azure_profile.json, testRG, westeurope, teststoragejoez, testVNET

# Create a resource group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation;


# Create Storage Account
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -SkuName Standard_LRS -Location $resourceGroupLocation;


# Create a virtual Network
# Create Network Security Group (Firewall)
$sshrule = New-AzureRmNetworkSecurityRuleConfig -Name "SSH" -Description "Allow SSH" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 22

$gethruleinboundrule = New-AzureRmNetworkSecurityRuleConfig -Name "GethInbound" -Description "Allow Geth relevant ports - inbound" `
    -Access Allow -Protocol * -Direction Inbound -Priority 110 `
    -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 30303

$gethruleoutboundrule = New-AzureRmNetworkSecurityRuleConfig -Name "GethOutbound" -Description "Allow Geth relevant ports - outbound" `
    -Access Allow -Protocol * -Direction Outbound -Priority 110 `
    -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 30303

$jsonrpcrule = New-AzureRmNetworkSecurityRuleConfig -Name "JSON-RPC" -Description "Allow JSON-RPC" `
    -Access Allow -Protocol * -Direction Inbound -Priority 120 `
    -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 8545

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
 -Name "NSG-BackendSubnet" -SecurityRules $sshrule,$gethruleinboundrule,$gethruleoutboundrule,$jsonrpcrule

# The deployment of the vnet including the creation of the subnet
$BackendSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name "BackendSubnet" -AddressPrefix "192.168.1.0/24" -NetworkSecurityGroup $nsg

$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName `
    -AddressPrefix "192.168.0.0/16" -Location $resourceGroupLocation -Subnet $BackendSubnet;


# Create the VMs
# The transaction VM
$publicIPAddressTX0 = New-AzureRmPublicIpAddress -Name "TX0-Public-IP" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
    -AllocationMethod Static -IdleTimeoutInMinutes 4;

$nicTX0 = New-AzureRmNetworkInterface -Name "TX0-NIC" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
    -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIPAddressTX0.Id;

$securePassword = ConvertTo-SecureString 'testPass!1234' -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential ("adminjoez", $securePassword);

$osDiskUriTX0 = $storageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "tx0" + ".vhd";

$vmConfigTX0 = New-AzureRmVMConfig -VMName "TX0" -VMSize Standard_D1_v2 | `
    Set-AzureRmVMOperatingSystem -Linux -ComputerName "TX0" -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 16.04-LTS -Version latest | `
    Add-AzureRmVMNetworkInterface -Id $nicTX0.Id | `
    Set-AzureRmVMOSDisk -Name "TX0-OSDisk" -VhdUri $osDiskUriTX0 -CreateOption FromImage;

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -VM $vmConfigTX0;

# The first mining VM
$nicMN0 = New-AzureRmNetworkInterface -Name "MN0-NIC" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
    -SubnetId $vnet.Subnets[0].Id;

$securePassword = ConvertTo-SecureString 'testPass!1234' -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential ("adminjoez", $securePassword);

$osDiskUriMN0 = $storageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "mn0" + ".vhd";

$vmConfigMN0 = New-AzureRmVMConfig -VMName "MN0" -VMSize Standard_D1_v2 | `
    Set-AzureRmVMOperatingSystem -Linux -ComputerName "MN0" -Credential $cred  | `
    Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 16.04-LTS -Version latest | `
    Add-AzureRmVMNetworkInterface -Id $nicMN0.Id | `
    Set-AzureRmVMOSDisk -Name "MN0-OSDisk" -VhdUri $osDiskUriMN0 -CreateOption FromImage;

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -VM $vmConfigMN0;

# The second mining VM
$nicMN1 = New-AzureRmNetworkInterface -Name "MN1-NIC" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
    -SubnetId $vnet.Subnets[0].Id;

$securePassword = ConvertTo-SecureString 'testPass!1234' -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential ("adminjoez", $securePassword);

$osDiskUriMN1 = $storageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "mn1" + ".vhd";

$vmConfigMN1 = New-AzureRmVMConfig -VMName "MN1" -VMSize Standard_D1_v2 | `
    Set-AzureRmVMOperatingSystem -Linux -ComputerName "MN1" -Credential $cred  | `
    Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 16.04-LTS -Version latest | `
    Add-AzureRmVMNetworkInterface -Id $nicMN1.Id | `
    Set-AzureRmVMOSDisk -Name "MN1-OSDisk" -VhdUri $osDiskUriMN1 -CreateOption FromImage;

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -VM $vmConfigMN1;