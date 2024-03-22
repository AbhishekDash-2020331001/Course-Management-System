<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Students</title>
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
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
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

    </style>
</head>
<body>

<div class="container">
    <h1>Students Enrolled</h1>

    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Registration No.</th>
            </tr>
        </thead>
        <tbody>
            <% 
                String courseCode = request.getParameter("courseCode");
                if (courseCode != null) {
                    Connection connection = null;
                    PreparedStatement statement = null;
                    ResultSet resultSet = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

                        String query = "SELECT student_username FROM student_courses WHERE course_code = ?";
                        statement = connection.prepareStatement(query);
                        statement.setString(1, courseCode);
                        resultSet = statement.executeQuery();

                        while (resultSet.next()) {
                            String studentUsername = resultSet.getString("student_username");

                            // Fetch student name using the username
                            String studentName = "";
                            PreparedStatement nameStatement = null;
                            ResultSet nameResultSet = null;

                            try {
                                String nameQuery = "SELECT name FROM student WHERE username = ?";
                                nameStatement = connection.prepareStatement(nameQuery);
                                nameStatement.setString(1, studentUsername);
                                nameResultSet = nameStatement.executeQuery();

                                if (nameResultSet.next()) {
                                    studentName = nameResultSet.getString("name");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (nameResultSet != null) nameResultSet.close();
                                if (nameStatement != null) nameStatement.close();
                            }

                            out.println("<tr>");
                            out.println("<td>" + studentName + "</td>");
                            out.println("<td>" + studentUsername + "</td>");
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
                } else {
                    out.println("<tr><td colspan=\"2\">No students enrolled</td></tr>");
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>
