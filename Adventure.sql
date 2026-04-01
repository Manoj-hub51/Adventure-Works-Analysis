create database Adventure;
use Adventure;
-- Data Cleaning

select count(*)
from factinternetsales;



select * from factinternetsales;
desc factinternetsales;
alter table FactInternetSales
modify UnitPrice decimal(10,2),
modify ExtendedAmount decimal(10,2),
modify DiscountAmount decimal(10,2),
modify SalesAmount decimal(10,2),
modify TaxAmt decimal(10,2),
modify Freight decimal(10,2),
modify ProductStandardCost decimal(10,4),
modify TotalProductCost decimal(10,4),
modify UnitPriceDiscountPct decimal(5,4);

set sql_safe_updates=0;
alter table factinternetsales  add Orderdate_new date;
update factinternetsales  set Orderdate_new= date_add('1899-12-30', interval OrderDate day);
alter table factinternetsales  drop column OrderDate;
alter table factinternetsales  add Duedate_new date;
update factinternetsales  set Duedate_new= date_add('1899-12-30', interval DueDate day);
alter table factinternetsales  drop column DueDate;
alter table factinternetsales  add Shipdate_new date;
update factinternetsales  set Shipdate_new= date_add('1899-12-30', interval ShipDate day);
alter table factinternetsales  drop column ShipDate;
select * from factinternetsales;

desc fact_internet_sales_new;
alter table fact_internet_sales_new
modify UnitPrice decimal(10,2),
modify ExtendedAmount decimal(10,2),
modify DiscountAmount decimal(10,2),
modify SalesAmount decimal(10,2),
modify TaxAmt decimal(10,2),
modify Freight decimal(10,2),
modify ProductStandardCost decimal(10,4),
modify TotalProductCost decimal(10,4),
modify UnitPriceDiscountPct decimal(5,4);

alter table fact_internet_sales_new add Orderdate_new date;
update fact_internet_sales_new set Orderdate_new= date_add('1899-12-30', interval OrderDate day);
alter table fact_internet_sales_new drop column OrderDate;
alter table fact_internet_sales_new add Duedate_new date;
update fact_internet_sales_new set Duedate_new= date_add('1899-12-30', interval DueDate day);
alter table fact_internet_sales_new drop column DueDate;
alter table fact_internet_sales_new add Shipdate_new date;
update fact_internet_sales_new set Shipdate_new= date_add('1899-12-30', interval ShipDate day);
alter table fact_internet_sales_new drop column ShipDate;
select * from fact_internet_sales_new;

desc dimcustomer;
alter table DimCustomer add BirthDate_new date;
update DimCustomer set BirthDate_new = date_add('1899-12-30', interval BirthDate day);
alter table DimCustomer drop column BirthDate;
alter table DimCustomer add DateFirstPurchase_new date;
update DimCustomer set DateFirstPurchase_new = date_add('1899-12-30', interval DateFirstPurchase day);
alter table DimCustomer drop column DateFirstPurchase;
alter table DimCustomer modify HouseOwnerFlag bit;
select * from dimcustomer;

desc dimproduct;
select productsubcategorykey from dimproduct where productsubcategorykey regexp'[^0-9]';
select count(*) from dimproduct where productsubcategorykey= '';
update dimproduct set productsubcategorykey= null where productsubcategorykey= '';
alter table dimproduct modify productsubcategorykey int;
alter table dimproduct
change Unit0price UnitPrice text;
select UnitPrice from dimproduct where UnitPrice regexp'[^0-9.]';
update dimproduct set UnitPrice= null where trim(UnitPrice)= '';
alter table dimproduct modify UnitPrice decimal(10,2);
select StandardCost from dimproduct where StandardCost regexp'[^0-9.]';
update dimproduct set StandardCost= null where trim(StandardCost)= '';
alter table dimproduct modify StandardCost decimal(10,2);
select ListPrice from dimproduct where ListPrice regexp'[^0-9.]';
update dimproduct set ListPrice= null where trim(ListPrice)= '';
alter table dimproduct modify ListPrice decimal(10,2);
select DealerPrice from dimproduct where DealerPrice regexp'[^0-9.]';
update dimproduct set DealerPrice= null where trim(DealerPrice)= '';
alter table dimproduct modify DealerPrice decimal(10,2);
select Weight from dimproduct where Weight regexp'[^0-9.]';
update dimproduct set Weight= null where trim(Weight)= '';
alter table dimproduct modify Weight decimal(10,2);
alter table dimproduct add StartDate_new date;
update dimproduct set StartDate_new = date_add('1899-12-30', interval StartDate day);
alter table dimproduct drop column StartDate;
alter table dimproduct add EndDate_new date;
update dimproduct set EndDate_new = date_add('1899-12-30', interval EndDate day);
alter table dimproduct drop column EndDate;
update dimproduct set EndDate_new= null where EndDate_new= '1899-12-30';
select * from dimproduct;

