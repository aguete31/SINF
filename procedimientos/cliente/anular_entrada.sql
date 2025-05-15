USE entrada_eventos;

DELIMITER //

-- Procedimiento para anular las reservas por usuario y permitir a 
-- otros comprar.
CREATE OR REPLACE PROCEDURE anularReserva(
    IN aux_UbicacionLocalidad VARCHAR(10),
    IN aux_NombreEspectaculo VARCHAR(55),
    IN aux_TipoEspectaculo VARCHAR(55),
    IN aux_Ubicacion VARCHAR(55),
    IN aux_FechaInicio TIMESTAMP,
    IN aux_IBAN VARCHAR(35),
    IN aux_TipoUsuario VARCHAR(10)
)

BEGIN
    -- Declaramos las variables para gestionar los minutos restantes
    -- y si existen reservas.
    DECLARE minutos_restantes INT;
    DECLARE reserva_existente INT;

    -- Control para eliminar usuario si no tiene entrdas.
    DECLARE entradas_cliente INT;

    -- Comprobamos si existe y que es una reserva, no una compra
    SELECT COUNT(*) INTO reserva_existente
    FROM RESERVA_COMPRA
    WHERE IBAN = aux_IBAN
      AND UbicacionLocalidad = aux_UbicacionLocalidad
      AND NombreEspectaculo = aux_NombreEspectaculo
      AND TipoEspectaculo = aux_TipoEspectaculo
      AND Ubicacion = aux_Ubicacion
      AND FechaInicio = aux_FechaInicio
      AND Estado = FALSE;

    -- Comprobamos si hay reservas para el usuario
    IF reserva_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existen reservas para este cliente.';
    ELSE
        -- Calculamos el tiempo restante
        SELECT TIMESTAMPDIFF(MINUTE, NOW(), aux_FechaInicio) INTO minutos_restantes;

        -- Comprobamos si esta a menos de 20 min
        IF minutos_restantes < 20 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede anular dado que va a empezar pronto el evento.';
        ELSE
            -- En el caso de no estar a menos de 20 min, la eliminamos
            DELETE FROM RESERVA_COMPRA
            WHERE UbicacionLocalidad = aux_UbicacionLocalidad
              AND NombreEspectaculo = aux_NombreEspectaculo
              AND TipoEspectaculo = aux_TipoEspectaculo
              AND Ubicacion = aux_Ubicacion
              AND FechaInicio = aux_FechaInicio
              AND IBAN = aux_IBAN
              AND Estado = FALSE;

            -- Verificamos si el cliente tiene mas entradas
            SELECT COUNT(*) INTO entradas_cliente
            FROM RESERVA_COMPRA
            WHERE IBAN = aux_IBAN;

            -- Si no tiene mas entradas, eliminamos el cliente
            IF entradas_cliente = 0 THEN
                DELETE FROM CLIENTE
                WHERE IBAN = aux_IBAN;
            END IF;

        END IF;
    END IF;
END;

//

DELIMITER ;
