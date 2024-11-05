-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 13, 2023 at 04:03 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `huddland_parliament`
--

-- --------------------------------------------------------

--
-- Table structure for table `constituencies`
--

CREATE TABLE `constituencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `population` int(11) NOT NULL,
  `region` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `constituencies`
--

INSERT INTO `constituencies` (`id`, `population`, `region`) VALUES
(1, 73292, 'Cruickshankstad'),
(2, 84555, 'Lockmanfort'),
(3, 79428, 'East Holdenport'),
(4, 75800, 'Shanahanburgh'),
(5, 84570, 'Port Autumnborough'),
(6, 88322, 'Port Terrellburgh'),
(7, 73626, 'North Kaela'),
(8, 89861, 'Port Vladimirfort'),
(9, 81042, 'Cornersbury'),
(10, 76271, 'Veummouth'),
(11, 94682, 'East Abdulville'),
(12, 91977, 'Reneemouth'),
(13, 83355, 'Rowebury'),
(14, 68477, 'North Millerbury'),
(15, 82823, 'Coleview'),
(16, 86452, 'West Donaldfurt'),
(17, 91638, 'West Helgaside'),
(18, 70647, 'Chelsieberg'),
(19, 85679, 'Camronmouth');

-- --------------------------------------------------------

--
-- Table structure for table `interests`
--

CREATE TABLE `interests` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `interests`
--

INSERT INTO `interests` (`id`, `name`) VALUES
(1, 'Immigration'),
(2, 'National Security'),
(3, 'Prisons and Probation'),
(4, 'Policing'),
(5, 'Defence'),
(6, 'Health and Social care'),
(7, 'Business and Innovation'),
(8, 'Energy and Industrial Strategy'),
(9, 'International Trade'),
(10, 'Social Security'),
(11, 'Education'),
(12, 'Environment'),
(13, 'Rural Affairs'),
(14, 'Housing'),
(15, 'Transport'),
(16, 'International Development'),
(17, 'Culture, Media and Sport');

-- --------------------------------------------------------

--
-- Table structure for table `interest_member`
--

CREATE TABLE `interest_member` (
  `member_id` int(10) UNSIGNED NOT NULL,
  `interest_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `interest_member`
--

INSERT INTO `interest_member` (`member_id`, `interest_id`) VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 12),
(2, 16),
(3, 7),
(3, 8),
(3, 9),
(4, 6),
(4, 11),
(4, 15),
(5, 2),
(5, 5),
(6, 14),
(7, 6),
(7, 10),
(7, 14),
(8, 1),
(8, 7),
(8, 8),
(9, 3),
(9, 4),
(10, 9),
(10, 16);

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) UNSIGNED NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `party_id` int(11) UNSIGNED DEFAULT NULL,
  `constituency_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `firstname`, `lastname`, `date_of_birth`, `party_id`, `constituency_id`) VALUES
(1, 'Quincy', 'Daniel', '1967-01-08', 3, 12),
(2, 'Tina', 'Barrows', '1979-10-30', 3, 7),
(3, 'Amira', 'Bogan', '1990-03-14', 3, 4),
(4, 'August', 'Little', '1973-12-10', 3, 13),
(5, 'Maxie', 'Price', '1958-09-01', 2, 5),
(6, 'Yasmine', 'Terry', '1963-08-21', 2, 8),
(7, 'Bryon', 'Balistreri', '1984-03-18', 4, 17),
(8, 'Alfreda', 'Connelly', '1970-07-19', 5, 11),
(9, 'Adil', 'Iqbal', '1961-02-10', 1, 2),
(10, 'Sophia', 'Podalski', '1953-04-13', 5, 15);

-- --------------------------------------------------------

--
-- Table structure for table `parties`
--

CREATE TABLE `parties` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `date_of_foundation` smallint(6) NOT NULL,
  `principal_colour` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parties`
--

INSERT INTO `parties` (`id`, `name`, `date_of_foundation`, `principal_colour`) VALUES
(1, 'Putting People First', 1917, 'purple'),
(2, 'Democratic Alliance', 1987, 'light blue'),
(3, 'Traditionalists', 1851, 'red'),
(4, 'Environmentalists', 1993, 'navy'),
(5, 'The Fairness Party', 2007, 'green');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` tinyint(4) NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Kate', 'k.l.hutton@assign3.ac.uk', '$2y$10$C8RsCwFPKUbhuWU9ze4p9e1TdjJxhUVKp/IJF9kpxzul9jgmDya36', 1, NULL, NULL, NULL),
(2, 'Yousef', 'y.miandad@assign3.ac.uk', '$2y$10$x7f9igWGzIUVJ4XcGxVbmO6LHe.HwLLGqR0aA6gllxMT50.POHMM.', 2, NULL, NULL, NULL),
(3, 'Sunil', 's.laxman@assign3.ac.uk', '$2y$10$JBaf7d66ishGUwGDcgSs.uNKyqTqEcdMzZgiPBvp5034wCB.hikKS', 1, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `constituencies`
--
ALTER TABLE `constituencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `interests`
--
ALTER TABLE `interests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `interest_member`
--
ALTER TABLE `interest_member`
  ADD PRIMARY KEY (`member_id`,`interest_id`),
  ADD KEY `fk_member_interest_members_interest_id` (`interest_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_members_constituencies_party_id` (`party_id`),
  ADD KEY `constituency_id` (`constituency_id`) USING BTREE;

--
-- Indexes for table `parties`
--
ALTER TABLE `parties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `constituencies`
--
ALTER TABLE `constituencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `interests`
--
ALTER TABLE `interests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `parties`
--
ALTER TABLE `parties`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `interest_member`
--
ALTER TABLE `interest_member`
  ADD CONSTRAINT `fk_member_interest_members_interest_id` FOREIGN KEY (`interest_id`) REFERENCES `interests` (`id`),
  ADD CONSTRAINT `fk_member_interest_members_member_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `fk_members_constituencies_constituency_id` FOREIGN KEY (`constituency_id`) REFERENCES `constituencies` (`id`),
  ADD CONSTRAINT `fk_members_parties_party_id` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
