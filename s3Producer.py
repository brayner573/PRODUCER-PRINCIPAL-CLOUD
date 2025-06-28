import boto3
import os

aws_access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")
region_name = "us-east-1"
bucket_name = "producer-bucket03-cloud"
file_name = "DataCovid.csv" 

s3 = boto3.client(
    
    's3',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name=region_name                  
                  
)

s3.upload_file(file_name, bucket_name, file_name)
print(f"Archivo {file_name} subido a {bucket_name}")