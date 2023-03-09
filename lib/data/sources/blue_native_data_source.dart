part of data_source;

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
