#!/bin/bash

echo "===== Fluent Bit 파드 확인 ====="
kubectl get pods -n logging

echo -e "\n===== Fluent Bit 파드 상세 정보 ====="
POD_NAME=$(kubectl get pods -n logging -l app=fluentbit-app -o jsonpath="{.items[0].metadata.name}")
kubectl describe pod -n logging $POD_NAME

echo -e "\n===== Fluent Bit 보안 컨텍스트 확인 ====="
kubectl get pod -n logging $POD_NAME -o jsonpath='{.spec.securityContext}{"\n"}'
kubectl get pod -n logging $POD_NAME -o jsonpath='{.spec.containers[0].securityContext}{"\n"}'

echo -e "\n===== Fluent Bit 로그 확인 ====="
kubectl logs -n logging $POD_NAME --tail=50

echo -e "\n===== Fluent Bit 상태 확인 ====="
echo "파드 상태: $(kubectl get pod -n logging $POD_NAME -o jsonpath='{.status.phase}')"
echo "컨테이너 상태: $(kubectl get pod -n logging $POD_NAME -o jsonpath='{.status.containerStatuses[0].ready}')"
echo "재시작 횟수: $(kubectl get pod -n logging $POD_NAME -o jsonpath='{.status.containerStatuses[0].restartCount}')"

echo -e "\n===== Fluent Bit 설정 확인 ====="
echo "ConfigMap 내용:"
kubectl get configmap -n logging fluentbit-app-config -o yaml

echo -e "\n===== Fluent Bit 메트릭 확인 ====="
echo "다음 명령어를 실행하여 메트릭을 확인할 수 있습니다:"
echo "kubectl port-forward -n logging $POD_NAME 2020:2020"
echo "그런 다음 브라우저에서 http://localhost:2020/api/v1/metrics 접속"

echo -e "\n===== 테스트 로그 생성 ====="
echo "다음 명령어로 테스트 로그를 생성할 수 있습니다:"
echo "kubectl run test-logger --image=busybox -- sh -c 'while true; do echo \$(date) - 테스트 로그 메시지; sleep 5; done'"

echo -e "\n===== Loki에서 로그 확인 ====="
echo "Grafana를 통해 Loki에서 로그를 확인하려면 다음 명령어를 실행하세요:"
echo "kubectl port-forward -n monitoring svc/grafana-app 3000:80"
echo "그런 다음 브라우저에서 http://localhost:3000에 접속하여 Explore 메뉴에서 Loki 데이터 소스를 선택하고 로그를 확인하세요." 