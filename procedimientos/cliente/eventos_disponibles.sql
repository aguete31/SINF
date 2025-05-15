USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento destinado a consultar los eventos disponibles
CREATE OR REPLACE PROCEDURE eventosDisponibles()
BEGIN
    SELECT
        e.NombreEspectaculo,
        e.TipoEspectaculo,
        e.Ubicacion,
        e.FechaInicio,
        r.Nombre AS NombreRecinto,
        esp.Descripcion,
        esp.DuracionEspectaculo
    FROM EVENTO e
    LEFT JOIN RECINTO r ON e.Ubicacion = r.Ubicacion
    LEFT JOIN ESPECTACULO esp ON e.NombreEspectaculo = esp.NombreEspectaculo
                             AND e.TipoEspectaculo = esp.TipoEspectaculo
    GROUP BY
        e.NombreEspectaculo,
        e.TipoEspectaculo,
        e.Ubicacion,
        e.FechaInicio,
        r.Nombre,
        esp.Descripcion,
        esp.DuracionEspectaculo
    ORDER BY e.FechaInicio ASC;
END;

//

DELIMITER ;