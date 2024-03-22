package cse.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RegisterCourseServlet
 */
@WebServlet("/RegisterCourseServlet")
public class RegisterCourseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterCourseServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String courseCode = request.getParameter("courseCode");

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

            
            String query = "SELECT course_name, department FROM courses WHERE course_code = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, courseCode);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String courseName = resultSet.getString("course_name");
                String department = resultSet.getString("department");

                String insertQuery = "INSERT INTO student_courses (student_username, course_code, course_name, department) VALUES (?, ?, ?, ?)";
                statement = connection.prepareStatement(insertQuery);
                statement.setString(1, username);
                statement.setString(2, courseCode);
                statement.setString(3, courseName);
                statement.setString(4, department);
                statement.executeUpdate();
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

        
        response.sendRedirect("student.jsp");
    }
}
