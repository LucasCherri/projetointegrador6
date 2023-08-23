import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Db{
  static Future<mongo.Db> getConnectionStartup() async{
    final db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.bdyhejx.mongodb.net/startup?retryWrites=true&w=majority");
    await db.open();
    return db;
  }

  static Future<mongo.Db> getConnectionInvestidor() async{
    final db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.bdyhejx.mongodb.net/investidor?retryWrites=true&w=majority");
    await db.open();
    return db;
  }
}