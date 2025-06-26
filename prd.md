바코디언 (Barcodian)
제품 요구사항 정의서 (Product Requirements Document, PRD)

---

## [2024-06-09] 개발 진행 및 기술/구현 사항 요약

### 1. Flutter 프로젝트 구조 및 주요 기술
- Flutter + Riverpod 상태관리
- mobile_scanner(카메라 바코드 스캔), crypto(해시/랜덤)
- 바코디언 데이터 모델, StateNotifierProvider, 동적 생성/추가
- UI: 내 바코디언 리스트(카드형), 상세, 바코드 스캔(카메라)

### 2. 바코드 스캔 및 바코디언 생성 로직
- 모든 바코드(숫자/문자/특수문자 등) 스캔 가능
- 계정ID+바코드값을 SHA-256 해시 → 시드(64자리) 생성
- **같은 계정+같은 바코드 → 항상 같은 결과**
- **다른 계정+같은 바코드 → 완전히 다른 결과(랜덤성)**
- **비즈니스 바코드(BIZ_, EVENT_ 등 prefix) → 모든 계정 동일 결과**
- 시드에서 능력치/속성/희귀도/종족 등 추출
- 중복 바코디언 방지(동일 id 존재 시 추가 안함)

### 3. 주요 폴더/파일 구조
- lib/models/barcodian.dart: 데이터 모델
- lib/providers/barcodian_provider.dart: StateNotifierProvider, 동적 추가
- lib/utils/barcodian_generator.dart: 시드/능력치 생성 유틸
- lib/screens/barcodian_list_page.dart: 리스트+스캔 버튼
- lib/screens/barcode_scan_page.dart: 카메라 스캔
- lib/screens/barcodian_detail_page.dart: 상세
- lib/widgets/barcodian_card.dart, barcodian_badge.dart: UI 위젯

### 4. Android/iOS 권한 및 설정
- AndroidManifest.xml: <uses-permission android:name="android.permission.CAMERA" />
- Info.plist: <key>NSCameraUsageDescription</key> 추가

### 5. 기타
- pubspec.yaml: flutter_riverpod, mobile_scanner, crypto 등 의존성 명시
- NDK 버전 이슈, adb 무선 디버깅 방법 등 개발 환경 팁

---

# 이어서 작업하기 위한 추천 방법

1. **전체 프로젝트 폴더(예: barcodian/)를 git 저장소로 관리**
   - GitHub, GitLab, Bitbucket 등 원격 저장소에 push
   - .gitignore, README.md 등 포함
2. **다른 컴퓨터에서 git clone**
   - 의존성 설치: `flutter pub get`
   - Android/iOS 환경 세팅(권한, NDK 등) 확인
3. **개발 환경 세팅**
   - Android Studio, VSCode, Flutter SDK, adb 등 설치
   - 환경 변수(PAT) 설정, adb 무선 디버깅 필요시 platform-tools 경로 추가
4. **flutter run**으로 바로 실행/개발 가능
5. **중요: pubspec.yaml, android/ios 권한, utils/provider/model 등 최신화 확인**

---

# 기타 참고
- 바코드 스캔/생성 로직, UI/상태관리, 무선 디버깅 등 상세 내용은 이 PRD 최신본 참고
- 추가 요구/이슈/설계 변경 시 이 파일에 계속 업데이트

---

# (이하 기존 PRD 내용)

