import boto3
import json
import urllib.parse
import os

s3 = boto3.client('s3')
sns = boto3.client('sns')

SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')

def handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])
    
    response = s3.get_object(Bucket=bucket, Key=key)
    log_content = response['Body'].read().decode('utf-8')
    
    lines = log_content.split('\n')
    errors = []
    
    for line in lines:
        if 'ERROR' in line or 'CRITICAL' in line:
            errors.append(line)
    
    if errors:
        message = f"Errors detected in log file: {key}\n\n"
        message += f"Found {len(errors)} error(s):\n\n"
        message += '\n'.join(errors)
        
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f"CloudOps Alert - Errors detected in {bucket}",
            Message=message
        )
        
        print(f"Alert sent for {len(errors)} errors in {key}")
    else:
        print(f"No errors found in {key}")
    
    return {'statusCode': 200}