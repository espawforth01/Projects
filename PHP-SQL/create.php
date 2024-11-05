<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Huddland Parliament | Create</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>
    <?php
        // Configuration
        $db_host = 'localhost';
        $db_username = 'web_pro_project';
        $db_password = 'web_pro_project';
        $db_name = 'web_pro_project';

        // Create connection
        $conn = new mysqli($db_host, $db_username, $db_password, $db_name);

        // Check connection
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Start session
        session_start();

        // Check if user is logged in
        if (!isset($_SESSION['user_id'])) {
            header('Location: huddland-parliment.php');
            exit;
        }

        // Check if user has permission to view site
        if ($_SESSION['role'] != 2) {
            echo "You do not have permission to view this site";
            exit;
        }

        // Get parties
        $sql = "SELECT * FROM parties";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->get_result();

        // Get constituencies
        $sql = "SELECT * FROM constituencies";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $constituency_result = $stmt->get_result();

        // Get all interests from the database
        $sql = "SELECT * FROM interests";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $interest_result = $stmt->get_result();

        // Handle form submission
        if (isset($_POST['create'])) {
            $firstname = $_POST['firstname'];
            $lastname = $_POST['lastname'];
            $date_of_birth = $_POST['date_of_birth'];
            $party_id = $_POST['party_id'];
            $constituency_id = $_POST['constituency_id'];
            $interests = $_POST['interests']; // Get the selected interests

            // Insert member
            $sql = "INSERT INTO members (firstname, lastname, date_of_birth, party_id, constituency_id) VALUES (?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssssi", $firstname, $lastname, $date_of_birth, $party_id, $constituency_id);
            $stmt->execute();
            $member_id = $stmt->insert_id; // Get the ID of the newly created member

            // Insert interests into the interest_member table
            if (!empty($interests)) {
                foreach ($interests as $interest_id) {
                    $sql = "INSERT INTO interest_member (member_id, interest_id) VALUES (?, ?)";
                    $stmt = $conn->prepare($sql);
                    $stmt->bind_param("ii", $member_id, $interest_id);
                    $stmt->execute();
                }
            }

            header('Location: huddland-parliment.php');
            exit;
        }

        // Display create form
        echo "<h1>Create Member</h1>";
        echo "<form action='' method='post'>";

        echo "<label for='firstname'>Firstname:</label>";
        echo "<input type='text' name='firstname' required>";
        echo "<br>";

        echo "<label for='lastname'>Lastname:</label>";
        echo "<input type='text' name='lastname' required>";
        echo "<br>";

        echo "<label for='date_of_birth'>Date of Birth:</label>";
        echo "<input type='date' name='date_of_birth' required>";
        echo "<br>";

        echo "<label for='party_id'>Party:</label>";
        echo "<select name='party_id'>";
        while ($row = $result->fetch_assoc()) {
            echo "<option value='" . $row['id'] . "'>" . $row['name'] . "</option>";
        }
        echo "</select>";
        echo "<br>";

        echo "<label for='constituency_id'>Constituency:</label>";
        echo "<select name='constituency_id'>";
        while ($row = $constituency_result->fetch_assoc()) {
            echo "<option value='" . $row['id'] . "'>" . $row['region'] . "</option>";
        }
        echo "</ select>";
        echo "<br>";

        echo "<label for='interests'>Interests:</label>";
        echo "<select name='interests[]' multiple size='5'>";
        while ($row = $interest_result->fetch_assoc()) {
            echo "<input type='checkbox' name='interests[]' value='" . $row['id'] . "'>" . $row['name'] . "</br>";
        }
        echo "</select>";
        echo "<br>";

        echo "<button type='submit' name='create'>Create</button>";
        echo "</form>";

        // Close connection
        $conn->close();
    ?>
</body>
</html>