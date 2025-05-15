USE entrada_eventos;

DELIMITER //

-- Creamos el procedimiento para evitar a un cliente comprar
-- o reservar un numero excesivo de entradas.
CREATE OR REPLACE PROCEDURE ReservarEntrada(
    IN aux_UbicacionLocalidad VARCHAR(10),
    IN aux_NombreEspectaculo VARCHAR(55),
    IN aux_TipoEspectaculo VARCHAR(55),
    IN aux_Ubicacion VARCHAR(55),
    IN aux_FechaInicio TIMESTAMP,
    IN aux_IBAN VARCHAR(35),
    IN aux_TipoUsuario VARCHAR(10)
)

BEGIN
    -- Declaramos las variables para la gestion de la compra
    DECLARE num_reservas_compras INT DEFAULT 0;
    DECLARE max_reservas_compras INT DEFAULT 5;

    -- Insertamos el cliente a nuestra base de datos si no existe
    IF NOT EXISTS(
        SELECT 1 FROM CLIENTE WHERE IBAN = aux_IBAN
    ) THEN
        INSERT INTO CLIENTE (IBAN) VALUES (aux_IBAN);
    END IF;

    -- Contamos cuantas reservas tiene ya ese cliente para ese evento
    SELECT COUNT(*) INTO num_reservas_compras
    FROM RESERVA_COMPRA
    WHERE IBAN = aux_IBAN
      AND NombreEspectaculo = aux_NombreEspectaculo
      AND TipoEspectaculo = aux_TipoEspectaculo
      AND Ubicacion = aux_Ubicacion
      AND FechaInicio = aux_FechaInicio;

    -- Verificamos el limite
    IF num_reservas_compras < max_reservas_compras THEN
        INSERT INTO RESERVA_COMPRA (
            UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo,
            Ubicacion, FechaInicio, IBAN, TipoUsuario, Estado
        ) VALUES (
            aux_UbicacionLocalidad, aux_NombreEspectaculo, aux_TipoEspectaculo,
            aux_Ubicacion, aux_FechaInicio, aux_IBAN, aux_TipoUsuario, FALSE
        );
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Límite de reservas/compras alcanzado para este evento.';
    END IF;
END;

//

DELIMITER ;
