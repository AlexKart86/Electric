unit uLocalize;
// Модуль для локализации текстов сообщений

interface


implementation
uses uLocalizeShared;

initialization
vUkrList.Values['Task'] := 'Знайти:';
vRusList.Values['Task'] := 'Найти:';

end.
