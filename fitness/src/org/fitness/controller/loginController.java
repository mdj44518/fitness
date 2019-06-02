package org.fitness.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class loginController
 */
@WebServlet("/login/*")
public class loginController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] tokens = request.getRequestURI().split("/");
		String emd = tokens[tokens.length - 1];
		if (request.getParameter("out") != null) {
			request.getSession().invalidate();
			response.sendRedirect(request.getContextPath());
		} else if (emd.equals("manager")) {
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);;
		} else {
			request.setAttribute("error", "요청하신 페이지가 존재하지 않습니다.");
			request.getRequestDispatcher("/index.jsp").forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		
		if (id.equals("admin") && pw.equals("0000")) {
			HttpSession session = request.getSession();
			session.setAttribute("user", "admin");
			
			response.sendRedirect(request.getContextPath());
		} else {
			request.setAttribute("error", "관리자 정보와 일치하지 않습니다.");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}

}
