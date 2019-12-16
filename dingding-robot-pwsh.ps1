#!/bin/bash

param (
    [parameter(Mandatory = $false)]
    [string]$msg = $( Read-Host -Prompt "Please input message to send" ),

    [parameter(Mandatory = $false)]
    [AllowNull()]
    [string]$atMobiles = $( Read-Host -Prompt "Please input mobile number of those who will sent message to, comma sperated[13xxxxxxxxx]" )
)

if ([string]::IsNullOrWhiteSpace($atMobiles)) {
    $atMobiles = "13xxxxxxxxx"
}

$url = "https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

$atUsers = $atMobiles.Replace(",", '@').Insert(0, '@')
#$atUsers = $atUsers.Insert(0,'@')

$header = @{
    "Content-Type" = "application/json"
}

$body = @"
{
    "msgtype": "text",
    "text": {
        "content": "$msg $atUsers"
    },
    "at": {
        "atMobiles": [
        $atMobiles
        ],
        "isAtAll": false
    }
}
"@

[array]$body = [System.Text.Encoding]::UTF8.GetBytes($body)
Invoke-WebRequest -Uri $url -Method 'POST' -Headers $header -Body $body