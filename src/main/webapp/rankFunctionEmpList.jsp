<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	/*
	select 번호, 사원ID, 성, 연봉, 급여순위
	from(
	    select rownum 번호, 사원ID, 성, 연봉, 급여순위
	    from(
	        select
	            employee_id 사원ID,
	            last_name 성,
	            salary 연봉,
	            rank() over(order by salary desc) 급여순위
	        from employees))
	where 번호 between 1 and 10
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
	   
	String sql = "select 번호, 사원ID, 성, 연봉, 급여순위 from(select rownum 번호, 사원ID, 성, 연봉, 급여순위 from(select employee_id 사원ID, last_name 성, salary 연봉, rank() over(order by salary desc) 급여순위 from employees)) where 번호 between ? and ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()) {
	      HashMap<String, Object> m = new HashMap<String, Object>();
	      m.put("번호", rs.getInt("번호"));
	      m.put("사원ID", rs.getInt("사원ID"));
	      m.put("성", rs.getString("성"));
	      m.put("연봉", rs.getInt("연봉"));
	      m.put("급여순위", rs.getInt("급여순위"));
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
<h1>Rank Function</h1>
	<table border="1">
      <tr>
         <td>번호</td>
         <td>사원ID</td>
         <td>성</td>
         <td>연봉</td>
         <td>급여순위</td>
      </tr>
      <%
         for(HashMap<String, Object> m : list) {
      %>
            <tr>
               <td><%=(Integer)(m.get("번호"))%></td>
               <td><%=(Integer)(m.get("사원ID"))%></td>
               <td><%=(String)(m.get("성"))%></td>
               <td><%=(Integer)(m.get("연봉"))%></td>
               <td><%=(Integer)(m.get("급여순위"))%></td>
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
			<a href="<%=request.getContextPath() %>/rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>	
	<%
		}
		
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {
	%>
				<span><%=i%></span>&nbsp;
	<%			
			} else {		
	%>
				<a href="<%=request.getContextPath() %>/rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;	
	<%	
			}
		}
		
		if(maxPage != lastPage) {
	%>
			<!--  maxPage + 1 -->
			<a href="<%=request.getContextPath() %>/rankFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%
		}
   	%>

</body>
</html>