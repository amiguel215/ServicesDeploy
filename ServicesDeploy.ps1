#Check current execution policy
$policy = Get-ExecutionPolicy

# if the current policy is "Restricted", change to "RemoteSigned"
if ($policy -eq "Restricted") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Execution policy has been changed to RemoteSigned"
} else {
    Write-Host "The current execution policy is $policy"
}

############################################################################################
#Command: https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1
# For security reasons, it is recommended that each user logs in using their own Azure credentials instead of using pre-defined login variables in the script. The following steps outline the manual login process:

# Connect Azure Account
Write-Host "-----------------------------------------------------------"
Write-Host "Connecting Azure Account......."
# $TenantId = "MyTenantId"
# $SubscriptionId = "MySubscriptionId"
# $ApplicationId = "MyApplicationId"
# $ApplicationPassword = Get-AzADAppCredential -ObjectId $ApplicationId
# $ApplicationSecuredPassword = ConvertTo-SecureString -String $ApplicationPassword -AsPlainText

# $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $ApplicationSecuredPassword
# Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Subscription $SubscriptionId -Credential $Credential

# Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId

Connect-AzAccount | Out-Null
Write-Output "Connection Successful.........."

# Environment
Write-Host "-----------------------------------------------------------"
Write-Host "Be Careful with the environment selection"
$Enviroment = "Dev"
Write-Host "$Enviroment environment selected"

############################################################################################
#Command: https://learn.microsoft.com/es-es/powershell/module/azurerm.resources/get-azurermresourcegroup?view=azurermps-6.13.0
#Command: https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroup?view=azps-9.7.1

# Resource Group
Write-Host "-----------------------------------------------------------"
Write-Host "Check or Create the Resource Group"

if ($Enviroment -eq "Prod"){

    $AzGroup = @{
        Name = "RG-Exercise-Prod"
        Location = "eastus"
    }
}

elseif ($Enviroment -eq "Dev"){

    $AzGroup = @{
        Name = "RG-Exercise-Dev"
        Location = "eastus"
    }
}

$ERG = Get-AzResourceGroup -Name $AzGroup.Name -ErrorAction SilentlyContinue

if ($ERG -ne $null) {
    Write-Host ""
    Write-Host "Resource Group "$($ERG.ResourceGroupName)" already exists"

    $resources = Get-AzResource -ResourceGroupName $ERG.ResourceGroupName
    Write-Host "Resources in the Resource Group:"
    Write-Host ""

    foreach ($resource in $resources) {
        Write-Host "Resource Name: $($resource.Name)"
        Write-Host "Resource Type: $($resource.Type)"
        Write-Host "--------"
    }

    $deployments = Get-AzResourceGroupDeployment -ResourceGroupName $ERG.ResourceGroupName
    foreach ($deployment in $deployments) {
        Write-Host "Deployment Name: $($deployment.DeploymentName)"
        Write-Host "Deployment State: $($deployment.ProvisioningState)"
        Write-Host "Deployment date and time: $($deployment.Timestamp)"
        Write-Host "--------"
    }
} else {
    Write-Host "Resource Group '$($AzGroup.Name)' doesn't exist. Creating new Resource Group..."
    New-AzResourceGroup @AzGroup
}

############################################################################################
# Funtion CheckResource
Write-Host "-------------------------------------------------------------------"
function CheckResource {
    param (
        [Parameter(Mandatory)]
        [string]$ResourceName
    )

    $Parameters =@{
        Name = "$ResourceName"
        ErrorAction = "SilentlyContinue"
    }

    if ($AzGroup.Name){
        $Parameters += @{
            ResourceGroupName = $AzGroup.Name
        }
    }

    $Exist = Get-AzResource @Parameters

    return $Exist ? $true : $false

}

############################################################################################
# Resource Names Declaration

if ($Enviroment -eq "Dev"){

    write-host "Enviroment: Development"

    $SA_Name = "fstorageaccountdev01"
    $AppPlan_Name = "AppService_dev"
    $WebApp_Name = "PruebaSDWebbAC01dev"
    $FuntionApp_Name = "funtionappdev"

}

elseif ($Enviroment -eq "Prod"){

    write-host "Enviroment: Production"

    $SA_Name = "fstorageaccountprod01"
    $AppPlan_Name = "AppService_prod"
    $WebApp_Name = "PruebaSDWebbAC01prod"
    $FuntionApp_Name = "funtionappprod"

}

############################################################################################
# Create Storage Account
#Command: https://learn.microsoft.com/en-us/powershell/module/az.storage/new-azstorageaccount?view=azps-9.7.1
Write-Host ""
Write-Host "Storage Account"

if (! (CheckResource -ResourceName $SA_Name)){
    $Parameters = @{
        ResourceGroupName = $AzGroup.Name
        Name = $SA_Name
        Location = $AzGroup.Location
        Kind = "StorageV2"
        PublicNetworkAccess = "Enabled"
        SkuName = "Standard_LRS"
        AccessTier = "Cool"
    }

    New-AzStorageAccount @Parameters

}else{
        Write-Host "The Storage Account Resource $SA_Name already exists."
    }


############################################################################################
# Create App Service Plan
#Command: https://learn.microsoft.com/en-us/powershell/module/az.websites/new-azappserviceplan?view=azps-9.7.1
Write-Host ""
Write-Host "App Service Plan"

if (! (CheckResource -ResourceName $AppPlan_Name)){
        $Parameters = @{
            ResourceGroupName = $AzGroup.Name
            Name = $AppPlan_Name
            Location = $AzGroup.Location
            Tier = "Basic"
            NumberofWorkers = 2
            WorkerSize  = "Small"
        }

        New-AzAppServicePlan @Parameters

}else{
        Write-Host "The App Service Plan Resource $AppPlan_Name already exists."
    }


############################################################################################
# Create Web App
#Command: https://learn.microsoft.com/en-us/powershell/module/az.websites/new-azwebapp?view=azps-9.7.1
Write-Host ""
Write-Host "Web App"

if (! (CheckResource -ResourceName $WebApp_Name)){
        $Parameters = @{
            ResourceGroupName = $AzGroup.Name
            Name = $WebApp_Name
            Location = $AzGroup.Location
            AppServicePlan = $AppPlan_Name
        }

        New-AzWebApp @Parameters

}else{
    Write-Host "The Web App Resource $WebApp_Name already exists."
}


############################################################################################
# Create Web App
#Command: https://learn.microsoft.com/en-us/powershell/module/az.functions/new-azfunctionapp?view=azps-9.7.1
Write-Host ""
Write-Host "Funtion App"

if (! (CheckResource -ResourceName $FuntionApp_Name)){
    $Parameters = @{
        ResourceGroupName = $AzGroup.Name
        Name = $FuntionApp_Name
        Location = $AzGroup.Location
        StorageAccountName = $SA_Name
        Runtime = "PowerShell"
    }

    New-AzFunctionApp @Parameters

}else{
Write-Host "The Funtion App Resource $FuntionApp_Name already exists."
}

Write-Host ""
Write-Output "Disconnecting from Azure Portal"
Write-Output "-----------------------------------------------------------------------------------------------------------"
Disconnect-AzAccount | Out-Null