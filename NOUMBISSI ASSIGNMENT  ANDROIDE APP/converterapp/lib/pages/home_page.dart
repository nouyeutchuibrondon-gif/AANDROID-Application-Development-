import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'scale_page.dart';
import '../services/file_service.dart';
import '../models/student.dart';

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
  List<Student>? _previewData;

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
          _selectedFileBytes = result.files.single.bytes;
          _selectedFile = null;
          debugPrint("DEBUG: File selected (web) -> $_selectedFileName");
        } else {
          final path = result.files.single.path;
          if (path != null) {
            _selectedFile = File(path);
            _selectedFileBytes = null;
            debugPrint("DEBUG: File selected -> ${_selectedFile!.path}");
          }
        }

        // Load preview data
        await _loadPreviewData();

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

  Future<void> _loadPreviewData() async {
    try {
      if (_selectedFileBytes != null) {
        _previewData = await FileService.readFileFromBytes(_selectedFileBytes!, _selectedFileName ?? "file");
      } else if (_selectedFile != null) {
        _previewData = await FileService.readFile(_selectedFile!);
      }
    } catch (e) {
      debugPrint("ERROR: Failed to load preview -> $e");
      _previewData = [];
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
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null && _selectedFileBytes == null) {
      return const SizedBox();
    }

    final fileName = _selectedFileName ?? "Unknown";
    final fileSize = _selectedFile != null
        ? (_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)
        : (_selectedFileBytes!.length / 1024).toStringAsFixed(2);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.file_present, color: Color(0xFF6366F1), size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("$fileSize KB", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                  onPressed: () {
                    setState(() {
                      _selectedFile = null;
                      _selectedFileBytes = null;
                      _selectedFileName = null;
                      _previewData = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_previewData != null && _previewData!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Text("Preview (${_previewData!.length} students)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: (_previewData!.length > 5 ? 5 : _previewData!.length),
                      itemBuilder: (context, index) {
                        final student = _previewData![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(student.name, style: const TextStyle(fontSize: 12)),
                              Text("CA: ${student.ca.toStringAsFixed(1)} | Exam: ${student.exam.toStringAsFixed(1)}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (_previewData!.length > 5) Text("... and ${_previewData!.length - 5} more", style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Grade Converter"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.school, size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      "Convert Your Grades",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Upload student marks in CSV or XLSX format",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Upload Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFile,
                  icon: _isLoading ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ) : const Icon(Icons.upload_file),
                  label: Text(_isLoading ? "Loading..." : "Upload File"),
                ),
              ),

              const SizedBox(height: 16),

              /// Supported Formats
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9D5FF)),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF7C3AED), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        "Format: CSV or XLSX with columns: Name, CA Score, Exam Score",
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B21A8)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// File Preview
              _buildFilePreview(),

              const SizedBox(height: 24),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedFile != null || _selectedFileBytes != null ? _goToScalePage : null,
                  child: const Text("Continue to Grade Scale"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
