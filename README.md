# safelight

SafeLight는 교통 약자 및 일반인들의 위험 지역 횡단을 돕는 소프트웨어 압버튼입니다.

교통 약자(시각장애)에게 맞춤형 보행 보조 도구로서 기존의 압버튼 사용시 불편함 해소를 목표로 개발 중입니다.

# 들어가기 앞서...
해당 프로젝트는 `Flutter`로 작성되었습니다.

먼저 Flutter에 대해 알아보고 해당 프로젝트를 살펴보는 것을 권장합니다.

### [Flutter 공식 문서](https://flutter.dev/)

또한, 해당 프로젝트를 실행하는 방법은 아래 링크에서 확인 가능합니다.


# 진행

* ~~[2022 배리어프리 공모전](https://www.autoeverapp.kr/) 예선 1차 합격~~

* ~~[2022 배리어프리 공모전](https://www.autoeverapp.kr/) 예선 심사 최종 합격(~2022.08.19)~~

* [2022 배리어프리 공모전](https://www.autoeverapp.kr/) 본선 진출(14팀)

# 의존 라이브러리
<details><summary>get</summary>

### [get: ^4.6.5](https://pub.dev/packages/get)
- Flutter App 내 State 관리
- App Navigator (route 관리)

</details>

<details><summary>flutter_blue</summary>

### [flutter_blue: ^0.8.0](https://pub.dev/packages/flutter_blue)
- App Bluetooth 통신
- SafeLight 페어링

</details>

<details><summary>http</summary>

### [http: ^0.13.5](https://pub.dev/packages/http)
- http 통신(get / post)

</details>

<details><summary>sqflite</summary>

### [sqflite: ^2.0.3](https://pub.dev/packages/sqflite)
- SafeLight와 신호등 압버튼의 관계 저장
- 신호등 압버튼 정보 저장

</details>

<details><summary>shared_preferences</summary>

### [shared_preferences: ^2.0.15](https://pub.dev/packages/shared_preferences)
- 사용자 상태(교통 약자 타입) 관리
- App 최신 버전 관리

</details>

<details><summary>flutter_local_notifications</summary>

### [flutter_local_notifications: ^9.7.0](https://pub.dev/packages/flutter_local_notifications)
- 자동 스캔 시, SafeLight Search 알림
- SAFELIGHT_SafeLightScan usecase에서 사용

</details>

<details><summary>flutter_tts</summary>

### [flutter_tts: ^3.5.0](https://pub.dev/packages/flutter_tts)
- 시각 장애 사용자를 위한 tts 서비스

</details>
