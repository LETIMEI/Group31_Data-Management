library(png)
library(grid)


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


# primary key check for category data
all_files <- list.files("data_upload/Category_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Category_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for customer data
all_files <- list.files("data_upload/Customer_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Customer_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for warehouse data
all_files <- list.files("data_upload/Warehouse_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Warehouse_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for supplier data
all_files <- list.files("data_upload/Supplier_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Supplier_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for product data
all_files <- list.files("data_upload/Product_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Product_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for shipment data
all_files <- list.files("data_upload/Shipment_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Shipment_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

# primary key check for order data
all_files <- list.files("data_upload/Orders_dataset/")
for (variable in all_files) {
  this_filepath <- paste0("data_upload/Orders_dataset/",variable)
  this_file_contents <- readr::read_csv(this_filepath)
  number_of_rows <- nrow(this_file_contents)
  
  print(paste0("Checking for: ",variable))
  
  print(paste0(" is ",nrow(unique(this_file_contents[,1]))==number_of_rows))
}

list_csv_files <- function(folder_path) {
  files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  return(files)
}


folder_table_mapping <- list(
  "Customer_dataset" = "Customer",
  "Supplier_dataset" = "Supplier",
  "Category_dataset" = "Category",
  "Product_dataset" = "Product",
  "Orders_dataset" = "Orders",
  "Warehouse_dataset" = "Warehouse",
  "Shipment_dataset" = "Shipment"
)


convert_column_types <- function(data, column_types) {
  for (col_name in names(column_types)) {
    if (col_name %in% names(data)) {
      col_type <- column_types[[col_name]]
      if (col_type == "character") {
        data[[col_name]] <- as.character(data[[col_name]])
      } else if (col_type == "date") {
        data[[col_name]] <- as.Date(data[[col_name]], format = "%Y/%m/%d")
        data[[col_name]] <- as.character(data[[col_name]])
      }
    }
  }
  return(data)
}

# Data type mapping for each table's columns
column_types_mapping <- list(
  "Category" = c("category_id" = "character", "parent_id" = "character"),
  "Customer" = c("customer_id" = "character", "referral_by" = "character"),
  "Supplier" = c("seller_id" = "character"),
  "Warehouse" = c("warehouse_id" = "character"),
  "Product" = c("product_id" = "character", "seller_id" = "character", 
                "warehouse_id" = "character", "category_id" = "character"),
  "Shipment" = c("shipment_id" = "character"),
  "Orders" = c("order_id" = "character", "customer_id" = "character", 
               "product_id" = "character", "shipment_id" = "character",
               "order_date" = "date")
)

# Path to the main folder containing subfolders (e.g., data_upload)
main_folder <- "data_upload"

# Process each subfolder (table)
for (folder_name in names(folder_table_mapping)) {
  folder_path <- file.path(main_folder, folder_name)
  if (dir.exists(folder_path)) {
    cat("Processing folder:", folder_name, "\n")
    # List CSV files in the subfolder
    csv_files <- list_csv_files(folder_path)
    
    # Get the corresponding table name from the mapping
    table_name <- folder_table_mapping[[folder_name]]
    
    # Append data from CSV files to the corresponding table
    for (csv_file in csv_files) {
      cat("Appending data from:", csv_file, "\n")
      tryCatch({
        # Read CSV file
        file_contents <- readr::read_csv(csv_file)
        
        # Convert column data types
        file_contents <- convert_column_types(file_contents, column_types_mapping[[table_name]])
        
        # Append data to the table in SQLite
        RSQLite::dbWriteTable(my_connection, table_name, file_contents, append = TRUE)
        cat("Data appended to table:", table_name, "\n")
      }, error = function(e) {
        cat("Error appending data:", csv_file, "\n")
        cat("Error message:", e$message, "\n")
      })
    }
  } else {
    cat("Folder does not exist:", folder_path, "\n")
  }
}

# List tables to confirm data appending
tables <- RSQLite::dbListTables(my_connection)
print(tables)


# double check data type, column names, primary key, and not null rule again
RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Orders);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Customer);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Warehouse);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Supplier);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Shipment);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Product);
")

RSQLite::dbExecute(my_connection, "
PRAGMA table_info(Category);
")


Customer <- dbGetQuery(my_connection, "SELECT * FROM Customer")
Supplier <- dbGetQuery(my_connection, "SELECT * FROM Supplier")
Warehouse <- dbGetQuery(my_connection, "SELECT * FROM Warehouse")
Product <- dbGetQuery(my_connection, "SELECT * FROM Product")
Orders <- dbGetQuery(my_connection, "SELECT * FROM Orders")
Shipment <- dbGetQuery(my_connection, "SELECT * FROM Shipment")
Category <- dbGetQuery(my_connection, "SELECT * FROM Category")


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


Orders$order_date <- as.Date(Orders$order_date)
Orders$quantity_of_product_ordered <- as.numeric(Orders$quantity_of_product_ordered)

agg_data <- Orders %>%
  group_by(order_date) %>%
  summarise(total_quantity = sum(quantity_of_product_ordered))

# Plot using ggplot
ggplot(agg_data, aes(x = order_date, y = total_quantity)) +
  geom_line(stat = "identity", color = "steelblue") +
  labs(x = "Order Date", y = "Total Quantity Ordered", title = "Number of Products Ordered per Day")

this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))

ggsave(paste0("figures/Quantity_Ordered_Trend_",
              this_filename_date,"_",
              this_filename_time,".png"))

Product$product_id <- as.character(Product$product_id)
Orders$product_id <- as.character(Orders$product_id)
Product$category_id <- as.character(Product$category_id)
Category$category_id <- as.character(Category$category_id)
Category$parent_id <- as.character(Category$parent_id)


Category <- Category %>%
  left_join(Category, by = c("parent_id" = "category_id"), suffix = c("", "_parent"))

# Create the parent_name column based on the join result
Category <- Category %>%
  mutate(parent_name = ifelse(is.na(parent_id), NA, category_name_parent)) %>%
  select(category_id, category_name, parent_id, parent_name)

sales_data <- Orders %>%
  inner_join(Product, by = "product_id") %>%
  inner_join(Category, by = "category_id") %>%
  group_by(order_date, parent_id, parent_name) %>%
  summarise(units_sold = sum(quantity_of_product_ordered))

ggplot(sales_data, aes(x = order_date, y = units_sold, color = parent_name)) +
  geom_line() +
  labs(x = "Order Date", y = "Units Sold", title = "Units Sold by Parent Category Across Time") +
  scale_color_discrete(name = "Parent Category")

this_filename_time <- as.character(format(Sys.time(), format = "%H_%M"))

ggsave(paste0("figures/Quantity_Ordered_Trend_by_ParentCategory_",
              this_filename_date,"_",
              this_filename_time,".png"))
