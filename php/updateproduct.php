<?php
error_reporting(0);
if (!isset($_POST)) {
$response = array('status' => 'failed', 'data' => null);
sendJsonResponse($response);
die();
}

include_once("dbconnect.php");
$productid = $_POST['productid'];
$userid = $_POST['userid'];
$prname = ucwords(addslashes($_POST['prname']));
$prdesc = ucfirst(addslashes($_POST['prdesc']));
$prprice = $_POST['prprice'];
$delivery = $_POST['delivery'];
$qty = $_POST['qty'];

$sqlupdate = "UPDATE `tbl_products` SET `product_id`='$productid',`user_id`='$userid',
`product_name`='$prname',`product_desc`='$prdesc',`product_delivery`='$delivery',
`product_qty`='$qty',`product_price`='3$prprice'  
WHERE `product_id` = '$productid' AND `user_id` = '$userid'";

try {
	if ($conn->query($sqlupdate) === TRUE) {
		$response = array('status' => 'success', 'data' => null);
		sendJsonResponse($response);
	} else {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
} catch (Exception $e) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}
$conn->close(); 

function sendJsonResponse($sentArray)
{
	header('Content-Type= application/json');
	echo json_encode($sentArray);
}
?>