SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
SELECT
-- Amount; ProductID; Name; Single Price
GROUP_CONCAT(DISTINCT "\"", order_list.quantity, ";", produkt.product_number, ";", order_list.label, ";", order_list.unit_price, ";",  "\"" SEPARATOR ',' ) AS order_label,
amount_total AS price_full,
position_price AS price_wo_post,
amount_net AS price_w_post_wo_tax,
shipping_total AS price_shipping,
order.order_date_time,
order_customer.customer_number,
order.order_number,
bill_address.first_name AS bill_first_name,
bill_address.last_name AS bill_last_name,
bill_address.street AS bill_street,
bill_address.zipcode AS bill_zipcode,
bill_address.city AS bill_city,
-- country_bill.name AS bill_country,
-- country_delivery.name AS ERRORbill_country,
LAND.name AS bill_land,
order_customer.email AS bill_email,
delivery_address.first_name AS delivery_first_name,
delivery_address.last_name AS delivery_last_name,
delivery_address.street AS delivery_street,
delivery_address.zipcode AS delivery_zipcode,
delivery_address.city AS delivery_city,
-- country_delivery.name AS country_delivery_name,
LAND2.name AS delivery_land,
order.customer_comment
FROM `order`
INNER JOIN order_customer
  ON order.id = order_customer.order_id
INNER JOIN order_delivery
  ON order.id = order_delivery.order_id
INNER JOIN order_transaction
  ON order.id = order_transaction.order_id
INNER JOIN order_delivery_position
  ON order.id = order_delivery.order_id
  AND order_delivery.id = order_delivery_position.order_delivery_id
INNER JOIN order_line_item AS order_list
  ON order.id = order_list.order_id
LEFT OUTER JOIN product AS produkt
  ON order.id = order_list.order_id AND order_list.product_id = produkt.id
LEFT OUTER JOIN order_address AS delivery_address
  ON order.id = delivery_address.order_id AND delivery_address.id
    IN (SELECT `shipping_order_address_id` FROM order_delivery)
LEFT OUTER JOIN order_address AS bill_address
  ON order.id = bill_address.order_id AND order.billing_address_id = bill_address.id
-- LEFT OUTER JOIN country_translation AS country_delivery
--  ON order.id = delivery_address.order_id AND delivery_address.country_id = country_delivery.country_id AND country_delivery.language_id = 0x8d4d74c6d98c4d59ba7821ec7f7d9cd9
--  IN (SELECT `shipping_order_address_id` FROM order_delivery)

LEFT OUTER JOIN country_translation as LAND
  ON order.billing_address_id = bill_address.id AND bill_address.country_id = LAND.country_id

LEFT OUTER JOIN country_translation as LAND2
  ON order.id = delivery_address.order_id AND delivery_address.country_id = LAND2.country_id

GROUP BY order.id
\G;



SET SESSION FOREIGN_KEY_CHECKS=0;
truncate `order`;
truncate order_address;
truncate order_customer;
truncate order_delivery;
truncate order_delivery_position;
truncate order_line_item;
truncate order_tag;
truncate order_transaction;
truncate customer;
truncate customer_address;
truncate log_entry;
DELETE FROM version_commit_data WHERE entity_name LIKE "order%";
SET SESSION FOREIGN_KEY_CHECKS=1;
