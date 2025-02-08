import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../Components/text_field.dart';
import '../Components/custom_action_button.dart';
import 'package:flutter/foundation.dart';
import '../Services/auth_service.dart';


class EditUserPage extends StatefulWidget {
  final String? initialFullName;
  final String? initialEmail;
  final String? initialProfileImageUrl;
  const EditUserPage({
    Key? key,
    this.initialFullName,
    this.initialEmail,
    this.initialProfileImageUrl,
  }) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  File? _image;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  final NetworkService _networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFullName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _webImage = result.files.first.bytes;
          _image = null; 
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  Future<void> _updateUserInfo() async {
    String? fullName = _nameController.text;
    String? email = _emailController.text;

    final response = await _networkService.updateUser(
      fullName: fullName,
      email: email,
      photo: kIsWeb ? _webImage : _image,
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['error']}')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    var content = Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Update user info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF192252),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: (_image == null && _webImage == null && widget.initialProfileImageUrl == null)
                            ? Colors.grey[300]
                            : null,
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : _webImage != null
                                ? DecorationImage(
                                    image: MemoryImage(_webImage!),
                                    fit: BoxFit.cover,
                                  )
                                : widget.initialProfileImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(widget.initialProfileImageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                      ),
                      child: (_image == null && _webImage == null)
                          ? Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white.withOpacity(0.7),
                                size: 50,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full name',
                    initialText:  widget.initialFullName ?? 'Enter your name',
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email address',
                    initialText:  widget.initialEmail ?? 'Enter your email',
                  ),
                  isMobile ? 
                  const Spacer() : SizedBox(height: 220),
                  CustomActionButton(
                    label: 'Update info',
                    isPrimary: true,
                    onTap: _updateUserInfo,
                  ),
                  const SizedBox(height: 55),
                ],
              ),
            );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                icon: Image.asset('assets/images/backIcon.png'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isMobile
          ? content
          : SingleChildScrollView(
              child: content
            ),
    );
  }
}