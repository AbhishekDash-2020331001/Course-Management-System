<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    boolean usernameExists = false;
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        String query = "SELECT username FROM teacher WHERE username = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, username);
        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            usernameExists = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    if (!usernameExists) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard</title>
    <style>
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            justify-content: center;
        align-items: center;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header {
            position: relative; /* Set position to relative */
        }

        .logout-button {
    position: absolute; 
    top: 15px; 
    right: 20px; 
    background-color: #007bff; 
    border: none;
    border-radius: 4px;
    padding: 10px 20px; 
    cursor: pointer;
    font-size: 16px;
    color: #fff; 
    transition: background-color 0.3s, color 0.3s;
    font-family: Arial, sans-serif; 
}

.logout-button:hover {
    background-color: #0056b3; 
    color: #fff; 
}
        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }

        .info-container {
            margin-bottom: 20px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }

        .info-container h2 {
            color: #333;
            margin-bottom: 15px;
        }

        .teacher-info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .teacher-info-table th,
        .teacher-info-table td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        .teacher-info-table th {
            width: 200px;
            font-weight: bold;
        }

        .teacher-info-table td {
            font-style: italic;
        }

        .table-container {
            margin-bottom: 30px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .see-students-btn {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .see-students-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
    String teacherName = "";
    connection = null;
    statement = null;
    resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        String query = "SELECT name FROM teacher WHERE username = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, (String) session.getAttribute("username"));
        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            teacherName = resultSet.getString("name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<div class="container">
    <div class="header">
        <h1>Teacher Dashboard</h1>
        <form action="LogoutServlet" method="post"> 
            <button type="submit" class="logout-button">Logout</button>
        </form>
    </div>
    <div class="info-container">
        <!-- Display teacher information here -->
        <table class="teacher-info-table">
            <tr>
                <th>Name</th>
                <td><%= teacherName %></td>
            </tr>
            <tr>
                <th>Username</th>
                <td><%= session.getAttribute("username") %></td>
            </tr>
        </table>
    </div>
    <!-- Table container for Assigned Courses -->
    <div class="table-container">
        <h2>Assigned Courses</h2>
        <table>
            <thead>
            <tr>
                <th>Course Code</th>
                <th>Course Name</th>
                <th>Department</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
    String assignedCourses = ""; 
    connection = null;
    statement = null;
    resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        String query = "SELECT course_code, course_name, department FROM teacher_courses WHERE teacher_username = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, (String) session.getAttribute("username"));
        resultSet = statement.executeQuery();

        // Check if the teacher has any assigned courses
        if (!resultSet.next()) {
            assignedCourses = "<tr><td colspan=\"4\">No courses assigned</td></tr>";
        } else {
            
            do {
                String courseCode = resultSet.getString("course_code");
                String courseName = resultSet.getString("course_name");
                String department = resultSet.getString("department");

                assignedCourses += "<tr>";
                assignedCourses += "<td>" + courseCode + "</td>";
                assignedCourses += "<td>" + courseName + "</td>";
                assignedCourses += "<td>" + department + "</td>";
                assignedCourses += "<td>";
                assignedCourses += "<form action=\"view_students.jsp\" method=\"get\">";
                assignedCourses += "<input type=\"hidden\" name=\"courseCode\" value=\"" + courseCode + "\">";
                assignedCourses += "<button type=\"submit\" class=\"see-students-btn\">See Students</button>";
                assignedCourses += "</form>";
                assignedCourses += "</td>";
                assignedCourses += "</tr>";
            } while (resultSet.next());
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    out.println(assignedCourses);
%>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

