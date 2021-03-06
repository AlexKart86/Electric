﻿unit uLocalize;
// Модуль для локализации текстов сообщений

interface


implementation
uses uLocalizeShared;

initialization
vUkrList.Values['Task'] := 'Знайти:';
vRusList.Values['Task'] := 'Найти:';

vUkrList.Values['Fs'] := 'Розрахуємо механічні характеристики асинхронного двигуна (момент на валу M=f(s) та частоту обертання ротора {tex}n_2=f(s){\tex}).'#13#10+
                         'Для цього використаємо:'#13#10;
vRusList.Values['Fs'] := 'Рассчитаем механические характеристики асинхронного двигателя (момент на валу M=f(s) и частоту вращения ротора {tex}n_2=f(s){\tex}).'#13#10+
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

vUkrList.Values['M1_1'] := 'У разі зниження напруги в мережі на {tex}(1 - k)\cdot 100% =[100kDelta]\,%{\tex} на виводах двигуна напруга стане рівною: '+
                           '{tex}U=k_U\cdot U_{\cyr{n}}=[kU]\cdot[Un]=[U]{\tex} В. При зниженій напрузі мережі  зменшується і обертовий момент, '+
                           'оскільки він пропорційний квадрату напруги.'#13#10+
                           'Оскільки момент двигуна пропорційний квадрату напруги, то'#13#10                           ;
vRusList.Values['M1_1'] := 'В случае понижения напряжения в сети на {tex}(1- k)\cdot 100% =[100kDelta]\,%{\tex} на выводах двигателя напряжение станет равным: '+
                           '{tex}U=k_U\cdot U_{\cyr{n}}=[kU]\cdot[Un]=[U]{\tex} В. При пониженном напряжении сети  уменьшится развиваемый двигателем вращающий момент, '+
                           'так как он пропорционален квадрату напряжения.'#13#10+
                           'Поскольку момент двигателя пропорциональный квадрату напряжения, то:'#13#10;
vUkrList.Values['M1_2'] := 'Звідси:';
vRusList.Values['M1_2'] := 'Отсюда:';

vUkrList.Values['M1_3'] := 'Як бачимо, новий пусковий момент ';
vRusList.Values['M1_3'] := 'Как видим, новый пусковой момент ';

vUkrList.Values['M1_3>'] := 'більший за номінальний момент: {tex}M''_{\cyr{pusk}}>M_{\cyr{n}}{\tex}. Тому пуск двигуна при такій зниженій напрузі буде можливим';
vRusList.Values['M1_3>'] := 'больший за номинальный момент: {tex}M''_{\cyr{pusk}}>M_{\cyr{n}}{\tex}. Поэтому пуск двигателя при таком пониженном напряжении будет возможным.';
vUkrList.Values['M1_3<'] := 'менший за номінальний момент: {tex}M''_{\cyr{pusk}}<M_{\cyr{n}}{\tex}. Тому пуск двигуна при такій зниженій напрузі буде неможливим';
vRusList.Values['M1_3<'] := 'меньший за номинальный момент: {tex}M''_{\cyr{pusk}}<M_{\cyr{n}}{\tex}. Поэтому пуск двигателя при таком пониженном напряжении будет невозможным';
vUkrList.Values['M1_3='] := 'рівний номінальному моменту: {tex}M''_{\cyr{pusk}}=M_{\cyr{n}}{\tex}. Тому пуск двигуна при такій зниженій напрузі в принципі буде можливим.';
vRusList.Values['M1_3='] := 'равный номинальному моменту: {tex}M''_{\cyr{pusk}}=M_{\cyr{n}}{\tex}. Поэтому пуск двигателя при таком пониженном напряжении в принципе будет возможным.';

vUkrList.Values['M1_4'] := 'Номінальний момент на валу при цьому буде визначатися схожою формулою:';
vRusList.Values['M1_4'] := 'Номинальный момент на валу при этом будет определяться похожей формулой:';

vUkrList.Values['M1_5'] := 'Механічна характеристика при цьому M′=f(s) визначатиметься за рівнянням Клосса:';
vRusList.Values['M1_5'] := 'Механическая характеристика при этом M′=f(s) будет определяться согласно уравнению Клосса:';

vUkrList.Values['Gr0'] := 'Робота двигуна';
vRusList.Values['Gr0'] := 'Работа двигателя';


vUkrList.Values['Gr1'] := 'Стійка';
vRusList.Values['Gr1'] := 'Устойчивая';

vUkrList.Values['Gr2'] := 'Не стійка';
vRusList.Values['Gr2'] := 'Не устойчивая';

vUkrList.Values['Gr3'] := 'Для порівняння наведемо в одних осях координат механічну характеристику {tex}n_2=f(M){\tex} при номінальній ({tex}U_{\cyr{n}}{\tex}) та зниженій ({tex}U=k_U\cdot U_{\cyr{n}}{\tex}) напругах:';
vRusList.Values['Gr3'] := 'Для сравнения приведем в одних осях координат механическую характеристику {tex}n_2=f(M){\tex} при номинальном ({tex}U_{\cyr{n}}{\tex}) и пониженном ({tex}U=k_U\cdot U_{\cyr{n}}{\tex}) напряжениях:';

vUkrList.Values['Gr4'] := 'На рисунку приведена механічна характеристика двигуна, де 1 - при номінальній напрузі {tex}U_{\cyr{n}}{\tex}, 2 - при зниженій напрузі {tex}U=k_U\cdot U_{\cyr{n}}{\tex}';
vRusList.Values['Gr4'] := 'На рисунке приведена механическая характеристика двигателя, где 1 - при номинальном напряжении {tex}U_{\cyr{n}}{\tex}, 2 - при пониженном напряжении {tex}U=k_U\cdot U_{\cyr{n}}{\tex}';

end.
