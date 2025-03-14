#!/bin/bash

echo "===== Fluent Bit 파드 확인 ====="
POD_NAME=$(kubectl get pods -n logging -l app=fluentbit-app -o jsonpath="{.items[0].metadata.name}")
echo "파드 이름: $POD_NAME"

echo -e "\n===== 디버깅 도구 설치 ====="
echo "Fluent Bit 컨테이너에 디버깅 도구를 설치합니다..."
kubectl exec -it -n logging $POD_NAME -- sh -c "apk add --no-cache busybox-extras findutils grep"

echo -e "\n===== 호스트 로그 디렉터리 구조 확인 ====="
kubectl exec -it -n logging $POD_NAME -- sh -c "ls -la /var/log/"
kubectl exec -it -n logging $POD_NAME -- sh -c "ls -la /var/log/pods/ | head -20"

echo -e "\n===== 로그 파일 검색 ====="
kubectl exec -it -n logging $POD_NAME -- sh -c "find /var/log -name '*.log' | head -20"

echo -e "\n===== 로그 파일 내용 확인 ====="
LOG_FILE=$(kubectl exec -it -n logging $POD_NAME -- sh -c "find /var/log/pods -name '*.log' | head -1")
if [ ! -z "$LOG_FILE" ]; then
  echo "로그 파일: $LOG_FILE"
  kubectl exec -it -n logging $POD_NAME -- sh -c "tail -5 $LOG_FILE"
else
  echo "로그 파일을 찾을 수 없습니다."
fi

echo -e "\n===== Fluent Bit 상태 디렉터리 확인 ====="
kubectl exec -it -n logging $POD_NAME -- sh -c "ls -la /fluent-bit/state/"

echo -e "\n===== Fluent Bit 설정 확인 ====="
kubectl exec -it -n logging $POD_NAME -- sh -c "cat /fluent-bit/etc/fluent-bit.conf" 