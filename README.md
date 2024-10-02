## Speedtest CLI Prometheus Exporter

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/blackdark93/prometheus-speedtest-exporter)](https://hub.docker.com/r/blackdark93/prometheus-speedtest-exporter/tags)

![](https://i.imgur.com/iIzWUre.png)

This Docker container serves as a Prometheus exporter to gather speed test data using the official [Speedtest CLI](https://www.speedtest.net/apps/cli) and [script_exporter](https://github.com/ricoberger/script_exporter). The Docker image, [blackdark93/prometheus-speedtest-exporter](https://hub.docker.com/repository/docker/blackdark93/prometheus-speedtest-exporter), supports multiple architectures including amd64, arm6, arm7, and arm64.

## Quick Start Guide

To perform a basic test of the exporter, execute the following command to run the container:

```bash
sudo docker run --rm -p 9469:9469 blackdark93/prometheus-speedtest-exporter:main
```

Next, access the `/probe` endpoint:

```bash
curl "http://localhost:9469/probe?script=speedtest"
```

After approximately 15 to 30 seconds, you should receive output similar to this:

```txt
# HELP script_success Script exit status (0 = error, 1 = success).
# TYPE script_success gauge
script_success{script="speedtest"} 1

# HELP script_duration_seconds Script execution time in seconds.
# TYPE script_duration_seconds gauge
script_duration_seconds{script="speedtest"} 11.471082

# HELP script_exit_code The exit code of the script.
# TYPE script_exit_code gauge
script_exit_code{script="speedtest"} 0

# HELP speedtester_ping_jitter Jitter in milliseconds.
# TYPE speedtester_ping_jitter gauge
speedtester_ping_jitter{server_id="31448"} 1.150

# HELP speedtester_ping_latency Average latency in milliseconds.
# TYPE speedtester_ping_latency gauge
speedtester_ping_latency{server_id="31448"} 8.346

# HELP speedtester_download_bandwidth Download bandwidth in bits per second.
# TYPE speedtester_download_bandwidth gauge
speedtester_download_bandwidth{server_id="31448"} 13397023

# HELP speedtester_upload_bandwidth Upload bandwidth in bits per second.
# TYPE speedtester_upload_bandwidth gauge
speedtester_upload_bandwidth{server_id="31448"} 4870315

# HELP speedtester_packet_loss Packet loss percentage.
# TYPE speedtester_packet_loss gauge
speedtester_packet_loss{server_id="31448"} 0
```

## Prometheus Configuration

To configure Prometheus, pass the script name as a parameter (`script`). It is recommended to use a long `scrape_interval` to minimize bandwidth usage.

Example configuration:

```yaml
scrape_configs:
  - job_name: 'speedtest'
    metrics_path: /probe
    params:
      script: [speedtest]
    static_configs:
      - targets: ['127.0.0.1:9469']
    scrape_interval: 60m
    scrape_timeout: 90s

  - job_name: 'script_exporter'
    metrics_path: /metrics
    static_configs:
      - targets: ['127.0.0.1:9469']
```

## Grafana Dashboard

An example Grafana dashboard is included and demonstrated in the screenshot above.

## Testing Against Multiple Servers

By default, Speedtest selects a nearby server automatically. To specify one manually, set the `server_id` environment variable in Docker Compose:

```yaml
speedtest:
  image: "blackdark93/prometheus-speedtest-exporter:main"
  restart: "on-failure"
  ports:
    - 9469:9469
  environment:
    - server_id=3855 # Example server ID for DTAC Bangkok
```

Metrics will include labels for each specified server ID. If adding more servers, consider extending the `scrape_timeout` to ensure completion:

```yaml
- job_name: "speedtest"
  metrics_path: /probe
  params:
    script: [speedtest]
  static_configs:
    - targets: ['127.0.0.1:9469']
  scrape_interval: 60m
  scrape_timeout: 10m
```

Refer to this [searchable list](https://williamyaps.github.io/wlmjavascript/servercli.html) to find server IDs.

## Acknowledgments

This project is inspired by:

- [prometheus-speedtest-exporter](https://github.com/billimek/prometheus-speedtest-exporter/tree/master)
- [prometheus-speedtest-exporter](https://github.com/h2xtreme/prometheus-speedtest-exporter)
- [script_exporter](https://github.com/ricoberger/script_exporter)
- [docker-ookla-speedtest-cli](https://github.com/pschmitt/docker-ookla-speedtest-cli)
