
#Gets a list of policies from Expensify
function SMA_ExpensifyPolicyList($url,$token,$partnerId,$partnerSecret)
{
    #Get property information
	$body = '{"type":"get","credentials":{
			"partnerUserID":"' + $partnerId + '","partnerUserSecret": "' + $partnerSecret + '"},
			"inputSettings":{"type":"policyList","adminOnly": false}}'

	$uripost = $url + $body

    try
    {
        $policyList = Invoke-Restmethod -Method POST -Uri $uripost -Body "{}" -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }
    
    return $policyList
}

# Adds a tag to a policy
function SMA_ExpensifyAddTagToPolicy($url,$token,$partnerId,$partnerSecret,$policyId,$tag,$tagGroup,$enabled)
{
	$policy = (SMA_GetExpensifyPolicy -url $url -partnerId $partnerId -partnerSecret $partnerSecret -policyId $policyId).policyInfo.$policyId.tags 
	$addtoPolicy = $policy | Where-Object{ $_.name -eq $tagGroup}
	$addtoPolicy.tags += @{glCode="";name=$tag;enabled=$enabled}
	$newTags = $addtoPolicy | ConvertTo-Json -Depth 7
	$body = '{
			"type":"update",
			"credentials":
			{
				"partnerUserID":"' + $partnerId + '",
				"partnerUserSecret": "' + $partnerSecret + '"
			},
			"inputSettings":
			{
				"type":"policy",
				"policyID": "' + $policyId + '"
			},
		    "tags": 
			{
				"data": [' + $newTags + ']
			}}'

	$uripost = $url + $body

    try
    {
        $policyList = Invoke-Restmethod -Method POST -Uri $uripost -Body "{}" -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }
    
    return $policyList
}

#Gets a list of policies from Expensify
function SMA_GetExpensifyPolicy($url,$token,$partnerId,$partnerSecret,$policyId)
{
    #Get property information
	$body = '{
				"type":"get",
				"credentials":
				{
					"partnerUserID":"' + $partnerId + '",
					"partnerUserSecret": "' + $partnerSecret + '"
				},
				"inputSettings":
				{
					"type":"policy",
					"fields": ["tags"],
					"policyIDList": ["' + $policyId + '"]
				}
			}'

	$uripost = $url + $body

    try
    {
        $policy = Invoke-Restmethod -Method POST -Uri $uripost -Body "{}" -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }
    
    return $policy
}
