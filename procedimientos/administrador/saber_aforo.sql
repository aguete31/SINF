USE entrada_eventos;

DELIMITER //

CREATE OR REPLACE PROCEDURE saberAforo()
BEGIN
    SELECT 
        Nombre, Ubicacion, AforoMaximo
    FROM RECINTO;
END;

// 

DELIMITER ;