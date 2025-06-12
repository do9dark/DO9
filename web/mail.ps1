param(
    [string]$Username,
    [string]$Password,
    [string]$OWAUrl = "https://mail.test.com/owa/service.svc?action=FindPeople",
    [string]$EWSUrl = "https://mail.test.com/ews/exchange.asmx"
)

function Get-FromOWA {
    Write-Host "[*] Trying OWA FindPeople..."

    $authInfo = ("{0}:{1}" -f $Username, $Password)
    $encodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($authInfo))

    $Headers = @{
        Authorization = "Basic $encodedAuth"
        "Content-Type" = "application/json; charset=utf-8"
    }

    $Body = @{
        Header = @{
            RequestServerVersion = "Exchange2013"
        }
        Body = @{
            SearchString = ""
            ParentFolder = @{
                __type = "FolderId:#Exchange"
                Id = "peoplefolder"
            }
            RequestedShape = @{
                BaseShape = "Default"
            }
            MaximumResults = 100
        }
    } | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-RestMethod -Uri $OWAUrl -Headers $Headers -Method POST -Body $Body -UseBasicParsing
        if ($response.Body.Result) {
            Write-Host "[+] Found people via OWA!"
            $response.Body.Result.Personas | ForEach-Object {
                $_.Persona.EmailAddress.EmailAddress
            }
            return $true
        }
    } catch {
        Write-Host "[!] OWA request failed."
        return $false
    }
}

function Get-FromEWS {
    Write-Host "[*] Trying EWS fallback..."

    $soapEnvelope = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:t="http://schemas.microsoft.com/exchange/services/2006/types"
            xmlns:m="http://schemas.microsoft.com/exchange/services/2006/messages">
  <s:Header>
    <t:RequestServerVersion Version="Exchange2013" />
  </s:Header>
  <s:Body>
    <m:ResolveNames SearchScope="GlobalAddressList" ReturnFullContactData="true">
      <m:UnresolvedEntry>a</m:UnresolvedEntry>
    </m:ResolveNames>
  </s:Body>
</s:Envelope>
"@

    $authInfo = ("{0}:{1}" -f $Username, $Password)
    $encodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($authInfo))

    $headers = @{
        Authorization = "Basic $encodedAuth"
        "Content-Type" = "text/xml"
        "SOAPAction" = "http://schemas.microsoft.com/exchange/services/2006/messages/ResolveNames"
    }

    try {
        $response = Invoke-WebRequest -Uri $EWSUrl -Headers $headers -Method POST -Body $soapEnvelope -UseBasicParsing
        if ($response.Content -match "<t:EmailAddress>(.*?)</t:EmailAddress>") {
            $matches = [regex]::Matches($response.Content, "<t:EmailAddress>(.*?)</t:EmailAddress>")
            foreach ($match in $matches) {
                $match.Groups[1].Value
            }
        }
    } catch {
        Write-Host "[!] EWS fallback failed: $_"
    }
}

# 시작
if (-not (Get-FromOWA)) {
    Get-FromEWS
}
