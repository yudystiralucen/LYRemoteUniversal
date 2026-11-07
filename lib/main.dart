
import 'package:flutter/material.dart';

void main() {
  runApp(const LYRemoteApp());
}

const navy = Color(0xFF101827);
const blue = Color(0xFF2878FF);
const panel = Color(0xFF1B2638);

class LYRemoteApp extends StatelessWidget {
  const LYRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LY REMOTE UNIVERSAL',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = [
      ['AC REMOTE', 'Air Conditioner', Icons.ac_unit],
      ['TV REMOTE', 'Television', Icons.tv],
      ['ANDROID TV', 'Smart TV & Box', Icons.connected_tv],
      ['STB REMOTE', 'Set Top Box', Icons.settings_input_antenna],
      ['FAN REMOTE', 'Electric Fan', Icons.air],
      ['AUDIO REMOTE', 'Speaker & Audio', Icons.speaker],
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('LY REMOTE',
                style: TextStyle(
                    fontSize: 21, fontWeight: FontWeight.bold)),
            Text('UNIVERSAL CONTROL',
                style: TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1765E8), Color(0xFF102C60)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.settings_remote,
                      size: 42, color: Colors.white),
                  SizedBox(height: 16),
                  Text('CONTROL EVERYTHING',
                      style: TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold)),
                  SizedBox(height: 7),
                  Text('One app for all your electronic devices.',
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 14),
                  Text('POWERED BY LUCEN YUDYSTIRA',
                      style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text('MY REMOTE DEVICES',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final device = devices[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RemotePage(
                          title: device[0] as String,
                          icon: device[2] as IconData,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(device[2] as IconData,
                            color: blue, size: 32),
                        const SizedBox(height: 12),
                        Text(device[0] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(device[1] as String,
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white54)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                'LY REMOTE UNIVERSAL  •  BY LUCEN YUDYSTIRA',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RemotePage extends StatelessWidget {
  final String title;
  final IconData icon;

  const RemotePage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 75, color: blue),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Select your device to get started.'),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('ADD DEVICE'),
            ),
          ],
        ),
      ),
    );
  }
}
