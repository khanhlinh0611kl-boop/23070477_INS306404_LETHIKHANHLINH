-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 04, 2026 at 04:34 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `university_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `course_code` varchar(15) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `credits` tinyint(4) NOT NULL DEFAULT 3,
  `department_id` int(11) NOT NULL,
  `instructor_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `course_code`, `name`, `description`, `credits`, `department_id`, `instructor_id`, `created_at`) VALUES
(1, 'INS3064', 'Cơ sở dữ liệu', 'Thiết kế lược đồ quan hệ và truy vấn SQL với MySQL.', 3, 1, 1, '2026-10-04 17:22:49'),
(2, 'INT2210', 'Cấu trúc dữ liệu và giải thuật', 'Danh sách, cây, đồ thị và các thuật toán sắp xếp, tìm kiếm.', 4, 1, 5, '2026-10-04 17:22:49'),
(3, 'BUS2101', 'Quản trị chiến lược', 'Phân tích môi trường và hoạch định chiến lược doanh nghiệp.', 3, 2, 2, '2026-10-04 17:22:49'),
(4, 'ACC2001', 'Nguyên lý kế toán', 'Các khái niệm cơ bản và quy trình kế toán tài chính.', 3, 3, 3, '2026-10-04 17:22:49'),
(5, 'MAT1101', 'Giải tích 1', 'Giới hạn, đạo hàm và tích phân của hàm một biến.', 4, 4, 4, '2026-10-04 17:22:49'),
(6, 'ENG1201', 'Tiếng Anh học thuật', 'Kỹ năng đọc, viết và thuyết trình bằng tiếng Anh.', 2, 5, 6, '2026-10-04 17:22:49');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `code`, `description`, `created_at`) VALUES
(1, 'Công nghệ thông tin', 'CNTT', 'Đào tạo về lập trình, cơ sở dữ liệu, mạng và hệ thống thông tin.', '2026-10-04 17:22:48'),
(2, 'Quản trị kinh doanh', 'QTKD', 'Đào tạo về quản trị, marketing và chiến lược doanh nghiệp.', '2026-10-04 17:22:48'),
(3, 'Kế toán - Kiểm toán', 'KTKT', 'Đào tạo về kế toán tài chính, kế toán quản trị và kiểm toán.', '2026-10-04 17:22:48'),
(4, 'Toán học', 'TOAN', 'Đào tạo về giải tích, đại số và xác suất thống kê.', '2026-10-04 17:22:48'),
(5, 'Ngôn ngữ Anh', 'NNA', 'Đào tạo tiếng Anh học thuật và tiếng Anh chuyên ngành.', '2026-10-04 17:22:48');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` bigint(20) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `enrolled_at` datetime NOT NULL DEFAULT current_timestamp(),
  `score` decimal(4,2) DEFAULT NULL,
  `status` enum('Đang học','Hoàn thành','Rút môn') NOT NULL DEFAULT 'Đang học'
) ;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `course_id`, `semester_id`, `enrolled_at`, `score`, `status`) VALUES
(1, 1, 1, 4, '2025-08-20 09:00:00', 8.50, 'Hoàn thành'),
(2, 1, 2, 4, '2025-08-20 09:05:00', 7.80, 'Hoàn thành'),
(3, 1, 5, 5, '2026-01-25 10:00:00', NULL, 'Đang học'),
(4, 2, 1, 4, '2025-08-21 14:00:00', 7.20, 'Hoàn thành'),
(5, 2, 2, 5, '2026-01-26 08:30:00', NULL, 'Đang học'),
(6, 3, 3, 4, '2025-08-22 11:00:00', 9.00, 'Hoàn thành'),
(7, 3, 6, 5, '2026-01-27 15:00:00', NULL, 'Đang học'),
(8, 4, 4, 4, '2025-08-22 13:30:00', 6.50, 'Hoàn thành'),
(9, 4, 5, 5, '2026-01-27 09:15:00', NULL, 'Rút môn'),
(10, 5, 5, 4, '2025-08-23 08:00:00', 9.20, 'Hoàn thành'),
(11, 5, 1, 5, '2026-01-28 10:30:00', NULL, 'Đang học'),
(12, 6, 6, 4, '2025-08-23 16:00:00', 8.00, 'Hoàn thành');

-- --------------------------------------------------------

--
-- Table structure for table `instructors`
--

CREATE TABLE `instructors` (
  `id` int(11) NOT NULL,
  `instructor_code` varchar(15) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `hire_date` date NOT NULL,
  `department_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `instructors`
--

