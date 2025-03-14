#!/bin/bash

echo "===== Fluent Bit 파드 확인 ====="
kubectl get pods -n logging

echo -e "\n===== Fluent Bit 파드 상세 정보 ====="
POD_NAME=$(kubectl get pods -n logging -l app=fluentbit-app -o jsonpath="{.items[0].metadata.name}")
kubectl describe pod -n logging $POD_NAME

echo -e "\n===== Fluent Bit 보안 컨텍스트 확인 ====="
kubectl get pod -n logging $POD_NAME -o jsonpath='{.spec.securityContext}{"\n"}'
kubectl get pod -n logging $POD_NAME -o jsonpath='{.spec.containers[0].securityContext}{"\n"}'

echo -e "\n===== 호스트 로그 디렉터리 구조 확인 ====="
kubectl exec -it -n logging $POD_NAME -- ls -la /var/log/
kubectl exec -it -n logging $POD_NAME -- ls -la /var/log/pods/ | head -20

echo -e "\n===== 로그 파일 검색 ====="
kubectl exec -it -n logging $POD_NAME -- find /var/log -name "*.log" | grep -v "/proc/" | head -20

echo -e "\n===== 로그 파일 권한 확인 ====="
LOG_DIR=$(kubectl exec -it -n logging $POD_NAME -- find /var/log/pods -type d | head -5)
for dir in $LOG_DIR; do
  echo "디렉터리: $dir"
  kubectl exec -it -n logging $POD_NAME -- ls -la $dir
  echo ""
done

echo -e "\n===== Fluent Bit 상태 디렉터리 확인 ====="
kubectl exec -it -n logging $POD_NAME -- ls -la /fluent-bit/state/

echo -e "\n===== Fluent Bit 설정 확인 ====="
kubectl exec -it -n logging $POD_NAME -- cat /fluent-bit/etc/fluent-bit.conf

echo -e "\n===== Fluent Bit 메트릭 확인 ====="
echo "다음 명령어를 실행하여 메트릭을 확인할 수 있습니다:"
echo "kubectl port-forward -n logging $POD_NAME 2020:2020"
echo "그런 다음 브라우저에서 http://localhost:2020/api/v1/metrics 접속"

echo -e "\n===== 테스트 로그 생성 ====="
echo "다음 명령어로 테스트 로그를 생성할 수 있습니다:"
echo "kubectl run test-logger --image=busybox -- sh -c 'while true; do echo \$(date) - 테스트 로그 메시지; sleep 5; done'" 