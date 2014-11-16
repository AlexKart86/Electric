unit uConsts;

//��������� ��������� �������

interface

Type

  // ��� ��������� (R+L+C) (R+X+X)
  TCalcType = (ctRLC, ctRXX);
  // ��� ������� �������
  TFreqType = (frtNone, frtF, frtW);
  // ��� ����������� ���������
  TAddParamType = (apU, apUmax, apUparal, apUmaxParal, apI, apImax, apP, apQ, apS);
  // ��� ��������
  TAddParamElement = (apeNone, apeR, apeL, apeC);

  // ��� ������ ��������� ����������
  TUChangeRule = (uSin, uCos);

const

  //����� �������������� ����������
  TAddParamNames: array [0 .. 8] of String = ('U', 'Umax', 'U�����', 'Umax�����', 'I', 'Imax', 'P', 'Q', 'S');
  TAddParamFormulas: array [0 .. 8] of String = ('U', 'U_max', 'U_String(�����)', 'U_max_String(�����)', 'I', 'I_(max)', 'P', 'Q', 'S');
  TAddParamFormulasW0: array [0 .. 8] of String = ('U', 'U', 'U_String(�����)', 'U_String(�����)', 'I', 'I', 'P', 'Q', 'S');
  //����� ��������� �������������� ����������
  TAddParamElementNames: array[0..3] of string = ('', 'R', 'L', 'C');

implementation

end.
