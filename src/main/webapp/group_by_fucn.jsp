<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%

	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	
	/*
		1)
		select department_id 부서ID, job_id 직무ID, count(*) 부서인원
		from employees
		group by department_id, job_id;
	*/

	String sql1 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by department_id, job_id";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println(stmt1);
	ResultSet rs1 = stmt1.executeQuery();
	ArrayList<HashMap<String, Object>> list1 
		= new ArrayList<HashMap<String, Object>>();
	while(rs1.next()) {
		HashMap<String, Object> m1 = new HashMap<String, Object>();
		m1.put("부서ID", rs1.getInt("부서ID"));
		m1.put("직무ID", rs1.getString("직무ID"));
		m1.put("부서인원", rs1.getInt("부서인원"));
		list1.add(m1);
	}
	System.out.println(list1);
	
	/*
		2) rollup
		select department_id 부서ID, job_id 직무ID, count(*) 부서인원
		from employees
		group by rollup(department_id, job_id);
	*/
	
	String sql2 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by rollup(department_id, job_id)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2);
	ResultSet rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list2
		= new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("부서ID", rs2.getInt("부서ID"));
		m2.put("직무ID", rs2.getString("직무ID"));
		m2.put("부서인원", rs2.getInt("부서인원"));
		list2.add(m2);
	}
	System.out.println(list2);
	
	/*
		3) cube
		select department_id 부서ID, count(*) 부서인원
		from employees
		group by cube(department_id);
	*/
	
	String sql3 = "select department_id 부서ID, count(*) 부서인원 from employees group by cube(department_id)";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	System.out.println(stmt3);
	ResultSet rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3
		= new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m3 = new HashMap<String, Object>();
		m3.put("부서ID", rs3.getInt("부서ID"));
		m3.put("부서인원", rs3.getInt("부서인원"));
		
		list3.add(m3);
	}
	System.out.println(list3);
	
	/*
		4) cube 2개컬럼
		select department_id 부서ID, job_id 직무ID, count(*) 부서인원
		from employees
		group by cube(department_id, job_id);
	*/
	
	String sql4 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by cube(department_id, job_id)";
	PreparedStatement stmt4 = conn.prepareStatement(sql4);
	System.out.println(stmt4);
	ResultSet rs4 = stmt4.executeQuery();
	ArrayList<HashMap<String, Object>> list4
		= new ArrayList<HashMap<String, Object>>();
	while(rs4.next()) {
		HashMap<String, Object> m4 = new HashMap<String, Object>();
		m4.put("부서ID", rs4.getInt("부서ID"));
		m4.put("직무ID", rs4.getString("직무ID"));
		m4.put("부서인원", rs4.getInt("부서인원"));
		list4.add(m4);
	}
	System.out.println(list4);



%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>1번 결과셋</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원</td>		
		</tr>
		<%
			for(HashMap<String, Object> m1 : list1) {
		%>
			<tr>
				<td><%=(Integer)m1.get("부서ID") %></td>
				<td><%=m1.get("직무ID") %></td>
				<td><%=(Integer)m1.get("부서인원") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>2번 결과셋</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원</td>		
		</tr>
		<%
			for(HashMap<String, Object> m2 : list2) {
		%>
			<tr>
				<td><%=(Integer)m2.get("부서ID") %></td>
				<td><%=m2.get("직무ID") %></td>
				<td><%=(Integer)m2.get("부서인원") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>3번 결과셋</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>부서인원</td>		
		</tr>
		<%
			for(HashMap<String, Object> m3 : list3) {
		%>
			<tr>
				<td><%=(Integer)m3.get("부서ID") %></td>
				<td><%=m3.get("직무ID") %></td>
				<td><%=(Integer)m3.get("부서인원") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>4번 결과셋</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원</td>		
		</tr>
		<%
			for(HashMap<String, Object> m4 : list4) {
		%>
			<tr>
				<td><%=(Integer)m4.get("부서ID") %></td>
				<td><%=m4.get("직무ID") %></td>
				<td><%=(Integer)m4.get("부서인원") %></td>
			</tr>
		<%
			}
		%>
		
	</table>

</body>
</html>