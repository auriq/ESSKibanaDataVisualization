#!/bin/bash

index=ess-xml

s3bucket="datasets.elasticmapreduce"
s3region="us-east-1"
s3prefix="wikipediaxml/part-00*"

ess select s3://${s3bucket} #--aws_access_key "${accessKey}" --aws_secret_access_key  "${secretKey}"
ess category add $index "$s3prefix" --dateformat 'auto' --noprobe --overwrite; ret=$?

[ `ess summary | grep -c "$index"` = 0 ] && { echo "Failed to create category, check your AWS configuration."; exit; }

type='main'
curl -XDELETE localhost:9201/${index}
curl -XPUT localhost:9201/${index} -d '{"settings":{"index":{"number_of_shards":3, "number_of_replicas":1}}}'
id=0
ess stream $index "*" "*" "aq_pp -f,eok,qui,xml - -d s:title:page[*].title s:id:page[*].id -o,jsn -" | while read line; do\
  curl -PUT localhost:9201/$index/${type}/$id -d "${line}" > tempdump 2>&1
  id=`expr $id + 1`
done

[ -e tempdump ] && rm -f tempdump


