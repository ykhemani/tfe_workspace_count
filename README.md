# TFE Workspace Counter

The [tfe_ws_count.sh](tfe_ws_count.sh) script allows you to get a list and count of workspaces across your [Terraform Cloud and Terraform Enterprise](https://www.terraform.io/docs/cloud/index.html) (`TFC/TFE`) organizations.

The [tfe_ws_count.sh](tfe_ws_count.sh) script leverages the [Organization](https://www.terraform.io/docs/cloud/api/organizations.html#list-organizations) and [Workspace](https://www.terraform.io/docs/cloud/api/workspaces.html#list-workspaces) APIs for TFC/TFE.

## Environment

Please set the following environment variables in order to run [tfe_ws_count.sh](tfe_ws_count.sh).

* `TFE_ADDR` - Set to the TFC/TFE address. Defaults to `https://app.terraform.io` if not explicitly set.
* `TFE_TOKEN` - Set to the TFC/TFE token for a user who is a Site Admin or a members of the Owners team.

## Usage

```
TFE_TOKEN=<TFE_TOKEN> [TFE_ADDR=<TFE_ADDR>] ./tfe_ws_count.sh
```

## Example Output

```
$ TFE_TOKEN=${TFE_TOKEN:-$(vault kv get -field TFE_TOKEN ${VAULT_TFE_TOKEN_PATH})} ./tfe_ws_count.sh 
Org: test-org0
  Workspaces:
    ws-abcdefghijklmnop	tfctest4
    ws-abcdefghijklmnoq	tfctest3
    ws-abcdefghijklmnor	tfctest2
    ws-abcdefghijklmnos	tfctest1
    ws-abcdefghijklmnot	tfctest0
--------------------------------------------------------------------------------
Subtotal: 5

Org: test-org1
  Workspaces:
    ws-01234567890abcdE	tfctest3
    ws-01234567890abcdF	tfctest2
    ws-01234567890abcdG	tfctest1
    ws-01234567890abcdH	tfctest0
--------------------------------------------------------------------------------
Subtotal: 4

Total workspaces: 9
```
