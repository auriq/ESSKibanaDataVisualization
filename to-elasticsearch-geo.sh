#!/bin/bash

yy=`date +%Y`
cols='S:ID S:USAF S:WBAN S:Elevation S:Country_Code L:Latitude L:Longitude S:Date I:Year I:Month I:Day F:Mean_Temp F:Mean_Temp_Count F:Mean_Dewpoint F:Mean_Dewpoint_Count F:Mean_Sea_Level_Pressure F:Mean_Sea_Level_Pressure_Count F:Mean_Station_Pressure F:Mean_Station_Pressure_Count F:Mean_Visibility F:Mean_Visibility_Count F:Mean_Windspeed F:Mean_Windspeed_Count F:Max_Windspeed F:Max_Gust F:Max_Temp F:Max_Temp_Quality_Flag F:Min_Temp F:Min_Temp_Quality_Flag F:Precipitation F:Precip_Flag F:Snow_Depth F:Fog F:Rain_or_Drizzle F:Snow_or_Ice F:Hail F:Thunder F:Tornado'

index="daily-global-weather"
s3bucket="aws-gsod"
s3region="us-east-1"
s3prefix="${yy}/*.csv"

ess select s3://${s3bucket} # --aws_access_key "${accessKey}" --aws_secret_access_key  "${secretKey}"
if [ `ess summary | grep -c $index` -eq 0 ]; then
  ess category add $index "$s3prefix" --dateregex 'auto' --delimiter ',' --overwrite
  ess category change columnspec "$index" "$cols"
fi

[ `ess summary | grep -c "$index"` = 0 ] && { echo "Failed to create category, check your AWS configuration."; exit; }

[ `which jq 2>&1 |  grep -c 'no jq'` != 0 ] && sudo yum -y install jq

type='geos'
curl -XDELETE localhost:9201/${index}
curl -XPUT localhost:9201/${index} -d '{"settings":{"index":{"number_of_shards":3, "number_of_replicas":1}}, "mappings":{"'${type}'":{"properties": {"geoip":{"dynamic" : true, "properties":{"location": {"type": "geo_point"}}}}}}}'
id=0
ess stream $index "*" "*" "aq_pp -f,eok,qui - -d %cols -o,jsn -" | jq -c '.geoip.location = [ .Latitude, .Longitude]' | while read line; do\
  curl -PUT localhost:9201/$index/${type}/$id -d "${line}" > tempdump 2>&1
  id=`expr $id + 1`
done

[ -e tempdump ] && rm -f tempdump

