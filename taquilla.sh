#!/bin/bash
#mariadb < "drop database entrada_eventos; create database entrada_eventos;"

# mariadb < taquilla.sql

DB_ADMIN_USER="admin"
DB_ADMIN_PASSWORD="1Qwertyuiop_"
DATABASE_NAME="entrada_eventos"

# Execute SQL scripts for clientes
for entry in procedimientos/cliente/*.sql; do
  if [[ -f "$entry" ]]; then
    echo "USE $DATABASE_NAME;" | cat - "$entry" | mariadb -u "$DB_ADMIN_USER" -p"$DB_ADMIN_PASSWORD"
  echo "$entry"

  fi
done

# Execute SQL scripts for administradores
for entry in procedimientos/administrador/*.sql; do
  if [[ -f "$entry" ]]; then
    echo "USE $DATABASE_NAME;" | cat - "$entry" | mariadb -u "$DB_ADMIN_USER" -p"$DB_ADMIN_PASSWORD"
  echo "$entry"
  fi
done
