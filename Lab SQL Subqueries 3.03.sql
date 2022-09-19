-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(film_id)
FROM inventory
WHERE film_id = (SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible');

-- 2.List all films whose length is longer than the average of all the films.

SELECT title
FROM film
WHERE length > (SELECT avg(length)
FROM film);
    
-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
    
SELECT concat(first_name, ' ' , last_name) as Actor
FROM actor
WHERE actor_id IN (SELECT actor_id
FROM film
join film_actor using (film_id)
where title = 'Alone Trip');

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title
from film
join film_category using(film_id)
where category_id IN(
SELECT category_id
FROM sakila.category
WHERE name = 'Family');
    
-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Subqueries
select  concat(first_name, ' ', last_name) as Name, email
from customer
where address_id in(
select address_id
from address
join city using (city_id)
where country_id = (
select country_id
from country where country = 'Canada'));
  
-- Joins
select concat(first_name, ' ', last_name) as Name, email
from customer
join address using (address_id)
join city using(city_id)
join country using (country_id)
where country = 'Canada';

-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
    
select title as Movies
from film
join film_actor using (film_id) where
actor_id =(
SELECT actor_id
FROM sakila.actor
INNER JOIN sakila.film_actor USING (actor_id)
INNER JOIN sakila.film USING (film_id)
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC 
LIMIT 1);


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select title as Movies
from film
where film_id in(
select film_id
from rental
join inventory using (inventory_id)
where customer_id =(
SELECT customer_id
FROM customer
INNER JOIN payment USING (customer_id)
GROUP BY customer_id
ORDER BY sum(amount) DESC
Limit 1));

-- 8.Customers who spent more than the average payments.

SELECT CONCAT(first_name, ' ', last_name) as 'Customer above average spending'
FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT AVG(t1.total)
FROM
(SELECT SUM(amount) as total
FROM payment
GROUP BY customer_id) t1);