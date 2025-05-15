USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento para poder observar el porcentaje de ocupacion del evento
CREATE OR REPLACE PROCEDURE aforoEvento()
BEGIN
    SELECT
        e.NombreEspectaculo,
        e.TipoEspectaculo,
        e.Ubicacion,
        e.FechaInicio,
        r.AforoMaximo,
        COUNT(rc.UbicacionLocalidad) AS EntradasVendidas,
        ROUND((COUNT(rc.UbicacionLocalidad) / r.AforoMaximo) * 100, 2) AS PorcentajeOcupacion
    FROM
        EVENTO e
    LEFT JOIN
        RECINTO r ON e.Ubicacion = r.Ubicacion
    LEFT JOIN
        RESERVA_COMPRA rc ON e.NombreEspectaculo = rc.NombreEspectaculo 
                         AND e.TipoEspectaculo = rc.TipoEspectaculo 
                         AND e.Ubicacion = rc.Ubicacion 
                         AND e.FechaInicio = rc.FechaInicio
    GROUP BY
        e.NombreEspectaculo, e.TipoEspectaculo, e.Ubicacion, e.FechaInicio, r.AforoMaximo
    ORDER BY
        e.FechaInicio;
END;

//

DELIMITER ;