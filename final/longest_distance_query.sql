/* 

In this query, we find the true origin city and true destination city for each order
just like we did in airspace_data_engineer.ipynb. Then, we join the table with the 
start_addresses and end_addresses tables. We then have the longitudes and latitudes
of the origin city and destination city of each order. Using the Euclidean distance,
we compute the total distance between the pickup and delivery locations of each order
and return the greatest distance.

*/

SELECT
  temp.order_id,
  temp.origin_city as origin_city,
  ea.city as destination_city,
  ((ea.lat - temp.start_lat)^2 + (ea.lng - temp.start_lng)^2)^.5 as distance,
  temp.start_lat as origin_lat, 
  temp.start_lng as origin_lng,
  ea.lat as destination_lat,
  ea.lng as destination_lng
FROM (
  SELECT 
    drs.order_id,
    drs.start_address_id, 
    drs.end_address_id,
    sa.city as origin_city,
    sa.lat as start_lat, 
    sa.lng as start_lng
  FROM (
    SELECT 
      order_id, 
      MIN(start_address_id) as start_address_id,
      MAX(end_address_id) as end_address_id
    FROM delivery_route_segments
    GROUP BY order_id
    ORDER BY order_id DESC) 
    as drs
  INNER JOIN start_addresses as sa
  ON (drs.start_address_id=sa.id)) 
  as temp
INNER JOIN end_addresses as ea
ON (temp.end_address_id=ea.id)
ORDER BY distance DESC LIMIT 1