# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Determines if the object supports tags
function global:SupportsTags {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    process {
        if (
            ($PSRule.TargetType -eq 'Microsoft.Subscription') -or
            ($PSRule.TargetType -like 'Microsoft.Authorization/*') -or
            ($PSRule.TargetType -like 'Microsoft.Billing/*') -or
            ($PSRule.TargetType -like 'Microsoft.Classic*') -or
            ($PSRule.TargetType -like 'Microsoft.Consumption/*') -or
            ($PSRule.TargetType -like 'Microsoft.Gallery/*') -or
            ($PSRule.TargetType -like 'Microsoft.Security/*') -or
            ($PSRule.TargetType -like 'microsoft.support/*') -or
            ($PSRule.TargetType -like 'Microsoft.WorkloadMonitor/*') -or
            ($PSRule.TargetType -like '*/providers/roleAssignments') -or

            # Exclude sub-resources by default
            ($PSRule.TargetType -like 'Microsoft.*/*/*' -and !(
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/runbooks' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/configurations' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/compilationjobs' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/modules' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/nodeConfigurations' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/python2Packages' -or
                $PSRule.TargetType -eq 'Microsoft.Automation/automationAccounts/watchers'
            )) -or

            # Some exception to resources (https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-support#microsoftresources)
            ($PSRule.TargetType -like 'Microsoft.Resources/*' -and !(
                $PSRule.TargetType -eq 'Microsoft.Resources/deployments' -or
                $PSRule.TargetType -eq 'Microsoft.Resources/deploymentScripts' -or
                $PSRule.TargetType -eq 'Microsoft.Resources/resourceGroups'
            ))
        ) {
            return $False;
        }
        return $True;
    }
}

# Determines if the object is a Resource Group
function global:IsResourceGroup {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    process {
        return $PSRule.TargetType -eq 'Microsoft.Resources/resourceGroups';
    }
}

# Determines if the object is a managed resource group created by Azure
function global:IsManagedRG {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    process {
        if ($PSRule.TargetType -ne 'Microsoft.Resources/resourceGroups') {
            return $False;
        }

        # Check for managed RG names
        return (
            $PSRule.TargetName -eq 'NetworkWatcherRG' -or
            $PSRule.TargetName -like 'AzureBackupRG_*' -or
            $PSRule.TargetName -like 'DefaultResourceGroup-*' -or
            $PSRule.TargetName -like 'cloud-shell-storage-*' -or
            $PSRule.TargetName -like 'MC_*'
        )
    }
}

# Determines if the object is a managed load balancer created by Azure
function global:IsManagedLB {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    process {
        if ($PSRule.TargetType -ne 'Microsoft.Network/loadBalancers') {
            return $False;
        }

        # Check for managed load balancer names
        return (
            $PSRule.TargetName -like 'kubernetes*'
        )
    }
}
