<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMoviesTable extends Migration
{
    public function up()
    {
        Schema::create('movies', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('genre');
            $table->string('like')->default(0);
            $table->string('comment')->nullable();
            $table->string('reaction')->default(0);
            $table->string('share')->default(0);
            $table->timestamp('like_date')->nullable();
            $table->timestamp('comment_date')->nullable();
            $table->timestamp('share_date')->nullable();
            $table->timestamp('reaction_date')->nullable();
            $table->timestamps();
        });
    }
    public function down()
    {
    
            Schema::table('movies', function (Blueprint $table) {
                $table->dropColumn('like');
                $table->dropColumn('comment');
                $table->dropColumn('reaction');
                $table->dropColumn('share');
                $table->dropColumn('like_date');
                $table->dropColumn('comment_date');
                $table->dropColumn('share_date');
                $table->dropColumn('reaction_date');
            });
        }
    }

