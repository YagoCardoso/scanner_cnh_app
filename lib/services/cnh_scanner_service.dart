import 'package:edge_detection/edge_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CnhScannerService {
  static Future<String?> captureDocument() async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/cnh_scan_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final success = await EdgeDetection.detectEdge(
        filePath,
        androidCropTitle: "Ajuste o documento",
        androidCropBlackWhiteTitle: "Preto e Branco",
        androidCropReset: "Redefinir",
        canUseGallery: true,
      );

      if (!success) {
        throw Exception('Falha ao capturar imagem');
      }

      return filePath;
    } catch (e) {
      throw Exception('Erro ao capturar documento: ${e.toString()}');
    }
  }

  static Future<String> extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception('Erro no OCR: ${e.toString()}');
    } finally {
      textRecognizer.close();
    }
  }

  static Map<String, String> parseCnhData(String fullText) {
    // Limpeza do texto para facilitar os matches
    fullText = fullText
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ');

    // Nome (NOME SOCIAL ou 2 e 1 NOME E SOBRENOME)
    final name = _extractField(
      r'(?:NOME\s+SOCIAL|NOME\s+E\s+SOBRENOME)\s+([A-ZÀ-Ú\s]{5,})',
      fullText,
    );

    // Validade (4b VALIDADE)
    final validade = _extractField(
      r'(?:4B\s+VALIDADE|VALIDADE)\s+(\d{2}/\d{2}/\d{4})',
      fullText,
    );

    // Número de registro (5 Nº REGISTRO ou apenas REGISTRO)
    final numeroRegistro = _extractField(
      r'(?:Nº\s+REGISTRO|REGISTRO)\s+(\d{4,})',
      fullText,
    );

    // Categoria
    final categoria = _extractField(
      r'(?:CATEGORIA|CAT\.?\s*HAB\.?)\s*:? ?([A-Z]{1,2})',
      fullText,
    );

    return {
      'Nome': name,
      'Validade': validade,
      'Número Registro': numeroRegistro,
      'Categoria': categoria,
    };
  }

  static String _extractField(String pattern, String text) {
    final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
    return match?.group(1)?.trim() ?? 'Não encontrado';
  }
}
