import json
import os
from io import BytesIO

import boto3
import PIL
from PIL import Image
import logging


'''def resized_image_url(resized_key, bucket, region):
    return "https://s3-{region}.amazonaws.com/{bucket}/{resized_key}".format(
        bucket=bucket, region=region, resized_key=resized_key
    )'''

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def resize_image(bucket_name, key, size):
    size_split = size.split('x')
    s3 = boto3.resource('s3')

    try:
        obj = s3.Object(
            bucket_name=bucket_name,
            key=key,
        )
    except Exception:
        print("Error when fetching image: " + key)
        raise Exception("Not found")


    obj_body = obj.get()['Body'].read()

    img = Image.open(BytesIO(obj_body))
    format = img.format
    img = img.resize(
        (int(size_split[0]), int(size_split[1])), PIL.Image.ANTIALIAS
    )
    buffer = BytesIO()
    img.save(buffer, format)
    buffer.seek(0)

    resized_key = "{item}-{size}.{type}".format(item=key,size=size,type=img.format.lower())

    obj = s3.Object(
        bucket_name=bucket_name,
        key=resized_key,
    )
    obj.put(Body=buffer, ContentType='image/' + img.format.lower())

    return resized_key

def lambda_handler(event, context):

    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    key =  event["pathParameters"]["image_id"]
    size = event["queryStringParameters"]["size"]

    thumbnail_image_id = resize_image(os.environ["BUCKET_NAME"], key, size)

    response = {
    'statusCode': 200,
    'body': json.dumps({"image_id": thumbnail_image_id,
    "message":"image resized successfully, access using download/<image_id>.<image_type>"}),
    'headers': {'Access-Control-Allow-Origin': '*'}
    }

    return response
