
Essentia, data visualization with Kibana.
=

This repository illustrates how Essentia streams data into Elasticsearch and makes it viewable via Kibana.


## Environment used in this sample

- amazon ec2

- Java8

- Elasticsearch 2.3.5

- Kibana 4.5.4

- aq_tools 1.2.4

- jq (1.5)


## Datasets used in this sample

- `to-elasticsearch-xml.sh` uses "xml" data from AWS S3's open dataset: "datasets.elasticmapreduce"

- `to-elasticsearch-geo.sh` uses csv formatted data from AWS S3's open dataset: "aws-gsod", see more details in [the Official site of GSOD on AWS](https://aws.amazon.com/public-data-sets/gsod/).


## Recommended steps

If this is your first time using Essentia with Elasticsearch and Kibana: follow the "Installation & setup" section below to install the necessary commands and programs, and to set up your AWS S3 keys.

1. Start Elasticsearch.

1. Run one of the scripts `to-*.sh` to load data into Elasticsearch.

1. Start Kibana and make sure you have an open port for Kibana (default port setting is usually 5601).

1. Open http://YourInstanceIP:KibanaPort with a browser. Ex: http://127.0.0.1:5601



## Installation & setup

* Java8

	Elasticsearch requires Java8. If you do not have it in your environment, run the following

		$ sudo yum install -y java-1.8.0 java-1.8.0-openjdk-devel

	If you already have Java8, but is set to other version, then run it and choose version8.

		$ sudo /usr/sbin/alternatives --config java

* Elasticsearch

	Pull files from [the official](https://www.elastic.co/downloads/elasticsearch) and uncompress.

		$ wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.3.5/elasticsearch-2.3.5.zip
		$ unzip elasticsearch-2.3.5.zip
		$ elasticsearch -d  # start Elasticsearch

* Kibana

	Pull files from [the official](https://www.elastic.co/downloads/kibana) and uncompress.

		$ wget https://download.elastic.co/kibana/kibana/kibana-4.5.4-linux-x64.tar.gz
		$ gunzip kibana-4.5.4-linux-x64.tar.gz
		$ tar -xvf kibana-4.5.4-linux-x64.tar

	[Optional] Install kibana's plugin "elastic/sense"
	(This is not necessary if you have Kibana after version 5, or if you do not need it.)

		$ cd kibana-4.5.4-linux-x64
		$ bin/kibana plugin --install elastic/sense

	To start Kibana and view it via browser

		$ kibana >> /dev/null &  # start (just "kibana" is enough if you are ok with not running as background)

	open port 5601(default) to your IP in AWS security group, then open browser and type this url
	http://yourinstanceip:5601

* jq to parse json

		$ sudo yum install -y jq

* AWS Configure (access/secret keys to connect S3 bucket)

	The samples are using data from S3 buckets. In order to run the sample scripts, you need to setup your AWS access/secret keys' information under ~/.aws directory or add key options to the `ess select` commands in the sample scripts.

	(Any keys will work since this sample is accessing only public s3 buckets.)

	Setup your S3 key as

		$ aws configure

	If you do not have awscli in your environment, run this to install

		$ sudo yum -y install awscli

	Or, set the "--aws_access_key" and "--aws_secret_access_key" options for `ess select`.









