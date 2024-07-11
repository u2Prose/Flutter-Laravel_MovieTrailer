<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Movie extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'genre',
        'comment',
        'like',
        'reaction',
        'share',
        'like_date',
        'comment_date',
        'share_date',
        'reaction_date',
    ];

    protected $dates = [
        'like_date',
        'comment_date',
        'share_date',
        'reaction_date',
    ];
}
