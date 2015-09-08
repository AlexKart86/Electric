object dmMain: TdmMain
  OldCreateOrder = False
  Height = 507
  Width = 580
  object dbMain: TSQLiteDatabase
    Connected = True
    Filename = 'K:\Electric\DriverF\BIN\formulas.db'
    Left = 32
    Top = 16
  end
  object memItems: TMemTableEh
    Params = <>
    Left = 40
    Top = 136
    object memItemsITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object memItemsMEASURE_ID: TIntegerField
      FieldName = 'MEASURE_ID'
    end
    object memItemsVALUE: TFloatField
      DisplayLabel = #1047#1072#1076#1072#1085#1077' '#1079#1085#1072#1095#1077#1085#1085#1103
      FieldName = 'VALUE'
    end
    object memItemsCALC_VALUE: TFloatField
      DisplayLabel = #1056#1086#1079#1088#1072#1093#1086#1074#1072#1085#1077' '#1079#1085#1072#1095#1077#1085#1085#1103
      FieldName = 'CALC_VALUE'
    end
    object memItemsITEM_IMG: TBlobField
      FieldName = 'ITEM_IMG'
      BlobType = ftGraphic
    end
    object memItemsMEASURE_ID_LOOKUP: TStringField
      DisplayLabel = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091
      FieldKind = fkLookup
      FieldName = 'MEASURE_ID_LOOKUP'
      LookupDataSet = ldsMeasures
      LookupKeyFields = 'ID'
      LookupResultField = 'LABEL_UKR'
      KeyFields = 'MEASURE_ID'
      Size = 40
      Lookup = True
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
    Left = 104
    Top = 16
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
  object dsItems: TDataSource
    DataSet = memItems
    Left = 96
    Top = 136
  end
  object ldsMeasures: TSQLiteDataset
    Aggregates = <>
    CommandText = 'select * from measures'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'LABEL_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'KOEFF'
        DataType = ftFloat
      end
      item
        Name = 'DESCRIPTION_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'BASE_ID'
        DataType = ftInteger
      end
      item
        Name = 'DESCRIPTION_RU'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'LABEL_RU'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Database = dbMain
    Left = 176
    Top = 16
    object ldsMeasuresID: TIntegerField
      FieldName = 'ID'
    end
    object ldsMeasuresLABEL_UKR: TWideStringField
      FieldName = 'LABEL_UKR'
      Size = 4000
    end
    object ldsMeasuresKOEFF: TFloatField
      FieldName = 'KOEFF'
    end
    object ldsMeasuresDESCRIPTION_UKR: TWideStringField
      FieldName = 'DESCRIPTION_UKR'
      Size = 4000
    end
    object ldsMeasuresBASE_ID: TIntegerField
      FieldName = 'BASE_ID'
    end
    object ldsMeasuresDESCRIPTION_RU: TWideStringField
      FieldName = 'DESCRIPTION_RU'
      Size = 4000
    end
    object ldsMeasuresLABEL_RU: TWideStringField
      FieldName = 'LABEL_RU'
      Size = 4000
    end
  end
  object ldsItemMeas: TSQLiteDataset
    Active = True
    Aggregates = <>
    CommandText = 
      'select im.*,'#13#10'       m.LABEL_UKR         '#13#10'from item_meas im,'#13#10' ' +
      '    measures m'#13#10'where im.MEAS_ID = m.ID     '
    FieldDefs = <
      item
        Name = 'ITEM_ID'
        DataType = ftInteger
      end
      item
        Name = 'MEAS_ID'
        DataType = ftInteger
      end
      item
        Name = 'LABEL_UKR'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Database = dbMain
    Left = 256
    Top = 16
    Data = {
      1C0100009619E0BD010000001800000003000C00000003000000580007495445
      4D5F49440400010000000000074D4541535F49440400010000000000094C4142
      454C5F554B5202004A000000010005574944544802000200401F000000000100
      0000010000000200120400000200000002000000020041000000030000000200
      0000020041000000040000000900000000000000050000000300000006004200
      19224100000005000000040000000A003A044200192241002000000006000000
      050000000400120442040000060000000600000006003A041204420400000700
      0000050000000400120442040000070000000600000006003A04120442040000
      09000000050000000400120442040000090000000600000006003A0412044204}
    object ldsItemMeasITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object ldsItemMeasMEAS_ID: TIntegerField
      FieldName = 'MEAS_ID'
    end
    object ldsItemMeasLABEL_UKR: TWideStringField
      FieldName = 'LABEL_UKR'
      Size = 4000
    end
  end
  object memCurMeasList: TMemTableEh
    Params = <>
    Left = 40
    Top = 216
    object memCurMeasListMEAS_ID: TIntegerField
      FieldName = 'MEAS_ID'
    end
    object memCurMeasListMEAS_NAME: TStringField
      FieldName = 'MEAS_NAME'
      Size = 80
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object MEAS_ID: TMTNumericDataFieldEh
          FieldName = 'MEAS_ID'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object MEAS_NAME: TMTStringDataFieldEh
          FieldName = 'MEAS_NAME'
          StringDataType = fdtStringEh
          Size = 80
        end
      end
      object RecordsList: TRecordsListEh
      end
    end
  end
  object dsCurMeasList: TDataSource
    DataSet = memCurMeasList
    Left = 128
    Top = 216
  end
end
