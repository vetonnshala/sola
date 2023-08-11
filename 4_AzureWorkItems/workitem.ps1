$headers = @{}
$headers.Add("Accept", "*/*")
$headers.Add("User-Agent", "Thunder Client (https://www.thunderclient.com)")
$headers.Add("Authorization", "Basic endmaXV6cDVxcmJ0dHpkcmMzejNhdnpxZmt2amRzaTVzenFldGljcGJubGFrdHZ1enZ3cTo=")

$reqUrl = 'https://dev.azure.com/vettonshalaa/solaborate/_apis/wit/workitems/1?api-version=7.0%20'

$response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers

# Check if the workitemtype is "Bug"
if ($response.fields."System.WorkItemType" -eq "Bug") {
    Write-Host "Work item type is 'Bug'"
    $response | ConvertTo-Json
} else {
    Write-Host "Work item type is not 'Bug'"
}
