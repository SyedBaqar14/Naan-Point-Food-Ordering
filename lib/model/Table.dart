class Tables{
  String tableID;
  String tableName;
  bool tableStatus;

  Tables({bool tableStatus, String tableName, String tableID}){
      this.tableID = tableID;
      this.tableName = tableName;
      this.tableStatus = tableStatus;
  }

  Tables.fromJson(Map<String, dynamic> json) {
    tableID = json['tableID'];
    tableName = json['tableName'];
    tableStatus = json['tableStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableID'] = this.tableID;
    data['tableName'] = this.tableName;
    data['tableStatus'] = this.tableStatus;

    return data;
  }
}