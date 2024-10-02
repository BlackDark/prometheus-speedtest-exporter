#!/bin/bash
set -e

if [ -z "$server_id" ]
then
    COMMAND="/usr/local/bin/speedtest --accept-license --accept-gdpr -f json"
else
    COMMAND="$COMMAND --server-id $server_id"
fi

# Function to output metrics from JSON data
output_metrics() {
  # Read JSON data from standard input
  json_data=$($COMMAND)

  # Extract labels
  #isp=$(echo $json_data | jq -r '.isp')
  # Not included your interface information
  server_id=$(echo $json_data | jq -r '.server.id')
  server_ip=$(echo $json_data | jq -r '.server.ip')
  server_host=$(echo $json_data | jq -r '.server.host')
  server_name=$(echo $json_data | jq -r '.server.name')

  LABELS="{server_id=\"$server_id\",server_ip=\"$server_ip\",server_host=\"$server_host\",server_name=\"$server_name\"}"

  # Extract and output each metric with comments and labels
  echo "# TYPE speedtester_ping_jitter gauge"
  echo "# HELP speedtester_ping_jitter Jitter in milliseconds"
  echo "speedtester_ping_jitter$LABELS $(echo $json_data | jq '.ping.jitter')"

  echo "# TYPE speedtester_ping_latency gauge"
  echo "# HELP speedtester_ping_latency Average latency in milliseconds"
  echo "speedtester_ping_latency$LABELS $(echo $json_data | jq '.ping.latency')"

  echo "# TYPE speedtester_ping_low gauge"
  echo "# HELP speedtester_ping_low Lowest latency recorded in milliseconds"
  echo "speedtester_ping_low$LABELS $(echo $json_data | jq '.ping.low')"

  echo "# TYPE speedtester_ping_high gauge"
  echo "# HELP speedtester_ping_high Highest latency recorded in milliseconds"
  echo "speedtester_ping_high$LABELS $(echo $json_data | jq '.ping.high')"

  echo "# TYPE speedtester_download_bandwidth gauge"
  echo "# HELP speedtester_download_bandwidth Download bandwidth in bits per second"
  echo "speedtester_download_bandwidth$LABELS $(echo $json_data | jq '.download.bandwidth')"

  echo "# TYPE speedtester_download_bytes counter"
  echo "# HELP speedtester_download_bytes Total bytes downloaded"
  echo "speedtester_download_bytes$LABELS $(echo $json_data | jq '.download.bytes')"

  echo "# TYPE speedtester_download_elapsed gauge"
  echo "# HELP speedtester_download_elapsed Time elapsed for download in milliseconds"
  echo "speedtester_download_elapsed$LABELS $(echo $json_data | jq '.download.elapsed')"

  echo "# TYPE speedtester_download_latency_iqm gauge"
  echo "# HELP speedtester_download_latency_iqm Interquartile mean latency during download in milliseconds"
  echo "speedtester_download_latency_iqm$LABELS $(echo $json_data | jq '.download.latency.iqm')"

  echo "# TYPE speedtester_download_latency_low gauge"
  echo "# HELP speedtester_download_latency_low Lowest latency during download in milliseconds"
  echo "speedtester_download_latency_low$LABELS $(echo $json_data | jq '.download.latency.low')"

  echo "# TYPE speedtester_download_latency_high gauge"
  echo "# HELP speedtester_download_latency_high Highest latency during download in milliseconds"
  echo "speedtester_download_latency_high$LABELS $(echo $json_data | jq '.download.latency.high')"

  echo "# TYPE speedtester_download_latency_jitter gauge"
  echo "# HELP speedtester_download_latency_jitter Jitter during download in milliseconds"
  echo "speedtester_download_latency_jitter$LABELS $(echo $json_data | jq '.download.latency.jitter')"

  echo "# TYPE speedtester_upload_bandwidth gauge"
  echo "# HELP speedtester_upload_bandwidth Upload bandwidth in bits per second"
  echo "speedtester_upload_bandwidth$LABELS $(echo $json_data | jq '.upload.bandwidth')"

  echo "# TYPE speedtester_upload_bytes counter"
  echo "# HELP speedtester_upload_bytes Total bytes uploaded"
  echo "speedtester_upload_bytes$LABELS $(echo $json_data | jq '.upload.bytes')"

  echo "# TYPE speedtester_upload_elapsed gauge"
  echo "# HELP speedtester_upload_elapsed Time elapsed for upload in milliseconds"
  echo "speedtester_upload_elapsed$LABELS $(echo $json_data | jq '.upload.elapsed')"

  echo "# TYPE speedtester_upload_latency_iqm gauge"
  echo "# HELP speedtester_upload_latency_iqm Interquartile mean latency during upload in milliseconds"
  echo "speedtester_upload_latency_iqm$LABELS $(echo $json_data | jq '.upload.latency.iqm')"

  echo "# TYPE speedtester_upload_latency_low gauge"
  echo "# HELP speedtester_upload_latency_low Lowest latency during upload in milliseconds"
  echo "speedtester_upload_latency_low$LABELS $(echo $json_data | jq '.upload.latency.low')"

  echo "# TYPE speedtester_upload_latency_high gauge"
  echo "# HELP speedtester_upload_latency_high Highest latency during upload in milliseconds"
  echo "speedtester_upload_latency_high$LABELS $(echo $json_data | jq '.upload.latency.high')"

  echo "# TYPE speedtester_upload_latency_jitter gauge"
  echo "# HELP speedtester_upload_latency_jitter Jitter during upload in milliseconds"
  echo "speedtester_upload_latency_jitter$LABELS $(echo $json_data | jq '.upload.latency.jitter')"

  echo "# TYPE speedtester_packet_loss gauge"
  echo "# HELP speedtester_packet_loss Packet loss in percentage"
  echo "speedtester_packet_loss$LABELS $(echo $json_data | jq '.packetLoss')"
}

# Execute the function with JSON data from standard input
output_metrics
