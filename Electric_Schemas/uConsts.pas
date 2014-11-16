unit uConsts;

//Различные константы проекта

interface

Type

  // Тип обчислень (R+L+C) (R+X+X)
  TCalcType = (ctRLC, ctRXX);
  // Тип задання частоти
  TFreqType = (frtNone, frtF, frtW);
  // Тип додаткового параметра
  TAddParamType = (apU, apI, apS, apP, apQ, apPRi, apUri, apUli, apUci,
    apQli, apQci, apSi, apIi);
  // Тип закона изменения напряжения
  TUChangeRule = (uSin, uCos);

const
  //Имена дополнительных параметров
  TAppParamNames: array [0 .. 12] of String = ('U', 'I', 'S', 'P', 'Q', 'P[r]',
    'U[r]', 'U[l]', 'U[c]', 'Q[l]', 'Q[c]', 'S[i]', 'I[i]');

  //Формулы для рассчета дополнительных параметров
  TAddParamFormulas: array[0..12] of String = ('', '', '', '', '',
    'P_R_i=I_i^2*.R_i',
    'U_R_i=I_i*.R_i',
    'U_L_i=I_i*.X_L_i',
    'U_C_i=I_i*.X_C_i',
    'Q_L_i=I_i^2*.X_L_i',
    'Q_C_i=I_i^2*.X_C_i',
    'S_i=I_i^2*.Z_i',
    'U=I_i*.Z_i');

  //Символы, обозначающие доп. параметры
  TAddParamPrefix: array[0..12] of String = ('U', 'I', 'S', 'P', 'Q', 'P_r',
    'U_r', 'U_l', 'U_c', 'Q_l', 'Q_c', 'S', 'I');

  //Единицы измерения для доп параметров
  TAddParamsPostfix: array[0..12] of string = ('В', 'А', 'ВАP', 'Вт', 'ВА', 'Вт',
   'B', 'B', 'B', 'ВА', 'ВА', 'ВАР', 'A');


  // Список параметров, которые требуют указывать номер ветки
  TNeedNodeParamSet: set of TAddParamType = [apPRi, apUri, apUli, apUci, apQli, apQci, apSi, apIi];

implementation

end.
