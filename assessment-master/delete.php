<?php include 'partials/header.php' ?>
<?php 
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
?>
<?php include 'partials/footer.php' ?>