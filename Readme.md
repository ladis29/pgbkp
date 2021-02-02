# Postgres dump Container

- Criei esse container para fazer dump de duas bases de dados postgres.
- O container tem um shell que roda em um horário específico que pode ser programado na cron do container.
- Para facilitar adicionei, na versão 1.1, uma variável que permite alterar o timezone do container, por padrão o horário é UTC.

### Variáveis

|  Variável  |  Valor Padrão  |  Descrição  |
|---|:---:|---|
| CREATION_DATE  | /bin/date +%Y%m%d%H%M | Data do sistema. Fará parte do nome dos backups feitos para diferenciá-los |
| RETENTION | 10 | Tempo em dias de retenção dos backups, após isso os backups começam a ser apagados |
| BKP1_NAME  | database1_bkp | Nome do backup da database1 |
| BKP2_NAME  | database2_bkp | Nome do backup da database2 |
| *PGHOST  | postgres_host | Endereço do servidor postgres(Ip ou URL) |
| *PGUSER  | postgres | Usuário com permissão de acesso e criação de dump |
| *PGPASSWORD  | postgres-pass | Senha do usuário |
| *DATABASE1  | database1 | Nome da database 1 para fazer backup |
| DATABASE2  | database2 | Nome da database 2 para fazer backup |
| TIMEZONE | UTC | Timezone que vc quer rodar o container |
| CRON_MIN | "00" | Minuto da config da crontab |
| CRON_HOUR | "20" | Hora da config da crontab |
| CRON_MONTH_DAY | "*" | Dia da config da crontab(se você quiser rodar em dias específicos do mês) |
| CRON_MONTH | "*" | Mês da config da crontab(se você quiser rodar em meses específicos do ano) |
| CRON_WEEK_DAY | "*" | Dia da semana da config da crontab(se você quiser rodar em dias específicos da semana)|

#### As variáveis marcadas com um '*' acima são obrigatórias, as demais podem ser mantido o valor padrão.

### Adicionando volume ao container
- Caso você queira adicionar um volume para persistir seus dumps pode adicionar o comando:
```
-v /path/to/volume:/bkp
```
na criação do container

### Exemplo de comando para rodar
```
docker run -d \
--name pgbkp \
-v /path/to/volume:/bkp \
-e RETENTION=10 \
-e BKP1_NAME=<database1_bkp> \
-e BKP2_NAME=<database2_bkp> \
-e PGHOST=<endereço do servidor postgres> \
-e PGUSER=<usuário com permissão para dump> \
-e PGPASSWORD=<senha do usuário> \
-e DATABASE1=<database1> \
-e DATABASE2=<database2> \
-e TIMEZONE=America/Sao_Paulo \
-e CRON_MIN="00" \
-e CRON_HOUR="20" \
-e CRON_MONTH_DAY="*" \
-e CRON_MONTH="*" \
-e CRON_WEEK_DAY="*" \
bkp_database:1.1
```

### Rodando comandos manualmente
- Para rodar backups manualmente vc pode rodar o seguinte comando contra o seu container:
```
$ docker exec -it pgbkp sh /bkp/bkp_database.sh
```
- Para verificar os arquivos de dump dentro do container(caso você não tenha acesso ao volume persistido)
```
$ docker exec -it pgbkp ls -la /bkp/postgres 
```
- Para Restaurar databases
```
#Database 1																					     
$ docker exec -it pgbkp psql -h $PGHOST -U $PGUSER -d $DATABASE1 -f /bkp/postgres/<backupfile>.sql
#Database 2																		  				 
$ docker exec -it pgbkp psql -h $PGHOST -U $PGUSER -d $DATABASE2 -f /bkp/postgres/<backupfile>.sql
```
