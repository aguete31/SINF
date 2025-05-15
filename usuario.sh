create user 'admin' identified by 'Kshmw7ujbs_ksh';
create user 'admin'@'localhost' identified by '1Qwertyuiop_';


create user 'cliente' identified by 'KIOuLiop_43liop';
create user 'cliente'@'localhost' identified by '2Zxcvbnm_';

GRANT EXECUTE ON PROCEDURE entrada_eventos.ReservarEntrada TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE entrada_eventos.anularReserva TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE entrada_eventos.entradasCliente TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE entrada_eventos.eventosDisponibles TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE entrada_eventos.saberPrecio TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE entrada_eventos.localidadesLibres TO 'cliente'@'localhost';



