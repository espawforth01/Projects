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
        echo "<a href='huddland-parliment.php?logout=true'>Logout</a>";

        // Search function
        if (isset($_GET['search'])) {
            $search_term = $_GET['search'];
            $sql = "SELECT m.id, m.firstname, m.lastname, c.region AS constituency_region 
                    FROM members m 
                    LEFT JOIN constituencies c ON m.constituency_id = c.id 
                    WHERE m.firstname LIKE ? OR m.lastname LIKE ?";
            $stmt = $conn->prepare($sql);
            $search_term = '%' . $search_term . '%';
            $stmt->bind_param("ss", $search_term, $search_term);
        } else {
            $sql = "SELECT m.id, m.firstname, m.lastname, c.region AS constituency_region 
                    FROM members m 
                    LEFT JOIN constituencies c ON m.constituency_id = c.id";
            $stmt = $conn->prepare($sql);
        }

        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Display members table
            echo "<h1>Members</h1>";
            echo "<form action='' method='get'>
            <input type='text' name='search' placeholder='Search by name'>
            <button type='submit'>Search</button>
            </form></br>";
            echo "<table border='1'>";
            echo "<tr><th>ID</th><th>First name</th><th>Last name</th><th>Constituency</th>";
            if ($_SESSION['role'] == 2) {
                echo "<th>Options</th>";
            }
            echo "</tr>";
            while($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td><a href='details.php?id=" . $row["id"] . "'>" . $row["id"] . "</a></td>";
                echo "<td>" . $row["firstname"] . "</td>";
                echo "<td>" . $row["lastname"] . "</td>";
                echo "<td>" . $row["constituency_region"] . "</td>";
                if ($_SESSION['role'] == 2) {
                    echo "<td><a href='delete.php?id=" . $row["id"] . "' onclick=\"return confirm('Are you sure you want to delete this member?')\">Delete</a></td>";
                }
                echo "</tr>";
            }
            echo "</table></br>";
            if ($_SESSION['role'] == 2) {
                echo "<a href='create.php'>Create Member</a>";
            }
        } else {
            echo "No members found";
        }

        $conn->close();
    ?>
</body>
</html>