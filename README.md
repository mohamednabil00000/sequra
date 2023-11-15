# README

## Problem statement
We have to implement a system to automate the calculation of merchants’ disbursements payouts and seQura commissions for existing, present in the CSV files, and new orders.

The system must comply with the following requirements:

All orders must be disbursed precisely once.
Each disbursement, the group of orders paid on the same date for a merchant, must have a unique alphanumerical reference.
Orders, amounts, and fees included in disbursements must be easily identifiable for reporting purposes.
The disbursements calculation process must be completed, for all merchants, by 8:00 UTC daily, only including those merchants that fulfill the requirements to be disbursed on that day. Merchants can be disbursed daily or weekly. We will make weekly disbursements on the same weekday as their live_on date (when the merchant started using seQura, present in the CSV files). Disbursements groups all the orders for a merchant in a given day or week.

For each order included in a disbursement, seQura will take a commission, which will be subtracted from the merchant order value gross of the current disbursement, following this pricing:

- 1.00 % fee for orders with an amount strictly smaller than 50 €.
- 0.95 % fee for orders with an amount between 50 € and 300 €.
- 0.85 % fee for orders with an amount of 300 € or more.


Remember that we are dealing with money, so we should be careful with related operations. In this case, we should round up to two decimals following.

Lastly, on the first disbursement of each month, we have to ensure the minimum_monthly_fee for the previous month was reached. The minimum_monthly_fee ensures that seQura earns at least a given amount for each merchant.

When a merchant generates less than the minimum_monthly_fee of orders’ commissions in the previous month, we will charge the amount left, up to the minimum_monthy_fee configured, as “monthly fee”. Nothing will be charged if the merchant generated more fees than the minimum_monthly_fee.

Charging the minimum_monthly_fee is out of the scope of this challenge. It is not subtracted from the disbursement commissions. Just calculate and store it for later usage.


## Breif description of solution
We Just created 4 models(merchants, orders, merchant_disbursements, charged_monthly_fees)
### Merchant Model
We created rake task to read merchants from csv file and persist them in a bulk into merchants table but I added a new column on the fly for live_on_weekday to make it easy when I search for the weekly merchants during calculating their disbursements. 
### Order Model
We created a model task to read orders from csv file and persist them in a bulk into orders table but I added a new column on the fly for commission fee for each order.
### Merchant Disbursement Model
We created a cron job that runs every day at 8:00 am UTC to calculate the disbursements for daily & weekly merchants and persist them into merchant_disbursements table.
### charged_monthly_fees Model
We created a cron job that runs every month at day one 00:00 am UTC to find the merchants that have commissions monthly fees in the previous month less than the minimum monthly fees and persist them into charged_monthly_fees table.

### update_minimum_fees_for_old_orders Method
This method is responsible for update commisions monthly fees for old data imported through csv which we get the first and last date for orders and loop through months between them and update charged_monthly_fees table.

## Statistics results
Year | Number of disbursements	 | Amount disbursed to merchants	 | Amount of order fees	 | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) 
--- | --- | --- | --- |--- |--- 
2022 | 208601 | 38786477.63€ | 347319.36€ | 127 | 2051.76€ 
2023 | 1100422 | 188750380.28€ | 1695618.64€  | 105 | 1751.32€ 


## cron jobs
### disbursements_calculations
This job runs every day at 8:00 am UTC to calculate the disbursements for merchants either daily or weekly.
### minimum_monthly_fees_calculations
This job runs every month at first day at 00:00 am UTC to calcuate the amount should charged from merchants who have commissions fees in the previous month less than the 
 minimum_monthly_fee and persist them into database.


## Tasks
### Import merchants

```
$ rake merchants:import\['csv_file_path'\]

for example

$  rake merchants:import\['/Users/mnabil/sequra/csv_files/merchants.csv'\]
you can find csv example files in csv_files/merchants.csv
```
### Import orders
```
$ rake orders:import\['csv_file_path'\]

```


## Running the Rails console
When the app is already running with `docker-compose` up, attach to the container:
```
$ docker-compose exec app bin/rails c
```
When no container running yet, start up a new one:
```
$ docker-compose run --rm app bin/rails c
```


## Features
* Rails 7
* Ruby 3.2.1
* Dockerfile and Docker Compose configuration
* PostgreSQL database
* Rubocop for linting
* Rspec & Factorybot
* whenever(Need to optimized later to use sidekiq)
* GitHub Actions for
  * tests
  * Rubocop for linting
  * security(Soon)

## Requirements

Please ensure you have docker & docker-compose

https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-to-install-Docker-and-docker-compose-on-Ubuntu

https://dockerlabs.collabnix.com/intermediate/workshop/DockerCompose/How_to_Install_Docker_Compose.html

Check your docker compose version with:
```
% docker compose version
Docker Compose version v1.27.4
```

## Running the Rails app
```
$ cd docker
$ docker-compose build
$ docker-compose up
```


## Author

**Mohamed Nabil**

- <https://www.linkedin.com/in/mohamed-nabil-a184125b>
- <https://github.com/mohamednabil00000>
- <https://leetcode.com/mohamednabil00000/>
