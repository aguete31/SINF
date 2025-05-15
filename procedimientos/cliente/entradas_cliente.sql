USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento destinado a que los clientes puedan ver todas sus reservas o compras
CREATE OR REPLACE PROCEDURE entradasCliente(IN aux_IBAN VARCHAR(35))
BEGIN
    SELECT
        rc.NombreEspectaculo,
        rc.TipoEspectaculo,
        rc.Ubicacion,
        rc.FechaInicio,
        rc.UbicacionLocalidad,
        rc.TipoUsuario,
        rc.Estado,
        c.PrecioLocalidad
    FROM RESERVA_COMPRA rc
    LEFT JOIN CUESTA c ON rc.UbicacionLocalidad = c.UbicacionLocalidad
                      AND rc.NombreEspectaculo = c.NombreEspectaculo
                      AND rc.Ubicacion = c.Ubicacion
                      AND rc.FechaInicio = c.FechaInicio
                      AND rc.TipoEspectaculo = c.TipoEspectaculo
                      AND rc.TipoUsuario = c.TipoUsuario
    WHERE rc.IBAN = aux_IBAN;
END;

//

DELIMITER ;