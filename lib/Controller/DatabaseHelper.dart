import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1_a1/Model/Atendimento.dart';




class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();


  Database? _db;
  Future<Database> get db async => _db ??= await initDb();


  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "trabalho_1_a1.db");

    return openDatabase(path, version: 1, 
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
        """
          CREATE TABLE ATENDIMENTO(
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            DATA_ABERTURA TEXT NOT NULL,
            NOME_SOLICITANTE TEXT NOT NULL,
            SOLICITACAO TEXT NOT NULL,
            DATA_ENCERRAMENTO TEXT,
            STATUS_ATENDIMENTO TEXT NOT NULL
          )
        """
      );
      });
  }



  // ignore: non_constant_identifier_names
  Future<int> insert_atendimento(Atendimento atendimento) async{
    Database database = await db;
    int result = await database.insert('atendimento', atendimento.toMap());
    return result;
  }


  Future<int> update_atendimento(Atendimento atendimento) async{
    Database database = await db;
    int result = await database.update(
      'atendimento',
      atendimento.toMap(),
      where: "id = ?",
      whereArgs: [atendimento.ID],
    );
    return result;
  }
  Future<Object> atenimento_id(int id) async {
    Database database = await db;
    var res = await database.query(
      'atendimento',
      where: "id = ?",
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return Atendimento.fromMap(res.first);
    } else {
      return Null;
    }
  }
  

  Future<List<Atendimento>> retrieve_atendimentos() async{
    Database database = await db;
    final List<Map<String, Object?>> queryResult = await database.query('atendimento');
    return queryResult.map((e) => Atendimento.fromMap(e)).toList();
  }

  Future<void> delete_atendimento(int id) async{
    Database database = await db;
    await database.delete(
      'atendimento',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}