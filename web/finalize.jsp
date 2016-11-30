<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="connection.jsp" %>


<html>
<head>
	<title>Checkout</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<script>
	</script>
</head>
<body>

<%
try {
	getConnection();
	//get parameters
	String shipAddress = request.getParameter("address");
	String shipType = request.getParameter("shipType");
	String payType = request.getParameter("payType");
	String country = request.getParameter("country");
	String province = request.getParameter("province");
	String city = request.getParameter("city");
	
	HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");	
	PreparedStatement pstmt = null;
	out.println("<h1>Place Order</h1><p>Are these details correct?</p>");
	
	out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

	double total = 0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = itemList.entrySet().iterator();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	while (iterator.hasNext())//print out cart info
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
		out.print("<tr><td>"+productId+"</td>");
		out.print("<td>"+product.get(1)+"</td>");
		out.print("<td align=\"center\">"+product.get(3)+"</td>");
		String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\">Total: </td><td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	//applicable taxes
	double tax = total*0.12;
	out.println("<tr><td colspan=\"4\" align=\"right\">Tax: </td><td align=\"right\">"+currFormat.format(tax)+"</td></tr>");
	
	//print shipcost
	pstmt = con.prepareStatement("SELECT cost FROM ShippingOption WHERE shippingType = ?");
	pstmt.setString(1, shipType);
	ResultSet ships = pstmt.executeQuery();
	double shipCost = 0;
	while(ships.next()){
		shipCost = ships.getDouble(1);
		out.println("<tr><td colspan=\"4\" align=\"right\">Shipping Cost: </td><td align=\"right\">"+currFormat.format(shipCost)+"</td></tr>");
	}
	
	double orderTotal = shipCost + tax + total;
	out.println("<tr><td colspan=\"4\" align=\"right\">Order Total: </td><td align=\"right\">"+currFormat.format(orderTotal)+"</td></tr>");
	out.println("<tr><td align='left'>Payment Method: " + payType + "</td><tr>");

	
	out.println("</table><form method='post' action='insertorder.jsp'>");//TODO: add form data location
	out.println("<input name='grandTotal' type='hidden' value='"+orderTotal+"'>");
	out.println("<input name='street' type='hidden' value='"+shipAddress+"'>");
	out.println("<input name='city' type='hidden' value='"+city+"'>");
	out.println("<input name='province' type='hidden' value='"+province+"'>");
	out.println("<input name='country' type='hidden' value='"+country+"'>");
	out.println("<input name='shipType' type='hidden' value='"+shipType+"'>");
	out.println("<input name='payType' type='hidden' value='"+payType+"'>");
	out.println("<input name='shipCost' type='hidden' value='"+shipCost+"'>");
	out.println("<input name='cartTotal' type='hidden' value='"+total+"'>");
	out.println("<input id='submit' type='submit' value='Place Order'>");

	out.println("</form>");

	

}catch(SQLException e){
	out.println(e);
}finally{
	closeConnection();
}
	
%>                       				


</body>
</html>