import json
import boto3
import base64
import uuid
import os

import logging
import io

s3 = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    if event['httpMethod'] == 'POST':

        image_id = str(uuid.uuid4())[:8]
        content_type = event["headers"]["Content-Type"]
        image_type =  content_type.split('/')[1]
        object_key = '{id}.{type}'.format(id=image_id,type=image_type)
        decode_image = base64.b64decode(event['body'])
        s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=object_key, Body=decode_image, ContentType=content_type)

        return {
        'statusCode': 200,
        'body': json.dumps({"image_id": image_id,"message":"image uploaded successfully, access using download/<image_id>.<image_type>"}),
        'headers': {'Access-Control-Allow-Origin': '*'}
        }
    else:
        return {
        'statusCode' : 405,
        'body' : 'method not supported'
        }
