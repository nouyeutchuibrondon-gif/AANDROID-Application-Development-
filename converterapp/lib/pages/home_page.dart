import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../pages/scale_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  bool _isLoading = false;

  /// Pick CSV or Excel file
  Future<void> _pickFile() async {
    debugPrint("DEBUG: Opening file picker...");

    try {
      setState(() => _isLoading = true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
      );

      if (result != null) {
        _selectedFileName = result.files.single.name;
        
        if (kIsWeb) {
          // Web platform: use file bytes
          _selectedFileBytes = result.files.single.bytes;
          _selectedFile = null;
          debugPrint("DEBUG: File selected (web) -> $_selectedFileName");
        } else {
          // Desktop/Mobile platform: use file path
          final path = result.files.single.path;
          if (path != null) {
            _selectedFile = File(path);
            _selectedFileBytes = null;
            debugPrint("DEBUG: File selected -> ${_selectedFile!.path}");
          }
        }

        setState(() {});
      } else {
        debugPrint("DEBUG: User canceled file selection.");
      }
    } catch (e) {
      debugPrint("ERROR: File picking failed -> $e");
      _showSnackBar("Error picking file: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToScalePage() {
    if (_selectedFile == null && _selectedFileBytes == null) {
      _showSnackBar("Please upload a file first");
      return;
    }

    debugPrint("DEBUG: Navigating to Scale Page");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScalePage(
          file: _selectedFile,
          fileBytes: _selectedFileBytes,
          fileName: _selectedFileName,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null && _selectedFileBytes == null) return const SizedBox();

    final fileName = _selectedFileName ?? "Unknown";
    final fileSize = _selectedFile != null
        ? (_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)
        : (_selectedFileBytes!.length / 1024).toStringAsFixed(2);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading:
            const Icon(Icons.insert_drive_file, size: 40, color: Colors.indigo),
        title: Text(fileName),
        subtitle: Text("Size: $fileSize KB"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            debugPrint("DEBUG: File removed");
            setState(() {
              _selectedFile = null;
              _selectedFileBytes = null;
              _selectedFileName = null;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DEBUG: HomePage rebuilt");

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text("Grade Converter"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Icon(
              Icons.school,
              size: 80,
              color: Colors.indigo,
            ),

            const SizedBox(height: 20),

            const Text(
              "Upload Student Marks File",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Supported formats: CSV, XLSX",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickFile,
                icon: const Icon(Icons.upload_file),
                label: const Text(
                  "Upload File",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Loading Indicator
            if (_isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 20),

            /// File Preview
            _buildFilePreview(),

            const Spacer(),

            /// Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _goToScalePage,
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
