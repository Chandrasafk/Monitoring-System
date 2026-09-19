import boto3
import json
import gzip
import base64
import datetime
import os

s3 = boto3.client('s3')

BUCKET_NAME = os.environ.get('BUCKET_NAME')

def handler(event, context):
    encoded_data = event['awslogs']['data']
    compressed_data = base64.b64decode(encoded_data)
    log_data = json.loads(gzip.decompress(compressed_data))
    
    log_events = log_data.get('logEvents', [])
    log_stream = log_data.get('logStream', 'unknown')
    
    log_lines = []
    for log_event in log_events:
        timestamp = datetime.datetime.fromtimestamp(
            log_event['timestamp'] / 1000
        ).strftime('%Y-%m-%d %H:%M:%S')
        message = log_event['message']
        log_lines.append(f"{timestamp} | {log_stream} | {message}")
    
    log_content = '\n'.join(log_lines)
    
    now = datetime.datetime.utcnow()
    key = f"logs/{now.year}/{now.month:02d}/{now.day:02d}/{log_stream}-{now.strftime('%H%M%S')}.log"
    
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=log_content.encode('utf-8')
    )
    
    print(f"Delivered {len(log_events)} log events to s3://{BUCKET_NAME}/{key}")
    return {'statusCode': 200}