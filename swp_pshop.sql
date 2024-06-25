CREATE DATABASE IF NOT EXISTS swp_pshop;

USE swp_pshop;

CREATE TABLE typeAccount (
    typeAccountId INT AUTO_INCREMENT PRIMARY KEY,
    typeAccountName VARCHAR(255) NOT NULL
);

INSERT INTO typeAccount (typeAccountName) VALUES ('user'), ('admin'), ('employee');

CREATE TABLE users (
    userID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    userDOB VARCHAR(255) DEFAULT '1999-01-01',
    password VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phoneNumber VARCHAR(20),
    gender BOOLEAN DEFAULT true,
    address VARCHAR(255),
    avatar VARCHAR(255) DEFAULT 'https://www.w3schools.com/howto/img_avatar.png',
    description TEXT,
    typeAccountId INT DEFAULT 1,
    idFacebook VARCHAR(255),
    idGoogle VARCHAR(255),
    status BOOLEAN DEFAULT 0,
    token VARCHAR(255),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (typeAccountId) REFERENCES typeAccount(typeAccountId)
);

INSERT INTO users (name, password, email, typeAccountId, status) VALUES ('admin', '086bcce1a45148452e10d600038380617447e9786feeb3e6ea50168770dd2af0', 'admin@admin.com', (SELECT typeAccountId FROM typeAccount WHERE typeAccountName = 'admin'), true);



CREATE TABLE typeProduct (
    typeProductId INT AUTO_INCREMENT PRIMARY KEY,
    typeProductName VARCHAR(255) NOT NULL,
    describeType TEXT,
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE size (
    sizeId INT AUTO_INCREMENT PRIMARY KEY,
    sizeName VARCHAR(255) NOT NULL,
    describeSize TEXT,
    weight VARCHAR(255),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE trademark (
    trademarkId INT AUTO_INCREMENT PRIMARY KEY,
    trademarkName VARCHAR(255) NOT NULL,
    logo VARCHAR(255),
    descriptionTrademark TEXT,
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(255) NOT NULL,
    img VARCHAR(255), 
    img1 VARCHAR(255),
    img2 VARCHAR(255),
    img3 VARCHAR(255),
    priceProduct int DEFAULT 0,
    typeProductId INT,
    sizeId INT,
    trademarkId INT,
    quantity INT DEFAULT 0,
    describeProduct TEXT,
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status BOOLEAN DEFAULT 1,
    FOREIGN KEY (typeProductId) REFERENCES typeProduct(typeProductId),
    FOREIGN KEY (sizeId) REFERENCES size(sizeId),
    FOREIGN KEY (trademarkId) REFERENCES trademark(trademarkId)
);

CREATE TABLE product_sizes (
    productId INT,
    sizeId INT,
    PRIMARY KEY (productId, sizeId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (sizeId) REFERENCES size(sizeId)
);

CREATE TABLE discount (
    discountId INT PRIMARY KEY AUTO_INCREMENT,
    discountPercentage DECIMAL(5, 2) NOT NULL CHECK (discountPercentage BETWEEN 0 AND 100),
    startDate DATE,
    endDate DATE,
    status BOOLEAN DEFAULT 1,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE product_discount (
    productId INT,
    discountId INT,
    PRIMARY KEY (productId, discountId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (discountId) REFERENCES discount(discountId)
);

CREATE TABLE payment (
    paymentId INT AUTO_INCREMENT PRIMARY KEY,
    typePayment VARCHAR(255) NOT NULL
);

CREATE TABLE voucher (
    code VARCHAR(255) PRIMARY KEY,
    sale DECIMAL(5, 2) NOT NULL,
    regulationNo VARCHAR(255),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE transport (
    transportId INT AUTO_INCREMENT PRIMARY KEY,
    transportName VARCHAR(255) NOT NULL,
    priceTransPort DECIMAL(10, 2) NOT NULL,
    descriptionTransport TEXT
);

CREATE TABLE billSale (
    billSaleId INT AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    statusBillSale VARCHAR(255) NOT NULL,
    voucherCode VARCHAR(255),
    vat DECIMAL(5, 2) NOT NULL,
    transportId INT,
    paymentId INT,
    employeeId INT,
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employeeId) REFERENCES users(userID),
    FOREIGN KEY (userID) REFERENCES users(userID),
    FOREIGN KEY (voucherCode) REFERENCES voucher(code),
    FOREIGN KEY (transportId) REFERENCES transport(transportId),
    FOREIGN KEY (paymentId) REFERENCES payment(paymentId)
);

CREATE TABLE billDetail (
    billDetailId INT AUTO_INCREMENT,
    productId INT,
    quantity INT NOT NULL,
    billSaleId INT,
    priceBillDetail DECIMAL(10, 2),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (billDetailId, productId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (billSaleId) REFERENCES billSale(billSaleId)
);

CREATE TABLE review (
    reviewId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    userID INT,
    startQuantity INT NOT NULL,
    content TEXT,
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (userID) REFERENCES users(userID)
);

CREATE TABLE carts (
    cartId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE cart_items (
    cartItemId INT AUTO_INCREMENT PRIMARY KEY,
    cartId INT,
    productId INT,
    quantity INT NOT NULL,
    discountId INT,
    priceAfterDiscount INT,
    FOREIGN KEY (cartId) REFERENCES carts(cartId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (discountId) REFERENCES discount(discountId)
);
