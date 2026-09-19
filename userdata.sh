<powershell>
# Install CloudWatch Agent
Invoke-WebRequest -Uri "https://amazoncloudwatch-agent.s3.amazonaws.com/windows/amd64/latest/amazon-cloudwatch-agent.msi" -OutFile "C:\amazon-cloudwatch-agent.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList '/i "C:\amazon-cloudwatch-agent.msi" /qn' -Wait

# Create log directory
New-Item -ItemType Directory -Path "C:\Logs" -Force

# Write CloudWatch Agent config
$config = @'
{
    "agent": {
        "imds_retries": 1
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "C:\\Logs\\cloudops-*.log",
                        "log_group_name": "${log_group_name}",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    },
    "metrics": {
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_user"],
                "metrics_collection_interval": 60
            },
            "Memory": {
                "measurement": ["Available MBytes"],
                "metrics_collection_interval": 60
            }
        }
    }
}
'@

$config | Out-File -FilePath "C:\cwagent-config.json" -Encoding ascii

# Start CloudWatch Agent with config
cd "C:\Program Files\Amazon\AmazonCloudWatchAgent"
.\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -s -c file:C:\cwagent-config.json

# Write log generation script
Set-Content -Path "C:\LogGenerator.ps1" -Encoding ASCII -Value @"
while (`$true) {
    `$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    `$filename = 'C:\Logs\cloudops-' + (Get-Date -Format 'yyyyMMdd') + '.log'
    `$random = Get-Random -Minimum 1 -Maximum 10
    if (`$random -eq 1) {
        `$logEntry = "`$timestamp ERROR Instance OutOfMemory exception occurred in application"
    } elseif (`$random -eq 2) {
        `$logEntry = "`$timestamp CRITICAL Instance Disk space below threshold"
    } else {
        `$logEntry = "`$timestamp INFO Instance Application running normally"
    }
    [System.IO.File]::AppendAllText(`$filename, `$logEntry + "`n")
    Start-Sleep -Seconds 30
}
"@

# Register and start scheduled task
$taskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NonInteractive -WindowStyle Hidden -File C:\LogGenerator.ps1"
$taskTriggerStartup = New-ScheduledTaskTrigger -AtStartup
$taskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0
$taskPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "LogGenerator" -Action $taskAction -Trigger $taskTriggerStartup -Settings $taskSettings -Principal $taskPrincipal -Force
Start-ScheduledTask -TaskName "LogGenerator"
</powershell>