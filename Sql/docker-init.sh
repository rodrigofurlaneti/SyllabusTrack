#!/bin/bash
# Aguarda o SQL Server subir antes de rodar os scripts de seed
set -e

echo "Aguardando SQL Server iniciar..."
until /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -C -Q "SELECT 1" &>/dev/null; do
    sleep 2
done

echo "SQL Server pronto. Executando scripts..."

/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -C -i /sql/MasterScript.sql
echo "✔ MasterScript.sql"

/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -C -d SyllabusTrackDb -i /sql/SeedData.sql
echo "✔ SeedData.sql"

/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -C -d SyllabusTrackDb -i /sql/Seed_FAM_Psicologia_Farmacia.sql
echo "✔ Seed_FAM_Psicologia_Farmacia.sql"

echo "Banco de dados inicializado com sucesso."
