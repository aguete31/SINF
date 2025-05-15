USE entrada_eventos;

-- Insertamos USUARIOS
INSERT INTO USUARIO VALUES 
('Adulto'),
('Jubilado'),
('Infantil'),
('Parado'),
('Bebe');

-- Insertamos CLIENTES
--INSERT INTO CLIENTE VALUES 
--('ES1111222233334444555566'),
--('ES9990000000000000000001');

-- Insertamos ESPECTACULO
INSERT INTO ESPECTACULO VALUES 
('ShowTest', 'Musical', 'Un espectáculo musical para pruebas', 120);

-- Insertamos RECINTO
INSERT INTO RECINTO VALUES 
('TEST_REC1', 'Recinto Central', 1000);

-- Insertamos FECHA
INSERT INTO FECHA VALUES 
('2025-07-01 21:00:00');

-- Insertamos EVENTO
INSERT INTO EVENTO VALUES 
('ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', '2025-07-01 23:00:00');

-- Insertamos LOCALIDADES
INSERT INTO LOCALIDAD VALUES 
('A1', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A2', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A3', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A4', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A5', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A6', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00');

-- Insertamos PERMITE
INSERT INTO PERMITE VALUES 
('ShowTest', 'Musical', 'Adulto'),
('ShowTest', 'Musical', 'Parado');

-- Insertamos precios en CUESTA
INSERT INTO CUESTA VALUES 
('A1', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0),
('A2', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0),
('A3', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0),
('A4', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0),
('A5', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0),
('A6', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00', 'Adulto', 30.0);

INSERT INTO ENTRADA VALUES
('A1', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A2', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A3', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A4', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A5', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00'),
('A6', 'ShowTest', 'Musical', 'TEST_REC1', '2025-07-01 21:00:00');
