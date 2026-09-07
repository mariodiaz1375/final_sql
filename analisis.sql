-- Top 5 clientes por gasto total 
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    c.email,
	COALESCE(telefono, 'No especificado'), -- mostramos 'No especificado' si el telefono es nulo
    SUM(p.total) AS gasto_total  -- sumamos el gasto total
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id -- se usa inner join para traer solamente los clientes que hicieron pedidos
WHERE p.estado != 'Cancelado' -- los pedidos cancelados no suman al total, los dejo afuera de la suma
GROUP BY c.cliente_id, c.nombre, c.apellido, c.email  -- agrupamos por cliente
ORDER BY gasto_total DESC -- ordenamos del mayor gasto al menor
LIMIT 5; -- usamos limit 5 para traer el top 5 de clientes

-- Ventas totales por mes (funciones de fecha)
SELECT 
    TO_CHAR(DATE_TRUNC('month', fecha_pedido), 'YYYY-MM') AS mes, -- primero redondeo la fecha al primer dia del mes, luego le doy formato 'YYYY-MM'
    COUNT(pedido_id) AS cantidad_pedidos,  -- contamos la cantidad de pedidos
    SUM(total) AS ingresos_totales		-- sumamos el total
FROM pedidos
WHERE fecha_pedido >= DATE_TRUNC('month', CURRENT_DATE) 						-- filtramos la fecha de los pedidos para que sea mayor o igual al primer dia del mes actual
  AND fecha_pedido <  DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' 	-- y tambien menor al primer dia del mes siguiente
  AND estado != 'Cancelado' -- dejamos afuera del calculo a los pedidos cancelado
GROUP BY mes; -- finalmente agrupamos el conteo y suma de pedidos por el mes para ver la cantidad de pedidos y los ingresos totales del mes


-- 3 productos menos vendidos
SELECT 
    p.producto_id,
    p.nombre AS producto,
    p.precio,
    p.atributos ->> 'marca' AS marca, -- accediendo a la marca de la columna jsonb
    c.nombre AS categoria,
    COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas -- por si fuera nulo al no tener ventas
FROM productos p
INNER JOIN categorias c
    ON p.categoria_id = c.categoria_id
LEFT JOIN detalle_pedido dp		-- en este caso se usa left join para que muestre incluso los productos sin ventas
    ON p.producto_id = dp.producto_id
GROUP BY p.producto_id, p.nombre, p.precio, p.atributos, c.nombre
ORDER BY unidades_vendidas ASC
LIMIT 3;   -- al final limitamos a 3 para ver cuales son los productos menos vendidos


-- Ranking de pedidos por categoría con RANK() (Window Function)
WITH ventas_por_producto AS (  -- se usa una cte para mejor legibilidad
    SELECT 
        c.categoria_id,
        c.nombre AS categoria,
        p.producto_id,
        p.nombre AS producto,
        p.precio,
        p.atributos ->> 'marca' AS marca,   -- accediendo a la marca de la columna jsonb
        COALESCE(SUM(dp.cantidad), 0) AS total_unidades_vendidas,     -- si fuera nulo al no tener ventas
        COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) AS ingresos_totales 	-- si fuera nulo al no tener ventas
    FROM categorias c
    INNER JOIN productos p  -- solo categorias que tienen productos
        ON c.categoria_id = p.categoria_id
    LEFT JOIN detalle_pedido dp   -- incluso mostramos pedidos que no tienen ventas
        ON p.producto_id = dp.producto_id
    LEFT JOIN pedidos ped   -- 
        ON dp.pedido_id = ped.pedido_id AND ped.estado != 'Cancelado'  -- se descartan los pedidos cancelados
    GROUP BY c.categoria_id, c.nombre, p.producto_id, p.nombre, p.precio, p.atributos
),
ranking_por_categoria AS (  --segunda cte: consulta a la primer cte para el ranking
    SELECT 
        categoria,
		producto_id,
        producto,
        marca,
        precio,
        total_unidades_vendidas,
        ingresos_totales,
        RANK() OVER (    -- clasifica los productos dentro de cada categoria
            PARTITION BY categoria_id 
            ORDER BY total_unidades_vendidas DESC, ingresos_totales DESC
        ) AS rank_posicion
    FROM ventas_por_producto
)
SELECT -- consulta final
    categoria,
    rank_posicion,
	producto_id,
    producto,
    marca,
    precio,
    total_unidades_vendidas,
    ingresos_totales
FROM ranking_por_categoria
ORDER BY categoria, rank_posicion ASC; 	-- muestra la categoria y la posicion del producto en orden descendente
										-- podemos saber cuales son los productos mas vendidos de cada categoria 
