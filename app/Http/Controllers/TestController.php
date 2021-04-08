<?php

namespace App\Http\Controllers;

use App\Models\User;

class TestController extends Controller
{
    public function __construct()
    {
        $this->authorizeResource(User::class, 'plan');
    }

    public function index()
    {
        return [123];
    }
}
