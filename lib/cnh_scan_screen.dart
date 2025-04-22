import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner_cnh_app/services/cnh_scanner_service.dart';
import 'dart:io';

class CnhScannerScreen extends StatefulWidget {
  const CnhScannerScreen({super.key});

  @override
  State<CnhScannerScreen> createState() => _CnhScannerScreenState();
}

class _CnhScannerScreenState extends State<CnhScannerScreen> {
  bool _isLoading = false;
  Map<String, String> _extractedData = {};
  String? _imagePath;

  Future<void> _scanDocument() async {
    setState(() => _isLoading = true);
    try {
      final imagePath = await CnhScannerService.captureDocument();
      if (imagePath == null) return;

      final text = await CnhScannerService.extractTextFromImage(imagePath);
      final data = CnhScannerService.parseCnhData(text);

      setState(() {
        _extractedData = data;
        _imagePath = imagePath;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          action: SnackBarAction(
            label: 'Configurações',
            onPressed: openAppSettings,
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CNH Scanner Protótipo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: openAppSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _scanDocument,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Escanear CNH'),
            ),
            const SizedBox(height: 20),
            if (_imagePath != null) ...[
              Image.file(File(_imagePath!), height: 200, fit: BoxFit.contain),
            ],
            const SizedBox(height: 20),
            if (_extractedData.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _extractedData.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  '${entry.key.toUpperCase()}: ${entry.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
