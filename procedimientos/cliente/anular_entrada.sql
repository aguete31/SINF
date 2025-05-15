DELIMITER //

-- Creamos el procedimiento para evitar a un cliente comprar un numero excesivo de
-- entradas.

-- CARGAR VALORES DE RESERVA_COMPRA
-- COMPROBAMOS QUE NO EXISTA EN LA TABLA, PORQUE PERTENECE A OTRO SI NO
-- SI NO ESTÁ, O RESERVAMOS O COMPRAMOS, LIMITE ENTRE LOS DOS

CREATE PROCEDURE ReservarEntrada(
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
    DECLARE num_reservas INT DEFAULT 0;
    DECLARE max_reservas INT DEFAULT 5;

    -- Contamos cuantas reservas tiene ya ese cliente para ese evento
    SELECT COUNT(*) INTO num_reservas
    FROM RESERVA_COMPRA
    WHERE IBAN = p_IBAN
      AND NombreEspectaculo = aux_NombreEspectaculo
      AND TipoEspectaculo = aux_TipoEspectaculo
      AND Ubicacion = aux_Ubicacion
      AND FechaInicio = aux_FechaInicio;

    -- Verificamos el limite
    IF num_reservas < max_reservas THEN
        INSERT INTO RESERVA_COMPRA (
            UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo,
            Ubicacion, FechaInicio, IBAN, TipoUsuario
        ) VALUES (
            aux_UbicacionLocalidad, aux_NombreEspectaculo, aux_TipoEspectaculo,
            aux_Ubicacion, aux_FechaInicio, aux_IBAN, aux_TipoUsuario
        );
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Límite de reservas alcanzado para este evento.';
    END IF;
    
END;

//

DELIMITER ;
