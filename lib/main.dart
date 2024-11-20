import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Publicações com Imagem e Curtidas',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/post': (context) => PostPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
      ),
      body: posts.isEmpty
          ? Center(
              child: Text(
                'Nenhuma publicação ainda.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (posts[index]['image'] != null)
                          Image.file(
                            posts[index]['image'],
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit
                                .contain,
                          ),
                        if (posts[index]['image'] != null) SizedBox(height: 8),
                        Text(
                          posts[index]['text'],
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Curtidas: ${posts[index]['likes']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              color: posts[index]['liked']
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  if (posts[index]['liked']) {
                                    posts[index]['likes']--;
                                    posts[index]['liked'] = false;
                                  } else {
                                    posts[index]['likes']++;
                                    posts[index]['liked'] = true;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/post');
          if (result != null) {
            setState(() {
              posts.add({
                ...result as Map<String, dynamic>,
                'likes': 0,
                'liked': false,
              });
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _controller = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Publicação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite sua publicação',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            if (_image != null)
              Column(
                children: [
                  Image.file(
                    _image!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text('Galeria'),
                ),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: Icon(Icons.camera),
                  label: Text('Câmera'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty || _image != null) {
                  Navigator.pop(
                    context,
                    {
                      'text': _controller.text,
                      'image': _image,
                    },
                  );
                }
              },
              child: Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
