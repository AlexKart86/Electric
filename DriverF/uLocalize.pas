unit uLocalize;
// Модуль для локализации текстов сообщений

interface


implementation
uses uLocalizeShared;

initialization
vUkrList.Values['Task'] := 'Знайти:';
vRusList.Values['Task'] := 'Найти:';

vUkrList.Values['Fs'] := 'Розрахуємо механічні характеристики асинхронного двигуна (момент на валу M=f(s) та частоту обертання ротора n2 = f(s)).'#13#10+
                         'Для цього використаємо:'#13#10;
vRusList.Values['Fs'] := 'Рассчитаем механические характеристики асинхронного двигателя (момент на валу M=f(s) и частоту вращения ротора n2 = f(s)).'#13#10+
                         'Для этого используем:'#13#10;
vUkrList.Values['N1'] := '';

end.
