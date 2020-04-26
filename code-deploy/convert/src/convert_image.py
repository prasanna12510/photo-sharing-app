import datetime
import json
import os
from io import BytesIO

import boto3
import PIL
from PIL import Image

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])


def resized_image_url(converted_key, bucket, region):
    return "https://s3-{region}.amazonaws.com/{bucket}/{converted_key}".format(
        bucket=bucket, region=region, converted_key=converted_key
    )

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def convert_image(bucket_name, key, output_type):

    if file and allowed_file(output_type):

        key_split = key.split('/')
		s3 = boto3.resource('s3')
        obj = s3.Object(
            bucket_name=bucket_name,
            key=key,
        )
        obj_body = obj.get()['Body'].read()

        img = Image.open(BytesIO(obj_body))

        buffer = BytesIO()
        img.save(buffer, output_type)
        buffer.seek(0)

        converted_key = "{folder}/converted_{item}".format(folder=key_split[0],item=key_split[1])

        obj = s3.Object(
            bucket_name=bucket_name,
            key=converted_key,
        )
        content_type = "image/{type}".format(type=output_type)
        obj.put(Body=buffer, ContentType=content_type)

        return converted_image_url(
            converted_key, bucket_name, os.environ["AWS_REGION"]
        )
	else:
        return json.dumps({'message' : 'Allowed file types are png, jpg, jpeg, gif'})



def lambda_handler(event, context):
    key         =  event["pathParameters"]["id"] + "/" + event["pathParameters"]["filename"]
    output_type = event["queryStringParameters"]["output"]

    result_url = convert_image(os.environ["BUCKET_NAME"], key, filename ,output_type)

    response = {
        "statusCode": 301,
        "body": "",
        "headers": {
            "location": result_url
        }
    }

    return response
