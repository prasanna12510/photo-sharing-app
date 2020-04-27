import json
import boto3
import base64
import uuid
import os

import logging
from PIL import Image
import io

s3 = boto3.client('s3')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#out_img = BytesIO()
#image.save(out_img, img_type)
#out_img.seek(0)  # Without this line it fails
#self.bucket.put_object(Bucket=self.bucket_name,
#                       Key=key,
#                       Body=out_img)

def lambda_handler(event, context):

    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    if event['httpMethod'] == 'POST' :
        image_id = str(uuid.uuid4())[:8]
        body = event['body']
        content_type = event["headers"]["content-type"]
        image_type =  content_type.split('/')[1]
        object_key = '{image}.{type}'.format(image=image_id,type=image_type)

        s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=object_key, Body=body, ContentType=content_type)
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
