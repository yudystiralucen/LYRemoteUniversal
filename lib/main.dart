import 'package:flutter/material.dart';
import 'ir_controller.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? irAvailable;
  bool checking = false;

  @override
  void initState() {
    super.initState();
    checkInfrared();
  }

  Future<void> checkInfrared() async {
    setState(() => checking = true);

    final result = await IRController.hasIrEmitter();

    if (!mounted) return;

    setState(() {
      irAvailable = result;
      checking = false;
    });
  }

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
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('UNIVERSAL CONTROL',
                style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
      body: ListView(
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
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('One app for all your electronic devices.'),
                SizedBox(height: 15),
                Text('POWERED BY LUCEN YUDYSTIRA',
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('INFRARED STATUS',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      irAvailable == true
                          ? Icons.check_circle
                          : irAvailable == false
                              ? Icons.error
                              : Icons.hourglass_empty,
                      color: irAvailable == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        checking
                            ? 'Memeriksa IR Blaster...'
                            : irAvailable == true
                                ? 'Infrared tersedia'
                                : irAvailable == false
                                    ? 'Infrared tidak terdeteksi'
                                    : 'Belum diperiksa',
                      ),
                    ),
                    IconButton(
                      onPressed: checking ? null : checkInfrared,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const Text(
                  'Pemeriksaan hardware. Kode remote perangkat '
                  'akan ditambahkan pada tahap berikutnya.',
                  style: TextStyle(
                      fontSize: 11, color: Colors.white54),
                ),
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
                        irAvailable: irAvailable == true,
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
              'LY REMOTE UNIVERSAL • BY LUCEN YUDYSTIRA',
              style: TextStyle(
                  fontSize: 9, color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }
}

class RemotePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool irAvailable;

  const RemotePage({
    super.key,
    required this.title,
    required this.icon,
    required this.irAvailable,
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(
              irAvailable
                  ? 'Infrared hardware tersedia'
                  : 'Infrared belum terdeteksi',
            ),
            const SizedBox(height: 12),
            const Text(
              'Database kode perangkat sedang dikembangkan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
