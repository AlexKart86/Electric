object dmMain: TdmMain
  OldCreateOrder = False
  Height = 222
  Width = 288
  object dbMain: TSQLiteDatabase
    Filename = 'K:\Electric\DriverF\BIN\formulas.db'
    Left = 32
    Top = 16
  end
  object memItems: TMemTableEh
    Active = True
    Params = <>
    Left = 48
    Top = 136
    object memItemsITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object memItemsMEASURE_ID: TIntegerField
      FieldName = 'MEASURE_ID'
    end
    object memItemsVALUE: TFloatField
      FieldName = 'VALUE'
    end
    object memItemsCALC_VALUE: TFloatField
      FieldName = 'CALC_VALUE'
    end
    object memItemsITEM_IMG: TBlobField
      FieldName = 'ITEM_IMG'
      BlobType = ftGraphic
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object ITEM_ID: TMTNumericDataFieldEh
          FieldName = 'ITEM_ID'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object MEASURE_ID: TMTNumericDataFieldEh
          FieldName = 'MEASURE_ID'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object VALUE: TMTNumericDataFieldEh
          FieldName = 'VALUE'
          NumericDataType = fdtFloatEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object CALC_VALUE: TMTNumericDataFieldEh
          FieldName = 'CALC_VALUE'
          NumericDataType = fdtFloatEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object ITEM_IMG: TMTBlobDataFieldEh
          FieldName = 'ITEM_IMG'
          BlobType = ftBlob
          GraphicHeader = False
          Transliterate = False
        end
      end
      object RecordsList: TRecordsListEh
      end
    end
  end
  object ldsItems: TSQLiteDataset
    Aggregates = <>
    CommandText = 'select * from items'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'F_STR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'F_TEX'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'DESC_RU'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'DESC_UKR'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Database = dbMain
    Left = 128
    Top = 24
    object ldsItemsID: TIntegerField
      FieldName = 'ID'
    end
    object ldsItemsNAME: TWideStringField
      FieldName = 'NAME'
      Size = 4000
    end
    object ldsItemsF_STR: TWideStringField
      FieldName = 'F_STR'
      Size = 4000
    end
    object ldsItemsF_TEX: TWideStringField
      FieldName = 'F_TEX'
      Size = 4000
    end
    object ldsItemsDESC_RU: TWideStringField
      FieldName = 'DESC_RU'
      Size = 4000
    end
    object ldsItemsDESC_UKR: TWideStringField
      FieldName = 'DESC_UKR'
      Size = 4000
    end
  end
  object ilItems: TImageList
    Left = 216
    Top = 24
  end
  object dsItems: TDataSource
    DataSet = memItems
    Left = 120
    Top = 144
  end
end
