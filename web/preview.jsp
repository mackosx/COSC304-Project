<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="connection.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>2Kyle16 Store</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<link rel="icon" href="images/favicon.png">

	<script>
		function addcart(pid, pname, cost, inventory, current) {
			qty = document.getElementById('number').value;
			if(!(qty=="" || qty==null)){
				//checks if quantity + current cart value is greater than inventory
				if((parseInt(qty) + parseInt(current)) <= parseInt(inventory)){
					if(parseInt(qty) > 0 && parseInt(qty) <= 100)
						window.location.href ="addcart.jsp?pid=" + pid + "&pname=" + pname +"&qty=" + qty + "&cost=" + cost +"&inventory="+inventory;
					else
						alert("Please enter a value between 1 and 100.");
				}else{
					alert("We dont have that many!");
				}
			}
		}
	</script>
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<br><br><br><br>
	
	<!--
	<h1>Product</h1>
	<a href = "listproducts.php">Back</a>
	<a href = "home.html">Home</a> -->
	<% // Get product name to search for
	String pid = request.getParameter("pid");
			
	try{
		getConnection();

		PreparedStatement p = null;
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		p = con.prepareStatement("SELECT pname, cost, description, image, inventory FROM Product WHERE pid = ?");
		p.setString(1, pid);
		ResultSet rst = p.executeQuery();
		HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");
		int curAmount = 0;
		while(rst.next()){
			//checks item quantity in the cart
			if(itemList!=null){
				if (itemList.containsKey(pid)){
					ArrayList<Object> product =(ArrayList<Object>) itemList.get(pid);
					curAmount = ((Integer) product.get(3)).intValue();
				}
			}
			String pname = rst.getString(1);
			Double cost = rst.getDouble(2);
			String desc = rst.getString(3);
			String image = rst.getString(4);
			int inventory = rst.getInt(5);
			out.println("<table>");
			out.println("<td><img src=\"images/products/" + image + "\"></td>");
			out.println("<td><table>");
			out.println("<tr><td>" + pname + "</td></tr>");
			if(inventory <= 0){
				out.println("<tr><td>Out of Stock</td><tr>");
			}else{
				out.println("<tr><td align='left'>" + currFormat.format(cost) + "</td><tr>");
				// addcart as submit button, gets info from text box
				out.println("<tr><td align='left'><input type='number' class='numberBox' id='number' value='1' id='qty' size='1' min='1' max='100'>  Stock: " + inventory + "</td></tr>");
				out.println("<tr><td align='left'><input type='button' id='submit' value='Add to Cart' onclick=\'addcart(\""+pid+"\", \"" +pname+"\", \""+ cost+"\", \""+inventory+"\", \""+curAmount+"\")\'></td></tr>");
			}
			out.println("</table></td>");
			out.println("</table>");
			out.println("<p><br>"+ desc + "</p>");
			
		}
		con.close();
	}catch(SQLException e){
		out.println("Error: " + e);
	}finally{
		try
		{
			closeConnection();
		}
		catch (SQLException ex)
		{
			out.println(ex); 
		}
	}
	%>
<br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>