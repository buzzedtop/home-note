import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Note',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed( seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Note {
  String id;
  String content;

  Note({required this.id, required this.content});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        content: json['content'] as String,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  List<Note> _notes = [];
  final ScrollController _scrollController = ScrollController();
  
  // Google Sign-In and Drive
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
    ],
  );
  GoogleSignInAccount? _currentUser;
  bool _isLoadingDrive = false;
  static const String _driveFileName = 'home_note_data.json';

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (account != null) {
        _loadNotesFromDrive();
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('notes');
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonData = json.decode(jsonString);
        setState(() {
          _notes = jsonData.map((item) => Note.fromJson(item)).toList();
        });
      }
    } catch (e) {
      // If encountering an error, return empty list
      setState(() {
        _notes = [];
      });
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = _notes.map((note) => note.toJson()).toList();
      final jsonString = json.encode(jsonData);
      await prefs.setString('notes', jsonString);
      
      // Also save to Google Drive if signed in
      if (_currentUser != null) {
        _saveNotesToDrive();
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving notes: $e')),
        );
      }
    }
  }

  Future<void> _saveNotesToDrive() async {
    if (_currentUser == null) return;
    
    try {
      setState(() {
        _isLoadingDrive = true;
      });

      final httpClient = (await _googleSignIn.authenticatedClient())!;
      final driveApi = drive.DriveApi(httpClient);

      final jsonData = _notes.map((note) => note.toJson()).toList();
      final jsonString = json.encode(jsonData);
      
      // Search for existing file
      final fileList = await driveApi.files.list(
        q: "name='$_driveFileName' and trashed=false",
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      final fileContent = jsonString.codeUnits;
      final media = drive.Media(
        Stream.value(fileContent),
        fileContent.length,
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // Update existing file
        final fileId = fileList.files!.first.id!;
        await driveApi.files.update(
          drive.File(),
          fileId,
          uploadMedia: media,
        );
      } else {
        // Create new file
        final driveFile = drive.File()
          ..name = _driveFileName
          ..mimeType = 'application/json';
        
        await driveApi.files.create(
          driveFile,
          uploadMedia: media,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes saved to Google Drive')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving to Drive: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingDrive = false;
      });
    }
  }

  Future<void> _loadNotesFromDrive() async {
    if (_currentUser == null) return;
    
    try {
      setState(() {
        _isLoadingDrive = true;
      });

      final httpClient = (await _googleSignIn.authenticatedClient())!;
      final driveApi = drive.DriveApi(httpClient);

      // Search for the file
      final fileList = await driveApi.files.list(
        q: "name='$_driveFileName' and trashed=false",
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final fileId = fileList.files!.first.id!;
        
        // Download file content
        final response = await driveApi.files.get(
          fileId,
          downloadOptions: drive.DownloadOptions.fullMedia,
        ) as drive.Media;

        final dataBytes = <int>[];
        await for (var chunk in response.stream) {
          dataBytes.addAll(chunk);
        }
        
        final jsonString = utf8.decode(dataBytes);
        final List<dynamic> jsonData = json.decode(jsonString);
        
        setState(() {
          _notes = jsonData.map((item) => Note.fromJson(item)).toList();
        });
        
        // Also save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('notes', jsonString);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notes loaded from Google Drive')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading from Drive: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingDrive = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: $error')),
        );
      }
    }
  }

  Future<void> _handleGoogleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
    });
  }

  void _addNote() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _notes.add(Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _textController.text.trim(),
        ));
        _textController.clear();
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  void _moveNoteUp(int index) {
    if (index > 0) {
      setState(() {
        final note = _notes.removeAt(index);
        _notes.insert(index - 1, note);
      });
      _saveNotes();
    }
  }

  void _moveNoteDown(int index) {
    if (index < _notes.length - 1) {
      setState(() {
        final note = _notes.removeAt(index);
        _notes.insert(index + 1, note);
      });
      _saveNotes();
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final note = _notes.removeAt(oldIndex);
      _notes.insert(newIndex, note);
    });
    _saveNotes();
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleGoogleSignIn();
                },
                icon: const Icon(Bootstrap.google),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Microsoft login functionality placeholder
                },
                icon: const Icon(Bootstrap.microsoft),
                label: const Text('Continue with Microsoft'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Apple login functionality placeholder
                },
                icon: const Icon(Bootstrap.apple),
                label: const Text('Continue with Apple'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (_isLoadingDrive)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          if (_currentUser != null) ...[
            IconButton(
              onPressed: _loadNotesFromDrive,
              icon: const Icon(Icons.cloud_download, color: Colors.white),
              tooltip: 'Load from Google Drive',
            ),
            IconButton(
              onPressed: _saveNotesToDrive,
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              tooltip: 'Save to Google Drive',
            ),
            TextButton.icon(
              onPressed: _handleGoogleSignOut,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                _currentUser!.displayName ?? _currentUser!.email,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ] else
            TextButton.icon(
              onPressed: _showLoginDialog,
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Enter a note',
                      border: OutlineInputBorder(),
                      hintText: 'Type your note here...',
                    ),
                    maxLines: 3,
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addNote,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text(
                      'No notes yet. Add one above!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ReorderableListView.builder(
                    scrollController: _scrollController,
                    itemCount: _notes.length,
                    onReorder: _onReorder,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return Card(
                        key: Key(note.id),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(note.content),
                          leading: const Icon(Icons.drag_handle),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Bootstrap.arrow_up_circle_fill), 
                                onPressed: index > 0
                                    ? () => _moveNoteUp(index)
                                    : null,
                                tooltip: 'Move up',
                              ),
                              IconButton(
                                icon: const Icon(Bootstrap.arrow_down_circle_fill),
                                onPressed: index < _notes.length - 1
                                    ? () => _moveNoteDown(index)
                                    : null,
                                tooltip: 'Move down',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteNote(index),
                                color: Colors.red,
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
