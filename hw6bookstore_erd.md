# Bookstore Database: ERD

## Sơ đồ quan hệ

```
publishers ||--o{ books            : "xuất bản"        (1:N)
authors    }o--o{ books            : "viết"            (M:N qua book_authors)
categories }o--o{ books            : "phân loại"       (M:N qua book_categories)
categories ||--o{ categories       : "thể loại con"    (1:N, tự tham chiếu)
customers  ||--o{ orders           : "đặt"             (1:N)
orders     ||--|{ order_items      : "gồm"             (1:N)
books      ||--o{ order_items      : "được bán trong"  (1:N)
customers  ||--o{ reviews          : "viết"            (1:N)
books      ||--o{ reviews          : "được đánh giá"   (1:N)
```

┌────────────┐ 1 N ┌──────────┐ N M ┌───────────┐
│ publishers │─────────│ books │─────────│ authors │
└────────────┘ └──────────┘ (qua └───────────┘
│ │ book_authors)
1:N │ │ N:M (qua book_categories)
│ └──────────────┐
┌────┴─────┐ ┌─────┴──────┐
│ reviews │ │ categories │
└──────────┘ └────────────┘

## Các thực thể

### publishers

| Cột          | Kiểu                 | Khóa |
| ------------ | -------------------- | ---- |
| publisher_id | INT AUTO_INCREMENT   | PK   |
| name         | VARCHAR(150), UNIQUE |      |
| address      | VARCHAR(255)         |      |
| website      | VARCHAR(255)         |      |

### authors

| Cột         | Kiểu               | Khóa |
| ----------- | ------------------ | ---- |
| author_id   | INT AUTO_INCREMENT | PK   |
| full_name   | VARCHAR(120)       |      |
| biography   | TEXT               |      |
| nationality | VARCHAR(60)        |      |

### categories

| Cột                | Kiểu                | Khóa                        |
| ------------------ | ------------------- | --------------------------- |
| category_id        | INT AUTO_INCREMENT  | PK                          |
| name               | VARCHAR(80), UNIQUE |                             |
| description        | VARCHAR(255)        |                             |
| parent_category_id | INT, NULL           | FK → categories.category_id |

### books

| Cột              | Kiểu               | Khóa                         |
| ---------------- | ------------------ | ---------------------------- |
| book_id          | INT AUTO_INCREMENT | PK                           |
| isbn             | CHAR(13), UNIQUE   |                              |
| title            | VARCHAR(200)       |                              |
| publisher_id     | INT                | FK → publishers.publisher_id |
| price            | DECIMAL(10,2), > 0 |                              |
| stock            | INT, >= 0          |                              |
| publication_date | DATE               |                              |

### book_authors (bảng trung gian M:N)

| Cột       | Khóa             |
| --------- | ---------------- |
| book_id   | PK, FK → books   |
| author_id | PK, FK → authors |

### book_categories (bảng trung gian M:N)

| Cột         | Khóa                |
| ----------- | ------------------- |
| book_id     | PK, FK → books      |
| category_id | PK, FK → categories |

### customers

| Cột           | Kiểu                 | Khóa |
| ------------- | -------------------- | ---- |
| customer_id   | INT AUTO_INCREMENT   | PK   |
| full_name     | VARCHAR(120)         |      |
| email         | VARCHAR(150), UNIQUE |      |
| password_hash | VARCHAR(255)         |      |
| address       | VARCHAR(255)         |      |
| created_at    | DATETIME             |      |

### orders

| Cột              | Kiểu                                                     | Khóa                       |
| ---------------- | -------------------------------------------------------- | -------------------------- |
| order_id         | INT AUTO_INCREMENT                                       | PK                         |
| customer_id      | INT                                                      | FK → customers.customer_id |
| order_date       | DATETIME                                                 |                            |
| status           | ENUM(pending, processing, shipped, delivered, cancelled) |                            |
| total            | DECIMAL(12,2)                                            |                            |
| shipping_address | VARCHAR(255)                                             |                            |

### order_items

| Cột           | Kiểu                                            | Khóa                 |
| ------------- | ----------------------------------------------- | -------------------- |
| order_item_id | INT AUTO_INCREMENT                              | PK                   |
| order_id      | INT                                             | FK → orders.order_id |
| book_id       | INT                                             | FK → books.book_id   |
| quantity      | INT, > 0                                        |                      |
| unit_price    | DECIMAL(10,2)                                   |                      |
| subtotal      | DECIMAL(12,2), cột tính = quantity × unit_price |                      |

UNIQUE (order_id, book_id)

### reviews

| Cột         | Kiểu               | Khóa                       |
| ----------- | ------------------ | -------------------------- |
| review_id   | INT AUTO_INCREMENT | PK                         |
| book_id     | INT                | FK → books.book_id         |
| customer_id | INT                | FK → customers.customer_id |
| rating      | TINYINT, 1..5      |                            |
| comment     | TEXT               |                            |
| review_date | DATETIME           |                            |

UNIQUE (book_id, customer_id)

## Bảng cardinality

| Quan hệ                 | Cardinality | Cách cài đặt        |
| ----------------------- | ----------- | ------------------- |
| publishers – books      | 1:N         | books.publisher_id  |
| books – authors         | M:N         | book_authors        |
| books – categories      | M:N         | book_categories     |
| categories – categories | 1:N         | parent_category_id  |
| customers – orders      | 1:N         | orders.customer_id  |
| orders – books          | M:N         | order_items         |
| customers – reviews     | 1:N         | reviews.customer_id |
| books – reviews         | 1:N         | reviews.book_id     |
