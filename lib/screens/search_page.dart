import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:trendveiw/model/movie_model.dart';
import 'package:trendveiw/screens/movie_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>> searchedMovies= ApiCall().getSearchedMovies("");
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
       
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      searchedMovies = ApiCall().getSearchedMovies(query);
    });

    
      

      /* if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage))
          else */
            
    

/* }catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    } */
  }
  

      

      /* if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['results'];
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load movies: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  } */




  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB Movie Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Movies',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMovies(_searchController.text),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _searchMovies(value),
            ),
          ),

          Expanded(
              child: FutureBuilder(
                future: Future.wait([searchedMovies,]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieScreen(snapshot: snapshot, heading: "Search", futureindex: 0,);
                  } else {
                    return Text('Error ${snapshot.error}');
                  }
                },
              ),
            )
        ],
      ),
    );
  }
}
