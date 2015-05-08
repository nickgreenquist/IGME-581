<?php
	require_once("loadDB.php");
	
	$queryString = prepareQuery();
	queryDB($queryString);
	
	function prepareQuery(){
		$queryString = "SELECT * FROM Profile";
		
		return $queryString;
	}
	
	function queryDB($queryString){
		$db = openDB();
		$results = $db->query($queryString);
		$allRows = $results->fetchAll();
		$numFound = count($allRows);
		
		$results = array();
		
		foreach($allRows as $row){
			$filteredRow['Name'] = $row['Name'];
			$filteredRow['Interests'] = $row['Interests'];
			$filteredRow['Town'] = $row['Town'];
			$filteredRow['Phone'] = $row['Phone'];
			
			$results[] = $filteredRow;
		}
		
		$array = array('status'=>'success', 'numFound'=>$numFound, 'results'=>$results);
		
		$json = json_encode($array);
		header("content-type: application/json");
		echo $json;
	}

?>