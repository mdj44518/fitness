package org.fitness.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.fitness.dao.FitnessDAO;
import org.fitness.model.Member;

/**
 * Servlet implementation class memberController
 */
@WebServlet("/admin/*")
public class adminController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		    //관리자 전용 요청. 로그인 되어있는지 확인.
		if (request.getSession().getAttribute("user") != null) {
			String[] tokens = request.getRequestURI().split("/");
			String cme = tokens[tokens.length - 1];
			if (cme.equals("add")) {
				request.getRequestDispatcher("/WEB-INF/views/addMember.jsp").forward(request, response);
			} else if (cme.equals("memberList")) {
				goMemberListPage(request, response);
			} else {
				request.setAttribute("error", "요청하신 페이지가 존재하지 않습니다.");
				request.getRequestDispatcher("/index.jsp").forward(request, response);
			}
		} else {
			request.setAttribute("error", "관리자 권한 페이지 입니다.");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (request.getSession().getAttribute("user") != null) {
			String[] tokens = request.getRequestURI().split("/");
			String cmd = tokens[tokens.length - 1];
			if (cmd.equals("add")) {
				addMember(request, response);
			} else if (cmd.equals("memberList")) {
				updateMember(request, response);
			} else {
				request.setAttribute("error", "요청하신 페이지가 존재하지 않습니다.");
				request.getRequestDispatcher("/index.jsp").forward(request, response);
			}
		} else {
			request.setAttribute("error", "관리자 권한 페이지 입니다.");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}
	
	private void goMemberListPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FitnessDAO dao = new FitnessDAO();
		Member[] members = null;
		//요청올때 page 숫자가 함께 넘어왔다면.
		String page = request.getParameter("page");
		if (page != null) {
			int i = Integer.parseInt(page);
			members = dao.getMemberList(i);
			request.setAttribute("chPage", i);//???없어도될까?
			request.setAttribute("pCount", dao.getPageCount(i));
		} else {
			//page 페라메타 없다면 첫페이지의 정보 요청
			members = dao.getMemberList(1);
			request.setAttribute("chPage", 1);
			request.setAttribute("pCount", dao.getPageCount(1));
		}
		if (members != null ) {
			request.setAttribute("members", members);
		} else {
			request.setAttribute("error", "데이터베이스 정보 조회에 실패하였습니다.");
		}
		request.getRequestDispatcher("/WEB-INF/views/memberList.jsp").forward(request, response);
	}

	private void updateMember(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Member m = new Member();
		FitnessDAO dao = new FitnessDAO();
		m.setMemberNum(Integer.parseInt(request.getParameter("memberNum")));
		m.setAddress((String)request.getParameter("address"));
		m.setBirthday((String)request.getParameter("birthday"));
		m.setEndDay((String)request.getParameter("endDay"));
		m.setGender((String)request.getParameter("gender"));
		m.setMemberType((String)request.getParameter("memberType"));
		m.setmName((String)request.getParameter("mName"));
		m.setPhone((String)request.getParameter("phone"));
		m.setStartDay((String)request.getParameter("startDay"));
		int result = dao.updateMember(m);
		if (result > 0) {
			request.setAttribute("error", "변경완료. 회원번호 = " + result);
			goMemberListPage(request, response);
		} else {
			request.setAttribute("error", "데이터베이스 오류로 정보수정에 실패하였습니다.");
			goMemberListPage(request, response);
		}
	}

	private void addMember(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Member m = new Member();
		FitnessDAO dao = new FitnessDAO();
		
		m.setAddress((String)request.getParameter("address"));
		m.setBirthday((String)request.getParameter("birthday"));
		m.setEndDay((String)request.getParameter("endDay"));
		m.setGender((String)request.getParameter("gender"));
		m.setMemberType((String)request.getParameter("memberType"));
		m.setmName((String)request.getParameter("mName"));
		m.setPhone((String)request.getParameter("phone"));
		m.setStartDay((String)request.getParameter("startDay"));
		int result = dao.addMember(m);
		if (result > 0) {
			request.setAttribute("error", "등록에 성공하였습니다. 회원번호 = " + result);
			request.getRequestDispatcher("/WEB-INF/views/addMember.jsp").forward(request, response);
		} else if (result == -2) {
			request.setAttribute("error", "이미 존재하는 회원 정보입니다.");
			request.setAttribute("mName", m.getmName());
			request.setAttribute("phone", m.getPhone());
			request.getRequestDispatcher("/WEB-INF/views/addMember.jsp").forward(request, response);
		} else {
			request.setAttribute("error", "데이터베이스 오류로 정보입력에 실패하였습니다.");
			request.getRequestDispatcher("/WEB-INF/views/addMember.jsp").forward(request, response);
		}
	
	}

}
