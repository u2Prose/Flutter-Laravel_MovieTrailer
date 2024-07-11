// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Map<String, dynamic>> movies = [];
  List<Map<String, dynamic>> filteredMovies = [];
  final TextEditingController _searchController = TextEditingController();
  int movieCounter = 1; // Counter for numbering movies

  @override
  void initState() {
    super.initState();
    _filterMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to show a dialog message
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  // Function to show a warning dialog
  void _showWarningDialog(String message, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Function to add a new movie
  void addMovie(Map<String, dynamic> movie) async {
    _showWarningDialog('Are you sure you want to add this movie?', () async {
      // Append numbering to title and genre
      movie['title'] = '${movieCounter}. ${movie['title']}';
      movie['created_at'] = DateTime.now().toIso8601String();
      movieCounter++; // Increment the counter

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/movies'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie),
      );

      if (response.statusCode == 201) {
        setState(() {
          movies.add(json.decode(response.body));
          _filterMovies();
        });
        _showMessage('Movie added successfully');
      } else {
        _showMessage('Failed to add movie');
      }
    });
  }

  // Function to update an existing movie
  void updateMovie(int id, Map<String, dynamic> updatedMovie) async {
    _showWarningDialog('Are you sure you want to update this movie?', () async {
      updatedMovie['updated_at'] = DateTime.now().toIso8601String();
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/movies/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedMovie),
      );

      if (response.statusCode == 200) {
        setState(() {
          int index = movies.indexWhere((movie) => movie['id'] == id);
          if (index != -1) {
            movies[index] = updatedMovie;
            _filterMovies();
          }
        });
        _showMessage('Movie updated successfully');
      } else {
        _showMessage('Failed to update movie');
      }
    });
  }

  // Function to delete a movie
  void deleteMovie(int id) async {
    _showWarningDialog('Are you sure you want to delete this movie?', () async {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/movies/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          movies.removeWhere((movie) => movie['id'] == id);
          _filterMovies();
        });
        _showMessage('Movie deleted successfully');
      } else {
        _showMessage('Failed to delete movie');
      }
    });
  }

  // Function to like a movie
  void likeMovie(int id) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/movies/$id/like'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'like_date': DateTime.now().toIso8601String()}),
    );

    if (response.statusCode == 200) {
      setState(() {
        int index = movies.indexWhere((movie) => movie['id'] == id);
        if (index != -1) {
          movies[index]['like'] = (movies[index]['like'] ?? 0) + 1;
          _filterMovies();
        }
      });
    }
  }

  // Function to comment on a movie
  void commentMovie(int id, String comment) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/movies/$id/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'comment': comment,
        'comment_date': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        int index = movies.indexWhere((movie) => movie['id'] == id);
        if (index != -1) {
          movies[index]['comment'] = comment;
          _filterMovies();
        }
      });
    }
  }

  // Function to share a movie
  void shareMovie(int id) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/movies/$id/share'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'share_date': DateTime.now().toIso8601String()}),
    );

    if (response.statusCode == 200) {
      setState(() {
        int index = movies.indexWhere((movie) => movie['id'] == id);
        if (index != -1) {
          movies[index]['share'] = (movies[index]['share'] ?? 0) + 1;
          _filterMovies();
        }
      });
    }
  }

  // Function to react to a movie
  void reactionMovie(int id) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/movies/$id/reaction'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'reaction_date': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        int index = movies.indexWhere((movie) => movie['id'] == id);
        if (index != -1) {
          movies[index]['reaction'] = (movies[index]['reaction'] ?? 0) + 1;
          _filterMovies();
        }
      });
    }
  }

  // Function to show the dialog for adding a new movie
  void _showAddMovieDialog() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _genreController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newMovie = {
                  'title': _titleController.text,
                  'genre': _genreController.text,
                };
                Navigator.of(context).pop();
                addMovie(newMovie);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to show the dialog for editing an existing movie
  void _showEditMovieDialog(Map<String, dynamic> movie) {
    final TextEditingController _titleController =
        TextEditingController(text: movie['title']);
    final TextEditingController _genreController =
        TextEditingController(text: movie['genre']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedMovie = {
                  'id': movie['id'],
                  'title': _titleController.text,
                  'genre': _genreController.text,
                };
                Navigator.of(context).pop();
                updateMovie(movie['id'], updatedMovie);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Function to show the dialog for commenting on a movie
  void _showCommentDialog(int movieId) {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final comment = _commentController.text;
                Navigator.of(context).pop();
                commentMovie(movieId, comment);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to filter movies based on search query
  void _filterMovies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMovies = movies.where((movie) {
        final title = movie['title'].toLowerCase();
        final genre = movie['genre'].toLowerCase();
        return title.contains(query) || genre.contains(query);
      }).toList();
    });
  }

  // Function to create rows for the DataTable
  List<DataRow> _createRows() {
    return filteredMovies.map<DataRow>((movie) {
      return DataRow(cells: [
        DataCell(Text(movie['title'])),
        DataCell(Text(movie['genre'])),
        DataCell(Text(movie['comment'] ?? '')),
        DataCell(Text(movie['like']?.toString() ?? '0')),
        DataCell(Text(movie['reaction']?.toString() ?? '0')),
        DataCell(Text(movie['share']?.toString() ?? '0')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () => _showCommentDialog(movie['id']),
              ),
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () => likeMovie(movie['id']),
              ),
              IconButton(
                icon: Icon(Icons.face),
                onPressed: () => reactionMovie(movie['id']),
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => shareMovie(movie['id']),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showEditMovieDialog(movie),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteMovie(movie['id']),
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  // Function to get the list of movie titles for the autocomplete
  List<String> _getMovieTitles() {
    return movies.map((movie) => movie['title'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Trailer Movies'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/image10.jpeg"), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _getMovieTitles().where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _searchController.text = selection;
                          _filterMovies();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration:
                                InputDecoration(labelText: 'Search Movies'),
                            onChanged: (value) {
                              _searchController.text = value;
                              _filterMovies();
                            },
                            onSubmitted: (value) {
                              _filterMovies();
                              onFieldSubmitted();
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed:
                          _filterMovies, // Trigger search on button press
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Genre')),
                      DataColumn(label: Text('Comment')),
                      DataColumn(label: Text('Like')),
                      DataColumn(label: Text('Reaction')),
                      DataColumn(label: Text('Share')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _createRows(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMovieDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
