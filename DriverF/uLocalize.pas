unit uLocalize;
// ������ ��� ����������� ������� ���������

interface


implementation
uses uLocalizeShared;

initialization
vUkrList.Values['Task'] := '������:';
vRusList.Values['Task'] := '�����:';

vUkrList.Values['Fs'] := '��������� ������� �������������� ������������ ������� (������ �� ���� M=f(s) �� ������� ��������� ������ n2 = f(s)).'#13#10+
                         '��� ����� �����������:'#13#10;
vRusList.Values['Fs'] := '���������� ������������ �������������� ������������ ��������� (������ �� ���� M=f(s) � ������� �������� ������ n2 = f(s)).'#13#10+
                         '��� ����� ����������:'#13#10;
vUkrList.Values['N1'] := '';

end.
