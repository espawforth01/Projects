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

    // Get member ID
    $member_id = $_GET['id'];

    // Delete member's interests
    $sql = "DELETE FROM interest_member WHERE member_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $member_id);
    $stmt->execute();

    // Delete member
    $sql = "DELETE FROM members WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $member_id);
    $stmt->execute();

    header('Location: huddland-parliment.php');
    exit;

    // Close connection
    $conn->close();
?>