INSERT INTO `instructors` (`id`, `instructor_code`, `full_name`, `email`, `phone`, `hire_date`, `department_id`, `created_at`) VALUES
(1, 'GV001', 'Nguyễn Văn Hùng', 'hung.nguyen@university.edu.vn', '0912345001', '2012-08-15', 1, '2026-10-04 17:22:48'),
(2, 'GV002', 'Trần Thị Mai', 'mai.tran@university.edu.vn', '0912345002', '2014-03-01', 2, '2026-10-04 17:22:48'),
(3, 'GV003', 'Lê Hoàng Nam', 'nam.le@university.edu.vn', '0912345003', '2016-09-05', 3, '2026-10-04 17:22:48'),
(4, 'GV004', 'Phạm Thu Hà', 'ha.pham@university.edu.vn', '0912345004', '2010-01-20', 4, '2026-10-04 17:22:48'),
(5, 'GV005', 'Đỗ Minh Quân', 'quan.do@university.edu.vn', '0912345005', '2018-07-10', 1, '2026-10-04 17:22:48'),
(6, 'GV006', 'Vũ Thanh Lan', 'lan.vu@university.edu.vn', '0912345006', '2015-11-12', 5, '2026-10-04 17:22:48');

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `season` enum('Xuân','Hè','Thu','Đông') NOT NULL,
  `academic_year` smallint(6) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`id`, `name`, `season`, `academic_year`, `start_date`, `end_date`) VALUES
(1, 'Mùa thu 2024', 'Thu', 2024, '2024-09-02', '2025-01-10'),
(2, 'Mùa xuân 2025', 'Xuân', 2025, '2025-02-10', '2025-06-15'),
(3, 'Mùa hè 2025', 'Hè', 2025, '2025-06-23', '2025-08-15'),
(4, 'Mùa thu 2025', 'Thu', 2025, '2025-09-01', '2026-01-09'),
(5, 'Mùa xuân 2026', 'Xuân', 2026, '2026-02-09', '2026-06-14');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `student_code` varchar(15) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `gender` enum('Nam','Nữ','Khác') NOT NULL DEFAULT 'Khác',
  `date_of_birth` date NOT NULL,
  `gpa` decimal(3,2) NOT NULL DEFAULT 0.00,
  `status` enum('Đang học','Bảo lưu','Đã tốt nghiệp') NOT NULL DEFAULT 'Đang học',
  `department_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_code`, `full_name`, `email`, `gender`, `date_of_birth`, `gpa`, `status`, `department_id`, `created_at`) VALUES
(1, 'SV24001', 'Nguyễn Minh Anh', 'anh.nm@student.edu.vn', 'Nữ', '2005-03-14', 3.45, 'Đang học', 1, '2026-10-04 17:22:49'),
(2, 'SV24002', 'Trần Quốc Bảo', 'bao.tq@student.edu.vn', 'Nam', '2005-07-22', 3.10, 'Đang học', 1, '2026-10-04 17:22:49'),
(3, 'SV24003', 'Lê Thị Cẩm Tú', 'tu.ltc@student.edu.vn', 'Nữ', '2004-11-05', 3.78, 'Đang học', 2, '2026-10-04 17:22:49'),
(4, 'SV24004', 'Phạm Đức Dũng', 'dung.pd@student.edu.vn', 'Nam', '2005-01-30', 2.85, 'Đang học', 3, '2026-10-04 17:22:49'),
(5, 'SV24005', 'Hoàng Thị Hạnh', 'hanh.ht@student.edu.vn', 'Nữ', '2004-09-18', 3.60, 'Đang học', 4, '2026-10-04 17:22:49'),
(6, 'SV24006', 'Vũ Gia Huy', 'huy.vg@student.edu.vn', 'Nam', '2005-05-09', 3.25, 'Đang học', 5, '2026-10-04 17:22:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `fk_courses_department` (`department_id`),
  ADD KEY `fk_courses_instructor` (`instructor_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_enrollment` (`student_id`,`course_id`,`semester_id`),
  ADD KEY `fk_enrollments_course` (`course_id`),
  ADD KEY `fk_enrollments_semester` (`semester_id`);

--
-- Indexes for table `instructors`
--
ALTER TABLE `instructors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `instructor_code` (`instructor_code`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_instructors_department` (`department_id`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `uq_semester_season_year` (`season`,`academic_year`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_code` (`student_code`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_students_department` (`department_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courses_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `fk_enrollments_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_enrollments_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_enrollments_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `instructors`
--
ALTER TABLE `instructors`
  ADD CONSTRAINT `fk_instructors_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
