function New-ScriptScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position = 0, HelpMessage = 'Please set a descriptive name for this task')]
        [string]$TaskName,
        [Parameter(Mandatory = $true, HelpMessage = 'Full path of the script (ps1) to run')]
        $TaskScript,
        [Parameter(Mandatory = $true, HelpMessage = 'File hash of script file')]
        $ScriptHash,
        [string]$TaskDescription = "Task created by $env:USERNAME via New-EnTaskScheduler script",
        $TaskDate = (Get-Date).AddDays(30)
    )
    
    begin {
        # Set the task action to point at the script
        $commandArg = "-ExecutionPolicy Bypass -command if ((Get-FileHash -Path $TaskScript).hash -eq "+"`'$ScriptHash`'"+")  {.  $TaskScript}"
        $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $commandArg
        $taskTrigger = New-ScheduledTaskTrigger -At $TaskDate -Once
        $taskSettings = New-ScheduledTaskSettingsSet # using default settings
        # Get credentials to securely use for new task
        $taskCreds = Get-Credential -UserName $env:USERDOMAIN'\'$env:USERNAME -Message "Input the ADMIN credentials to run this task on $TaskDate"
        $taskPass = $taskCreds.GetNetworkCredential().Password
    }
    
    process {
        $taskProps = @{
            'TaskName' = $TaskName;
            'Description' = $TaskDescription;
            'Action' = $taskAction;
            'Trigger' = $taskTrigger;
            'User' = $taskCreds.GetNetworkCredential().UserName;
            'Password' = $taskPass;
            'Settings' = $taskSettings;
            'RunLevel' = 'Highest';  
        }
        
        Register-ScheduledTask @taskProps
        Start-Sleep -Seconds 3
    }
    
    end {
        Write-Verbose "New task $TaskName created"
    }
}

function Select-Value { # src: https://geekeefy.wordpress.com/2017/06/26/selecting-objects-by-value-in-powershell/
    [Cmdletbinding()]
    param(
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )
    process {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name
        If($Property){
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

function Get-MyRGs () { 
	Get-AzResourceGroup | 
	select ResourceGroupName,Location | 
	sort-object ResourceGroupName
}

# Enable oh-my-posh for different OSes
if ($IsMacOS -and (get-command oh-my-posh)) {
  $brewPrefix = brew --prefix oh-my-posh
  oh-my-posh init pwsh --config "$brewPrefix/themes/negligible.omp.json"
} elseif ($IsLinux -and (Get-Command oh-my-posh)) {
	oh-my-posh init pwsh --config '~/.poshthemes/microverse-power.omp.json' | Invoke-Expression
} else {
  oh-my-posh prompt init pwsh --config $env:POSH_THEMES_PATH/negligible.omp.json | Invoke-Expression
}

# Vim aliases
if ($IsWindows) {
  New-Alias -Name vi -Value 'C:\Program Files\vim\vim90\vim.exe'
  New-Alias -Name vim -Value 'C:\Program Files\vim\vim90\vim.exe'
}
