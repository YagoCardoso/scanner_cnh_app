# CNH Scanner Protótipo

Protótipo em Flutter para escanear a CNH (Carteira Nacional de Habilitação) e extrair automaticamente os principais dados utilizando OCR (reconhecimento óptico de caracteres).

## Funcionalidades

- Captura da imagem da CNH utilizando **Edge Detection**
- Extração de texto via **Google ML Kit Text Recognition**
- Análise e filtragem do texto com **expressões regulares**
- Exibição dos campos extraídos:
  - Nome
  - Categoria da habilitação
  - Data de validade
  - Número de registro

## Tecnologias utilizadas

- Flutter
- [google_mlkit_text_recognition](https://pub.dev/packages/google_mlkit_text_recognition)
- [edge_detection](https://pub.dev/packages/edge_detection)
- Regex personalizada para mapeamento dos campos

## Resultado

O protótipo demonstrou boa eficiência na extração de dados da CNH, com taxa de acerto satisfatória para as principais informações. Ajustes futuros podem melhorar a precisão e lidar com variações entre modelos antigos e novos da CNH.

## Como executar

1. Clone este repositório
2. Execute `flutter pub get`
3. Execute o app em um dispositivo físico (necessário para uso da câmera)
4. Clique em **"Escanear CNH"** e teste com uma imagem real do documento

## Observações

Este projeto tem fins educativos e demonstração de OCR em documentos. Nenhuma informação é armazenada ou compartilhada.

 ![Captura de tela 2025-04-22 180131](https://github.com/user-attachments/assets/c6f12683-2627-441e-a29f-a0c7a5c51451)




