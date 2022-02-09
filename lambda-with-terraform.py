import json
import boto3
import logging


def list_buckets():
    """
    List buckets name
    """
    s3 = boto3.resource('s3')
    bucketlist = list()

    for bucket in s3.buckets.all():
        bucketlist.append(bucket.name)

    return bucketlist


def create_bucket(bucket_name, region=None):
    """
    Create a bucket in a specific region.
    If bucket is not given, bucket will be create in default region (us-east-1).
    Bucket name should be globally unique.
    :param bucket_name: Bucket to create
    :param region: String region to create bucket in, e.g., 'eu-west-1'
    :return: True if bucket created, else False
    """
    try:
        if region is None:
            s3 = boto3.resource('s3')
            s3.create_bucket(Bucket=bucket_name)
        else:
            s3 = boto3.resource('s3', region_name=region)
            location = {'LocationConstraint': region}
            s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=location)
    except ClientError as e:
        logging.error(e)
        logging.info("Bucket creation is not successful")
        return False
    logging.info("Bucket creation is successful")
    return True


def lambda_handler(event, context):
    """
    Input key1 to 0 for listing, 1 for creating bucket.
    :param event["key1"]: 0 or 1
    :param event["key2"]: bucket name to create. Compulsory if key1 is 1 and should be unique
    :param event["key3"]: optinal, bucket region to create
    :return: output message
    """
    if event["key1"] == 0:
        bucketlist = list_buckets()
        return_value = {'statusCode': 200, 'body': bucketlist}
    elif event["key1"] == 1:
        create_bucket(event["key2"], event["key3"])
        return_value = {'statusCode': 200, 'body': event['key2'] + " created in " + event['key3']}
    else:
        return_value = {'statusCode': 200, 'body': "Input 0 to list, 1 to create bucket"}
    return return_value



