# SavePoint

Statements like:

- `Savepoint savePoint = Database.setSavepoint();` 
- `Database.rollback(savePoint);`
- `Database.releaseSavepoint(savePoint);`

issue DMLs.

Due to that behavior Savepoint has to be explicitly invoke. Default Lib behavior shoudn't create savepoints.