desc dimproductsubcategory;
alter table dimproductsubcategory
modify productsubcategorykey int primary key;

desc dimproductcategory;
alter table dimproductcategory
modify productcategorykey int primary key;

desc dimsalesterritory;
alter table dimsalesterritory
modify salesterritorykey int primary key;

desc dimdate;

-- Task 0
create table sales as
select * from factinternetsales 
union all
select * from fact_internet_sales_new;
select * from sales;

-- Task 1
select * from dimproduct;
select s.*, p.englishproductname as productname
from sales s
left join dimproduct p
on s.productkey = p.productkey;

-- Task 2
select * from dimcustomer;
update dimcustomer set MiddleName = NULL where MiddleName = '';
select s.*,
concat_ws(' ', c.FirstName, c.MiddleName, c.LastName) as CustomerFullName,
p.EnglishProductName as ProductName, 
p.UnitPrice as UnitPrice1
from sales s 
left join dimcustomer c
on s.CustomerKey = c.CustomerKey
left join dimproduct p
on s.ProductKey = p.ProductKey;

-- Task 3
select OrderDateKey,
str_to_date(OrderDateKey, '%Y%m%d') as OrderDate1,
year(str_to_date(OrderDateKey, '%Y%m%d')) as `Year`,
month(str_to_date(OrderDateKey, '%Y%m%d')) as MonthNo,
monthname(str_to_date(OrderDateKey, '%Y%m%d')) as `MonthName`,
concat('Q', quarter(str_to_date(OrderDateKey, '%Y%m%d'))) as Quarter,
date_format(str_to_date(OrderDateKey, '%Y%m%d'),'%Y-%b') as YearMonth,
weekday(str_to_date(OrderDateKey, '%Y%m%d')) +1 as WeekDayNo,
dayname(str_to_date(OrderDateKey, '%Y%m%d'))  as WeekDayName,
case when month(str_to_date(OrderDateKey, '%Y%m%d')) >= 4
then concat('FM',month(str_to_date(OrderDateKey, '%Y%m%d')) - 3)
else concat('FM',month(str_to_date(OrderDateKey, '%Y%m%d')) + 9)
end as FinancialMonth,
case when month(str_to_date(OrderDateKey, '%Y%m%d')) between 4 and 6 then 'FQ1'
when month(str_to_date(OrderDateKey, '%Y%m%d')) between 7 and 9 then 'FQ2'
when month(str_to_date(OrderDateKey, '%Y%m%d')) between 10 and 12 then 'FQ3'
else 'FQ4'
end as FinancialQuarter
from sales;

-- Task 4 (Sales column)
select s.salesordernumber, s.unitprice, s.orderquantity, s.unitpricediscountpct, 
s.unitprice * s.orderquantity * (1 - s.unitpricediscountpct) as salesamount_calc
from sales s;

-- Task 5 (Cost column)
select s.productkey, p.standardcost, s.orderquantity , p.standardcost * s.orderquantity as productioncost
from sales s
left join dimproduct p
on s.productkey = p.productkey;

-- Task 6
select s.productkey, s.unitprice, s.orderquantity, s.unitpricediscountpct, p.standardcost,
(s.unitprice * s.orderquantity * (1 - s.unitpricediscountpct)) - (p.standardcost * s.orderquantity) as profit
from sales s
left join dimproduct p
on s.productkey = p.productkey;

-- Task 7
select year(orderdate_new) as `year`,
monthname(orderdate_new) as `Month`,
sum(salesamount) as Totalsales
from sales
where year(orderdate_new) = 2013
group by year(orderdate_new), month(orderdate_new), monthname(orderdate_new)
order by month(orderdate_new);

