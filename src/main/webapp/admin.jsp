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

        String query = "SELECT username FROM admin WHERE username = ?";
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
    <title>University Course Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column; /* Align items in a column */
            min-height: 100vh;
        }

        .header {
/*             background-color: #007bff; */
/*             color: #fff; */
            text-align: center;
            padding: 10px 0;
            font-size: 24px;
            font-weight: bold;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            flex-grow: 1; /* Expand to fill remaining space */
        }

        .form-container,
        .table-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 50%;
            margin: 0 20px;
            padding: 40px;
            box-sizing: border-box;
            text-align: center;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        input[type="text"],
        select {
            width: calc(100% - 16px);
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .header {
            position: relative;
            text-align: center; /* Center align the content */
            margin-bottom: 20px; /* Add some bottom margin */
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
.logout-button:hover {
    background-color: #0056b3; 
    color: #fff; 
}

        input[type="submit"] {
            width: 100%;
            background-color: #4CAF50;
            color: white;
            padding: 14px 20px;
            margin-top: 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .form-group {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Admin Dashboard</h1>
    <form action="LogoutServlet" method="post"> <!-- Assuming LogoutServlet handles the logout functionality -->
            <button type="submit" class="logout-button">Logout</button>
        </form>
</div>
<div class="container">
    <div class="form-container">
        <h2>Add Course and Assign Teacher</h2>
        <form action="AddCourseServlet" method="post">
            <div class="form-group">
                <label for="course_code">Course Code:</label>
                <input type="text" id="course_code" name="course_code" required>
            </div>

            <div class="form-group">
                <label for="course_name">Course Name:</label>
                <input type="text" id="course_name" name="course_name" required>
            </div>

            <div class="form-group">
                <label for="department">Department:</label>
                <select id="department" name="department" required>
                    <option value="">Select Department</option>
                    <option value="IT">Information Technology</option>
                    <option value="CS">Computer Science</option>
                    <option value="EE">Electrical Engineering</option>

                </select>
            </div>

            <div class="form-group">
                <label for="teacher">Select Teacher:</label>
                <select id="teacher" name="teacher" required>
                    <option value="">Select Teacher</option>
                    
                    <%
                        connection = null;
                        statement = null;
                        resultSet = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

                            String query = "SELECT username FROM teacher";
                            statement = connection.prepareStatement(query);
                            resultSet = statement.executeQuery();

                            while (resultSet.next()) {
                                String teacherUsername = resultSet.getString("username");
                                out.println("<option value='" + teacherUsername + "'>" + teacherUsername + "</option>");
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
                </select>
            </div>

            <input type="submit" value="Add Course">
        </form>
    </div>

    <div class="table-container">
        <h2>Existing Courses</h2>
        <table>
            <thead>
            <tr>
                <th>Course Code</th>
                <th>Course Name</th>
                <th>Department</th>
                <th>Teacher</th>
            </tr>
            </thead>
            <tbody>
            

            <%
                connection = null;
                statement = null;
                resultSet = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

                    String query = "SELECT course_code, course_name, department, course_teacher_username FROM courses";
                    statement = connection.prepareStatement(query);
                    System.out.println(statement);
                    resultSet = statement.executeQuery();

                    while (resultSet.next()) {
                        String courseCode = resultSet.getString("course_code");
                        String courseName = resultSet.getString("course_name");
                        String department = resultSet.getString("department");
                        String teacher = resultSet.getString("course_teacher_username");

                        out.println("<tr>");
                        out.println("<td>" + courseCode + "</td>");
                        out.println("<td>" + courseName + "</td>");
                        out.println("<td>" + department + "</td>");
                        out.println("<td>" + teacher + "</td>");
                        out.println("</tr>");
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
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
                
