#!/bin/bash

echo "===== Fluent Bit 파드 확인 ====="
kubectl get pods -n logging -l app=fluentbit-app

echo -e "\n===== Fluent Bit 로그 확인 ====="
POD_NAME=$(kubectl get pods -n logging -l app=fluentbit-app -o jsonpath="{.items[0].metadata.name}")
kubectl logs -n logging $POD_NAME --tail=50

echo -e "\n===== Fluent Bit 메트릭 확인 ====="
echo "다음 명령어를 실행하여 메트릭을 확인할 수 있습니다:"
echo "kubectl port-forward -n logging $POD_NAME 2020:2020"
echo "그런 다음 브라우저에서 http://localhost:2020/api/v1/metrics 접속"

echo -e "\n===== 로그 파일 경로 확인 ====="
kubectl exec -it -n logging $POD_NAME -- find /var/log/pods -type f -name "*.log" | head -5

echo -e "\n===== 로그 파일 내용 확인 ====="
LOG_FILE=$(kubectl exec -it -n logging $POD_NAME -- find /var/log/pods -type f -name "*.log" | head -1)
if [ ! -z "$LOG_FILE" ]; then
  echo "로그 파일: $LOG_FILE"
  kubectl exec -it -n logging $POD_NAME -- tail -5 $LOG_FILE
else
  echo "로그 파일을 찾을 수 없습니다."
fi

echo -e "\n===== Fluent Bit 입력 플러그인 상태 확인 ====="
echo "다음 명령어를 실행하여 입력 플러그인 상태를 확인할 수 있습니다:"
echo "kubectl port-forward -n logging $POD_NAME 2020:2020"
echo "그런 다음 브라우저에서 http://localhost:2020/api/v1/storage 접속" 