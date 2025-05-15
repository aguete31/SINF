import mysql.connector
from datetime import datetime, timedelta
from random import choice, randint, sample, uniform
from faker import Faker

# Database connection details (replace with your actual credentials)
db_config = {
    "host": "localhost",
    "user": "your_user",
    "password": "your_password",
    "database": "entrada_eventos"
}

fake = Faker('es_ES')  # Using Spanish locale for more realistic names

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

def insert_random_fecha(cursor, num_entries=50):
    start_date = datetime(2025, 6, 1)
    end_date = datetime(2025, 8, 31)
    time_difference = end_date - start_date
    for _ in range(num_entries):
        random_days = randint(0, time_difference.days)
        random_hour = randint(10, 22)
        random_minute = choice([0, 15, 30, 45])
        fecha = start_date + timedelta(days=random_days, hours=random_hour, minutes=random_minute)
        try:
            cursor.execute(
                "INSERT INTO FECHA (FechaInicio) VALUES (%s)",
                (fecha,)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Fecha: {err}")

def insert_random_evento(cursor, espectaculos, recintos, fechas, num_entries=500):
    for _ in range(num_entries):
        nombre_espectaculo, tipo_espectaculo = choice(espectaculos)
        ubicacion = choice(recintos)
        fecha_inicio = choice(fechas)
        duracion_espectaculo = next((duracion for n, t, _, duracion in espectaculos if n == nombre_espectaculo and t == tipo_espectaculo), 90)
        fecha_fin = fecha_inicio + timedelta(minutes=duracion_espectaculo)
        try:
            cursor.execute(
                "INSERT INTO EVENTO (NombreEspectaculo, TipoEspectaculo, Ubicacion, FechaInicio, FechaFin) VALUES (%s, %s, %s, %s, %s)",
                (nombre_espectaculo, tipo_espectaculo, ubicacion, fecha_inicio, fecha_fin)
            )
        except mysql.connector.Error as err:
            print(f"Error inserting random Evento: {err}")

def insert_random_localidad(cursor, eventos, num_entries=1000):
    ubicaciones_localidad = ["Fila A Asiento {}".format(i) for i in range(1, 21)] + \
                              ["Fila B Asiento {}".format(i) for i in range(1, 21)] + \
                              ["Palco {}".format(i) for i in range(1, 6)]
    for _ in range(num_entries):
        nombre_espectaculo, tipo_espectaculo, ubicacion_recinto, fecha_inicio = choice(eventos)
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
        # Randomly assign allowed user types (at least one)
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

        print("Inserting random Fecha entries...")
        insert_random_fecha(cursor, num_entries=100)
        cnx.commit()
        cursor.execute("SELECT FechaInicio FROM FECHA")
        fechas_data = [row[0] for row in cursor.fetchall()]

        print("Inserting random Evento entries...")
        insert_random_evento(cursor, espectaculos_data, recintos_data, fechas_data, num_entries=200)
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

        print("Random data insertion completed successfully!")

    except mysql.connector.Error as err:
        print(f"Error: '{err}'")

    finally:
        if cnx.is_connected():
            cursor.close()
            cnx.close()
            print("MySQL connection closed.")
