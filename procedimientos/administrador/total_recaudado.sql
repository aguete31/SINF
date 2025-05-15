USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento para saber cuanto hemos recaudado
-- Seleccionamos los atributos correspondientes de la tabla reserva_compra y los comparamos con
-- la tabla cuesta para poder ir sumando el precio de la localidad correspondiente y así saber 
-- cuanto generamos para cada evento segun las entradas compradas.
CREATE OR REPLACE PROCEDURE TotalRecaudado()
BEGIN
    SELECT 
        rc.NombreEspectaculo,
        rc.TipoEspectaculo,
        rc.Ubicacion,
        rc.FechaInicio,
        COUNT(*) AS EntradasVendidas,
        ROUND(SUM(c.PrecioLocalidad), 2) AS TotalRecaudado
    FROM 
        RESERVA_COMPRA rc
    LEFT JOIN 
        CUESTA c ON rc.UbicacionLocalidad = c.UbicacionLocalidad
               AND rc.NombreEspectaculo = c.NombreEspectaculo
               AND rc.TipoEspectaculo = c.TipoEspectaculo
               AND rc.Ubicacion = c.Ubicacion
               AND rc.FechaInicio = c.FechaInicio
               AND rc.TipoUsuario = c.TipoUsuario
    GROUP BY 
        rc.NombreEspectaculo, rc.TipoEspectaculo, rc.Ubicacion, rc.FechaInicio
    ORDER BY 
        rc.FechaInicio;
END;

//

DELIMITER ;
