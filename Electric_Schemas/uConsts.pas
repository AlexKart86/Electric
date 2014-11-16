unit uConsts;

//��������� ��������� �������

interface

Type

  // ��� ��������� (R+L+C) (R+X+X)
  TCalcType = (ctRLC, ctRXX);
  // ��� ������� �������
  TFreqType = (frtNone, frtF, frtW);
  // ��� ����������� ���������
  TAddParamType = (apU, apI, apS, apP, apQ, apPRi, apUri, apUli, apUci,
    apQli, apQci, apSi, apIi);
  // ��� ������ ��������� ����������
  TUChangeRule = (uSin, uCos);

const
  //����� �������������� ����������
  TAppParamNames: array [0 .. 12] of String = ('U', 'I', 'S', 'P', 'Q', 'P[r]',
    'U[r]', 'U[l]', 'U[c]', 'Q[l]', 'Q[c]', 'S[i]', 'I[i]');

  //������� ��� �������� �������������� ����������
  TAddParamFormulas: array[0..12] of String = ('', '', '', '', '',
    'P_R_i=I_i^2*.R_i',
    'U_R_i=I_i*.R_i',
    'U_L_i=I_i*.X_L_i',
    'U_C_i=I_i*.X_C_i',
    'Q_L_i=I_i^2*.X_L_i',
    'Q_C_i=I_i^2*.X_C_i',
    'S_i=I_i^2*.Z_i',
    'U=I_i*.Z_i');

  //�������, ������������ ���. ���������
  TAddParamPrefix: array[0..12] of String = ('U', 'I', 'S', 'P', 'Q', 'P_r',
    'U_r', 'U_l', 'U_c', 'Q_l', 'Q_c', 'S', 'I');

  //������� ��������� ��� ��� ����������
  TAddParamsPostfix: array[0..12] of string = ('�', '�', '��P', '��', '��', '��',
   'B', 'B', 'B', '��', '��', '���', 'A');


  // ������ ����������, ������� ������� ��������� ����� �����
  TNeedNodeParamSet: set of TAddParamType = [apPRi, apUri, apUli, apUci, apQli, apQci, apSi, apIi];

implementation

end.
