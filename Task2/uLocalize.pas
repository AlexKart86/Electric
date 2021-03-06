﻿unit uLocalize;

interface
uses uLocalizeShared;

implementation

initialization

vUkrList.Values['Task'] := 'Знайти:';
vRusList.Values['Task'] := 'Найти:';

vUkrList.Values['Schema'] := 'Еквівалентна схема:';
vRusList.Values['Schema'] := 'Эквивалентная схема:';

vUkrList.Values['Module1#1'] := '1. Визначимо зсув фаз між напругою та силою струму за тангенсом, щоб уникнути втрати знаку кута:';
vRusList.Values['Module1#1'] := '1. Определим смещение фаз между напряжением и силой тока по тангенсу, чтобы избежать потери знака угла:';
vUkrList.Values['Module1#2'] := 'Звідси ';
vRusList.Values['Module1#2'] := 'Отсюда ';

vUkrList.Values['Module1#3_<0'] := 'Як бачимо, φ<0. Це означає, що у колі активно-ємнісний характер навантаження';
vRusList.Values['Module1#3_<0'] := 'Как видим, φ<0.  Это означает,  что в цепи активно-ёмкостный характер нагрузки';

vUkrList.Values['Module1#3_>0'] := 'Як бачимо, φ>0. Це означає, що у колі активно-індуктивний характер навантаження';
vRusList.Values['Module1#3_>0'] := 'Как видим, φ>0.  Это означает,  что в цепи активно-индуктивный характер нагрузки';

vUkrList.Values['Module1#3_0'] := 'Як бачимо, φ=0. Це означає, що у колі лише активний  характер навантаження';
vRusList.Values['Module1#3_0'] := 'Как видим, φ=0.  Это означает,  что в цепи только активный характер нагрузки';

vUkrList.Values['Module1#3_90'] := 'Як бачимо, φ=90°. Це означає, що у колі лише індуктивний характер навантаження';
vRusList.Values['Module1#3_90'] := 'Как видим, φ=90°.  Это означает,  что в цепи только индуктивный характер нагрузки';

vUkrList.Values['Module1#3_-90'] := 'Як бачимо, φ=-90°. Це означає, що у колі лише ємнісний характер навантаження';
vRusList.Values['Module1#3_-90'] := 'Как видим, φ=-90°.  Это означает,  что в цепи только ёмкостный характер нагрузки';

vUkrList.Values['Module2#1'] := '2. Коефіцієнт потужності кола визначається:';
vRusList.Values['Module2#1'] := '2. Коэффициент мощности цепи определяется:';

vUkrList.Values['Module3#1'] := '3. Визначимо загальну напругу:';
vRusList.Values['Module3#1'] := '3. Определим общее напряжение:';

vUkrList.Values['Module4#1'] := '4. Визначимо повний опір (імпеданс) електричного кола:';
vRusList.Values['Module4#1'] := '4. Определим общее сопротивление (импеданс) электической цепи:';

vUkrList.Values['Module5#1'] := '5. Визначимо активну потужність у колі:';
vRusList.Values['Module5#1'] := '5. Определим активную мощность в цепи:';

vUkrList.Values['Module5#2'] := 'Визначимо реактивну потужність у колі:';
vRusList.Values['Module5#2'] := 'Определим реактивную мощность в цепи:';

vUkrList.Values['Module5#3'] := 'Визначимо повну потужність у колі:';
vRusList.Values['Module5#3'] := 'Определим полную мощность в цепи:';

vUkrList.Values['Module6#1'] := '6. Розрахуємо опори кожного елемента (див. еквівалентну схему):';
vRusList.Values['Module6#1'] := '6. Рассчитаем сопротивления каждого элемента (см. эквивалентную схему):';


end.
