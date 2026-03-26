import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tasks')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        task = {
            'task_id': str(uuid.uuid4()),
            'title': body['title'],
            'description': body.get('description', ''),
            'status': 'pending',
            'created_at': datetime.utcnow().isoformat()
        }
        table.put_item(Item=task)
        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Task created', 'task': task})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
