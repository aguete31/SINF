USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento para saber que clientes son frecuentes en nuestro sistema gestor de eventos
CREATE OR REPLACE PROCEDURE clientesFrecuentes()
BEGIN
    SELECT 
        rc.IBAN,
        COUNT(*) AS EntradasCompradas
    FROM
        RESERVA_COMPRA rc
    GROUP BY
        rc.IBAN
    ORDER BY
        EntradasCompradas DESC;
END;

//

DELIMITER ;