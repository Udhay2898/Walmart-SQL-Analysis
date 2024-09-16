# Walmart SQL Analysis

This project aims to explore the Walmart Sales data to understand top performing branches and products, sales trend of of different products, customer behaviour. The aims is to study how sales strategies can be improved and optimized.

**Purposes Of The Project**
The major aim of thie project is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the different branches.

**About Data**

**Column	                        Description	                                        Data Type**
invoice_id	                    Invoice of the sales made	                            VARCHAR(30)
branch	                        Branch at which sales were made	                        VARCHAR(5)
city	                        The location of the branch	                            VARCHAR(30)
customer_type	                The type of the customer	                            VARCHAR(30)
gender	                        Gender of the customer making purchase	                VARCHAR(10)
product_line	                Product line of the product solf	                    VARCHAR(100)
unit_price	                    The price of each product	                            DECIMAL(10, 2)
quantity	                    The amount of the product sold	                            INT
VAT	                            The amount of tax on the purchase	                    FLOAT(6, 4)
total	                        The total cost of the purchase	                        DECIMAL(10, 2)
date	                        The date on which the purchase was made	                    DATE
time	                        The time at which the purchase was made	                  TIMESTAMP
payment_method	                The total amount paid	                                DECIMAL(10, 2)
cogs	                        Cost Of Goods sold	                                    DECIMAL(10, 2)
gross_margin_percentage	        Gross margin percentage	                                FLOAT(11, 9)
gross_income	                Gross Income	                                        DECIMAL(10, 2)
rating	                        Rating	                                                FLOAT(2, 1)
