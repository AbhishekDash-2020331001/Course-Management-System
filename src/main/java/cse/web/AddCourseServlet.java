package cse.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddCourseServlet
 */
@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddCourseServlet() {
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
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      
        String courseCode = request.getParameter("course_code");
        String courseName = request.getParameter("course_name");
        String department = request.getParameter("department");
        String teacherUsername = request.getParameter("teacher");

        
        Connection connection = null;
        PreparedStatement courseStatement = null;
        PreparedStatement courseTeacherStatement = null;

        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");

            
            String courseQuery = "INSERT INTO courses (course_code, course_name, department, course_teacher_username) VALUES (?, ?, ?, ?)";
            courseStatement = connection.prepareStatement(courseQuery);
            courseStatement.setString(1, courseCode);
            courseStatement.setString(2, courseName);
            courseStatement.setString(3, department);
            courseStatement.setString(4, teacherUsername);
            courseStatement.executeUpdate();

            
            String courseTeacherQuery = "INSERT INTO teacher_courses (course_code, course_name, department, teacher_username) VALUES (?, ?, ?, ?)";
            courseTeacherStatement = connection.prepareStatement(courseTeacherQuery);
            courseTeacherStatement.setString(1, courseCode);
            courseTeacherStatement.setString(2, courseName);
            courseTeacherStatement.setString(3, department);
            courseTeacherStatement.setString(4, teacherUsername);
            courseTeacherStatement.executeUpdate();

            
            response.sendRedirect("admin.jsp");
        } catch (ClassNotFoundException | SQLException e) {
            
            e.printStackTrace();
            
        } finally {
            // Close database resources
            try {
                if (courseStatement != null) {
                    courseStatement.close();
                }
                if (courseTeacherStatement != null) {
                    courseTeacherStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
