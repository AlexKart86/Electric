unit uConsts;

//Различные константы проекта

interface

Type

  // Тип обчислень (R+L+C) (R+X+X)
  TCalcType = (ctRLC, ctRXX);
  // Тип задання частоти
  TFreqType = (frtNone, frtF, frtW);
  // Тип додаткового параметра
  TAddParamType = (apU, apUmax, apUparal, apUmaxParal, apI, apImax, apP, apQ, apS);
  // Тип элемента
  TAddParamElement = (apeNone, apeR, apeL, apeC);

  // Тип закона изменения напряжения
  TUChangeRule = (uSin, uCos);

const

  //Имена дополнительных параметров
  TAddParamNames: array [0 .. 8] of String = ('U', 'Umax', 'Uпарал', 'Umaxпарал', 'I', 'Imax', 'P', 'Q', 'S');
  TAddParamFormulas: array [0 .. 8] of String = ('U', 'U_max', 'U_String(парал)', 'U_max_String(парал)', 'I', 'I_(max)', 'P', 'Q', 'S');
  TAddParamFormulasW0: array [0 .. 8] of String = ('U', 'U', 'U_String(парал)', 'U_String(парал)', 'I', 'I', 'P', 'Q', 'S');
  //Имена элементов дополнительных параметров
  TAddParamElementNames: array[0..3] of string = ('', 'R', 'L', 'C');

implementation

end.
