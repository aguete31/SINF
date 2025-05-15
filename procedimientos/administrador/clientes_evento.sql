USE entrada_eventos;

DELIMITER //

-- Creamos este procedimiento para saber el tipo de usuarios que acceden a los eventos,
-- así sabremos a que público centrarnos y ofrecer algo mas de propuesta de valor.
CREATE OR REPLACE PROCEDURE clientesEvento()
BEGIN
    SELECT 
        rc.NombreEspectaculo,
        rc.TipoEspectaculo,
        rc.Ubicacion,
        rc.FechaInicio,
        rc.TipoUsuario,
        COUNT(*) AS EntradasVendidas
    FROM 
        RESERVA_COMPRA rc
    GROUP BY 
        rc.NombreEspectaculo, rc.TipoEspectaculo, 
        rc.Ubicacion, rc.FechaInicio, rc.TipoUsuario
    ORDER BY 
        rc.FechaInicio, rc.TipoUsuario;
END;

//

DELIMITER ;
