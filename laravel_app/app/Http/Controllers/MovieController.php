<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Movie;

class MovieController extends Controller
{
    // Fetch all movies
    public function index()
    {
        return Movie::all();
    }

    // Add a new movie
    public function store(Request $request)
    {
        $movie = Movie::create([
            'title' => $request->input('title'),
            'genre' => $request->input('genre'),
            'comment' => '',
            'like' => 0,
            'reaction' => 0,
            'share' => 0,
            'created_at' => now(),
        ]);

        return response()->json($movie, 201);
    }

    // Update an existing movie
    public function update($id, Request $request)
    {
        $movie = Movie::findOrFail($id);
        $movie->title = $request->input('title');
        $movie->genre = $request->input('genre');
        $movie->updated_at = now();
        $movie->save();

        return response()->json($movie, 200);
    }

    // Delete a movie
    public function destroy($id)
    {
        $movie = Movie::findOrFail($id);
        $movie->delete();

        return response()->json(null, 200);
    }

    // Like a movie
    public function like($id, Request $request)
    {
        $movie = Movie::findOrFail($id);
        $movie->like += 1;
        $movie->like_date = $request->input('like_date');
        $movie->save();

        return response()->json($movie, 200);
    }

    // Comment on a movie
    public function comment($id, Request $request)
    {
        $movie = Movie::findOrFail($id);
        $movie->comment = $request->input('comment');
        $movie->comment_date = $request->input('comment_date');
        $movie->save();

        return response()->json($movie, 200);
    }

    // Share a movie
    public function share($id, Request $request)
    {
        $movie = Movie::findOrFail($id);
        $movie->share += 1;
        $movie->share_date = $request->input('share_date');
        $movie->save();

        return response()->json($movie, 200);
    }

    // React to a movie
    public function reaction($id, Request $request)
    {
        $movie = Movie::findOrFail($id);
        $movie->reaction += 1;
        $movie->reaction_date = $request->input('reaction_date');
        $movie->save();

        return response()->json($movie, 200);
    }
// search to a movie
public function search(Request $request)
{
    $query = $request->input('query');

    // Perform the search query
    $movies = Movie::where('title', 'comment', 'like', 'reaction', 'share', "%$query%")
                    ->orWhere('genre', 'comment', 'like', 'reaction', 'share', "%$query%")
                    ->get();

    return response()->json($movies);
}
}