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

    if event['httpMethod'] == 'POST' :
        #data  = json.loads(event['body'])
        #name  = data['name']
        #image = data['file']
        #image_data = image[image.find(",")+1:]
        #content_type = image[image.find(":")+1:image.find(";")]
        #image_type = image[image.find("data:")+1:image.find(";")].split('/')[1]

        image_id = str(uuid.uuid4())[:8]
        #content_type = event["headers"]["content-type"]
        #image_type =  content_type.split('/')[1]
        #object_key = '{id}/{name}.{type}'.format(id=image_id, name=image_id,type=image_type)
        #dec = base64.b64decode(event['body'])
        #s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=object_key, Body=dec, ContentType=content_type)

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
