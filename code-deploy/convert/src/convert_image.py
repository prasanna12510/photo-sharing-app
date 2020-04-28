import json
import os
from io import BytesIO

import boto3
import PIL
from PIL import Image
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])


def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def convert_image(bucket_name, key, output_format):
    filename=key.split(".")[0]
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
    buffer = BytesIO()
    img.save(buffer, output_format)
    buffer.seek(0)

    converted_key = "{item}.{type}".format(item=filename,type=output_format.lower())

    obj = s3.Object(
        bucket_name=bucket_name,
        key=converted_key,
    )
    obj.put(Body=buffer, ContentType='image/' + output_format.lower())

    return converted_key


def lambda_handler(event, context):
    if 'LOG_EVENTS' in os.environ and os.environ['LOG_EVENTS'] == 'true':
        logger.info('Event logging enabled: `{}`'.format(json.dumps(event)))

    key           =  event["pathParameters"]["image_id"]
    output_format = event["queryStringParameters"]["output"]

    if key and allowed_file(output_format.lower()):
        convert_image_id = convert_image(os.environ["BUCKET_NAME"], key, output_format.upper())
        response = {
        'statusCode': 200,
        'body': json.dumps({"image_id": converted_image_id,
        "message":"image converted successfully, access using download/<image_id>.<image_type>"}),
        'headers': {'Access-Control-Allow-Origin': '*'}
        }
    else:
        response = {
        'statusCode': 400,
        'body': json.dumps({'message' : 'Allowed output file types are png, jpg, jpeg, gif'}),
        'headers': {'Access-Control-Allow-Origin': '*'}
        }
    return response
