#!/bin/bash

mariadb < taquilla.sql

for entry in procedimientos/cliente do
	mariadb < "$entry"
done