<?php include 'partials/header.php' ?>
<?php
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
?>
<?php include 'partials/footer.php'?>