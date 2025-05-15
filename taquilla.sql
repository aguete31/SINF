DROP DATABASE IF EXISTS entrada_eventos;
CREATE DATABASE entrada_eventos;
USE entrada_eventos;

CREATE TABLE ESPECTACULO(
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Descripcion varchar(255),
    DuracionEspectaculo int,
    check (DuracionEspectaculo>0),
    primary key (NombreEspectaculo, TipoEspectaculo)
);

CREATE TABLE RECINTO(
    Ubicacion varchar(55),
    Nombre varchar(55),
    AforoMaximo int,
    check (AforoMaximo>0),
    primary key(Ubicacion)
);

CREATE TABLE FECHA(
    FechaInicio timestamp,
    primary key(FechaInicio)
);

CREATE TABLE EVENTO(
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Ubicacion varchar(55),
    FechaInicio timestamp,
    FechaFin timestamp,
    primary key (NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (NombreEspectaculo, TipoEspectaculo) references ESPECTACULO (NombreEspectaculo, TipoEspectaculo),
    foreign key (Ubicacion) references RECINTO (Ubicacion),
    foreign key (FechaInicio) references FECHA (FechaInicio)
);

CREATE TABLE LOCALIDAD(
    UbicacionLocalidad varchar(10),
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Ubicacion varchar(55),
    FechaInicio timestamp,
    primary key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) references EVENTO (NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio)
);

CREATE TABLE USUARIO(
    TipoUsuario varchar(10),
    check (TipoUsuario in('Jubilado', 'Adulto', 'Infantil', 'Parado', 'Bebe')),
    primary key (TipoUsuario)
);

CREATE TABLE PERMITE(
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    TipoUsuario varchar(10),
    check (TipoUsuario in('Jubilado', 'Adulto', 'Infantil', 'Parado', 'Bebe')),
    primary key (NombreEspectaculo, TipoEspectaculo, TipoUsuario),
    foreign key (NombreEspectaculo, TipoEspectaculo) references ESPECTACULO (NombreEspectaculo, TipoEspectaculo),
    foreign key (TipoUsuario) references USUARIO (TipoUsuario)
);

CREATE TABLE CUESTA(
    UbicacionLocalidad varchar(10),
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Ubicacion varchar(55),
    FechaInicio timestamp,
    TipoUsuario varchar(10),
    PrecioLocalidad float not null,
    check (TipoUsuario in('Jubilado', 'Adulto', 'Infantil', 'Parado', 'Bebe')),
    check (PrecioLocalidad>0),
    primary key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio, TipoUsuario),
    foreign key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) references LOCALIDAD (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (TipoUsuario) references USUARIO (TipoUsuario)
);

CREATE TABLE CLIENTE(
    IBAN varchar(35),
    primary key (IBAN)
);

CREATE TABLE ENTRADA(
    UbicacionLocalidad varchar(10),
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Ubicacion varchar(55),
    FechaInicio timestamp,
    primary key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) references LOCALIDAD (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio)
);

CREATE TABLE RESERVA_COMPRA(
    UbicacionLocalidad varchar(10),
    NombreEspectaculo varchar(55),
    TipoEspectaculo varchar(55),
    Ubicacion varchar(55),
    FechaInicio timestamp,
    IBAN varchar(35),
    TipoUsuario varchar(10),
    Estado boolean,
    check (TipoUsuario in('Jubilado', 'Adulto', 'Infantil', 'Parado', 'Bebe')),
    primary key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) references ENTRADA (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio),
    foreign key (TipoUsuario) references USUARIO (TipoUsuario),
    foreign key (IBAN) references CLIENTE (IBAN)
);

