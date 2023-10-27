# Docker Compose for Minio

## Cloudflare configuration

- `minio.andreygubarev.cloud`
- `minioconsole.andreygubarev.cloud`

## AWS CLI configuration

```ini
# ~/.aws/config
[profile minio]
region = us-east-1
output = json
endpoint_url = https://minio.andreygubarev.cloud/
s3 =
    signature_version = s3v4

# ~/.aws/credentials
[minio]
aws_access_key_id =
aws_secret_access_key =
```
