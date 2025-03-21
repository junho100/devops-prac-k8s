# DevOps Practice Kubernetes with ArgoCD

이 프로젝트는 ArgoCD의 App of Apps 패턴을 사용하여 Kubernetes 애플리케이션을 배포하는 예제입니다.

## 구조

```
.
├── apps/                  # ArgoCD 애플리케이션 매니페스트
│   ├── root/              # 루트 애플리케이션
│   │   └── root-app.yaml  # 루트 애플리케이션 매니페스트
│   ├── server-app.yaml    # 서버 애플리케이션 매니페스트
│   ├── prometheus-app.yaml # 프로메테우스 애플리케이션 매니페스트
│   └── grafana-app.yaml   # 그라파나 애플리케이션 매니페스트
└── charts/                # Helm 차트
    ├── server/            # 서버 애플리케이션 Helm 차트
    │   └── server/        # 서버 Helm 차트 디렉토리
    │       ├── Chart.yaml
    │       ├── templates/
    │       └── values.yaml
    ├── prometheus/        # 프로메테우스 Helm 차트
    │   ├── Chart.yaml
    │   ├── templates/
    │   └── values.yaml
    └── grafana/           # 그라파나 Helm 차트
        ├── Chart.yaml
        ├── templates/
        └── values.yaml
```

## 사용 방법

### 사전 요구 사항

- Kubernetes 클러스터
- ArgoCD 설치
- Helm 3

### 배포 방법

1. 이 저장소를 클론합니다.
2. `apps/root/root-app.yaml`, `apps/server-app.yaml`, `apps/prometheus-app.yaml`, `apps/grafana-app.yaml` 파일에서 `repoURL`을 실제 GitHub 저장소 URL로 변경합니다.
3. ArgoCD에 루트 애플리케이션을 배포합니다:

```bash
kubectl apply -f apps/root/root-app.yaml
```

4. ArgoCD UI에서 애플리케이션 동기화 상태를 확인합니다.

### 모니터링 도구 접근 방법

포트 포워딩을 통해 그라파나에 접근할 수 있습니다:

```bash
kubectl port-forward -n monitoring svc/grafana-grafana 3000:3000
```

- 그라파나: http://localhost:3000 (계정: admin / 비밀번호: admin)

## 서버 애플리케이션 정보

- 이미지: bemodesty306/devops-prac-server
- 포트: 8080

## 모니터링 도구 정보

### 프로메테우스

- 이미지: prom/prometheus:v2.45.0
- 포트: 9090
- 기능: 메트릭 수집 및 저장, 알림 규칙 관리

### 그라파나

- 이미지: grafana/grafana:10.2.0
- 포트: 3000
- 기능: 데이터 시각화, 대시보드 관리
- 기본 대시보드: Kubernetes 리소스 모니터링

## 참고 사항

- 이 예제는 ArgoCD의 App of Apps 패턴을 보여주기 위한 것입니다.
- 실제 환경에서는 보안 및 리소스 설정을 적절히 조정해야 합니다.
- ArgoCD App of Apps 패턴에서는 루트 애플리케이션이 다른 애플리케이션을 찾을 수 있도록 디렉토리 구조가 중요합니다.
- 프로메테우스와 그라파나는 기본적인 설정으로 배포되며, 실제 환경에서는 보안 및 성능 설정을 조정해야 합니다.
