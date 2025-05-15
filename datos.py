import mysql.connector
from datetime import datetime, timedelta
from random import choice, randint, sample, uniform
from faker import Faker

# Detalles de la conexión a la base de datos
db_config = {
    "host": "localhost",
    "user": "admin",
    "password": "1Qwertyuiop_",
    "database": "entrada_eventos"
}

fake = Faker('es_ES')

def insert_random_espectaculo(cursor, num_entries=100):
    tipos_espectaculo = ["Música", "Teatro", "Cine", "Danza", "Comedia", "Ópera"]
    for _ in range(num_entries):
        nombre = fake.sentence(nb_words=4).strip('.')
        tipo = choice(tipos_espectaculo)
        descripcion = fake.paragraph(nb_sentences=3)
        duracion = randint(60, 180)
        try:
            cursor.execute(
                "INSERT INTO ESPECTACULO (NombreEspectaculo, TipoEspectaculo, Descripcion, DuracionEspectaculo) VALUES (%s, %s, %s, %s)",
                (nombre, tipo, descripcion, duracion)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Espectaculo: {err}")

def insert_random_recinto(cursor, num_entries=20):
    for _ in range(num_entries):
        ubicacion = fake.city()
        nombre = f"{fake.word().capitalize()} {choice(['Arena', 'Teatro', 'Auditorio', 'Palacio'])}"
        aforo = randint(100, 3000)
        try:
            cursor.execute(
                "INSERT INTO RECINTO (Ubicacion, Nombre, AforoMaximo) VALUES (%s, %s, %s)",
                (ubicacion, nombre, aforo)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Recinto: {err}")

def insert_random_evento(cursor, espectaculos, recintos, num_entries=500):
    for _ in range(num_entries):
        espectaculo_seleccionado = choice(espectaculos)
        nombre_espectaculo = espectaculo_seleccionado[0]
        tipo_espectaculo = espectaculo_seleccionado[1]
        ubicacion = choice(recintos)
        fecha_inicio = datetime(2025, 6, 1) + timedelta(days=randint(0, 90), hours=randint(10, 22), minutes=choice([0, 15, 30, 45]))
        try:
            cursor.execute(
                "CALL crearEventos(%s, %s, %s, %s)",
                (nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Evento: {err}")

def insert_random_localidad(cursor, eventos, num_entries=1000):
    ubicaciones_localidad = ["F{}".format(i) for i in range(1, 21)] + \
                            ["C{}".format(i) for i in range(1, 21)] + \
                            ["A{}".format(i) for i in range(1, 6)]
    for _ in range(num_entries):
        evento_seleccionado = choice(eventos)
        nombre_espectaculo = evento_seleccionado[0]
        tipo_espectaculo = evento_seleccionado[1]
        ubicacion_recinto = evento_seleccionado[2]
        fecha_inicio = evento_seleccionado[3]
        ubicacion_localidad = choice(ubicaciones_localidad)
        try:
            cursor.execute(
                "INSERT INTO LOCALIDAD (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) VALUES (%s, %s, %s, %s, %s)",
                (ubicacion_localidad, nombre_espectaculo, tipo_espectaculo, ubicacion_recinto, fecha_inicio)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Localidad: {err}")

def insert_permite(cursor, espectaculos):
    tipos_usuario = ["Jubilado", "Adulto", "Infantil", "Parado", "Bebe"]
    for nombre_espectaculo, tipo_espectaculo, _, _ in espectaculos:
        num_allowed = randint(1, len(tipos_usuario))
        allowed_types = sample(tipos_usuario, num_allowed)
        for tipo_usuario in allowed_types:
            try:
                cursor.execute(
                    "INSERT INTO PERMITE (NombreEspectaculo, TipoEspectaculo, TipoUsuario) VALUES (%s, %s, %s)",
                    (nombre_espectaculo, tipo_espectaculo, tipo_usuario)
                )
            except mysql.connector.Error as err:
                print(f"Error inserting Permite: {err}")

def insert_usuario(cursor):
    usuarios_data = [("Jubilado",), ("Adulto",), ("Infantil",), ("Parado",), ("Bebe",)]
    for tipo_usuario in usuarios_data:
        try:
            cursor.execute("INSERT INTO USUARIO (TipoUsuario) VALUES (%s)", tipo_usuario)
        except mysql.connector.Error as err:
            print(f"Error inserting Usuario: {err}")

def insert_entrada(cursor, localidades):
    for ubicacion_localidad, nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio in localidades:
        try:
            cursor.execute(
                "INSERT INTO ENTRADA (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio) VALUES (%s, %s, %s, %s, %s)",
                (ubicacion_localidad, nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting Entrada: {err}")

def insert_cuesta(cursor, localidades, precios_por_tipo):
    """
    Inserta datos en la tabla CUESTA.

    Args:
        cursor: El cursor de la base de datos.
        localidades: Lista de tuplas que representan las localidades.
        precios_por_tipo: Diccionario que mapea el tipo de usuario al precio.
    """
    tipos_usuario = ["Jubilado", "Adulto", "Infantil", "Parado", "Bebe"] #lista de tipos de usuario
    for ubicacion_localidad, nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio in localidades:
        # Esto es un placeholder, necesitas reemplazarlo con la lógica real para obtener el tipo de usuario.
        tipo_usuario = choice(tipos_usuario) #selecciona un tipo de usuario al azar
        precio_localidad = precios_por_tipo.get(tipo_usuario, 20.00)  # 20.00 como precio por defecto
        try:
            cursor.execute(
                "INSERT INTO CUESTA (UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio, TipoUsuario, PrecioLocalidad) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (ubicacion_localidad, nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio, tipo_usuario, precio_localidad)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting CUESTA: {err}")

if __name__ == "__main__":
    try:
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()

        print("Inserting random Espectaculo entries...")
        insert_random_espectaculo(cursor, num_entries=50)
        cnx.commit()
        cursor.execute("SELECT NombreEspectaculo, TipoEspectaculo, Descripcion, DuracionEspectaculo FROM ESPECTACULO")
        espectaculos_data = cursor.fetchall()

        print("Inserting random Recinto entries...")
        insert_random_recinto(cursor, num_entries=10)
        cnx.commit()
        cursor.execute("SELECT Ubicacion FROM RECINTO")
        recintos_data = [row[0] for row in cursor.fetchall()]

        print("Inserting random Evento entries...")
        insert_random_evento(cursor, espectaculos_data, recintos_data, num_entries=200)
        cnx.commit()
        cursor.execute("SELECT NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio FROM EVENTO")
        eventos_data = cursor.fetchall()

        print("Inserting random Localidad entries...")
        insert_random_localidad(cursor, eventos_data, num_entries=500)
        cnx.commit()
        cursor.execute("SELECT UbicacionLocalidad, NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio FROM LOCALIDAD")
        localidades_data = cursor.fetchall()

        print("Inserting Usuario entries...")
        insert_usuario(cursor)
        cnx.commit()

        print("Inserting Permite entries...")
        insert_permite(cursor, espectaculos_data)
        cnx.commit()

        print("Inserting Entrada entries...")
        insert_entrada(cursor, localidades_data)
        cnx.commit()

        # Insertar datos en CUESTA
        print("Inserting CUESTA entries...")
        precios_por_tipo = {
            "Jubilado": 15.00,
            "Adulto": 25.00,
            "Infantil": 10.00,
            "Parado": 18.00,
            "Bebe": 5.00,
        }
        insert_cuesta(cursor, localidades_data, precios_por_tipo)
        cnx.commit()

        print("Random data insertion completed successfully!")

    except mysql.connector.Error as err:
        print(f"Error: '{err}'")
