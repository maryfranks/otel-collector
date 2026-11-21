#!/usr/bin/env bash
set -euo pipefail

OTEL_ENDPOINT="${OTEL_ENDPOINT:-http://localhost:4318}"
VM_ENDPOINT="${VM_ENDPOINT:-http://localhost:8428}"
METRIC_NAME="telemetry_smoke_test_total"
RUN_ID="$(date +%s)"
NOW_NS="$((RUN_ID * 1000000000))"

echo "Sending test OTLP metric (${METRIC_NAME}, run=${RUN_ID}) to ${OTEL_ENDPOINT}/v1/metrics..."

HTTP_STATUS=$(curl -sS -o /dev/null -w "%{http_code}"   -X POST "${OTEL_ENDPOINT}/v1/metrics"   -H "Content-Type: application/json"   -d "{
    "resourceMetrics": [{
      "resource": {
        "attributes": [{
          "key": "service.name",
          "value": { "stringValue": "smoke-test" }
        }]
      },
      "scopeMetrics": [{
        "metrics": [{
          "name": "${METRIC_NAME}",
          "sum": {
            "dataPoints": [{
              "attributes": [{
                "key": "smoke_test_run",
                "value": { "stringValue": "${RUN_ID}" }
              }],
              "timeUnixNano": "${NOW_NS}",
              "asInt": "1"
            }],
            "aggregationTemporality": 2,
            "isMonotonic": true
          }
        }]
      }]
    }]
  }")

if [[ "${HTTP_STATUS}" != "200" ]]; then
  echo "ERROR: OTel Collector returned HTTP ${HTTP_STATUS}" >&2
  exit 1
fi

echo "Accepted (HTTP 200). Waiting for collector batch flush to VictoriaMetrics..."

for attempt in $(seq 1 15); do
  QUERY_RESULT=$(curl -fsS -G "${VM_ENDPOINT}/api/v1/query"     --data-urlencode "query=${METRIC_NAME}{smoke_test_run="${RUN_ID}"}" || true)

  if echo "${QUERY_RESULT}" | grep -q ""smoke_test_run":"${RUN_ID}""; then
    echo "SUCCESS: Verified ${METRIC_NAME}{smoke_test_run="${RUN_ID}"} in VictoriaMetrics."
    exit 0
  fi

  sleep 1
done

echo "ERROR: Timed out after 15s waiting for metric to appear in VictoriaMetrics (${VM_ENDPOINT})." >&2
exit 1
