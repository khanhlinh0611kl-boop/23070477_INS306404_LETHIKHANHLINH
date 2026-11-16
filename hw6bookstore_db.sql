/* ==========================================================
   BOOKSTORE DATABASE - Homework 06
   ==========================================================
   GIẢI THÍCH 3NF
   - 1NF: Mọi cột chứa giá trị đơn (atomic). Không lưu danh sách
     tác giả hay thể loại trong một cột; thay vào đó dùng các bảng
     book_authors và book_categories.
   - 2NF: Các bảng trung gian có khóa chính tổ hợp nhưng không có
     thuộc tính phụ thuộc một phần khóa. Các bảng còn lại dùng khóa
     thay thế (một cột) nên không thể có phụ thuộc từng phần.
   - 3NF: Không có phụ thuộc bắc cầu. Ví dụ: thông tin nhà xuất bản
     (tên, địa chỉ, website) nằm ở bảng publishers, không lặp lại
     trong books; books chỉ giữ publisher_id. Tương tự, tên tác giả
     và tên thể loại chỉ nằm ở authors và categories.
   - Ghi chú thiết kế: orders.total và order_items.unit_price là giá
     trị "chụp lại" tại thời điểm đặt hàng (snapshot), vì giá sách có
     thể thay đổi sau này. order_items.subtotal là cột tính
     (generated) nên không bị dư thừa dữ liệu.
   ========================================================== */

DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookstore;

-- ---------- CREATE TABLE ----------

