param
(
    [Parameter (Mandatory=$true)]
    [string] $SubscriptionId,

    [Parameter (Mandatory=$true)]
    [string] $ResourceGroup,

    [Parameter (Mandatory=$false)]
    [string] $TenantId
)


if(Get-AzContext | Where-Object {$_.Subscription.Id -eq $SubscriptionId})
{
    $selectSubscriptionParams = @{
        SubscriptionId = $SubscriptionId
        ErrorAction = 'Stop'
    }
    if($TenantId)
    {
        $selectSubscriptionParams.Add('TenantId', $TenantId)
    }
    Select-AzSubscription @selectSubscriptionParams
}
else
{
    Connect-AzAccount -ErrorAction Stop

    $selectSubscriptionParams = @{
        SubscriptionId = $SubscriptionId
        ErrorAction = 'Stop'
    }
    if($TenantId)
    {
        $selectSubscriptionParams.Add('TenantId', $TenantId)
    }

    Select-AzSubscription @selectSubscriptionParams
}

$firstDeploymentParams = @{
    Name = 'azDeploy-' + ((Get-Date).ToUniversalTime() ).ToString('yyMMdd-HHmm')
    ResourceGroupName = $ResourceGroup
    TemplateFile = '.\azuredeploy.json'
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
    ErrorAction = 'Stop'
}
New-AzResourceGroupDeployment @firstDeploymentParams
