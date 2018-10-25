-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    `first_name`, last_name
FROM
    `sakila`.`actor`;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
    lower(CONCAT(first_name, ' ', last_name)) AS Actor_Name
FROM
    actor;
    -- 
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';
        --
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
    -- 
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;
-- 
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    -- 
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter	table actor add description blob;
-- 
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop description;
-- 

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;
-- 
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
having count(last_name)>1
ORDER BY COUNT(last_name) DESC;
-- 
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE `sakila`.`actor`
SET
`first_name` = 'HARPO' 
WHERE first_name= 'GROUCHO' and last_name=' WILLIAMS';
-- 
SELECT 
    first_name, last_name
FROM
    actor
    where first_name= 'harpo';
    -- 
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE `sakila`.`actor`
SET
`first_name` = 'GROUCHO'
WHERE first_name = 'HARPO';

UPDATE actor 
SET 
    first_name = 'harpo'
where first_name='groucho' and (
last_name='sinatra'
or
last_name = 'dunst'
);
-- 
SELECT 
    first_name, last_name
FROM
    actor
    where first_name='harpo';
    -- 

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT 
    first_name, last_name, address
FROM
    staff 
    join address on address.address_id = staff.address_id ;
    -- 
-- lets do this time with subqueries
select address
from address
where address_id in
(SELECT 
    address_id
FROM
    staff)
;
-- 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
    staff_id, SUM(amount), count(amount)
FROM
    payment
group by staff_id;

SELECT 
    s.staff_id, first_name, last_name, SUM(amount)
FROM
    staff s
        JOIN
    payment ON payment.staff_id = s.staff_id
    group by staff_id;
    -- 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;
--
SELECT 
    COUNT(actor_id) as k
FROM
    film_actor
GROUP BY film_id
order by k desc;
--
SELECT 
    f.film_id, title,count(actor_id) as c
FROM
    film f
    join film_actor fa on f.film_id = fa.film_id
group by film_id
order by c desc;
-- 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
    film.film_id,title, COUNT(inventory_id) AS c
FROM
    inventory
join film on film.film_id=inventory.film_id
GROUP BY inventory.film_id
having title like 'Hunchback%';
-- 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT 
    payment.customer_id,first_name, last_name, SUM(amount) AS total
FROM
    payment join customer on payment.customer_id= customer.customer_id
GROUP BY customer_id
ORDER BY total DESC;
-- 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

 
 
 (SELECT 
    title
FROM
    film
WHERE
    ((title LIKE 'K%') OR (title LIKE 'Q%'))
    )
    ;
    -- 

select title from film where language_id in     
(select language_id 
from language 
where name='English'
)
;
-- 
SELECT 
    title
FROM
    film
WHERE
    ((title LIKE 'K%') OR (title LIKE 'Q%'))
        AND language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')
;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor
where actor_id 
in (
select actor_id 
from film_actor
where film_id
in(
select film_id
from film
where title = 'Alone Trip'
));
-- 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT 
    first_name, last_name, email,country
from customer
join address
    on address.address_id = customer.address_id
join city
    on city.city_id = address.city_id
join country
    on country.country_id = city.country_id
where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films. film, film_category
use sakila;
SELECT 
    category.category_id, film_id,name
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
    where name ='Family';
-- 7e. Display the most frequently rented movies in descending order.
SELECT 
    film.film_id,
    title,
   -- inventory.inventory_id,
    COUNT(rental_id)
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
    group by title
    order by count(rental_id) desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    store.store_id, SUM(amount)
FROM
    store
        JOIN
    staff ON store.store_id = staff.store_id
        JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT 
    store_id, city, country
FROM
    store
        JOIN
    address ON store.address_id = address.address_id
        JOIN
    city ON address.city_id = city.city_id
        JOIN
    country ON city.country_id=country.country_id;
-- h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
    category.name, SUM(amount)
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film_category.film_id = film.film_id
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
		join payment on rental.rental_id=payment.rental_id
        group by name
        order by sum(amount) desc
        limit 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view  TopFiveGenres as

SELECT 
    category.name, SUM(amount)
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film_category.film_id = film.film_id
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
		join payment on rental.rental_id=payment.rental_id
        group by name
        order by sum(amount) desc
        limit 5;


-- 8b. How would you display the view that you created in 8a?
select * from TopFiveGenres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view TopFiveGenres;