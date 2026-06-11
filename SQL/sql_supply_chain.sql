CREATE DATABASE supply_chain_control_tower;
USE supply_chain_control_tower;
SHOW tables; 
RENAME TABLE `dataset_final+api`
TO supply_chain;

SELECT COUNT(*)
FROM supply_chain;

DROP TABLE supply_chain;

SHOW tables;

SELECT COUNT(*)
FROM supply_chain;

DESCRIBE supply_chain;

#Consulta 1: ¿Qué proveedores concentran más gasto de aprovisionamiento?
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend),2) AS total_spend
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_spend DESC
LIMIT 5;

#SUP_7 y SUP_8 destacan claramente por encima del resto de proveedores, acumulando más de 2,7 millones en gasto de aprovisionamiento cada uno. Esto indica que una parte importante de las compras depende de un número reducido de proveedores, algo que conviene tener en cuenta desde el punto de vista del riesgo operativo.

#Consulta 2: ¿QUé almacenes concentran mayor valor de inventario?
SELECT
    warehouse_id,
    ROUND(SUM(inventory_value),2) AS total_inventory_value
FROM supply_chain
GROUP BY warehouse_id
ORDER BY total_inventory_value DESC;

#El análisis muestra diferencias significativas en el valor de inventario entre almacenes. WH_2 concentra más de 12 millones en inventario, mientras que WH_3 se sitúa por debajo de los 10 millones. Esto puede indicar una mayor necesidad de stock en esa ubicación o una posible oportunidad para revisar la distribución del inventario.

#Consulta 3: ¿QUé proveedores presentan mayores lead_time?
SELECT
    supplier_id,
    ROUND(AVG(supplier_lead_time_days),2) AS avg_lead_time
FROM supply_chain
GROUP BY supplier_id
ORDER BY avg_lead_time DESC;

#El análisis de lead time revela diferencias entre proveedores, con valores comprendidos entre 6,96 y 8,64 días. Al cruzar esta información con el gasto de aprovisionamiento, se observa que algunos proveedores estratégicos también presentan tiempos de suministro elevados, lo que incrementa su impacto potencial sobre la disponibilidad de inventario y la continuidad operativa.La monitorización conjunta de gasto y lead time permite priorizar acciones de seguimiento y mitigación de riesgos.

#Consulta 4: ¿Qué regiones tienen mayor cobertura de inventario respecto a la demanda prevista?
SELECT
    region,
    ROUND(AVG(inventory_coverage),2) AS avg_inventory_coverage
FROM supply_chain
GROUP BY region
ORDER BY avg_inventory_coverage DESC;

#La cobertura media de inventario presenta valores muy similares entre regiones, oscilando entre 43,92 y 45,91. Estos resultados sugieren una estrategia de planificación relativamente equilibrada, donde los niveles de inventario se ajustan de forma consistente a la demanda prevista en las distintas áreas geográficas. No se identifican diferencias significativas que indiquen situaciones de sobrestock o riesgo elevado de desabastecimiento a nivel regional.

#Consulta 5: ¿En qué regiones la previsión de demanda es menos precisa?
SELECT
    region,
    ROUND(AVG(abs_forecast_error),2) AS avg_forecast_error
FROM supply_chain
GROUP BY region
ORDER BY avg_forecast_error DESC;

SELECT
    region,
    MIN(abs_forecast_error),
    MAX(abs_forecast_error),
    ROUND(AVG(abs_forecast_error),2)
FROM supply_chain
GROUP BY region;

#El análisis del error absoluto de forecast muestra resultados muy similares entre todas las regiones, con un error medio de aproximadamente 2,38 unidades. Estos resultados indican que la precisión de las previsiones de demanda se mantiene estable a nivel regional, sin evidencias de desviaciones significativas que requieran acciones específicas de planificación o ajuste del modelo de forecast. La homogeneidad observada sugiere una gestión consistente de la previsión de demanda en toda la red logística.

#Consulta 6: ¿Qué proveedores generan más órdenes de reposición?
SELECT
    supplier_id,
    SUM(replenishment_flag) AS total_replenishments
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_replenishments DESC;

#El análisis muestra que los proveedores SUP_7 y SUP_8 concentran el mayor número de órdenes de reposición, con 679 y 567 reposiciones respectivamente. Al comparar estos resultados con el gasto de aprovisionamiento, se observa que los proveedores con mayor volumen de compras también generan una mayor actividad de reabastecimiento. Estos proveedores pueden considerarse estratégicos para la operación y requieren un seguimiento continuo para minimizar riesgos de suministro y garantizar la disponibilidad de inventario.

#Consulta 7: ¿QUé regiones concentran el mayor volumen de demanda?
SELECT
    region,
    ROUND(SUM(units_sold),0) AS total_units_sold
FROM supply_chain
GROUP BY region
ORDER BY total_units_sold DESC;

