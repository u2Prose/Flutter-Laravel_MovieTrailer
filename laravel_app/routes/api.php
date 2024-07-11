<?php

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MovieController;
use App\Http\Controllers\VideoController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/movies/search', 'MovieController@search');

Route::apiResource('movies', MovieController::class);
Route::post('/movies/{id}/like', [MovieController::class, 'like']);
Route::post('/movies/{id}/comment', [MovieController::class, 'comment']);
Route::post('/movies/{id}/reaction', [MovieController::class, 'reaction']);
Route::post('/movies/{id}/share', [MovieController::class, 'share']);
Route::get('/movies/{query}/search', [MovieController::class, 'search']);

Route::get('/videos/{filename}', [VideoController::class, 'getVideos']);
Route::get('/video/{filename}', [VideoController::class, 'getVideo']);


Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
