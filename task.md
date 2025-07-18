# Starbase 기반 계정별 데이터/인증/DB 설계 및 운영 전략

## Todo: Barcodian Admin 페이지 제작 단계

- [x] 1) Next.js 프로젝트 초기화 (npx create-next-app@latest barcodian-admin, TypeScript, App Router, ESLint, Tailwind, shadcn/ui 등)
- [x] 2) 폴더 구조 설계 (/app, /components, /lib, /types, /app/(admin)/dashboard, /app/(admin)/barmon, /app/(admin)/user)
- [x] 3) shadcn/ui 설치 및 세팅 (npx shadcn-ui@latest init, 버튼/테이블/폼 등 추가)
- [x] 4) API 연동 (Starbase API fetcher, SWR/React Query 등 데이터 패칭/캐싱)
- [x] 5) 기본 페이지/컴포넌트 구현 (로그인/인증, 마스터 바몬 CRUD, 유저 바몬 관리, 대시보드 등) → 샘플 대시보드/목업 API/타입/컴포넌트까지 정상 동작 확인
- [x] 6) 권한/보안/감사 로그 (관리자 인증/권한 체크, 변경 내역 로깅)
- [x] Flutter 클라이언트 상세페이지 UI/UX 개선(스와이프, 이미지 전환, 능력치 배경색 등) 완료
- [x] 바몬 상세페이지: 리스트-상세 이미지 분리, 스와이프 전환, 능력치 배경색 속성색-흰색 중간값 적용 등 실사용 수준 UI 개선
- [x] Flutter 클라이언트 구글 소셜 로그인 연동 및 자동화 (pubspec.yaml 에셋 경로 자동 수정, 빌드 오류 자동화, Provider 관련 코드 자동 수정 등)
- [x] pubspec.yaml 에셋 경로 자동화 및 flutter pub get, flutter run 등 명령 자동 실행, 빌드 오류 자동 수정
- [ ] 7) 스타일/UX 개선 (반응형, 다크모드, 접근성 등)
- [ ] 8) 빌드/배포 (npm run build 후 /var/www/html/barmon 등으로 배포)
- [x] Supabase 테이블(user_barmon, barmon 등) 생성 및 RLS(본인만 접근/수정/삭제) 정책 적용
- [x] Flutter → Supabase Client → DB 구조로 전환, Drizzle ORM은 서버/운영툴에서만 사용
- [x] Supabase Flutter SDK 연동 및 인증/CRUD 구현 
- [x] GUEST(비회원) 모드 및 CRUD MVP 자동화 적용

**운영 서버(ralphpark.com)에 SSH로 접속하여 /var/www/html/barmon 경로에 직접 작업/배포함.**

---

## 진행 상황 요약 (2024-06-28)

- ✅ Next.js App Router 기반 SPA 구조, 폴더/파일 세팅, 글로벌 스타일, shadcn/ui, React Query, SWR, axios 등 환경 구축 완료
- ✅ 샘플 대시보드, API Route Handler, 타입, fetcher 유틸 등 구현 및 정상 동작 확인
- ✅ Server/Client 컴포넌트 경계 오류, 모듈 export 오류 등 모두 해결
- ✅ 브라우저에서 /dashboard 접속 시 샘플 바몬 리스트, shadcn 버튼 등 정상 출력 확인
- ✅ Supabase Auth 인증 연동
- ✅ Flutter 클라이언트 상세페이지 UI/UX 개선(스와이프, 이미지 전환, 능력치 배경색 등) 완료
- ✅ 바몬 상세페이지: 리스트-상세 이미지 분리, 스와이프 전환, 능력치 배경색 속성색-흰색 중간값 적용 등 실사용 수준 UI 개선
- ✅ Supabase 테이블(user_barmon, barmon 등) 생성 및 RLS(본인만 접근/수정/삭제) 정책 적용
- ✅ Flutter → Supabase Client → DB 구조로 전환, Drizzle ORM은 서버/운영툴에서만 사용
- ✅ Supabase Flutter SDK 연동 및 인증/CRUD 구현
- ✅ GUEST(비회원) 모드 및 CRUD MVP 자동화 적용
- ✅ Flutter 클라이언트 구글 소셜 로그인 연동, Provider 관련 코드 자동화, pubspec.yaml 에셋 경로 자동화, 빌드 오류 자동 수정 등 모든 자동화 원칙 적용
- ⏭️ 다음 단계: Flutter-API-DB 연동 고도화, 운영툴 대시보드/CRUD/보안 강화, 실운영 배포 등

