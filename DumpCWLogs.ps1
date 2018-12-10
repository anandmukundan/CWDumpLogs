Param(
    [Parameter(Mandatory=$true,HelpMessage="Enter the Log Group Name")]
    [string]
    $LogGroupName
)

$LogGroupName=$LogGroupName.Trim()
$logs = aws logs describe-log-streams --order-by LastEventTime --log-group-name "$LogGroupName" --output text


$logCount = $logs.Count;
if ($logCount -eq 0){
    "Error Getting Information about Log Group"
    Exit
}

$count =0;
$percentComplete=0;
Write-Progress -Activity "Exporting Logs" 
Foreach ($log in $logs) {
    $logItem = $log.Split()
    #"$" can create a problem in powershell and so that needs to be escaped
    $logStreamName = $logItem[6].Replace("`$", "``$")
    $percentComplete = (($count/$logCount)*100)
    Write-Progress -Id 1 -Activity "Exporting Logs" -Status "Processing $logStreamName"  -PercentComplete $percentComplete
    #Handle the presense of the "$" character and LATEST that is found in Lambda Logs in the filename
    $filename = Join-Path $PSScriptRoot $logStreamName.Replace("/", ".").Replace("``$", "").Replace("[LATEST]", "")
    $x = "aws logs get-log-events --log-group-name  $LogGroupName --log-stream-name $logStreamName --output text > $filename.log"
    #Using Invoke-Expression, so that the command can be dumped and makes it easier to debug.
    Invoke-Expression -Command $x
    $count +=1
}