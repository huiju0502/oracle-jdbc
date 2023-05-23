<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	/*
	select 번호, 매니저ID, 계층, 계층구조,  경로
	from(
		select 
		    rownum 번호,
		    manager_id 매니저ID,
		    level 계층,
		    lpad(' ', level-1) || first_name 계층구조,
		    sys_connect_by_path(first_name, '-') 경로
		from employees
		start with manager_id is null 
		connect by prior employee_id = manager_id)
	where 번호 between 1 and 20;
	*/
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	   
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);

	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()) {
		totalRow = totalRowRs.getInt(1); // totalRowRs.getInt("count(*)")
	}
	   
	int rowPerPage = 10;
	int beginRow = (currentPage-1) * rowPerPage + 1;
	int endRow = beginRow + (rowPerPage - 1);
	if(endRow > totalRow) {
		endRow = totalRow;
	}
	   
	String sql = "select 번호, 매니저ID, 계층, 계층구조, 경로 from(select rownum 번호, manager_id 매니저ID, level 계층,lpad(' ', level-1) || first_name 계층구조, sys_connect_by_path(first_name, '-') 경로 from employees start with manager_id is null connect by prior employee_id = manager_id) where 번호 between ? and ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()) {
	      HashMap<String, Object> m = new HashMap<String, Object>();
	      m.put("번호", rs.getInt("번호"));
	      m.put("매니저ID", rs.getInt("매니저ID"));
	      m.put("계층", rs.getInt("계층"));
	      m.put("계층구조", rs.getString("계층구조"));
	      m.put("경로", rs.getString("경로"));
	      list.add(m);
	}
	System.out.println(list.size() + " <- list.size()");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Start With Connect By Prior</h1>
	<table border="1">
      <tr>
         <td>번호</td>
         <td>매니저ID</td>
         <td>계층</td>
         <td>계층구조</td>
         <td>경로</td>
      </tr>
      <%
         for(HashMap<String, Object> m : list) {
      %>
            <tr>
               <td><%=(Integer)(m.get("번호"))%></td>
               <td><%=(Integer)(m.get("매니저ID"))%></td>
               <td><%=(Integer)(m.get("계층"))%></td>
               <td><%=(String)(m.get("계층구조"))%></td>
               <td><%=(String)(m.get("경로"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
   <%
  
   		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		
		// 페이지 네비게이션 페이징
		int pagePerPage = 10;
		
		int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
		int maxPage = minPage + (pagePerPage - 1);
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		if(minPage > 1) {
	%>
			<a href="<%=request.getContextPath() %>/start_with_connect_by_prior_list.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>	
	<%
		}
		
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {
	%>
				<span><%=i%></span>&nbsp;
	<%			
			} else {		
	%>
				<a href="<%=request.getContextPath() %>/start_with_connect_by_prior_list.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;	
	<%	
			}
		}
		
		if(maxPage != lastPage) {
	%>
			<!--  maxPage + 1 -->
			<a href="<%=request.getContextPath() %>/start_with_connect_by_prior_list.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%
		}
   	%>


</body>
</html>