#!/usr/bin/env -S bash -e

ROOTDIR=$(dirname "$(readlink -f "$0")")
source "$ROOTDIR/.env"
now=$(date --iso-8601=seconds)

DATABASE_NAME=nextcloud

echo "Dumping Postgres Database..."
cd ~ && pg_dump -Fc $DATABASE_NAME -f postgres.dump
echo "Uploading Postgres Database..."
aws s3 cp /home/nextcloud/postgres.dump s3://$S3_BUCKET_NAME/backup-postgres/$now/
echo "Heartbeat"
curl $HEART_BEAT_URL
echo "Done."