object dmMain: TdmMain
  OldCreateOrder = False
  Height = 222
  Width = 288
  object dbMain: TDISQLite3Database
    Connected = True
    DatabaseName = 'C:\AK\WORK\Electric\DriverF\BIN\Test.db'
    Left = 40
    Top = 32
  end
  object DISQLite3UniDirQuery1: TDISQLite3UniDirQuery
    Database = dbMain
    SelectSQL = 'select * from measures'
    Left = 128
    Top = 56
  end
  object DataSource1: TDataSource
    DataSet = MemTableEh1
    Left = 40
    Top = 96
  end
  object MemTableEh1: TMemTableEh
    FetchAllOnOpen = True
    Params = <>
    DataDriver = DataSetDriverEh1
    Left = 96
    Top = 160
  end
  object DataSetDriverEh1: TDataSetDriverEh
    ProviderDataSet = DISQLite3UniDirQuery1
    Left = 208
    Top = 168
  end
end
