import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OrderTrackingTextScanner {
  OrderTrackingTextScanner({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<String?> scanFromCamera() async {
    final image = await _pickImage(ImageSource.camera);
    return _scanImage(image);
  }

  Future<XFile?> _pickImage(ImageSource source) {
    return _imagePicker.pickImage(source: source, imageQuality: 90);
  }

  Future<String?> _scanImage(XFile? image) async {
    if (image == null) {
      return null;
    }

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await recognizer.processImage(inputImage);
      final text = recognizedText.text.trim();
      return text.isEmpty ? null : text;
    } finally {
      await recognizer.close();
    }
  }
}
