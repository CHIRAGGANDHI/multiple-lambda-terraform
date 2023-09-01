import datetime
import logging
import boto3
import os

AWS_REGION = os.environ['AWS_LAMBDA_REGION']

ssm_client = boto3.client("ssm", region_name=AWS_REGION)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def run(event, context):

    space = os.environ['AWS_PARAMETER_SPACE']
    spaceDetails = "/{}/connectionstring".format(space)
    response = ssm_client.get_parameter(Name=spaceDetails)
    
    logger.info("lambda-cron-sample-test-2, Space Name:" + spaceDetails + ",Space Value:" + response['Parameter']['Value'])   

    current_time = datetime.datetime.now().time()
    name = context.function_name        
    logger.info("Your cron function " + name + " ran at " + str(current_time))
