#!/bin/bash
mariadb < "drop database entrada_eventos; create database entrada_eventos;"

mariadb < taquilla.sql

for entry in procedimientos/cliente do
	mariadb < "$entry"
done

for entry in procedimientos/administrador do
        mariadb < "$entry"
done
