import json
import os
import boto3

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def handler(event, context):
    print("Received event: ", json.dumps(event))
    
    for record in event.get('Records', []):
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        print(f"Processing file {key} from bucket {bucket}")
        
        table.put_item(
            Item={
                'doc_id': key,
                'chunk_id': 1,
                'text_content': "Sample processed text content from " + key
            }
        )
        
    return {
        'statusCode': 200,
        'body': json.dumps('Document processed and indexed successfully!')
    }
