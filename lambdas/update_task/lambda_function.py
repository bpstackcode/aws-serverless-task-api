import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tasks')

def lambda_handler(event, context):
    try:
        task_id = event['pathParameters']['task_id']
        body = json.loads(event['body'])
        response = table.update_item(
            Key={'task_id': task_id},
            UpdateExpression='SET #t = :title, #d = :desc, #s = :status',
            ExpressionAttributeNames={
                '#t': 'title',
                '#d': 'description',
                '#s': 'status'
            },
            ExpressionAttributeValues={
                ':title': body.get('title'),
                ':desc': body.get('description'),
                ':status': body.get('status')
            },
            ReturnValues='ALL_NEW'
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'updated': response['Attributes']})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
