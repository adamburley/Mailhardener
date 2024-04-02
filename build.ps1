# basic build to get us started
Get-ChildItem .\Private, .\Public -Filter *.ps1 | ForEach-Object { Get-Content $_ } | Out-File -Path .\Mailhardener.psm1

$functions = Get-ChildItem .\Public -Filter *.ps1 | ForEach-Object { $_.BaseName }
Update-ModuleManifest -Path .\Mailhardener.psd1 -RootModule .\Mailhardener.psm1 -FunctionsToExport $functions

# platyPS for documentation
Import-Module .\Mailhardener.psm1
Update-MarkdownHelp -Path '.\docs'