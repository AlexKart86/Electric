object dmMain: TdmMain
  OldCreateOrder = False
  Height = 507
  Width = 580
  object dbMain: TSQLiteDatabase
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
    Active = True
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
    Data = {
      D10200009619E0BD010000001800000007000C00000003000000C50002494404
      00010000000000094C4142454C5F554B5202004A000000010005574944544802
      000200401F054B4F45464608000400000000000F4445534352495054494F4E5F
      554B5202004A000000010005574944544802000200401F07424153455F494404
      000100000000000E4445534352495054494F4E5F525502004A00000001000557
      4944544802000200401F084C4142454C5F525502004A00000001000557494454
      4802000200401F00000000000200000002004100000000000000F03F0A001004
      3C043F0435044004000000000000000000000001000000020012040000000000
      00F03F0A0012043E043B044C0442040000000000000000000000030000000600
      420019224100000000000000F03F160012043E043B044C0442042D0030043C04
      3F04350440040000000000000000000000040000000A003A0442001922410020
      000000000000408F401E001A0456043B043E0432043E043B044C0442042D0030
      043C043F0435044004040000001E001A0438043B043E0432043E043B044C0442
      042D0030043C043F043504400400000000000500000004001204420400000000
      0000F03F0800120430044204420400000000000000000000000600000006003A
      04120442040000000000408F4010001A0456043B043E04320430044204420405
      000000000000000000000700000006001D0419223C04000000000000F03F0000
      000000000000000000000008000000020025007B14AE47E17A843F0000090000
      0000000000000000090000000000000000000000F03F00000000000000000000
      0000000A0000000A003E0431042F0045043204000000000000F03F0000000000
      0000000C003E0431042F003C0438043D040000000B0000000A00400430043404
      2F004104000000000000F03F000000000000000000000000000C000000040013
      044604000000000000F03F00000000000000000000}
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
end
