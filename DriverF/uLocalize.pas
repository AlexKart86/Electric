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
vUkrList.Values['N2'] := 'Частоту обертання ротора {tex}n_2{\tex} визначимо із формули, що визначає ковзання: {tex}s=\frac{n_1-n_2}{n_1}{\tex}.'#13#10+
                         'Звідси: {tex}n_2=n_1(1-s)=[n1](1-s){\tex}';
vRusList.Values['N2'] := 'Частоту вращения ротора {tex}n_2{\tex} определим из формулы, которая определяет скольжение: {tex}s=\frac{n_1-n_2}{n_1}{\tex}.'#13#10+
                         'Отсюда: {tex}n_2=n_1(1-s)=[n1](1-s){\tex}';
vUkrList.Values['tbl_h'] := 'Результати розрахунків наведені в таблиці';
vRusList.Values['tbl_h'] := 'Результаты расчетов приведены в таблице';

vUkrList.Values['tbl_h_M1'] := 'Складемо таблицю значень ковзання (s), частоти обертання ротора ({tex}n_2{\tex}) та нового моменту на валу ({tex}M''{\tex}) при зниженій напрузі';
vRusList.Values['tbl_h_M1'] := 'Составим таблицу значений скольжения (s), частоты вращения ротора ({tex}n_2{\tex}) и нового момента на валу ({tex}M''{\tex}) при пониженном напряжении:';

vUkrList.Values['tbl_h1'] :=  'Ковзання, s';
vRusList.Values['tbl_h1'] :=  'Скольжение, s';

vUkrList.Values['tbl_h2'] :=  ' об/хв';
vRusList.Values['tbl_h2'] :=  ' об/мин';

vUkrList.Values['tbl_h3'] :=  'M';
vRusList.Values['tbl_h3'] :=  'M';

vUkrList.Values['tbl_h3_M1'] :=  'M''';
vRusList.Values['tbl_h3_M1'] :=  'M''';

end.