---

## 자동화 원칙 및 역할 분담
- AI(Assistant)는 코드 수정, 설정 변경, pubspec.yaml/에셋 경로/명령 실행 등 자동화 가능한 모든 작업을 직접 처리
- 사용자는 외부 콘솔 입력, OAuth Client 발급, Supabase 콘솔 설정 등 자동화 불가한 작업만 직접 수행
- 모든 자동화 내역 및 수동 작업 요청은 task.md 및 대화에 명확히 기록

---

## 1. 배경 및 목표
- 바몬(BarMon) 게임은 글로벌 서비스, 계정 기반 성장/수집/교환/랭킹 등 다양한 온라인 기능을 지원해야 함
- 보안, 동기화, 데이터 무결성, 확장성, 운영 편의성을 위해 **모든 계정별(플레이어별) 데이터는 Starbase(운영 서버) DB에 저장**
- 차후 Auth(인증) 시스템까지 통합하여, 계정/데이터/권한을 안전하게 관리할 계획

---

## 2. DB/서버 설계 원칙
1. **모든 계정별 데이터는 서버(DB)에 저장**
   - user_barmon 등 모든 개체 데이터는 user_id(계정 식별자)로 소유자 구분
   - 클라이언트(디바이스)에는 임시 캐시/조회 데이터만 저장(중요 정보는 서버에만)
2. **Auth(인증) 시스템과 연동**
   - OAuth, 소셜 로그인, 자체 계정 등 확장 가능성 고려
   - 인증 토큰 기반 API(JWT, 세션 등) 설계
   - 인증/권한 체크 미들웨어(Express 등) 도입
3. **API/DB 설계 시 항상 user_id(계정 식별자) 기반**
   - 데이터 생성/조회/수정/삭제 시 인증된 user_id 기준
4. **보안/동기화/확장성 최우선**
   - 서버-클라이언트 간 데이터 일관성 유지
   - 글로벌 서비스, 랭킹, PvP, 교환 등도 계정 기반 확장 용이

---

## 3. 데이터 흐름(구조)

- **마스터 데이터(barmon)**: Starbase 서버(ralphpark.com) PostgreSQL DB에 저장, 모든 유저가 공통 참조
- **플레이어별 개체(user_barmon)**: Starbase 서버 DB에 저장, user_id로 소유자 구분
- **클라이언트(Flutter 등)**: 서버 API를 통해 데이터 조회/갱신, 로컬에는 임시 캐시만 저장

### Mermaid 다이어그램
```mermaid
db["마스터 DB (barmon)"]:::dbmaster
userdb["플레이어별 바몬 DB (user_barmon)"]:::dbuser
api["Starbase API 서버"]:::starbase
fe["프론트엔드(Flutter 등)"]:::local

fe -- "API 호출(REST)" --> api
api --> db
api --> userdb

classDef dbmaster fill:#e8f5e9,stroke:#388e3c,stroke-width:2;
classDef dbuser fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2;
classDef starbase fill:#fff3e0,stroke:#f57c00,stroke-width:2;
classDef local fill:#e0f7fa,stroke:#00796b,stroke-width:2;
```

---

## 4. 향후 계획 및 실무 적용
- Auth(Supabase Auth, 자체 구현 등) 도입 시 user_id 관리/보안 강화
- 모든 API/DB 작업에 인증/권한 체크 필수 적용
- 운영/배포 환경에서는 .env 등 환경변수로 DB/인증 정보 분리 관리
- 데이터 백업, 장애 대응, 글로벌 확장 등도 서버 DB 기반으로 설계
- 클라이언트는 서버 API만 사용, 로컬 DB는 개발/테스트/임시 캐시 용도

