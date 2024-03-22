<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String username = (String) session.getAttribute("username");
    boolean usernameExists = false;
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        String query = "SELECT username FROM student WHERE username = ?";
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
    <title>Student Dashboard</title>
    <style>
        /* Your CSS styles here */
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
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

.student-info-table {
    width: 100%;
    border-collapse: collapse;
}

.student-info-table th,
.student-info-table td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
    text-align: left;
}

.student-info-table th {
    width: 200px;
    font-weight: bold;
}

.student-info-table td {
    font-style: italic;
}

.header {
            position: relative; 
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

.buttons-container button {
    margin: 0 10px;
    padding: 10px 20px;
    font-size: 16px;
    background-color: #4CAF50; 
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.buttons-container button:hover {
    background-color: #45a049; 
}

.buttons-container button.selected {
    background-color: #007bff; 
}

.buttons-container button.selected:hover {
    background-color: #0056b3; 
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

        .register-button {
            background-color: #4CAF50;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .register-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<%
    
    username = (String) session.getAttribute("username");
    String studentName = "";
    connection = null;
    statement = null;
    resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        String query = "SELECT name FROM student WHERE username = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, username);
        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            studentName = resultSet.getString("name");
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
        <h1>Student Dashboard</h1>
        <form action="LogoutServlet" method="post"> <!-- Assuming LogoutServlet handles the logout functionality -->
            <button type="submit" class="logout-button">Logout</button>
        </form>
    </div>
    <div class="info-container">
    
    <table class="student-info-table">
        <tr>
            <th>Registration Number</th>
            <td><%= session.getAttribute("username") %></td>
        </tr>
        <tr>
            <th>Name</th>
            <td><%= studentName %></td>
        </tr>
    </table>
</div>


    <div class="buttons-container">
    <button id="registeredCoursesBtn" class="selected" onclick="toggleTable('registeredCourses')">Registered Courses</button>
    <button id="allCoursesBtn" onclick="toggleTable('allCourses')">Other Courses</button>
    </div>

    
    <%
        boolean hasRegisteredCourses = false;
        connection = null;
        statement = null;
        resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

            String query = "SELECT COUNT(*) AS numCourses FROM student_courses WHERE student_username = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, username);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int numCourses = resultSet.getInt("numCourses");
                if (numCourses > 0) {
                    hasRegisteredCourses = true;
                }
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
    <div class="table-container" id="registeredCoursesTable">
        <% if (hasRegisteredCourses) { %>
            <h2>Registered Courses</h2>
            <table>
                <thead>
                    <tr>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Department</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <%
                    
                    String registeredCourses = ""; 
                    connection = null;
                    statement = null;
                    resultSet = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");
                        String query = "SELECT course_code, course_name, department FROM student_courses WHERE student_username = ?";
                        statement = connection.prepareStatement(query);
                        statement.setString(1, username);
                        resultSet = statement.executeQuery();

                        
                        while (resultSet.next()) {
                            String courseCode = resultSet.getString("course_code");
                            String courseName = resultSet.getString("course_name");
                            String department = resultSet.getString("department");

                            registeredCourses += "<tr>";
                            registeredCourses += "<td>" + courseCode + "</td>";
                            registeredCourses += "<td>" + courseName + "</td>";
                            registeredCourses += "<td>" + department + "</td>";
                            registeredCourses += "</tr>";
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

                    
                    out.println(registeredCourses);
                %>
                </tbody>
            </table>
        <% } else { %>
            <h2>No courses registered.</h2>
        <% } %>
    </div>

    <!-- Table container for All Courses -->
    <div class="table-container" id="allCoursesTable" style="display: none;">
        <h2>Unregistered Courses</h2>
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
    
    String unregisteredCourses = ""; 
    connection = null;
    statement = null;
    resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

        
        String query = "SELECT course_code, course_name, department FROM courses " +
                       "WHERE course_code NOT IN (SELECT course_code FROM student_courses WHERE student_username = ?)";
        statement = connection.prepareStatement(query);
        statement.setString(1, username);
        resultSet = statement.executeQuery();

        
        while (resultSet.next()) {
            String courseCode = resultSet.getString("course_code");
            String courseName = resultSet.getString("course_name");
            String department = resultSet.getString("department");

            unregisteredCourses += "<tr>";
            unregisteredCourses += "<td>" + courseCode + "</td>";
            unregisteredCourses += "<td>" + courseName + "</td>";
            unregisteredCourses += "<td>" + department + "</td>";
            unregisteredCourses += "<td><form action=\"RegisterCourseServlet\" method=\"post\">";
            unregisteredCourses += "<input type=\"hidden\" name=\"username\" value=\"" + session.getAttribute("username") + "\">";
            unregisteredCourses += "<input type=\"hidden\" name=\"courseCode\" value=\"" + courseCode + "\">";
            unregisteredCourses += "<button class=\"register-button\" type=\"submit\">Register</button>";
            unregisteredCourses += "</form></td>";
            unregisteredCourses += "</tr>";
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

    
    out.println(unregisteredCourses);
%>

            </tbody>
        </table>
    </div>
</div>

<script>
    function toggleTable(tableId) {
        if (tableId === 'registeredCourses') {
            document.getElementById('registeredCoursesTable').style.display = 'block';
            document.getElementById('allCoursesTable').style.display = 'none';
            document.getElementById('registeredCoursesBtn').classList.add('selected');
            document.getElementById('allCoursesBtn').classList.remove('selected');
        } else if (tableId === 'allCourses') {
            document.getElementById('registeredCoursesTable').style.display = 'none';
            document.getElementById('allCoursesTable').style.display = 'block';
            document.getElementById('registeredCoursesBtn').classList.remove('selected');
            document.getElementById('allCoursesBtn').classList.add('selected');
        }
    }
</script>

</body>
</html>
                            