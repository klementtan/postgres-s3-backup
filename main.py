from dotenv import load_dotenv
from datetime import date
import boto3
from botocore.exceptions import ClientError
import os
import logging

load_dotenv()


def env(ENV_VAR):
  return os.getenv(ENV_VAR)

file_name = f"{env('DB_NAME')}_{date.today().strftime('%d-%m-%Y')}.dump"

def get_db_dump():
  os.system(
    f"PGPASSWORD={env('DB_PASSWORD')} pg_dump {env('DB_NAME')} -U {env('DB_USERNAME')} -h {env('DB_HOST')} -p {env('DB_PORT')} > {file_name}"
  )

def get_s3():
  try:
    client = boto3.client(
      's3',
      aws_access_key_id=env('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key=env('AWS_SECRET_ACCESS_KEY'),
      region_name=env('AWS_REGION')
     )
  except ClientError as e:
    logging.error(e)
    return False
  return client

def upload_dump(s3):
  try:
    with open(file_name, "rb") as dump_file:
      response = s3.upload_fileobj(dump_file, env('AWS_BUCKET_NAME'), f'dumps/{file_name}')
      return response
  except ClientError as e:
    logging.error(e)

def send_notification(message):
  body = {
    "text": message
  }
  headers = {
    'Content-Type': 'application/json',
  }
  response = requests.post(env('SLACK_URL'), data=json.dumps(body), headers=headers)


    
def main():
  try:
    get_db_dump()
    s3 = get_s3()
    upload_dump(s3)
    logging.info('Uploaded dump to db')
    os.system( f"rm -rf {file_name}")
  except Exception as e:
    send_notification(str(e))

main()