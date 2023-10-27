# Docker Compose for Minio

## AWS CLI configuration

```ini
[profile minio]
region = us-east-1
output = json
endpoint_url = https://minio.andreygubarev.cloud/
s3 =
    signature_version = s3v4

[minio]
aws_access_key_id =
aws_secret_access_key =
```
