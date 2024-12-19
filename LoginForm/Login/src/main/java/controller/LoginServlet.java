package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet  extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		UserDAO dao = new UserDAO();
		User user = new User(username, password);
		
		if (dao.validateUser(user)) {
			HttpSession session = request.getSession();
			session.setAttribute("username", username);
			response.sendRedirect("pages/dashboard.jsp");
		} else {
			request.setAttribute("errorMessage", "아이디 또는 비밀번호가 잘못되었습니다.");
			RequestDispatcher dispatcher = request.getRequestDispatcher("pages/login.jsp");
			dispatcher.forward(request, response);
		}
	}
}
