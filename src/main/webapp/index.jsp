<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>



<meta charset="UTF-8">
<title>University Course Management System - Login</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .container {
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.2);
        overflow: hidden;
        width: 400px;
        max-width: 90%;
    }

    .header {
        background-color: #666;
        color: #fff;
        padding: 20px;
        text-align: center;
    }

    .form-container {
        padding: 20px;
    }

    h2 {
        margin-bottom: 20px;
        color: #FFFFFF;
    }

    label {
        display: block;
        margin-bottom: 5px;
        color: #666;
    }

    select, input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 3px;
        box-sizing: border-box;
    }

    select {
        cursor: pointer;
    }

    input[type="submit"] {
        width: 100%;
        background-color: #4CAF50;
        color: white;
        padding: 14px 20px;
        margin: 8px 0;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    .footer {
        background-color: #f0f0f0;
        padding: 10px 20px;
        text-align: center;
        font-size: 12px;
    }
</style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>University Course Management System</h2>
    </div>
    <div class="form-container">
        <form action="login" method="post">
            <label for="role">Select Role:</label>
            <select id="role" name="role">
                <option value="admin">Admin</option>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
            </select>
            
            <label for="username">Username:</label>
            <input type="text" id="username" name="username">
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password">
            
            <input type="submit" value="Login">
            
        </form>
    </div>
    <div class="footer">
        &copy; 2024 University Course Management System
    </div>
</div>


</body>
</html>