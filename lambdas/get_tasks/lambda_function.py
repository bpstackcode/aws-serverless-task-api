import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tasks')

def lambda_handler(event, context):
    try:
        response = table.scan()
        return {
            'statusCode': 200,
            'body': json.dumps({'tasks': response['Items']})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
