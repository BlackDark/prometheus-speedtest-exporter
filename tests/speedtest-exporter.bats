#!/usr/bin/env bats

FIXTURE_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/fixtures" && pwd)"
SCRIPT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)/speedtest-exporter.sh"

@test "filters log lines and uses only the result line for server labels" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  # server_id must be the real value, not "null" from log lines
  echo "$output" | grep -q 'server_id="74184"'
}

@test "extracts correct download bandwidth from mixed output" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "speedtester_download_bandwidth{.*} 13417577"
}

@test "extracts correct upload bandwidth from mixed output" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "speedtester_upload_bandwidth{.*} 2629393"
}

@test "extracts correct ping latency from mixed output" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "speedtester_ping_latency{.*} 4.568"
}

@test "extracts correct ping jitter from mixed output" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "speedtester_ping_jitter{.*} 0.145"
}

@test "includes server host label in metrics" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q 'server_host="stgt-tc.wsqm.telekom-dienste.de"'
}

@test "includes server name label in metrics" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q 'server_name="Deutsche Telekom"'
}

@test "exits with non-zero status when speedtest produces no result line" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/only_errors.json" bash "$SCRIPT"
  [ "$status" -ne 0 ]
}

@test "output contains TYPE and HELP comments for each metric" {
  run env SPEEDTEST_COMMAND="cat $FIXTURE_DIR/mixed_output.json" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "# TYPE speedtester_download_bandwidth gauge"
  echo "$output" | grep -q "# HELP speedtester_download_bandwidth"
  echo "$output" | grep -q "# TYPE speedtester_upload_bandwidth gauge"
  echo "$output" | grep -q "# TYPE speedtester_ping_latency gauge"
}
