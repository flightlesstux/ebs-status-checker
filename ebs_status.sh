#!/bin/bash

# usage: ./describe_volume_modifications.sh --region REGION --volume-id VOLUME_ID [--slack-webhook WEBHOOK_URL]

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --region) region="$2"; shift ;;
        --volume-id) volume_id="$2"; shift ;;
        --slack-webhook) webhook_url="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if required arguments are provided
if [[ -z "$region" || -z "$volume_id" ]]; then
    echo "Error: --region and --volume-id arguments are required."
    exit 1
fi

# Run AWS command to get volume modifications
volume_modifications=$(aws ec2 describe-volumes-modifications --region "$region" --volume-id "$volume_id")

# Get the Volume Name tag
volume_name=$(aws ec2 describe-volumes --region "$region" --volume-ids "$volume_id" --query "Volumes[].Tags[?Key=='Name'].Value[]" --output text)

# Extract the ModificationState from the JSON response
modification_state=$(echo "$volume_modifications" | jq -r '.VolumesModifications[].ModificationState')

# Generate alert message
alert_text="*Alert:* Volume modification for volume *$volume_name* ($volume_id) is not completed. Current state: *$modification_state*"

# Print the alert message to the console
if [[ "$modification_state" != "completed" ]]; then
    echo -e "$alert_text"
else
    echo -e "Volume modification for volume $volume_name ($volume_id) is completed."
fi

# Send alert to Slack if webhook URL is provided and ModificationState is not 'completed'
if [[ "$modification_state" != "completed" ]] && [[ -n "$webhook_url" ]]; then
    payload="{\"text\": \"$alert_text\"}"
    curl -X POST -H 'Content-type: application/json' --data "$payload" "$webhook_url"
fi
