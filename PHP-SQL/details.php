<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Huddland Parliment | Member Details</title>
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
            echo "You must be logged in to view this page.";
            exit;
        }

        // Get the member ID from the URL
        if (isset($_GET['id'])) {
            $member_id = $_GET['id'];

            // Prepare SQL statement to get member details
            $sql = "SELECT m.id, m.firstname, m.lastname, c.region AS constituency_region, 
                        p.name AS political_party, p.date_of_foundation, p.principal_colour, 
                        m.date_of_birth, i.name AS interest
                    FROM members m 
                    LEFT JOIN constituencies c ON m.constituency_id = c.id
                    LEFT JOIN parties p ON m.party_id = p.id
                    LEFT JOIN interest_member im ON m.id = im.member_id
                    LEFT JOIN interests i ON im.interest_id = i.id
                    WHERE m.id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $member_id);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                // Display member details
                $member = $result->fetch_assoc();
                echo "<h1>Member Details</h1>";
                echo "<h2>Personal Details</h2>";
                echo "<p>ID: " . $member["id"] . "</p>";
                echo "<p>Firstname: " . $member["firstname"] . "</p>";
                echo "<p>Lastname: " . $member["lastname"] . "</p>";
                echo "<p>Date of Birth: " . $member["date_of_birth"] . "</p>";
                echo "<p>Constituency: " . $member["constituency_region"] . "</p></br>";
                echo "<h2>Party Details</h2>";
                echo "<p>Political Party: " . $member["political_party"] . "</p>";
                echo "<p>Date of Foundation: " . $member["date_of_foundation"] . "</p>";
                echo "<p>Principal Colour: " . $member["principal_colour"] . "</p></br>";
                echo "<h2>Interests</h2>";

                // Fetch and display interests
                $interests_sql = "SELECT i.name 
                                FROM interests i 
                                JOIN interest_member im ON i.id = im.interest_id 
                                WHERE im.member_id = ?";
                $interests_stmt = $conn->prepare($interests_sql);
                $interests_stmt->bind_param("i", $member_id);
                $interests_stmt->execute();
                $interests_result = $interests_stmt->get_result();

                if ($interests_result->num_rows > 0) {
                    while ($interest = $interests_result->fetch_assoc()) {
                        echo "<p>" . $interest["name"] . "</p>";
                    }
                } else {
                    echo "<p>No interests found for this member.</p>";
                }
            } else {
                echo "No member found with that ID.";
            }
        } else {
            echo "No member ID specified.";
        }

        $conn->close();
    ?>
</body>
</html>