<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%

	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);

	/*
	1) no exists
	select 
		rownum 번호,
		e.employee_id 사원ID,
		e.first_name 이름
	from employees e 
	where not exists (select * 
					from departments d
	                where d.department_id = e.department_id)
	*/
	
	String noExistsSql = "select rownum 번호, e.employee_id 사원ID, e.first_name 이름 from employees e where not exists (select * from departments d where d.department_id = e.department_id)";
	PreparedStatement noExistsStmt = conn.prepareStatement(noExistsSql);
	ResultSet noExistsRs = noExistsStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list1
		= new ArrayList<HashMap<String, Object>>();
	while(noExistsRs.next()) {
	      HashMap<String, Object> e1 = new HashMap<String, Object>();
	      e1.put("번호", noExistsRs.getInt("번호"));
	      e1.put("사원ID", noExistsRs.getInt("사원ID"));
	      e1.put("이름", noExistsRs.getString("이름"));
	      list1.add(e1);
	}
	System.out.println(list1.size() + " <- list1.size()");
	
	/*
	2) exists
	select 번호, 사원ID, 이름
	from(
	    select rownum 번호, e.employee_id 사원ID, e.first_name 이름
	    from employees e 
	    where exists (select * from departments d
	                    where d.department_id = e.department_id))
	where 번호 between 1 and 10
	*/
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees e where exists (select * from departments d where d.department_id = e.department_id)";
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
	
	String existsSql = "select 번호, 사원ID, 이름 from(select rownum 번호, e.employee_id 사원ID, e.first_name 이름 from employees e where exists(select * from departments d where d.department_id = e.department_id)) where 번호 between ? and ?";
	PreparedStatement existsStmt = conn.prepareStatement(existsSql);
	existsStmt.setInt(1, beginRow);
	existsStmt.setInt(2, endRow);
	ResultSet existsRs = existsStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list2
		= new ArrayList<HashMap<String, Object>>();
	while(existsRs.next()) {
	      HashMap<String, Object> e2 = new HashMap<String, Object>();
	      e2.put("번호", existsRs.getInt("번호"));
	      e2.put("사원ID", existsRs.getInt("사원ID"));
	      e2.put("이름", existsRs.getString("이름"));
	      list1.add(e2);
	}
	System.out.println(list1.size() + " <- list1.size()");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>no exists 결과셋</h1>
		<table border="1">
			<tr>
				<td>번호</td>
				<td>사원ID</td>
				<td>이름</td>		
			</tr>
			<%
				for(HashMap<String, Object> e1 : list1) {
			%>
				<tr>
					<td><%=(Integer)e1.get("번호") %></td>
					<td><%=(Integer)e1.get("사원ID") %></td>
					<td><%=(String)e1.get("이름") %></td>
				</tr>
			<%
				}
			%>
		</table>
	<h1>exists 결과셋</h1>
		<table border="1">
			<tr>
				<td>번호</td>
				<td>사원ID</td>
				<td>이름</td>		
			</tr>
			<%
				for(HashMap<String, Object> e2 : list2) {
			%>
				<tr>
					<td><%=(Integer)e2.get("번호") %></td>
					<td><%=(Integer)e2.get("사원ID") %></td>
					<td><%=(String)e2.get("이름") %></td>
				</tr>
			<%
				}
			%>
		</table>

</body>
</html>