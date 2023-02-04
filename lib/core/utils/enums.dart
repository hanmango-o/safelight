// 앱 내에서 사용하는 Enum 모음
// 모든 Enum 형 변수는 naming 시 E를 처음 글자로 갖도록 해야한다.
// ignore_for_file: constant_identifier_names

/// [ECrosswalk]는 횡단보도의 타입을 나타내는 [Enum]이다.
///
/// [Crosswalk] 객체의 필드에 필수로 포함되어야 하는 값이며, 해당 횡단보도가 어떤 종류인지를 의미한다.
///
/// ### 포함하는 정보
/// [ECrosswalk]는 아래의 3가지 정보를 나타낸다.
/// - [SINGLE_ROAD] : 단일 신호등 지역, index(0)
/// - [INTERSECTION] : 교차로 지역, index(1)
/// - [FLASH_CROSSING] : 점멸 신호등 지역, index(2)
enum ECrosswalk {
  /// [SINGLE_ROAD]는 단일 신호등 지역을 의미한다.
  ///
  /// 단일 신호등 지역이란, 횡단보도가 하나만 존재하며 단방향으로 나아갈 수 있는 지역을 의미한다.
  /// 일반적인 신호등이 있는 횡단보도가 [SINGLE_ROAD]에 속하게 된다.
  ///
  /// [SINGLE_ROAD]는 [ECrosswalk]에서 0번 인덱스에 위치한다.
  SINGLE_ROAD,

  /// [INTERSECTION]은 교차로 지역을 의미한다.
  ///
  /// 교차로 지역이란, 횡단보도가 하나 이상 존재하며 나아갈 수 있는 방향이 2가지 이상인 지역을 의미한다.
  /// 일반적인 신호등이 있는 교차로 지역이 [INTERSECTION]에 속하게 된다.
  ///
  /// [INTERSECTION]은 [ECrosswalk]에서 1번 인덱스에 위치한다.
  INTERSECTION,

  /// [FLASH_CROSSING]은 점멸 신호등 지역을 의미한다.
  ///
  /// 점멸 신호등 지역이란, [SINGLE_ROAD]와 형태는 동일하나 보행자가 직접 물리적(혹은 SW) 버튼을 눌러야 신호가 변화하는 지역을 의미한다.
  ///
  /// [FLASH_CROSSING]은 [ECrosswalk]에서 2번 인덱스에 위치한다.
  FLASH_CROSSING,

  /// [UNKNOWN]은 알 수 없는 지역을 의미한다.
  ///
  /// 알 수 없는 지역이란, [SINGLE_ROAD], [INTERSECTION], [FLASH_CROSSING] 중 하나로 확인할 수 없는 지역을 의미한다.
  /// 주로, Firebase DB를 통해 확인할 수 없는 지역이 이에 해당한다.
  ///
  /// [UNKNOWN]은 [ECrosswalk]에서 마지막 인덱스에 위치한다.
  UNKNOWN,
}

/// [EBlueState]는 블루투스 통신 상태를 나타내는 [Enum]이다.
///
/// 앱 내에 불루트스 검색 및 연결 로직이 동작하게 되는 경우, 현재 동작 상태를 [EBlueState]를 통해 나타낸다.
///
///
/// ### 사용 시점 및 변수 사용 이유
/// [EBlueState]는 현재 디바이스의 블루투스 사용 여부를 판단하지는 않는다.
/// 즉, [EBlueState]는 블루투스 사용이 가능한 상태(Permission clear)일 때 사용하며
/// 블루투스 스캔, 연결 로직이 동작될 때 현재 상태를 나타내어 나타날 수 있는 버그를 최소화하는데 그 목적이 있다.
///
/// ### 포함하는 정보
/// [EBlueState]는 아래의 3가지 정보를 나타낸다.
/// - [ON] : 블루투스 스캔이 동작되고 있는 상태, index(0)
/// - [OFF] : 블루투스 스캔 및 연결이 완료된 상태, index(1)
/// - [CONNECT] : 블루투스 연결이 동작되고 있는 상태, index(2)
///
/// ### 일반적인 State 진행
/// 일반적인 상황에서 블루투스 연결 시 [EBlueState] 변경은 아래와 같이 진행된다.
///
/// *현재 상태를 `EBlueState state` 변수에 저장한다고 가정한다.*
///
/// |state 변수 상태|    |진행|
/// |-------------|----|---|
/// | [OFF]|
/// | [ON]||블루투스 스캔 시작|
/// | [OFF]||블루투스 스캔 종료|
/// | [OFF]||스캔 결과 선택|
/// | [CONNECT]||블루투스 연결 시작|
/// | [OFF]||블루투스 연결 종료|
enum EBlueState {
  /// [ON]은 블루투스 스캔이 동작되고 있는 상태를 나타낸다.
  ///
  /// 블루투스 스캔 로직이 시작될 때 상태를 [ON]으로 변경해주어야 하며, [ON] 상태일 경우 [CONNECT] 상태에서 진행할 수 있는 로직이 수행 불가능하다.
  /// [ON] 상태의 경우, [OFF]로의 전환만 가능하다. 즉, [ON] > [CONNECT] 로의 직접적인 전환은 불가능하다.
  ON,

  /// [OFF]는 블루투스 스캔 및 연결이 종료된 상태를 나타낸다.
  ///
  /// [OFF]상태는 가장 기본적인 상태로 모든 블루투스 로직이 시작될 수 있는 상태를 의미한다.
  /// 블루투스 스캔이 종료되었을 때와 블루투스 연결이 종료되었을 때 상태를 [OFF]로 변경해주어야 하며, [OFF] 상태일 경우 [ON], [CONNECT]로의 전환이 가능하다.
  OFF,

  /// [CONNECT]는 불루투스 연결이 동작되고 있는 상태를 의미한다.
  ///
  /// 블루투스 연결 로직이 시작될 때 상태를 [CONNECT]로 변경해주어야 하며, [CONNECT] 상태일 경우 [ON] 상태로의 직접적인 전환이 불가능하다.
  /// 즉, [CONNECT] > [OFF] 로의 전환만 가능하다.
  CONNECT,
}

enum EPermission {
  BLUETOOTH,
  LOCATION,
}
