# learning sql injection
you've to find the password of an user thanks to the API response

# requirements
- install php 
    - don't forget to enable pdo_mysql
- install mysql
- create database and run `hkg1_sqli_2017-04-03.sql`
- open active.php
    - change password and username by your db credentials
- write on terminal : `php -S localhost:80`

# walkthrough
1. use url to insert injection
2. the web site return 4 types of informations
    - active account
    - suspended account
    - sql error
    - blank when no error
3. try to find the column name with user's password
4. try to use the sql method `length` to find the size of the password
5. stop read solutions and find the password :)