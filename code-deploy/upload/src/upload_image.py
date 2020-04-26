import json
import boto3
import base64
import uuid
import os

import logging

s3 = boto3.client('s3')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    if event['httpMethod'] == 'POST' :
        image_id = str(uuid.uuid4())[:8]
        dec = base64.b64decode(event['body'])
        object_key = '{image_id}.jpeg'.format(image_id=image_id)
        s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=object_key, Body=dec)
        return {
        'statusCode': 200,
        'body': json.dumps({'image_id': image_id}),
        'headers': {'Access-Control-Allow-Origin': '*'}
        }
    else:
        return {
        'statusCode' : 405,
        'body' : 'method not supported'
        }
