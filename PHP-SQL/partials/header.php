<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Huddland Parliment</title>
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
            // Display login form
            echo "<h1>Login</h1>";
            echo "<form action='' method='post'>
            <input type='text' name='username' placeholder='Email'>
            <input type='password' name='password' placeholder='Password'>
            <button type='submit' name='login'>Login</button>
            </form>";

            // Check if login form has been submitted
            if (isset($_POST['login'])) {
                // Login function
                $username = $_POST['username'];
                $password = $_POST['password'];

                $sql = "SELECT * FROM users WHERE email = ?";
                $stmt = $conn->prepare($sql);
                $stmt->bind_param("s", $username);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    $row = $result->fetch_assoc();
                    if (password_verify($password, $row['password'])) {
                        $_SESSION['user_id'] = $row['id'];
                        $_SESSION['role'] = $row['role'];
                        header('Location: huddland-parliment.php');
                        exit;
                    } else {
                        echo "Invalid username or password";
                    }
                } else {
                    echo "Invalid username or password";
                }
            }

            exit;
        }

        // Check if user has permission to view site
        if ($_SESSION['role'] != 1 && $_SESSION['role'] != 2) {
            echo "You do not have permission to view this site";
            exit;
        }

        // Logout function
        if (isset($_GET['logout'])) {
            session_destroy();
            header('Location: huddland-parliment.php');
            exit;
        }

        // Logout button
        echo "<a href='huddland-parliment.php?logout=true'>Logout</a></br>";
        echo "<a href='huddland-parliment.php'>Home</a>";
    ?>