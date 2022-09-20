-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

select count(film_id)
from inventory
where film_id = (select film_id
from film
where title = 'Hunchback Impossible');

-- 2.List all films whose length is longer than the average of all the films.

select title
from film
where length > (select avg(length)
from film);
    
-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
    
select concat(first_name, ' ' , last_name) as Actor
from actor
where actor_id in (select actor_id
from film
join film_actor using (film_id)
where title = 'Alone Trip');

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title
from film
join film_category using(film_id)
where category_id in(
select category_id
from sakila.category
where name = 'Family');
    
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
select actor_id
from sakila.actor
inner join sakila.film_actor using (actor_id)
inner join sakila.film using (film_id)
group by actor_id
order by count(film_id) desc 
limit 1);


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select title as Movies
from film
where film_id in(
select film_id
from rental
join inventory using (inventory_id)
where customer_id =(
select customer_id
from customer
inner join payment using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1));

-- 8.Customers who spent more than the average payments.

select concat(first_name, ' ', last_name) as 'Customer above average spending'
from customer
join payment using (customer_id)
group by customer_id
having sum(amount) > (
select avg(t1.total)
from
(select sum(amount) as total
from payment
group by customer_id) t1);