-- Task 8
select year(orderdate_new) as `year`,
sum(salesamount) as Yearlysales
from sales
group by year(orderdate_new)
order by `year`;

-- Task 9
select date_format(orderdate_new, '%Y-%m') as yearmonth,
sum(salesamount) as monthly_sales
from sales group by yearmonth
order by yearmonth;

-- Task 10
select concat('Q', quarter(orderdate_new)) as `quarter`,
sum(salesamount) as quarter_sales
from sales group by `quarter` order by `quarter`;

-- Task 11
select year(s.orderdate_new) as `year`,
sum(s.salesamount) as total_sales,
sum(p.standardcost * s.orderquantity) as total_production_cost
from sales s
left join dimproduct p on s.productkey = p.productkey
group by `year`
order by `year`;

-- Task 12
-- KPIs
select sum(s.salesamount) as Total_sales, sum((s.unitprice * s.orderquantity * (1 - s.unitpricediscountpct)) - (p.standardcost * s.orderquantity)) as Total_profit,sum(s.orderquantity) as Units_sold
from sales s join dimproduct p on s.productkey=p.productkey;
select count(customerkey) as Total_customers from dimcustomer;
select sum(s.salesamount)/count(distinct c.customerkey) as Avg_sales_per_customer
from sales s join dimcustomer c on s.customerkey=c.customerkey;

-- Trend
select year(orderdate_new) as `year`,
sum(salesamount) as Yearlysales
from sales
group by year(orderdate_new)
order by `year`;

select date_format(orderdate_new, '%Y-%m') as yearmonth,
sum(salesamount) as monthly_sales
from sales group by yearmonth
order by yearmonth;

select concat('Q', quarter(orderdate_new)) as `quarter`,
sum(salesamount) as quarter_sales
from sales group by `quarter` order by `quarter`;

select 
case when dayofweek(OrderDate) in (1,7) then 'Weekend' else 'Weekday' end as DayType,
sum(SalesAmount) as TotalSales
from sales
group by DayType;

-- Product
select * from dimproduct;
select p.EnglishProductName, sum(s.SalesAmount) as TotalSales
from sales s join dimproduct p on s.Productkey = p.Productkey
group by p.EnglishProductName
order by TotalSales desc
limit 10; 
# Top 10 products by sales

select * from dimproductsubcategory;
select b.EnglishProductSubCategoryName,
sum(s.SalesAmount) as TotalSales
from sales s join dimproduct p on s.productkey=p.productkey
join dimproductsubcategory b on p.productsubcategorykey=b.productsubcategorykey
group by b.EnglishProductSubCategoryName
order by TotalSales desc
limit 5;  # Top 5 subcategory by sales

-- Region
select * from sales;
select t.salesterritorycountry, sum(s.salesamount) as total_sales
from sales s join dimsalesterritory t on s.salesterritorykey=t.salesterritorykey
group by t.salesterritorycountry order by total_sales;

-- Customer
select * from dimcustomer;
select concat_ws(' ', c.FirstName, c.MiddleName, c.LastName) as CustomerName,
sum(s.salesamount) as total_sales 
from sales s join dimcustomer c on s.customerkey=c.customerkey
group by CustomerName order by total_sales desc limit 10; # Top 10 customers

select Gender, count(*) as CustomerCount
from dimcustomer
group by Gender; # Gender Distribution

select 
case when timestampdiff(year, BirthDate_new, DateFirstPurchase_new) < 25 then 'Under 25'
when timestampdiff(year, BirthDate_new, DateFirstPurchase_new) between 25 and 34 then '25-34'
when timestampdiff(year, BirthDate_new, DateFirstPurchase_new) between 35 and 44 then '35-44'
when timestampdiff(year, BirthDate_new, DateFirstPurchase_new) between 45 and 54 then '45-54'
else '55+'
end as AgeGroup,
count(*) as CustomerCount
from dimcustomer
group by AgeGroup; #Age distribution

select  
case
when YearlyIncome < 30000 then '0-30k'
when YearlyIncome between 30000 and 60000 then '30k-60k'
when YearlyIncome between 60000 and 90000 then '60k-90k'
when YearlyIncome between 90000 and 120000 then '90k-120k'
when YearlyIncome between 120000 and 150000 then '120k-150k'
else '150k+' end as IncomeGroup,
count(*) as CustomerCount
from dimcustomer
group by IncomeGroup; #Income distribution










