USE entrada_eventos;

DELIMITER //

-- Creamos el procedimineto correspondiente para ver todas las butacas libres, esto nos interesa
-- para gestionar la decision sobre alguna butaca que no se compre nunca, entre otras cosas
CREATE OR REPLACE PROCEDURE localidadesLibres(
    IN aux_NombreEspectaculo VARCHAR(55),
    IN aux_TipoEspectaculo VARCHAR(55),
    IN aux_Ubicacion VARCHAR(55),
    IN aux_FechaInicio TIMESTAMP
)

BEGIN
    SELECT
        l.UbicacionLocalidad
    FROM
        LOCALIDAD l
    WHERE
        l.NombreEspectaculo = aux_NombreEspectaculo AND
        l.TipoEspectaculo = aux_TipoEspectaculo AND
        l.Ubicacion = aux_Ubicacion AND
        l.FechaInicio = aux_FechaInicio AND

        NOT EXISTS(
            SELECT *
            FROM RESERVA_COMPRA r
            WHERE r.UbicacionLocalidad = l.UbicacionLocalidad
              AND r.NombreEspectaculo = l.NombreEspectaculo
              AND r.TipoEspectaculo = l.TipoEspectaculo
              AND r.Ubicacion = l.Ubicacion
              AND r.FechaInicio = l.FechaInicio
        )
    ORDER BY l.UbicacionLocalidad;
END;

//

DELIMITER ;