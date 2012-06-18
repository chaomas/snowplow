
ADD JAR ${SERDE_FILE} ;

CREATE EXTERNAL TABLE `extracted_logs`
ROW FORMAT SERDE 'com.snowplowanalytics.snowplow.hadoop.hive.SnowPlowEventDeserializer'
LOCATION '${CLOUDFRONT_LOGS}' ;

CREATE EXTERNAL TABLE IF NOT EXISTS `events` (
tm string,
txn_id string,
user_id string,
user_ipaddress string,
visit_id int,
page_url string,
page_title string,
page_referrer string,
mkt_source string,
mkt_medium string,
mkt_term string,
mkt_content string,
mkt_name string,
ev_category string,
ev_action string,
ev_label string,
ev_property string,
ev_value string,
br_name string,
br_family string,
br_version string,
br_type string,
br_renderengine string,
br_lang string,
br_features array<string>,
br_cookies boolean,
os_name string,
os_family string,
os_manufacturer string,
dvce_type string,
dvce_ismobile boolean,
dvce_screenwidth int,
dvce_screenheight int
)
PARTITIONED BY (dt STRING)
LOCATION '${EVENTS_TABLE}' ;

SET hive.exec.dynamic.partition=true ;

INSERT OVERWRITE TABLE `events`
PARTITION (dt='${DATA_DATE}')
SELECT
tm,
txn_id,
user_id,
user_ipaddress,
visit_id,
page_url,
page_title,
page_referrer,
mkt_source,
mkt_medium,
mkt_term,
mkt_content,
mkt_name,
ev_category,
ev_action,
ev_label,
ev_property,
ev_value,
br_name,
br_family,
br_version,
br_type,
br_renderengine,
br_lang,
br_features,
br_cookies,
os_name,
os_family,
os_manufacturer,
dvce_type,
dvce_ismobile,
dvce_screenwidth,
dvce_screenheight
FROM `extracted_logs`
WHERE dt='${DATA_DATE}' ;
