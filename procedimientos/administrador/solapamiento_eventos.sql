USE entrada_eventos;

DELIMITER //

-- Procedimiento para evitar que se solapen eventos
CREATE OR REPLACE PROCEDURE crearEventos(
    IN aux_NombreEspectaculo varchar(55),
    IN aux_TipoEspectaculo varchar(55),
    IN aux_Ubicacion varchar(55),
    IN aux_FechaInicio timestamp
)

BEGIN
    -- Variables para calcular la duracion y fecha final de los eventos
    DECLARE aux_Duracion INT;
    DECLARE aux_FechaFin timestamp;
    DECLARE aux_Conflictos INT;

    -- Obtenemos la duracion del espectaculo
    SELECT DuracionEspectaculo INTO aux_Duracion
    FROM ESPECTACULO
    WHERE NombreEspectaculo = aux_NombreEspectaculo 
      AND TipoEspectaculo = aux_TipoEspectaculo;

    -- Calculamos la fecha del fin
    SET aux_FechaFin = DATE_ADD(aux_FechaInicio, INTERVAL aux_Duracion MINUTE);

    -- Verificamos los solapamientos en los recintos
    SELECT COUNT(*) INTO aux_Conflictos
    FROM EVENTO
    WHERE Ubicacion = aux_Ubicacion
      AND(
            -- Si el evento empieza durante otro
            (aux_FechaInicio BETWEEN FechaInicio AND FechaFin) OR

            -- Si el evento termina durante otro
            (aux_FechaFin BETWEEN FechaInicio AND FechaFin) OR

            -- El evento contiene al otro
            (aux_FechaInicio < FechaInicio AND aux_FechaFin > FechaFin)
      );

IF aux_Conflictos > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pueden solapar eventos';
ELSE
    -- Insertamos en la fecha
    INSERT INTO FECHA VALUES (aux_FechaInicio);

    -- Insertamos el evento
    INSERT INTO EVENTO
    VALUES(aux_NombreEspectaculo, aux_TipoEspectaculo, aux_Ubicacion, aux_FechaInicio, aux_FechaFin);
END IF;

END;

//

DELIMITER ;