CREATE TABLE publishers (
  publisher_id INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(150) NOT NULL UNIQUE,
  address      VARCHAR(255),
  website      VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE authors (
  author_id   INT AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(120) NOT NULL,
  biography   TEXT,
  nationality VARCHAR(60)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categories (
  category_id        INT AUTO_INCREMENT PRIMARY KEY,
  name               VARCHAR(80) NOT NULL UNIQUE,
  description        VARCHAR(255),
  parent_category_id INT NULL,
  CONSTRAINT fk_cat_parent FOREIGN KEY (parent_category_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE books (
  book_id          INT AUTO_INCREMENT PRIMARY KEY,
  isbn             CHAR(13) NOT NULL UNIQUE,
  title            VARCHAR(200) NOT NULL,
  publisher_id     INT NOT NULL,
  price            DECIMAL(10,2) NOT NULL,
  stock            INT NOT NULL DEFAULT 0,
  publication_date DATE,
  CONSTRAINT chk_book_price CHECK (price > 0),
  CONSTRAINT chk_book_stock CHECK (stock >= 0),
  CONSTRAINT fk_book_pub FOREIGN KEY (publisher_id)
    REFERENCES publishers(publisher_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE book_authors (
  book_id   INT NOT NULL,
  author_id INT NOT NULL,
  PRIMARY KEY (book_id, author_id),
  CONSTRAINT fk_ba_book FOREIGN KEY (book_id)
    REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ba_author FOREIGN KEY (author_id)
    REFERENCES authors(author_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE book_categories (
  book_id     INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (book_id, category_id),
  CONSTRAINT fk_bc_book FOREIGN KEY (book_id)
    REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_bc_cat FOREIGN KEY (category_id)
    REFERENCES categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE customers (
  customer_id   INT AUTO_INCREMENT PRIMARY KEY,
  full_name     VARCHAR(120) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  address       VARCHAR(255),
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
  order_id         INT AUTO_INCREMENT PRIMARY KEY,
  customer_id      INT NOT NULL,
  order_date       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status           ENUM('pending','processing','shipped','delivered','cancelled')
                   NOT NULL DEFAULT 'pending',
  total            DECIMAL(12,2) NOT NULL DEFAULT 0,
  shipping_address VARCHAR(255) NOT NULL,
  CONSTRAINT chk_order_total CHECK (total >= 0),
  CONSTRAINT fk_order_cust FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id      INT NOT NULL,
  book_id       INT NOT NULL,
  quantity      INT NOT NULL,
  unit_price    DECIMAL(10,2) NOT NULL,
  subtotal      DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  UNIQUE KEY uq_order_book (order_id, book_id),
  CONSTRAINT chk_item_qty   CHECK (quantity > 0),
  CONSTRAINT chk_item_price CHECK (unit_price > 0),
  CONSTRAINT fk_item_order FOREIGN KEY (order_id)
    REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_item_book FOREIGN KEY (book_id)
    REFERENCES books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reviews (
  review_id   INT AUTO_INCREMENT PRIMARY KEY,
  book_id     INT NOT NULL,
  customer_id INT NOT NULL,
  rating      TINYINT NOT NULL,
  comment     TEXT,
  review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_review (book_id, customer_id),
  CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT fk_rev_book FOREIGN KEY (book_id)
    REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rev_cust FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- SAMPLE DATA ----------

INSERT INTO publishers (name, address, website) VALUES
('NXB Trẻ',        '161B Lý Chính Thắng, Quận 3, TP.HCM', 'https://nxbtre.com.vn'),
('NXB Kim Đồng',   '55 Quang Trung, Hai Bà Trưng, Hà Nội', 'https://nxbkimdong.com.vn'),
('NXB Thế Giới',   '46 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',  'https://thegioipublishers.vn'),
('Prentice Hall',  'Upper Saddle River, New Jersey, USA',  'https://www.pearson.com');

INSERT INTO authors (full_name, biography, nationality) VALUES
('Nguyễn Nhật Ánh',  'Nhà văn Việt Nam nổi tiếng với truyện về tuổi thơ.', 'Việt Nam'),
('Tô Hoài',          'Nhà văn Việt Nam, tác giả Dế Mèn phiêu lưu ký.',     'Việt Nam'),
('Nam Cao',          'Nhà văn hiện thực Việt Nam trước 1945.',              'Việt Nam'),
('Yuval Noah Harari','Nhà sử học và tác giả người Israel.',                 'Israel'),
('Robert C. Martin', 'Kỹ sư phần mềm, tác giả về clean code.',              'Mỹ'),
('Isaac Asimov',     'Nhà văn khoa học viễn tưởng người Mỹ gốc Nga.',       'Mỹ');

INSERT INTO categories (name, description, parent_category_id) VALUES
('Văn học',            'Tiểu thuyết, truyện ngắn',      NULL),
('Khoa học viễn tưởng','Thể loại con của Văn học',      1),
('Công nghệ',          'Lập trình, kỹ thuật phần mềm',  NULL),
('Lịch sử',            'Lịch sử và khoa học xã hội',    NULL),
('Thiếu nhi',          'Sách dành cho thiếu nhi',       NULL);

INSERT INTO books (isbn, title, publisher_id, price, stock, publication_date) VALUES
('9786041000011', 'Cho tôi xin một vé đi tuổi thơ', 1,  85000.00, 40, '2008-12-01'),
('9786041000028', 'Dế Mèn phiêu lưu ký',            2,  60000.00, 55, '2019-06-15'),
('9786041000035', 'Lão Hạc',                        1,  55000.00, 30, '2015-03-20'),
('9786041000042', 'Sapiens: Lược sử loài người',    3, 189000.00, 25, '2018-09-10'),
('9780132350884', 'Clean Code',                     4, 450000.00, 12, '2008-08-01'),
('9786041000059', 'Foundation',                     3, 135000.00, 20, '2020-05-05'),
('9786041000066', 'I, Robot',                       3, 120000.00, 18, '2021-02-14'),
('9780134494166', 'Clean Architecture',             4, 420000.00,  9, '2017-09-12');

INSERT INTO book_authors (book_id, author_id) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,6),(8,5);

INSERT INTO book_categories (book_id, category_id) VALUES
(1,1),(2,1),(2,5),(3,1),(4,4),(5,3),(6,2),(7,2),(8,3);

INSERT INTO customers (full_name, email, password_hash, address) VALUES
('Nguyễn Văn An',  'an@example.com',    '$2y$10$hashAn000000000000000000000000000000000000000000001', '12 Giải Phóng, Hà Nội'),
('Trần Thị Bình',  'binh@example.com',  '$2y$10$hashBinh0000000000000000000000000000000000000000002', '45 Nguyễn Trãi, Hà Nội'),
('Lê Minh Cường',  'cuong@example.com', '$2y$10$hashCuong000000000000000000000000000000000000000003', '78 Lê Lợi, Đà Nẵng'),
('Phạm Thu Dung',  'dung@example.com',  '$2y$10$hashDung0000000000000000000000000000000000000000004', '9 Hai Bà Trưng, TP.HCM'),
('Hoàng Quốc Em',  'em@example.com',    '$2y$10$hashEm000000000000000000000000000000000000000000005', '33 Trần Phú, Hải Phòng');

INSERT INTO orders (customer_id, order_date, status, total, shipping_address) VALUES
(1, '2026-10-01 09:30:00', 'delivered',  225000.00, '12 Giải Phóng, Hà Nội'),
(2, '2026-10-05 14:10:00', 'delivered',  870000.00, '45 Nguyễn Trãi, Hà Nội'),
(3, '2026-10-12 11:00:00', 'shipped',    324000.00, '78 Lê Lợi, Đà Nẵng'),
(1, '2026-11-02 20:45:00', 'pending',    300000.00, '12 Giải Phóng, Hà Nội'),
(4, '2026-11-05 08:15:00', 'delivered',  444000.00, '9 Hai Bà Trưng, TP.HCM'),
(5, '2026-11-08 16:20:00', 'cancelled',  535000.00, '33 Trần Phú, Hải Phòng');

-- subtotal là cột tính nên không cần INSERT
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
(1,1,2, 85000.00), (1,3,1, 55000.00),
(2,5,1,450000.00), (2,8,1,420000.00),
(3,4,1,189000.00), (3,6,1,135000.00),
(4,2,3, 60000.00), (4,7,1,120000.00),
(5,6,1,135000.00), (5,7,1,120000.00), (5,4,1,189000.00),
(6,5,1,450000.00), (6,1,1, 85000.00);

INSERT INTO reviews (book_id, customer_id, rating, comment, review_date) VALUES
(1,1,5,'Đọc xong thấy nhớ tuổi thơ.',          '2026-10-10 10:00:00'),
(3,1,4,'Cảm động, văn phong giản dị.',          '2026-10-11 21:00:00'),
(5,2,5,'Rất hữu ích cho dân lập trình.',        '2026-10-15 09:00:00'),
(8,2,4,'Hay nhưng hơi nặng lý thuyết.',         '2026-10-16 19:30:00'),
(4,3,5,'Góc nhìn mới về lịch sử loài người.',   '2026-10-20 13:00:00'),
(6,3,4,'Cốt truyện cuốn hút.',                  '2026-10-21 22:00:00'),
(4,4,5,'Sách rất đáng đọc.',                    '2026-11-09 08:00:00'),
(6,4,3,'Hơi chậm ở đoạn đầu.',                  '2026-11-09 08:30:00'),
(7,4,4,'Các truyện ngắn rất thú vị.',           '2026-11-10 20:00:00'),
(1,5,4,'Giao hàng nhanh, sách đẹp.',            '2026-11-11 15:00:00');