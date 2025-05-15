USE entrada_eventos;

DELIMITER //

-- Creamos este procedimiento para comprobar a que eventos pueden acceder segun el tipo de usuario
CREATE OR REPLACE PROCEDURE eventosUsuarios(
    IN aux_TipoUsuario VARCHAR(10)
)

BEGIN
    SELECT
        p.NombreEspectaculo,
        p.TipoEspectaculo,
        e.Ubicacion,
        e.FechaInicio
    FROM
        PERMITE p
    LEFT JOIN
        EVENTO e ON p.NombreEspectaculo = e.NombreEspectaculo 
                AND p.TipoEspectaculo = e.TipoEspectaculo
    WHERE
        p.TipoUsuario = aux_TipoUsuario
    ORDER BY
        e.FechaInicio;
END;

//

DELIMITER ;