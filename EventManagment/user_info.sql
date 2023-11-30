-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2023 at 07:53 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `user_info`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBookings` (IN `emailid` VARCHAR(25))   SELECT * FROM venue_booking, equipments WHERE email = emailid and venue_booking_id = id$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_total_cost` (`event_id` INT) RETURNS INT(11)  BEGIN
    DECLARE equipment_cost INT;
    DECLARE total_cost INT;

    SELECT 
        SUM(chairs_no + tables_no + lights_no + speakers_no + microphones_no) * 10 INTO equipment_cost
    FROM equipments
    WHERE venue_booking_id = event_id;

    SET total_cost = equipment_cost + (SELECT rate FROM venue WHERE id = (SELECT venue_id FROM venue_booking WHERE id = event_id));

    RETURN total_cost;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `equipments`
--

CREATE TABLE `equipments` (
  `eid` int(3) NOT NULL,
  `chairs_no` int(3) NOT NULL,
  `tables_no` int(3) NOT NULL,
  `lights_no` int(3) NOT NULL,
  `speakers_no` int(3) NOT NULL,
  `microphones_no` int(3) NOT NULL,
  `venue_booking_id` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `equipments`
--

INSERT INTO `equipments` (`eid`, `chairs_no`, `tables_no`, `lights_no`, `speakers_no`, `microphones_no`, `venue_booking_id`) VALUES
(78, 123, 617, 247, 123, 82, 101),
(82, 12, 6, 2, 1, 1, 108),
(83, 12, 3, 2, 1, 1, 111);

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `id` int(1) NOT NULL,
  `name` varchar(25) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`id`, `name`, `description`) VALUES
(1, 'Wedding', 'Discover the epitome of love and luxury with our exquisite wedding packages'),
(2, 'Birthday', 'Unwrap joy, celebrate life—your perfect birthday awaits!'),
(3, 'Conference', 'Fuel innovation, connect minds—join us for a game-changing conference experience.'),
(25, 'Project', 'xyz');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(1) NOT NULL,
  `name` text NOT NULL,
  `email` varchar(20) NOT NULL,
  `phone_number` int(10) NOT NULL,
  `password` varchar(30) NOT NULL,
  `usertype` varchar(10) NOT NULL,
  `dt` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `email`, `phone_number`, `password`, `usertype`, `dt`) VALUES
(1, 'admin', 'admin@gmail.com', 123, 'admin', 'admin', '0000-00-00'),
(93, 'Cassy', 'Cassy@gmail.com', 123456789, 'Cassy', 'user', '2023-11-20'),
(95, 'Prams', 'Prams@gmail.com', 12345678, '12345', 'user', '2023-11-22');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `validate_email_format` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
  IF NEW.email NOT LIKE '%@gmail.com' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid email format. Email should end with @gmail.com';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `venue`
--

CREATE TABLE `venue` (
  `id` int(1) NOT NULL,
  `name` varchar(25) NOT NULL,
  `address` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `rate` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venue`
--

INSERT INTO `venue` (`id`, `name`, `address`, `description`, `rate`) VALUES
(1, 'Church Street', '4th Main, 16th cross, opp to socials ', 'grand and historic', 300),
(2, 'Palace Ground', '#23, opp to Shiva temple', 'Largest Indoor', 700),
(10, 'Star Banquets', 'Jayanagar, Bangalore.', 'Public and appropriate', 780),
(11, 'Lemon Tree Hotel', 'Electronic City, Bangalore.', 'More rewarding', 470),
(12, 'Whitefield Banquets', 'Whitefield, Bangalore.', 'Telly festival', 780),
(13, 'Leela Palace', 'Kodihalli, Bengaluru', 'A classic 5-star venue', 1000);

--
-- Triggers `venue`
--
DELIMITER $$
CREATE TRIGGER `tr_delete` AFTER DELETE ON `venue` FOR EACH ROW INSERT into venue_logs(venue_id,name,address,description,rate) VALUES(old.id, old.name, old.address, old.description, old.rate)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `venue_booking`
--

CREATE TABLE `venue_booking` (
  `id` int(3) NOT NULL,
  `user_name` varchar(25) NOT NULL,
  `email` varchar(50) NOT NULL,
  `user_phone` int(10) NOT NULL,
  `venue_id` int(1) NOT NULL,
  `event_id` int(1) NOT NULL,
  `date` date NOT NULL,
  `audience_size` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venue_booking`
--

INSERT INTO `venue_booking` (`id`, `user_name`, `email`, `user_phone`, `venue_id`, `event_id`, `date`, `audience_size`) VALUES
(101, 'Cassy', 'Cassy@gmail.com', 123456789, 2, 2, '2023-11-30', 1234),
(108, 'Prams', 'Prams@gmail.com', 12345678, 2, 1, '2023-11-25', 12),
(111, 'Cassy', 'Cassy@gmail.com', 123456789, 13, 1, '2023-11-25', 12);

-- --------------------------------------------------------

--
-- Table structure for table `venue_logs`
--

CREATE TABLE `venue_logs` (
  `id` int(2) NOT NULL,
  `venue_id` int(2) NOT NULL,
  `name` varchar(20) NOT NULL,
  `address` varchar(30) NOT NULL,
  `description` varchar(20) NOT NULL,
  `rate` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venue_logs`
--

INSERT INTO `venue_logs` (`id`, `venue_id`, `name`, `address`, `description`, `rate`) VALUES
(21, 100, 'Cubbon Park', 'x', 'y', 120),
(26, 14, 'Venue2', 'add2', 'desc2', 8),
(27, 33, '', 'ad5', 'desc5', 450);

--
-- Triggers `venue_logs`
--
DELIMITER $$
CREATE TRIGGER `del_logs` AFTER DELETE ON `venue_logs` FOR EACH ROW INSERT into venue VALUES(old.venue_id,old.name,old.address,old.description,old.rate)
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `equipments`
--
ALTER TABLE `equipments`
  ADD PRIMARY KEY (`eid`),
  ADD KEY `venue_booking_id` (`venue_booking_id`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`,`phone_number`);

--
-- Indexes for table `venue`
--
ALTER TABLE `venue`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `address` (`address`);

--
-- Indexes for table `venue_booking`
--
ALTER TABLE `venue_booking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `venue_id` (`venue_id`,`event_id`,`date`),
  ADD UNIQUE KEY `unique_venue_date` (`venue_id`,`date`),
  ADD KEY `venue_booking_ibfk_1` (`event_id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `venue_logs`
--
ALTER TABLE `venue_logs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `equipments`
--
ALTER TABLE `equipments`
  MODIFY `eid` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `venue`
--
ALTER TABLE `venue`
  MODIFY `id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `venue_booking`
--
ALTER TABLE `venue_booking`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `venue_logs`
--
ALTER TABLE `venue_logs`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `equipments`
--
ALTER TABLE `equipments`
  ADD CONSTRAINT `equipments_ibfk_1` FOREIGN KEY (`venue_booking_id`) REFERENCES `venue_booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `venue_booking`
--
ALTER TABLE `venue_booking`
  ADD CONSTRAINT `venue_booking_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `venue_booking_ibfk_2` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `venue_booking_ibfk_3` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
