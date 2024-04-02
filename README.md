# Mailhardener

PowerShell module for [Mailhardener API for MSP](https://api.mailhardener.com/docs/#/)

## Features

- [X] Authentication & token management
- [X] Error handling (useful error messages)
- [X] Input format validation
- [X] Comment-based help for all functions.
- [X] Support for the pipeline, `-WhatIf`, `-Verbose`
- [ ] `-Force` parameter for functions that prompt for confirmation (use `-Confirm:$false` to override)
- [ ] Additional custom properties on returned objects to associate customers with domains, etc
- [ ] Custom domain status report functions
- [ ] Report analysis functions

# Functions

See [docs](docs/) for full function documentation.

## Misc

- Connect-Mailhardener
- Get-MailHardenerToken
- Show-ReportingEndpoint

## Customers

- New-Customer
- Get-Customer
- Set-Customer
- Remove-Customer

## Team Members

- New-TeamMember
- Get-TeamMember
- Set-TeamMember
- Remove-TeamMember

## Domains

- New-Domain
- Get-Domain
- Remove-Domain

## Reports

- Get-EmailReport

# Errata

- Access token expiry is currently 30 days. Due to this, at this time the module does not attempt to track expiration or renew.
- Returned child objects (Team members, domains, reports) do not include the customer UID, somewhat limiting the ability to use pipelines.
- If you prefer to utilize a more explicit naming convention or are working with a module that contains conflicting function names you can import with a prefix, e.g.

```PowerShell
Import-Module Mailhardener -Prefix Mailhardener
Get-MailhardenerCustomer # Calls Get-Customer function
```
