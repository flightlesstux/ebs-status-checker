# describe_volume_modifications

This script is a Bash script that checks the status of an AWS EBS volume modification and sends an alert to a Slack channel if the volume modification is not completed.

## Usage

./ebs_status.sh --region REGION --volume-id VOLUME_ID [--slack-webhook WEBHOOK_URL]

## Requirements

- AWS CLI
- [jq](https://stedolan.github.io/jq/)

## Installation

1. Ensure AWS CLI is installed and configured with appropriate access keys and permissions.
2. Install `jq` using the package manager for your operating system.
3. Clone this repository or download the `ebs_status.sh` script.
4. Make the script executable: `chmod +x ebs_status.sh`

## Parameters

| Parameter        | Description                                                   | Required |
|------------------|---------------------------------------------------------------|----------|
| --region         | AWS region where the EBS volume resides                       | Yes      |
| --volume-id      | The ID of the EBS volume for which to check the modification  | Yes      |
| --slack-webhook  | Slack webhook URL to send the alert if modification not completed | No     |

## Examples

Check the modification status of an EBS volume and print the result to the console: 

`./ebs_status.sh --region us-west-2 --volume-id vol-0abcd1234efgh5678`

Check the modification status of an EBS volume and send an alert to Slack if the modification is not completed:` 

`./ebs_status.sh --region us-west-2 --volume-id vol-0abcd1234efgh5678 --slack-webhook [https://hooks.slack.com/services/XXXXXXXX/YYYYYYYY/ZZZZZZZZZZ](https://hooks.slack.com/services/XXXXXXXX/YYYYYYYY/ZZZZZZZZZZ)`

## Notes

This script requires AWS CLI and `jq` to be installed and assumes you have valid AWS credentials to query the necessary information.

If the Slack webhook URL is not provided, the script will only print the result to the console.
