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
#

def write_to_file(save_path, data):
    with open(save_path, "wb") as f:
        f.write(base64.b64decode(data))


def lambda_handler(event, context):

    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    if event['httpMethod'] == 'POST' :
        #get the content type
        content_type = event["headers"]["content-type"]
        image_type =  content_type.split('/')[1]
        #create tmp path
        tmp_file_path='/tmp/photo.{type}'.format(type=image_type)

        # Write request body data into file
        write_to_file(tmp_file_path, event["body"])

        #open image to validate if its in proper format
        img = Image.open('Glacier-National-Park-US.jpg')







        image_id = str(uuid.uuid4())[:8]
        object_key = '{image}.{type}'.format(image=image_id,type=image_type)

        #open the image
        #img = Image.open(io.BytesIO(body.encode()))
        #convert to bytes
        img_bytes = io.BytesIO()
        #save image to content-type format
        img.save(img_bytes, format=image_type.upper())
        #seek to first position
        img_bytes.seek(0)

        s3.put_object(Bucket=os.environ["BUCKET_NAME"], Key=object_key, Body=img_bytes, ContentType=content_type)
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
