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
	1) rank(중복 순위 포함)
	select 번호, 이름, 연봉, 연봉순위
	from(
	    select rownum 번호, 이름, 연봉, 연봉순위
	    from(
	        select 
	            first_name 이름, salary 연봉, rank() over(order by salary) 연봉순위
	        from employees))
	*/
   
	String rankSql = "select 번호, 이름, 연봉, 연봉순위 from(select rownum 번호, 이름, 연봉, 연봉순위 from(select first_name 이름, salary 연봉, rank() over(order by salary) 연봉순위 from employees))";
	PreparedStatement rankStmt = conn.prepareStatement(rankSql);
	ResultSet rankRs = rankStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list1
		= new ArrayList<HashMap<String, Object>>();
	while(rankRs.next()) {
	      HashMap<String, Object> r1 = new HashMap<String, Object>();
	      r1.put("번호", rankRs.getInt("번호"));
	      r1.put("이름", rankRs.getString("이름"));
	      r1.put("연봉", rankRs.getInt("연봉"));
	      r1.put("연봉순위", rankRs.getInt("연봉순위"));
	      list1.add(r1);
	}
	System.out.println(list1.size() + " <- list1.size()");
	
	/*
	2) dense_rank(중복 순위 무시)
	select 번호, 이름, 연봉, 연봉순위
	from(
	    select rownum 번호, 이름, 연봉, 연봉순위
	    from(
	        select 
	            first_name 이름, salary 연봉, dense_rank() over(order by salary) 연봉순위
	        from employees))
	*/
   
	String denseRankSql = "select 번호, 이름, 연봉, 연봉순위 from(select rownum 번호, 이름, 연봉, 연봉순위 from(select first_name 이름, salary 연봉, dense_rank() over(order by salary) 연봉순위 from employees))";
	PreparedStatement denseRankStmt = conn.prepareStatement(denseRankSql);
	ResultSet denseRankRs = denseRankStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list2
		= new ArrayList<HashMap<String, Object>>();
	while(denseRankRs.next()) {
	      HashMap<String, Object> r2 = new HashMap<String, Object>();
	      r2.put("번호", denseRankRs.getInt("번호"));
	      r2.put("이름", denseRankRs.getString("이름"));
	      r2.put("연봉", denseRankRs.getInt("연봉"));
	      r2.put("연봉순위", denseRankRs.getInt("연봉순위"));
	      list2.add(r2);
	}
	System.out.println(list2.size() + " <- list2.size()");
	
	/*
	3) row_number
	select 
		first_name 이름,
		salary 연봉,
		row_number() over(order by salary) 행번호
	from employees;
	*/
   
	String rowNumberSql = "select first_name 이름, salary 연봉, row_number() over(order by salary) 행번호 from employees";
	PreparedStatement rowNumberStmt = conn.prepareStatement(rowNumberSql);
	ResultSet rowNumberRs = rowNumberStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list3
		= new ArrayList<HashMap<String, Object>>();
	while(rowNumberRs.next()) {
	      HashMap<String, Object> r3 = new HashMap<String, Object>();
	      r3.put("이름", rowNumberRs.getString("이름"));
	      r3.put("연봉", rowNumberRs.getInt("연봉"));
	      r3.put("행번호", rowNumberRs.getInt("행번호"));
	      list3.add(r3);
	}
	System.out.println(list3.size() + " <- list3.size()");
	
	/*
	4) ntile
	select 번호, 이름, 연봉, 등급 
	from(
	    select rownum 번호, 이름, 연봉, 등급
	    from(
	        select 
	        	rownum,
	        	first_name 이름 , salary 연봉, ntile(10) over(order by salary desc) 등급
	        from employees));
	*/
	
	String ntileSql = "select 번호, 이름, 연봉, 등급 from(select rownum 번호, 이름, 연봉, 등급 from(select first_name 이름 , salary 연봉, ntile(10) over(order by salary desc) 등급 from employees))";
	PreparedStatement ntileStmt = conn.prepareStatement(ntileSql);
	ResultSet ntileRs = ntileStmt.executeQuery();
	   
	ArrayList<HashMap<String, Object>> list4
		= new ArrayList<HashMap<String, Object>>();
	while(ntileRs.next()) {
	      HashMap<String, Object> n = new HashMap<String, Object>();
	      n.put("번호", ntileRs.getInt("번호"));
	      n.put("이름", ntileRs.getString("이름"));
	      n.put("연봉", ntileRs.getInt("연봉"));
	      n.put("등급", ntileRs.getInt("등급"));
	      list4.add(n);
	}
	System.out.println(list4.size() + " <- list4.size()");



%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>rank 결과셋</h1>
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>연봉</td>		
			<td>연봉순위</td>		
		</tr>
		<%
			for(HashMap<String, Object> r1 : list1) {
		%>
			<tr>
				<td><%=(Integer)r1.get("번호") %></td>
				<td><%=(String)r1.get("이름") %></td>
				<td><%=(Integer)r1.get("연봉") %></td>
				<td><%=(Integer)r1.get("연봉순위") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>dense_rank 결과셋</h1>
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>연봉</td>		
			<td>연봉순위</td>		
		</tr>
		<%
			for(HashMap<String, Object> r2 : list2) {
		%>
			<tr>
				<td><%=(Integer)r2.get("번호") %></td>
				<td><%=(String)r2.get("이름") %></td>
				<td><%=(Integer)r2.get("연봉") %></td>
				<td><%=(Integer)r2.get("연봉순위") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>row_number 결과셋</h1>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>연봉</td>		
			<td>행번호</td>		
		</tr>
		<%
			for(HashMap<String, Object> r3 : list3) {
		%>
			<tr>
				<td><%=(String)r3.get("이름") %></td>
				<td><%=(Integer)r3.get("연봉") %></td>
				<td><%=(Integer)r3.get("행번호") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<h1>ntile 결과셋</h1>
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>연봉</td>		
			<td>등급</td>		
		</tr>
		<%
			for(HashMap<String, Object> n : list4) {
		%>
			<tr>
				<td><%=(Integer)n.get("번호") %></td>
				<td><%=(String)n.get("이름") %></td>
				<td><%=(Integer)n.get("연봉") %></td>
				<td><%=(Integer)n.get("등급") %></td>
			</tr>
		<%
			}
		%>
	</table>

</body>
</html>