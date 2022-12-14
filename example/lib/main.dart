import 'package:bitmap/bitmap.dart';
import 'package:desktop_window_manager/desktop_window_manager.dart'
    show DesktopWindowManager;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // Preparing to handle specific situations in DesktopWindowManager
  DesktopWindowManager.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Uint8List addBitmapHeaderAndFlipHorizontal(Uint8List headless) {
    const width = 36, height = 36;
    final bitmap = Bitmap.fromHeadless(
        width, height, Uint8List.fromList(headless.reversed.toList()));

    final modBitmap = bitmap.applyBatch([BitmapFlip.horizontal()]);
    return modBitmap.buildHeaded();
  }

  @override
  Widget build(BuildContext context) {
    final wiProvider = DesktopWindowManager.wiProvider;
    final wcList = wiProvider.makeWindowControlList();

    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: wcList.length,
          itemBuilder: (context, index) => Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(addBitmapHeaderAndFlipHorizontal(
                      wiProvider.getIconHeadless(wcList[index]))),
                  Text(
                    wiProvider.getTitle(wcList[index]),
                    style: const TextStyle(color: Colors.red),
                  ),
                  Text(
                    wiProvider.getModuleName(wcList[index]),
                    style: const TextStyle(color: Colors.blue),
                  ),
                  Text(
                    wiProvider.getPath(wcList[index]),
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
