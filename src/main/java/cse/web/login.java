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
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class login
 */
@WebServlet("/login")
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public login() {
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
	    String username = request.getParameter("username");
	    String password = request.getParameter("password");
	    String role = request.getParameter("role"); 
	    Connection connection = null;
	    PreparedStatement statement = null;
	    ResultSet resultSet = null;
	    
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/university", "root", "");
            
	        String query = "SELECT * FROM " + role + " WHERE username = ? AND password = ?";
	        statement = connection.prepareStatement(query);
	        statement.setString(1, username);
	        statement.setString(2, password);
	        System.out.print(statement);
	        System.out.print(role);
	        resultSet = statement.executeQuery();
	        if (resultSet.next()) {
	            
	            HttpSession session = request.getSession();
	            session.setAttribute("username", username);
	            session.setAttribute("role", role); 
	            System.out.print("roleeee"+role);
	            if(role.equals("admin")) {
	            	response.sendRedirect("admin.jsp"); 
	            }
	            else if(role.equals("student")) {
	            	System.out.print("hello");
	            	response.sendRedirect("student.jsp"); 
	            }
	            else {
	            	response.sendRedirect("teacher.jsp");
	            }
	            
	        } else {
	          
	        	
	        	response.sendRedirect("index.jsp");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (resultSet != null) {
	                resultSet.close();
	            }
	            if (statement != null) {
	                statement.close();
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
