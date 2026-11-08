import 'package:flutter/material.dart';
import 'ir_controller.dart';

class GreeAcRemotePage extends StatefulWidget {
  const GreeAcRemotePage({super.key});

  @override
  State<GreeAcRemotePage> createState() =>
      _GreeAcRemotePageState();
}

class _GreeAcRemotePageState
    extends State<GreeAcRemotePage> {
  bool power = false;
  bool swing = true;
  int temperature = 24;

  String mode = 'Cool';
  String fan = 'Auto';

  bool sending = false;

  Future<void> sendCommand() async {
    if (sending) return;

    setState(() => sending = true);

    final success = await IRController.sendGree(
      power: power,
      temperature: temperature,
      mode: mode,
      fan: fan,
      swing: swing,
    );

    if (!mounted) return;

    setState(() => sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Perintah infrared berhasil dikirim'
              : 'Gagal mengirim infrared',
        ),
      ),
    );
  }

  Widget controlButton(
    String label,
    VoidCallback action,
  ) {
    return ElevatedButton(
      onPressed: sending ? null : action,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GREE AC REMOTE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(
            Icons.ac_unit,
            size: 75,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          Center(
            child: Text(
              '$temperature°C',
              style: const TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controlButton(
                '−',
                () {
                  if (temperature > 16) {
                    setState(() => temperature--);
                  }
                },
              ),
              const SizedBox(width: 20),
              controlButton(
                '+',
                () {
                  if (temperature < 30) {
                    setState(() => temperature++);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          DropdownButtonFormField<String>(
            value: mode,
            decoration: const InputDecoration(
              labelText: 'Mode AC',
              border: OutlineInputBorder(),
            ),
            items: ['Auto', 'Cool', 'Dry', 'Fan', 'Heat']
                .map((v) => DropdownMenuItem(
                      value: v,
                      child: Text(v),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => mode = v);
              }
            },
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            value: fan,
            decoration: const InputDecoration(
              labelText: 'Kecepatan Fan',
              border: OutlineInputBorder(),
            ),
            items: ['Auto', 'Low', 'Medium', 'High']
                .map((v) => DropdownMenuItem(
                      value: v,
                      child: Text(v),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => fan = v);
              }
            },
          ),

          const SizedBox(height: 18),

          SwitchListTile(
            title: const Text('Swing'),
            value: swing,
            onChanged: (v) {
              setState(() => swing = v);
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: sending
                  ? null
                  : () {
                      setState(() => power = !power);
                      sendCommand();
                    },
              icon: const Icon(Icons.power_settings_new),
              label: Text(power ? 'TURN OFF' : 'TURN ON'),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: sendCommand,
              child: const Text('KIRIM PENGATURAN AC'),
            ),
          ),

          const SizedBox(height: 20),

          if (sending)
            const Center(
              child: CircularProgressIndicator(),
            ),

          const Text(
            'LY REMOTE UNIVERSAL • GREE',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
