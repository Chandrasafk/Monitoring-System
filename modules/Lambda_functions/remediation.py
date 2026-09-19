import boto3
import json
import os

ec2 = boto3.client('ec2', region_name='us-east-1')
sns = boto3.client('sns', region_name='us-east-1')

SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')

def handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    
    alarm_name = message['AlarmName']
    state = message['NewStateValue']
    
    if state != 'ALARM':
        print(f"State is {state}, no action needed")
        return {'statusCode': 200}
    
    dimensions = message['Trigger']['Dimensions']
    instance_id = None
    
    for dimension in dimensions:
        if dimension['name'] == 'InstanceId':
            instance_id = dimension['value']
            break
    
    if not instance_id:
        print("No instance ID found in alarm")
        return {'statusCode': 200}
    
    print(f"Rebooting instance {instance_id} due to alarm {alarm_name}")
    
    ec2.reboot_instances(InstanceIds=[instance_id])
    
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=f"CloudOps Remediation - Rebooted {instance_id}",
        Message=f"Automated remediation triggered.\n\nAlarm: {alarm_name}\nInstance: {instance_id}\nAction: Instance rebooted automatically."
    )
    
    return {'statusCode': 200}