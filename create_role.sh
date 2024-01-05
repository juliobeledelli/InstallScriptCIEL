read -p "Insira a linha 'User service' para criar a role do PostgreSQL: " OE_USER


sudo su - postgres -c "psql -c \"CREATE ROLE $OE_USER WITH SUPERUSER CREATEDB CREATEROLE LOGIN\"" 2> /dev/null || true