#La demanda se distribuye de forma muy equilibrada entre las distintas regiones analizadas. Ninguna región concentra una proporción significativamente superior de ventas respecto al resto. Este comportamiento es consistente con los resultados observados previamente en cobertura de inventario y error de forecast, donde tampoco se identificaron diferencias relevantes entre regiones.

#Consulta 8: ¿Qué productos concentran la mayor parte del inventario?
SELECT
    sku_id,
    ROUND(SUM(inventory_value),2) AS total_inventory_value
FROM supply_chain
GROUP BY sku_id
ORDER BY total_inventory_value DESC
LIMIT 10;

#El análisis muestra que ciertos productos concentran una parte significativa del valor total del inventario. SKU_38 destaca como el producto con mayor valor almacenado, superando los 16 millones, mientras que otros productos presentan niveles considerablemente inferiores. Estos resultados sugieren la conveniencia de aplicar estrategias de segmentación y priorización de inventario para focalizar los esfuerzos de gestión sobre los productos con mayor impacto económico.

#Consulta 9: ¿Qué almacenes mantienen mayores niveles de cobertura de inventario?
SELECT
    warehouse_id,
    ROUND(AVG(inventory_coverage),2) AS avg_inventory_coverage
FROM supply_chain
GROUP BY warehouse_id
ORDER BY avg_inventory_coverage DESC;

#El análisis muestra diferencias en la cobertura de inventario entre almacenes. WH_2 presenta la mayor cobertura media, alcanzando 50,65 unidades de cobertura frente a valores cercanos a 43 en otros almacenes. Al combinar esta información con el valor de inventario almacenado, se observa que WH_2 concentra tanto el mayor volumen de stock como la mayor cobertura, lo que lo convierte en un candidato prioritario para futuras iniciativas de optimización de inventario.

#Consulta 10: ¿Qué productos presentan mayores desviaciones entre demanda prevista y demanda real?
SELECT
    sku_id,
    ROUND(AVG(abs_forecast_error),2) AS avg_forecast_error
FROM supply_chain
GROUP BY sku_id
ORDER BY avg_forecast_error DESC
LIMIT 10;

#El error medio de forecast se mantiene muy estable entre los distintos productos analizados, lo que indica que la precisión de las previsiones de demanda es consistente a nivel de SKU. No se identifican productos que presenten desviaciones significativamente superiores al resto, por lo que no parece existir un grupo específico de artículos que requiera una atención especial desde el punto de vista de la planificación de demanda.

#Consulta 11: ¿Qué proveedores representan el mayor riesgo operativo para la cadena de suministro? (mayor volumen de gasto + mayor lead time)
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend),2) AS total_spend,
    ROUND(AVG(supplier_lead_time_days),2) AS avg_lead_time
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_spend DESC;

#El análisis conjunto de gasto y lead time permite identificar proveedores estratégicos con mayor exposición operativa. SUP_8 y SUP_4 destacan por combinar elevados niveles de gasto con tiempos de suministro superiores a la media, lo que incrementa su impacto potencial sobre la continuidad del abastecimiento. Por el contrario, proveedores como SUP_7 y SUP_10 mantienen altos volúmenes de compra con tiempos de suministro relativamente más reducidos, mostrando un perfil operativo más eficiente.

#Consulta 12: ¿Cuál es el impacto totl del tipo de cambio sobre el gasto de aprovisionamiento?
SELECT
    ROUND(SUM(procurement_spend),2) AS total_spend_usd,
    ROUND(SUM(procurement_spend_eur),2) AS total_spend_eur,
    ROUND(SUM(fx_impact),2) AS total_fx_impact
FROM supply_chain;

#La conversión de los costes de aprovisionamiento desde USD a EUR genera una diferencia acumulada de aproximadamente 1,59 millones. Este resultado demuestra que las fluctuaciones del tipo de cambio pueden tener un impacto relevante sobre los costes reportados por una organización con operaciones internacionales. En un entorno multinacional, donde las compras pueden realizarse en una moneda y el reporting financiero efectuarse en otra, el seguimiento del riesgo cambiario resulta fundamental para una correcta planificación financiera.

#Consulta 13: ¿Qué proveedores presentan mayor exposición al tipo de cambio?
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend),2) AS total_spend_usd,
    ROUND(SUM(procurement_spend_eur),2) AS total_spend_eur,
    ROUND(SUM(fx_impact),2) AS total_fx_impact
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_fx_impact DESC;

#Los proveedores que concentran un mayor volumen de compras son también los que generan una mayor exposición al riesgo cambiario. Esto es lógico porque cuanto mayor es el gasto gestionado con un proveedor, mayor es también el efecto acumulado de las variaciones del tipo de cambio sobre los costes reportados. SUP_8 y SUP_7 destacan como los proveedores con mayor impacto financiero derivado de la conversión USD-EUR, superando los 200.000 de impacto cambiario acumulado.