param([string]$IncludeStream, [switch]$Force)

Import-Module au

$releases = 'http://cpntools.org/category/downloads/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    $chooseos_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $urltodownload = $chooseos_page.Links | Where-Object href -match '\/Windows\/' | Select-Object -First 1 -ExpandProperty href
    $download_page = Invoke-WebRequest -Uri $urltodownload -UseBasicParsing

    $url = $download_page.Links | Where-Object href -match 'cpntools_.*\.exe$' | Select-Object -First 1 -ExpandProperty href
    $version = Get-Version $url

    return @{
        Version = $version
        URL32   = $url
    }

}

update -ChecksumFor 32
