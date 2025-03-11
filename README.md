# DevOps Practice Kubernetes with ArgoCD

이 프로젝트는 ArgoCD의 App of Apps 패턴을 사용하여 Kubernetes 애플리케이션을 배포하는 예제입니다.

## 구조

```
.
├── apps/                  # ArgoCD 애플리케이션 매니페스트
│   ├── root/              # 루트 애플리케이션
│   │   └── root-app.yaml  # 루트 애플리케이션 매니페스트
│   └── server/            # 서버 애플리케이션
│       └── server-app.yaml # 서버 애플리케이션 매니페스트
└── charts/                # Helm 차트
    └── server/            # 서버 애플리케이션 Helm 차트
        └── server/        # 서버 Helm 차트 디렉토리
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
2. `apps/root/root-app.yaml` 및 `apps/server/server-app.yaml` 파일에서 `repoURL`을 실제 GitHub 저장소 URL로 변경합니다.
3. ArgoCD에 루트 애플리케이션을 배포합니다:

```bash
kubectl apply -f apps/root/root-app.yaml
```

4. ArgoCD UI에서 애플리케이션 동기화 상태를 확인합니다.

## 서버 애플리케이션 정보

- 이미지: bemodesty306/devops-prac-server:sha-8c56847
- 포트: 8080

## 참고 사항

- 이 예제는 ArgoCD의 App of Apps 패턴을 보여주기 위한 것입니다.
- 실제 환경에서는 보안 및 리소스 설정을 적절히 조정해야 합니다.
