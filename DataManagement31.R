
rm(list=ls())
install.packages("readr")
install.packages("RSQLite")
install.packages("dplyr")
install.packages("chron")
install.packages("ggplot2")
library(readr)
library(RSQLite)
library(dplyr)
library(chron)
library(ggplot2)

my_connection <- RSQLite::dbConnect(RSQLite::SQLite(),"e-commerce.db")

RSQLite::dbExecute(my_connection,"
DROP TABLE IF EXISTS Category;
")

RSQLite::dbExecute(my_connection,"
CREATE TABLE IF NOT EXISTS Category(
  category_id VARCHAR(20) PRIMARY KEY NOT NULL,
  category_name VARCHAR (20) NOT NULL,
  parent_id INT,
  parent_name VARCHAR (20)
  );
  ")

RSQLite::dbExecute(my_connection,"
                   DROP TABLE IF EXISTS Customer; 
                   ")

RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Customer(
  customer_id VARCHAR(50) PRIMARY KEY NOT NULL,
  email VARCHAR (100) NOT NULL,
  first_name VARCHAR (100) NOT NULL,
  last_name VARCHAR (100) NOT NULL,
  street_name VARCHAR (100) NOT NULL,
  post_code VARCHAR(64) NOT NULL,
  city VARCHAR (100) NOT NULL,
  password_c VARCHAR (10) NOT NULL, 
  phone_number INT (11) NOT NULL,
  referral_by VARCHAR(20)
  );
  ")

RSQLite::dbExecute(my_connection, "
DROP TABLE IF EXISTS Supplier;
")

RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Supplier (
    seller_id VARCHAR(50) PRIMARY KEY NOT NULL,
    seller_store_name VARCHAR(100),
    supplier_email VARCHAR(255),
    password_s VARCHAR(255),
    receiving_bank VARCHAR(50),
    seller_rating INT,
    seller_phone_number VARCHAR(20),
    seller_address_street VARCHAR(255),
    s_post_code VARCHAR(50),
    s_city VARCHAR(50)
    );
    ")

RSQLite::dbExecute(my_connection, "
DROP TABLE IF EXISTS Warehouse;
")

RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Warehouse (
    warehouse_id VARCHAR(50) PRIMARY KEY NOT NULL,
    capacity INT,
    current_stock INT,
    w_city VARCHAR(50),
    w_post_code VARCHAR(50),
    w_address_street VARCHAR(255)
    );
    ")

RSQLite::dbExecute(my_connection, "
DROP TABLE IF EXISTS Product;
")


RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Product (
  product_id INT PRIMARY KEY NOT NULL,
  product_name VARCHAR(50),
  category_id VARCHAR(20),
  warehouse_id VARCHAR(50),
  seller_id VARCHAR(50),
  product_weight FLOAT,
  product_price FLOAT,
  product_size VARCHAR(20),
  FOREIGN KEY (seller_id) REFERENCES Supplier(seller_id)
  FOREIGN KEY (category_id) REFERENCES Category(category_id),
  FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
  );
  ")

RSQLite::dbExecute(my_connection, "
DROP TABLE IF EXISTS Shipment;
")

RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Shipment (
    shipment_id VARCHAR(50) PRIMARY KEY NOT NULL,
    shipping_method VARCHAR(50),
    shipping_charge FLOAT
    );
")

RSQLite::dbExecute(my_connection, "
DROP TABLE IF EXISTS Orders;
")

RSQLite::dbExecute(my_connection, "
CREATE TABLE IF NOT EXISTS Orders (
    order_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    quantity_of_product_ordered INT,
    payment_method VARCHAR(50),
    voucher_value INT,
    review_rating INT,
    shipment_id VARCHAR(50),
    product_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (order_id, customer_id, product_id),

    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
    );
")

Category <- readr::read_csv("old_data/category_data.csv")
Category$category_id <- as.character(Category$category_id)
Category$parent_id <- as.character(Category$parent_id)


Customer <- readr::read_csv("old_data/customer_data.csv")
Customer$customer_id <- as.character(Customer$customer_id)


Supplier <- readr::read_csv("old_data/supplier_data.csv")
Supplier$seller_id <- as.character(Supplier$seller_id)


Warehouse <- readr::read_csv("old_data/warehouse_data.csv")
Warehouse$warehouse_id <- as.character(Warehouse$warehouse_id)


Product <- readr::read_csv("old_data/product_data.csv")
Product$product_id <- as.character(Product$product_id)
Product$seller_id <- as.character(Product$seller_id)
Product$warehouse_id <- as.character(Product$warehouse_id)
Product$category_id <- as.character(Product$category_id)


Shipment <- readr::read_csv("old_data/shipment_data.csv")
Shipment$shipment_id <- as.character(Shipment$shipment_id)


Orders <- readr::read_csv("old_data/order_data.csv")

Orders$order_date <- as.Date(Orders$order_date, format = "%Y/%m/%d")
Orders$order_date <- as.character(Orders$order_date)
Orders$order_id <- as.character(Orders$order_id)
Orders$customer_id <- as.character(Orders$customer_id)
Orders$product_id <- as.character(Orders$product_id)
Orders$shipment_id <- as.character(Orders$shipment_id)

RSQLite::dbWriteTable(my_connection,"Category",Category,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Customer",Customer,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Supplier",Supplier,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Warehouse",Warehouse,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Product",Product,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Shipment",Shipment,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Orders",Orders,append=TRUE)

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Orders);
")

Category_new <- readr::read_csv("new_data/category_data_new.csv")
Category_new$category_id <- as.character(Category_new$category_id)
Category_new$parent_id <- as.character(Category_new$parent_id)


Customer_new <- readr::read_csv("new_data/customer_data_new.csv")
Customer_new$customer_id <- as.character(Customer_new$customer_id)


Supplier_new <- readr::read_csv("new_data/supplier_data_new.csv")
Supplier_new$seller_id <- as.character(Supplier_new$seller_id)


Warehouse_new <- readr::read_csv("new_data/warehouse_data_new.csv")
Warehouse_new$warehouse_id <- as.character(Warehouse_new$warehouse_id)


Product_new <- readr::read_csv("new_data/product_data_new.csv")
Product_new$product_id <- as.character(Product_new$product_id)
Product_new$seller_id <- as.character(Product_new$seller_id)
Product_new$warehouse_id <- as.character(Product_new$warehouse_id)
Product_new$category_id <- as.character(Product_new$category_id)


Shipment_new <- readr::read_csv("new_data/shipment_data_new.csv")
Shipment_new$shipment_id <- as.character(Shipment_new$shipment_id)


Orders_new <- readr::read_csv("new_data/order_data_new.csv")

Orders_new$order_date <- as.Date(Orders_new$order_date, format = "%Y/%m/%d")
Orders_new$order_date <- as.character(Orders_new$order_date)
Orders_new$order_id <- as.character(Orders_new$order_id)
Orders_new$customer_id <- as.character(Orders_new$customer_id)
Orders_new$product_id <- as.character(Orders_new$product_id)
Orders_new$shipment_id <- as.character(Orders_new$shipment_id)


RSQLite::dbWriteTable(my_connection,"Category",Category_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Customer",Customer_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Supplier",Supplier_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Warehouse",Warehouse_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Product",Product_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Shipment",Shipment_new,append=TRUE)
RSQLite::dbWriteTable(my_connection,"Orders",Orders_new,append=TRUE)


Warehouse <- rbind(Warehouse, Warehouse_new)
Product <- rbind(Product, Product_new)
Customer <- rbind(Customer, Customer_new)
Category <- rbind(Category, Category_new)
Supplier <- rbind(Supplier, Supplier_new)
Orders <- rbind(Orders, Orders_new)
Shipment <- rbind(Shipment, Shipment_new)


RSQLite::dbExecute(my_connection, "
SELECT * FROM Orders;
")

RSQLite::dbExecute(my_connection, "
SELECT * FROM Category
LIMIT 10
")

RSQLite::dbExecute(my_connection, "
SELECT 
    o.order_id,
    o.customer_id,
    SUM(o.quantity_of_product_ordered * (p.product_price - o.voucher_value)) AS total_value,
    s.shipping_charge
FROM 
    Orders o
JOIN 
    Product p ON o.product_id = p.product_id
JOIN 
    Shipment s ON o.shipment_id = s.shipment_id
GROUP BY 
    o.order_id, o.customer_id, s.shipping_charge
ORDER BY 
    total_value DESC;
    ")

RSQLite::dbExecute(my_connection, "
SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity_of_product_ordered) AS total_sold
FROM 
    Orders o
JOIN 
    Product p ON o.product_id = p.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_sold DESC;")

RSQLite::dbExecute(my_connection, "
SELECT 
    c.category_id,
    c.category_name,
    COUNT(o.quantity_of_product_ordered) AS total_sold_unit
FROM 
    Orders o
JOIN 
    Product p ON o.product_id = p.product_id
JOIN 
    Category c ON p.category_id = c.category_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    total_sold_unit DESC;
    ")

top_categ <- RSQLite::dbGetQuery(my_connection,"SELECT 
    pc.category_id AS parent_category_id,
    pc.category_name AS parent_category_name,
    c.category_id,
    c.category_name,
    COUNT(o.quantity_of_product_ordered) AS total_sold_unit
FROM 
    Orders o
JOIN 
    Product p ON o.product_id = p.product_id
JOIN 
    Category c ON p.category_id = c.category_id
JOIN 
    Category pc ON c.parent_id = pc.category_id
GROUP BY 
    pc.category_id, pc.category_name, c.category_id, c.category_name
ORDER BY 
    pc.category_id, total_sold_unit DESC;
")

ggplot(top_categ, aes(x = category_name, y = total_sold_unit, fill = parent_category_name)) +
  geom_bar(stat = "identity") +
  labs(x = "Category", y = "Total Sold Units", title = "Total Sold Units by Category") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_discrete(name = "Parent Category")

# Save the plot as an image
this_filename_date <- as.character(Sys.Date())
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))
ggsave(paste0("figures/Category_Sales_", this_filename_date, "_", this_filename_time, ".png"))

top_parent_categ <- RSQLite::dbGetQuery(my_connection,"
                                        SELECT 
    pc.category_id AS parent_category_id,
    pc.category_name AS parent_category_name,
    SUM(o.quantity_of_product_ordered) AS total_sold_unit
FROM 
    Orders o
JOIN 
    Product p ON o.product_id = p.product_id
JOIN 
    Category c ON p.category_id = c.category_id
JOIN 
    Category pc ON c.parent_id = pc.category_id
GROUP BY 
    pc.category_id, pc.category_name
ORDER BY 
    total_sold_unit DESC;
")

ggplot(top_parent_categ, aes(x = parent_category_name, y = total_sold_unit #, fill = parent_category_name
)) +
  geom_bar(stat = "identity") +
  labs(x = "Parent Category", y = "Total Sold Units", title = "Total Sold Units by Parent Category") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_discrete(name = "Parent Category")

# Save the plot as an image
this_filename_date <- as.character(Sys.Date())
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))
ggsave(paste0("figures/Parent_Category_Sales_", this_filename_date, "_", this_filename_time, ".png"))

top_recommender <- RSQLite::dbGetQuery(my_connection,"SELECT 
    c1.customer_id AS customer_id,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_name,
    COUNT(c2.referral_by) AS referred_number
FROM 
    Customer c1
LEFT JOIN 
    Customer c2 ON c1.customer_id = c2.referral_by
GROUP BY 
    c1.customer_id, c1.first_name, c1.last_name
ORDER BY 
    referred_number DESC
LIMIT 20;
")

ggplot(top_recommender, aes(x = customer_name, y = referred_number)) +
  geom_bar(stat = "identity", fill = "skyblue") +  # Bar plot with skyblue color
  labs(x = "Customer Name", y = "Number of Referrals", title = "Top 20 Recommenders") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip() 

# Save the plot as an image
this_filename_date <- as.character(Sys.Date())
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))
ggsave(paste0("figures/Top_Recommenders_", this_filename_date, "_", this_filename_time, ".png"))


warehouse_data <- data.frame(
  Warehouse_ID = 1:nrow(Warehouse),  # Assuming Warehouse has an ID column
  Capacity = Warehouse$capacity,
  Current_Stock = Warehouse$current_stock
)

# Create the ggplot object
ggplot(warehouse_data, aes(x = Warehouse_ID)) +
  geom_bar(aes(y = Capacity), stat = "identity", fill = "steelblue", alpha = 0.8) +
  geom_bar(aes(y = Current_Stock), stat = "identity", fill = "lightpink", alpha = 0.8) +
  labs(title = "Warehouse Capacity and Current Stock", x = "Warehouse ID", y = "Quantity") +
  theme_minimal() +
  theme(legend.position = "top") +
  scale_fill_manual(values = c("steelblue", "lightpink"), labels = c("Capacity", "Current Stock")) +
  guides(fill = guide_legend(title = "Legend"))

# Save the plot as an image
this_filename_date <- as.character(Sys.Date())
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))
ggsave(paste0("figures/Warehouse_Capacity_", this_filename_date, "_", this_filename_time, ".png"))



# Calculate the mean price
mean_price <- mean(Product$product_price)

# Create the histogram
ggplot(Product, aes(x = product_price)) +
  geom_histogram(binwidth = 1, position = "identity") +
  geom_vline(xintercept = mean_price, linetype = "dotted", color = "darkred") +  # Add the mean line
  labs(x = "Product Price", y = "Frequency", fill = "Category ID",
       title = "Distribution of Product Prices by Category") +
  theme_minimal()


this_filename_date <- as.character(Sys.Date())

# format the Sys.time() to show only hours and minutes 
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))

ggsave(paste0("figures/Product_Price_Distribution_",
              this_filename_date,"_",
              this_filename_time,".png"))



city_counts <- Customer %>%
  group_by(city) %>%
  summarise(num_customers = n())

# Plot the counts
ggplot(city_counts, aes(x = reorder(city, -num_customers), y = num_customers)) +
  geom_bar(stat = "identity") +
  labs(x = "City", y = "Number of Customers",
       title = "Number of Customers in Each City") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

this_filename_date <- as.character(Sys.Date())

# format the Sys.time() to show only hours and minutes 
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))

ggsave(paste0("figures/Customer_Distribution_",
              this_filename_date,"_",
              this_filename_time,".png"))


# Calculate the average rating for each product
class(Orders$review_rating)
Orders$review_rating <- as.numeric(Orders$review_rating)
product_ratings <- Orders %>%
  group_by(product_id) %>%
  summarise(avg_rating = mean(review_rating, na.rm = TRUE))

# Sort products by average rating in descending order
product_ratings <- product_ratings[order(-product_ratings$avg_rating),]

top_products <- product_ratings[product_ratings$avg_rating == 5,]


ggplot(product_ratings, aes(x = reorder(product_id, -avg_rating), y = avg_rating, fill = factor(product_id %in% top_products$product_id))) +
  geom_bar(stat = "identity") +
  labs(x = "Product ID", y = "Average Rating",
       title = "Average Rating for Each Product") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 0)) +
  scale_fill_manual(values = c("grey80", "darkred"), guide = FALSE)

this_filename_date <- as.character(Sys.Date())

# format the Sys.time() to show only hours and minutes 
this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))

ggsave(paste0("figures/Product_Avg_Rating_",
              this_filename_date,"_",
              this_filename_time,".png"))







