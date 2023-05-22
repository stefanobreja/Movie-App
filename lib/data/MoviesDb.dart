import 'package:movie/data/MovieDb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MoviesDb {
  static final MoviesDb instance = MoviesDb._init();
  static Database? _database;

  MoviesDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb("movies.db");
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int versions) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const realType = 'REAL';
    const textType = 'TEXT';

    await db.execute('''CREATE TABLE $tableMovies(
    ${MovieDbFields.id} $idType,
    ${MovieDbFields.title} $textType,
    ${MovieDbFields.overview} $textType,
    ${MovieDbFields.releaseDate} $textType,
    ${MovieDbFields.posterPath} $textType,
    ${MovieDbFields.backdropPath} $textType,
    ${MovieDbFields.voteAverage} $realType,
    ${MovieDbFields.voteCount} $intType
    )''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<MovieDb> create(MovieDb movie) async {
    final db = await instance.database;
    final id = await db.insert(tableMovies, movie.toJson());
    return movie.copy(id: id);
  }

  Future<bool> remove(int id) async {
    final db = await instance.database;
    await db.delete(
      tableMovies,
      where: '${MovieDbFields.id} == ?',
      whereArgs: [id],
    ).then((value) {
      if (value >= 1) {
        return true;
      }
    });
    return false;
  }

  Future<MovieDb> getMovie(int id) async {
    final db = await instance.database;
    final mapsResponse = await db.query(
      tableMovies,
      columns: MovieDbFields.values,
      where: '${MovieDbFields.id} == ?',
      whereArgs: [id],
    );
    if (mapsResponse.isNotEmpty) {
      return MovieDb.fromJson(mapsResponse.first);
    } else {
      throw Exception('Movie with $id not found');
    }
  }

  Future<List<MovieDb>> getMovies() async {
    final db = await instance.database;
    final result = await db.query(tableMovies);
    return result.map((json) => MovieDb.fromJson(json)).toList();
  }
}
