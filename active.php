<?php
  $serverName = "localhost";
  $userName = "root";
  $password = "root";
  $dbName = "hkg1_sqli";

  try {
    $dbConnection = new PDO("mysql:host=$serverName;dbname=$dbName", $userName, $password);
    $dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  }
  catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    die();
  }
?>

<h1>Checker</h1>
<?php if (isset($_GET['id'])):

  try {
    if (isset($_GET['id'])) {
      $sql = "SELECT active FROM users WHERE id=". $_GET['id'];

      $result = $dbConnection->query($sql)->fetch();
      if ($result) {
        if ($result['active'])
          echo "Your account is active\n";
        else
          echo "Your account is suspended\n";
      }
    }
    else {
      
    }
  }    
  catch (Exception $e) {
    echo "Sorry, an error occured";
  }

else: ?>
<form>
  <label for="id">Enter your account id</label>
  <input type="text" name="id" id="id">
</form>
<?php endif; ?>
