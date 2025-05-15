USE entrada_eventos;

DELIMITER //

CREATE OR REPLACE PROCEDURE saberPrecio()
BEGIN
    SELECT 
        UbicacionLocalidad,
        NombreEspectaculo,
        TipoEspectaculo,
        Ubicacion,
        FechaInicio,
        TipoUsuario,
        PrecioLocalidad
    FROM CUESTA
    ORDER BY 
        NombreEspectaculo, FechaInicio, UbicacionLocalidad;
END;

// 

DELIMITER ;
