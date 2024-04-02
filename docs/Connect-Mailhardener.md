---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://www.mailhardener.com/dashboard/team
schema: 2.0.0
---

# Connect-Mailhardener

## SYNOPSIS
Connect to the Mailhardener API for MSP usage

## SYNTAX

```
Connect-Mailhardener [-ClientID] <String> [-ClientSecret] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Accepts an Oauth2 client ID and secret and requests a session token from the Mailhardener API.
On success, an access token is stored in memory for use in subsequent calls.

## EXAMPLES

### EXAMPLE 1
```
Connect-Mailhardener -ClientID 'your_client_id' -ClientSecret 'your_client_secret'
```

## PARAMETERS

### -ClientID
Client ID

```yaml
Type: String
Parameter Sets: (All)
Aliases: client_id

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
Client secret

```yaml
Type: String
Parameter Sets: (All)
Aliases: client_secret

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
Oauth token lifetime is 30 days.

## RELATED LINKS

[https://www.mailhardener.com/dashboard/team](https://www.mailhardener.com/dashboard/team)

[https://api.mailhardener.com/docs/#/paths/session-action-access_token/post](https://api.mailhardener.com/docs/#/paths/session-action-access_token/post)

