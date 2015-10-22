object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 507
  Width = 580
  object dbMain: TSQLiteDatabase
    Connected = True
    Filename = 'K:\Electric\DriverF\BIN\formulas.db'
    Left = 32
    Top = 16
  end
  object memItems: TMemTableEh
    FieldDefs = <
      item
        Name = 'ITEM_ID'
        DataType = ftInteger
        Precision = 15
      end
      item
        Name = 'MEASURE_ID'
        DataType = ftInteger
        Precision = 15
      end
      item
        Name = 'VALUE'
        DataType = ftFloat
        Precision = 15
      end
      item
        Name = 'ITEM_IMG'
        DataType = ftGraphic
      end
      item
        Name = 'HINT'
        DataType = ftString
        Size = 4000
      end
      item
        Name = 'CALC_VALUE_CORRECT'
        DataType = ftFloat
        Precision = 15
      end
      item
        Name = 'F_TEX'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'DESC_RU'
        DataType = ftString
        Size = 400
      end>
    FetchAllOnOpen = True
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterScroll = memItemsAfterScroll
    OnCalcFields = memItemsCalcFields
    Left = 32
    Top = 128
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
    object memItemsHINT: TStringField
      FieldName = 'HINT'
      Size = 4000
    end
    object memItemsCALC_VALUE_CORRECT: TFloatField
      FieldName = 'CALC_VALUE_CORRECT'
    end
    object memItemsVALUE_CORRECT: TFloatField
      FieldKind = fkCalculated
      FieldName = 'VALUE_CORRECT'
      Calculated = True
    end
    object memItemsCALC_VALUE: TFloatField
      DisplayLabel = #1056#1086#1079#1088#1072#1093#1086#1074#1072#1085#1077' '#1079#1085#1072#1095#1077#1085#1085#1103
      FieldKind = fkCalculated
      FieldName = 'CALC_VALUE'
      Calculated = True
    end
    object memItemsF_TEX: TStringField
      FieldName = 'F_TEX'
      Size = 100
    end
    object memItemsNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object memItemsRESULT_VALUE: TFloatField
      FieldKind = fkCalculated
      FieldName = 'RESULT_VALUE'
      Calculated = True
    end
    object memItemsDESC_RU: TStringField
      DisplayLabel = #1053#1072#1079#1074#1072
      FieldName = 'DESC_RU'
      Size = 400
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
        object ITEM_IMG: TMTBlobDataFieldEh
          FieldName = 'ITEM_IMG'
          BlobType = ftGraphic
          GraphicHeader = False
          Transliterate = False
        end
        object HINT: TMTStringDataFieldEh
          FieldName = 'HINT'
          StringDataType = fdtStringEh
          Size = 4000
        end
        object CALC_VALUE_CORRECT: TMTNumericDataFieldEh
          FieldName = 'CALC_VALUE_CORRECT'
          NumericDataType = fdtFloatEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object F_TEX: TMTStringDataFieldEh
          FieldName = 'F_TEX'
          StringDataType = fdtStringEh
          Size = 100
        end
        object NAME: TMTStringDataFieldEh
          FieldName = 'NAME'
          StringDataType = fdtStringEh
          Size = 100
        end
        object DESC_RU: TMTStringDataFieldEh
          FieldName = 'DESC_RU'
          StringDataType = fdtStringEh
          Size = 400
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
      end
      item
        Name = 'LABEL_UKR_TR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'LABEL_RU_TR'
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
    object ldsMeasuresLABEL_UKR_TR: TWideStringField
      FieldName = 'LABEL_UKR_TR'
      Size = 4000
    end
    object ldsMeasuresLABEL_RU_TR: TWideStringField
      FieldName = 'LABEL_RU_TR'
      Size = 4000
    end
  end
  object ldsItemMeas: TSQLiteDataset
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
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 40
    Top = 216
    object memCurMeasListID: TIntegerField
      FieldName = 'ID'
    end
    object memCurMeasListLABEL_UKR: TStringField
      FieldName = 'LABEL_UKR'
      Size = 80
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object ID: TMTNumericDataFieldEh
          FieldName = 'ID'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object LABEL_UKR: TMTStringDataFieldEh
          FieldName = 'LABEL_UKR'
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
  object ldsFormulas: TSQLiteDataset
    Aggregates = <>
    CommandText = 'select * from formulas'
    FieldDefs = <
      item
        Name = 'FORMULA_ID'
        DataType = ftInteger
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
        Name = 'ITEM_ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'NAME_RUS'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'TEXT_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'TEXT_RUS'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'FONT_SIZE'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Database = dbMain
    Left = 336
    Top = 16
    object ldsFormulasFORMULA_ID: TIntegerField
      FieldName = 'FORMULA_ID'
    end
    object ldsFormulasF_STR: TWideStringField
      FieldName = 'F_STR'
      Size = 4000
    end
    object ldsFormulasF_TEX: TWideStringField
      FieldName = 'F_TEX'
      Size = 4000
    end
    object ldsFormulasITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object ldsFormulasNAME_UKR: TWideStringField
      FieldName = 'NAME_UKR'
      Size = 4000
    end
    object ldsFormulasNAME_RUS: TWideStringField
      FieldName = 'NAME_RUS'
      Size = 4000
    end
    object ldsFormulasTEXT_UKR: TWideStringField
      FieldName = 'TEXT_UKR'
      Size = 4000
    end
    object ldsFormulasTEXT_RUS: TWideStringField
      FieldName = 'TEXT_RUS'
      Size = 4000
    end
    object ldsFormulasFONT_SIZE: TWideStringField
      FieldName = 'FONT_SIZE'
      Size = 4000
    end
  end
  object ldsFormulaDetail: TSQLiteDataset
    Aggregates = <>
    CommandText = 
      'select fd.*,'#13#10'       f.F_STR,'#13#10'       it.NAME'#13#10'from formula_deta' +
      'il fd,'#13#10'     formulas f,'#13#10'     items it'#13#10'where f.FORMULA_ID = fd' +
      '.FORMULA_ID and fd.ITEM_ID = it.ID'
    FieldDefs = <
      item
        Name = 'FORMULA_ID'
        DataType = ftInteger
      end
      item
        Name = 'ITEM_ID'
        DataType = ftInteger
      end
      item
        Name = 'F_STR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Database = dbMain
    Left = 408
    Top = 16
    object ldsFormulaDetailFORMULA_ID: TIntegerField
      FieldName = 'FORMULA_ID'
    end
    object ldsFormulaDetailITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object ldsFormulaDetailF_STR: TWideStringField
      FieldName = 'F_STR'
      Size = 4000
    end
    object ldsFormulaDetailNAME: TWideStringField
      FieldName = 'NAME'
      Size = 4000
    end
  end
  object ilFormulas: TImageList
    Left = 224
    Top = 120
  end
end
