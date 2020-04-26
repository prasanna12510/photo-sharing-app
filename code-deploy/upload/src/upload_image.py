import json
import boto3
import base64

import logging

s3 = boto3.client('s3')

def lambda_handler(event, context):
    if event['httpMethod'] == 'POST' :
        print event['body']
        data = json.loads(event['body'])
        image_name= data['name']
        image_id = str(uuid.uuid4())[:8]
        image = data['file']
        image = image[image.find(",")+1:]
        dec = base64.b64decode(image + "===")
        s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=image_id/image_name, Body=dec)
        return {
        'statusCode': 200,
        'body': json.dumps({'image_id': image_id}),
        'headers': {'Access-Control-Allow-Origin': '*'}
        }
    else:
        return {
        'statusCode' : 405
        'body' : 'method not supported'
        }
