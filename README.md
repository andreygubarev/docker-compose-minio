# Docker Compose for Minio

## Usage

```bash
# create .env file and encrypt it
direnv allow .
make install  # optional, if you want need to setup new tunnel
make up  # start minio
make down  # stop minio
```

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

## Rclone configuration

```ini
[minio]
type = s3
provider = Minio
access_key_id =
secret_access_key =
endpoint = https://minio.andreygubarev.cloud/
acl = private
```