---

## 5. 참고/유의사항
- 운영 DB(ralphpark.com)와 개발/테스트 DB 분리
- 마스터 데이터/시드/마이그레이션 작업 시 운영 DB에 직접 반영됨을 항상 주의
- 보안, 개인정보, 결제 등 민감 데이터는 반드시 서버에서만 관리

---

**이 문서는 Starbase 기반 계정별 데이터/인증/DB 설계 및 운영의 기준 문서로 지속 업데이트 예정**

# Barcodian Admin(운영툴) 자동화 내역

## 1차 자동화
- barcodian-admin 폴더 생성, Next.js App Router 구조 세팅
- app, components, lib, types, styles 등 폴더 생성
- shadcn/ui, React Query, SWR, axios, tailwind 등 패키지 설치
- fetcher.ts, cn 유틸, 샘플 타입, 샘플 대시보드, 샘플 API Route Handler, 샘플 버튼 컴포넌트 생성
- .env.example, README.md 등 템플릿 추가

## TODO
- DB 연동(Drizzle, 운영 서버)
- 마스터/유저 바몬 CRUD, 대시보드/관리 UI
- 실운영 배포, 보안/권한 강화
- Mermaid 다이어그램, 운영툴 문서화
- Flutter → Supabase Client → DB 구조로 전환, Drizzle ORM은 서버/운영툴에서만 사용
- Supabase Flutter SDK 연동 및 인증/CRUD 구현 

## 2024-06-28 Flutter 클라이언트 인증/회원가입/UX/자동화 작업 내역

### 1. 인증/로그인/회원가입/게스트/구글 로그인 전체 UX 및 코드 구조
- 로그인 페이지에서 이메일/비밀번호 입력 후 로그인 또는 회원가입 버튼으로 각각 동작 분기
- 회원가입 버튼 클릭 시 별도 다이얼로그(모달)에서 이메일(ID), 비밀번호, 비밀번호 확인, 구글 로그인 버튼 입력/선택 가능
- 입력값 검증(이메일 형식, 비밀번호 일치/길이 등) 및 에러 안내, 가입 성공 시 자동 로그인
- GUEST(비회원) 모드 지원: 드로어 메뉴에서 GUEST 오른쪽에 회원가입 버튼 노출, 클릭 시 로그인/회원가입 화면으로 이동
- 구글 소셜 로그인: 로그인/회원가입 다이얼로그 모두에서 구글 로그인 버튼 제공, 성공 시 바로 바몬 리스트로 이동

### 2. 드로어(햄버거) 메뉴 UX 개선
- 로그인 계정 정보(이메일/구글 아이콘/GUEST) 맨 위에 표시
- 구글 계정 로그인 시 이메일 오른쪽에 구글 아이콘 노출
- GUEST 모드 시 회원가입 버튼 노출
- 구글 계정 분리(연결 해제) 버튼 추가, provider unlink 동작(계정 분할 아님)

### 3. Supabase Auth provider unlink(구글 계정 분리) 동작 및 한계
- unlinkIdentity는 provider 연결만 해제, user row 자체 분할(2개 계정 분리)은 불가
- 실제 계정 분할은 서버(Edge Function, Admin API)에서 별도 구현 필요

### 4. 코드 품질 및 자동화
- use_build_context_synchronously linter 경고 해결: builderContext.mounted, context 분리 사용
- pubspec.yaml, asset 경로, provider, 빌드 오류 등 자동화 원칙 적용
- @project-rules.mdc에 모든 Flutter/Supabase 연동, linter, 자동화 규칙 최신화

### 5. 기타/운영툴 연동
- task.md 및 대화에 모든 자동화/수동 작업 내역 명확히 기록
- 운영툴(Next.js, Drizzle, Starbase)과 연동되는 구조/정책 유지 