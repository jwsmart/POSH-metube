
<#
MeTube exposes four routes for the REST API
https://github.com/alexta69/metube/issues/491

POST at /add
POST at /delete
POST at /start
GET at /history
#>

# GET /history 
# takes no arguments
# returns a single json document with theee lists:
# * done - finished (or errored out) downloads
# * pending - queued (but not started) downloads
# * queue - currently downloading
function Get-MeTubeHistory {
    [CmdletBinding()]
    param (
        # MeTube URL
        [Parameter(Mandatory=$true)]
        [String]
        $MeTubeURL
    )
    
    begin {
        $URI = $MeTubeURL + '/history'
    }
    
    process {
        $Result = Invoke-WebRequest -Uri $URI -Method Get
        if ($Result.statuscode -eq 200) {
            $Result.Content | ConvertFrom-Json
        }
        else {
            $Result
        }
    }
    
    end {
        
    }
}

function Start-MeTubePending {
    [CmdletBinding()]
    param (
        # MeTube URL
        [Parameter(Mandatory=$true)]
        [String]
        $MeTubeURL,
        # ID
        [Parameter(Mandatory=$true)]
        [Alias('url')]
        [string[]]
        $ids
    )

    begin {
        $URI = $MeTubeURL + '/start'
    }
    
    process {
        $BodyJSON = @{'ids'=$ids} | ConvertTo-Json -Compress 
        Write-Host $BodyJSON
        $Result = Invoke-WebRequest -Uri $URI -Method Post -Body $BodyJSON
        $Result
    }
    
    end {
        
    }
    
}

function Remove-MeTubePending {
    [CmdletBinding()]
    param (
        # MeTube URL
        [Parameter(Mandatory=$true)]
        [String]
        $MeTubeURL,
        # ID
        [Parameter(Mandatory=$true)]
        [string[]]
        $ids, 
        #Where
        [Parameter(Mandatory=$true)]
        [string]
        $where
    )

    begin {
        $URI = $MeTubeURL + '/delete'
    }
    
    process {
        $BodyJSON = @{'ids'=$ids; 'where'=$where} | ConvertTo-Json -Compress 
        Write-Host $BodyJSON
        $Result = Invoke-WebRequest -Uri $URI -Method Post -Body $BodyJSON
        $Result
    }
    
    end {
        
    }
    
}

<#
    add takes the following arguments

    required:
    * url
    * quality
    
    optional:
    * format 
    * folder 
    * custom_name_prefix 
    * playlist_strict_mode 
    * playlist_item_limit 
    * auto_start 
#>
function Add-MeTubePending {
    [CmdletBinding()]
    param (
        # MeTube URL
        [Parameter(Mandatory=$true)]
        [String]
        $MeTubeURL,
        # URL
        [Parameter(Mandatory=$true)]
        [string]
        $URL,
        # Quality
        [Parameter()]
        [string]
        $Quality = 'best',
        # Auto-Start
        [Parameter()]
        [bool]
        $auto_start = $true,
        # format
        [Parameter()]
        [string]
        $format = 'any'
    )

    begin {
        $URI = $MeTubeURL + '/add'
    }
    
    process {
        $BodyJSON = @{
            'url' = $URL
            'quality' = $Quality
            'auto_start' = $auto_start
            'format' = $format
        } 
        $BodyJSON = $BodyJSON | ConvertTo-Json -Compress 
        Write-Host $BodyJSON
        $Result = Invoke-WebRequest -Uri $URI -Method Post -Body $BodyJSON
        $Result
    }
    
    end {
        
    }
    
}