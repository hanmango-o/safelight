part of data_source;

/// 블루투스 통신을 위한 Interface이다.
///
/// 블루투스 통신과 관련된 직접적인 처리를 수행한다.
/// [FlutterReactiveBle]를 통해 블루투스 scan, connect, send, disconnect를 수행한다.
///
/// FlutterReactiveBle를 사용하기 위해서는
/// 각 OS에 맞는 블루투스 권한 설정([aos](https://pub.dev/packages/flutter_reactive_ble#android), [ios](https://pub.dev/packages/flutter_reactive_ble#ios))이 필요하다.
///
/// 스마트 IOT 음향 신호기에 관한 경찰청 제공 프로토콜(2021 개정판)을 기준으로 블루투스 통신을 수행한다.
///
/// 해당 Interface의 구현부는 [AuthRemoteDataSourceImpl]이다.
///
/// **Summary :**
///
///   - **DO**
///   [FirebaseAuth]에 사용자 인증(로그인/로그아웃)과 관련된 요청을 처리한다.
///
///   {@template data_part1}
///   - **PREFER**
///   외부 DI를 통해 객체를 생성하는 것을 권장한다.
///   {@endtemplate}
///
///     ```dart
///     AuthRemoteDataSource datasource = DI.get<AuthRemoteDataSource>();
///     ```
///
///   - **DON'T**
///   Firebased SDK 설정과 FirebaseAuth 설정이 선행되지 않으면 사용할 수 없다.
///
/// {@macro usecase_part2}
///
/// **See also :**
///
///   - FlutterReact
abstract class BlueNativeDataSource {
  Future<List<DiscoveredDevice>> scan();
  Future<void> send(
    DiscoveredDevice post, {
    List<int> command = const [0x31, 0x00, 0x02],
  });
  Future<void> disconnect();
}

class BlueNativeDataSourceImpl implements BlueNativeDataSource {
  static StreamSubscription? subscription;
  static StreamSubscription<ConnectionStateUpdate>? connection;

  static const Duration duration = Duration(seconds: 1);
  final FlutterReactiveBle bluetooth;

  BlueNativeDataSourceImpl({required this.bluetooth});

  @override
  Future<List<DiscoveredDevice>> scan() async {
    List<DiscoveredDevice> results = [];
    try {
      subscription = bluetooth.scanForDevices(
        withServices: [Uuid.parse(Bluetooth.SERVICE_UUID)],
      ).listen((device) {
        final knownDeviceIndex = results.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          results[knownDeviceIndex] = device;
        } else {
          results.add(device);
        }
      }, onError: (e) {
        throw BlueException();
      });

      await Future.delayed(duration);
      await subscription!.cancel();

      return results;
    } catch (e) {
      throw BlueException();
    }
  }

  @override
  Future<void> send(
    DiscoveredDevice post, {
    List<int> command = Bluetooth.CMD_VOICE,
  }) async {
    try {
      connection = bluetooth.connectToDevice(id: post.id).listen(
        (update) async {
          if (update.connectionState == DeviceConnectionState.connected) {
            List<DiscoveredService> services =
                await bluetooth.discoverServices(post.id);

            final characteristic = services
                .firstWhere(
                  (service) =>
                      service.serviceId == Uuid.parse(Bluetooth.SERVICE_UUID),
                )
                .characteristics
                .firstWhere(
                  (characteristic) =>
                      characteristic.characteristicId ==
                      Uuid.parse(Bluetooth.CHAR_UUID),
                );

            final qualifiedCharacteristic = QualifiedCharacteristic(
              characteristicId: characteristic.characteristicId,
              serviceId: characteristic.serviceId,
              deviceId: post.id,
            );

            await bluetooth
                .writeCharacteristicWithoutResponse(
              qualifiedCharacteristic,
              value: command,
            )
                .then(
              (value) async {
                await Future.delayed(const Duration(milliseconds: 500));
                await disconnect();
              },
            );
          }
        },
        onError: (Object e) {
          throw BlueException();
        },
      );
    } catch (e) {
      throw BlueException();
    }
  }

  @override
  Future<void> disconnect() async {
    await connection!.cancel();
  }
}
