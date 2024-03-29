
#Использовать asserts
#Использовать tempfiles

Перем лФС;

&Перед
Процедура ПередЗапускомТеста() Экспорт
	Путь = ТекущийСценарий().Каталог + "/../Модули/ФС.os";
	лФС = ЗагрузитьСценарий(Путь);
КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть() Экспорт
	Путь = "d:\build";
	Корень = "d:\";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь);
	Ожидаем.Что(ОтносительныйПуть).Равно("build");

КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть_ДругойСлеш() Экспорт
	Путь = "d:/build";
	Корень = "d:/";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь);
	Ожидаем.Что(ОтносительныйПуть).Равно("build");

КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть_НеСвязанныеПути() Экспорт
	Путь = "d:\build";
	Корень = "w:\";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь);
	Ожидаем.Что(ОтносительныйПуть).Равно(Путь);

КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть_РазныеСлешиВКорнеИПути() Экспорт
	Путь = "d:\build/path";
	Корень = "d:/";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь, ПолучитьРазделительПути());

	Рез = СтрШаблон("build%1path", ПолучитьРазделительПути());
	Ожидаем.Что(ОтносительныйПуть).Равно(Рез);

КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть_ВернутьТочкуДляТекущегоКаталога() Экспорт
	Путь = "d:\build";
	Корень = "d:\build";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь);
	Ожидаем.Что(ОтносительныйПуть).Равно(".");
КонецПроцедуры

&Тест
Процедура Тест_ОтносительныйПуть_РазныеРегистры() Экспорт
	Путь = "c:\j\workspace\p-U4K64BCDKA@2\epf";
	Корень = "C:\j\WORKSPACE\p-U4K64BCDKA@2";

	ОтносительныйПуть = лФС.ОтносительныйПуть(Корень, Путь);
	Ожидаем.Что(ОтносительныйПуть).Равно("epf");
КонецПроцедуры

&Тест
Процедура Тест_ПолныйПуть() Экспорт
	Путь = "C:\projects\SB\vanessa\.\\apache";

	ПолныйПуть = лФС.ПолныйПуть(Путь);
	Ожидаем.Что(ПолныйПуть).Равно("C:\projects\SB\vanessa\apache");
КонецПроцедуры

&Тест
Процедура Тест_ОбъединитьПутиПравильно() Экспорт

	ПолныйПуть = лФС.ОбъединитьПути("E:\my\test", "\images", "upload/pic.png");

	ПолныйПуть = СтрЗаменить(ПолныйПуть, ПолучитьРазделительПути(), "\");

	Ожидаем.Что(ПолныйПуть).Равно("E:\my\test\images\upload\pic.png");
	
КонецПроцедуры

&Тест
#Если Windows Тогда
&Параметры("C:\projects\SB\vanessa\.\\apache", "C:\projects\SB\vanessa\apache")
&Параметры("C:/projects/SB/vanessa\apache/uplevel/..", "C:\projects\SB\vanessa\apache")
&Параметры("C:/projects/SB/vanessa/apache", "C:\projects\SB\vanessa\apache")
#Иначе
&Параметры("C:/projects/SB/vanessa\apache/uplevel/..", "C:/projects/SB/vanessa/apache")
#КонецЕсли
Процедура Тест_ПутиРавны(Первый, Второй) Экспорт
	Ожидаем.Что(лФС.ПутиРавны(Первый, Второй)).ЭтоИстина();
КонецПроцедуры

&Тест
Процедура УдалениеФайловПоМаске() Экспорт
	РабочийКаталог = ВременныеФайлы.СоздатьКаталог();

	Попытка
		СоздатьФайлЗаглушку(РабочийКаталог, "1.txt");
		СоздатьФайлЗаглушку(РабочийКаталог, "1.doc");

		Подкаталог = ОбъединитьПути(РабочийКаталог, "subdir");
		лФС.ОбеспечитьКаталог(Подкаталог);
		СоздатьФайлЗаглушку(Подкаталог, "1.txt");
		СоздатьФайлЗаглушку(Подкаталог, "1.doc");

		лФС.УдалитьФайлы(РабочийКаталог, "*.txt", Истина);

		ОставшиесяФайлы = НайтиФайлы(РабочийКаталог, ПолучитьМаскуВсеФайлы(), Истина);
		Ожидаемое = Новый Соответствие;
		Ожидаемое.Вставить("1.doc",Истина);
		Ожидаемое.Вставить("subdir",Истина);
		Ожидаемое.Вставить(ОбъединитьПути("subdir","1.doc"),Истина);

		Ожидаем.Что(ОставшиесяФайлы.Количество()).Больше(0);
		Для Каждого Файл Из ОставшиесяФайлы Цикл
			Хвост = СтрЗаменить(Файл.ПолноеИмя, РабочийКаталог + ПолучитьРазделительПути(), "");
			Ожидаем.Что(Ожидаемое[Хвост]).ЭтоИстина();
		КонецЦикла;
	Исключение
		ВременныеФайлы.Удалить();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&Тест
Процедура УдалениеКаталогаПоМаске() Экспорт
	РабочийКаталог = ВременныеФайлы.СоздатьКаталог();

	Попытка
		СоздатьФайлЗаглушку(РабочийКаталог, "1.txt");
		СоздатьФайлЗаглушку(РабочийКаталог, "1.doc");

		Подкаталог = ОбъединитьПути(РабочийКаталог, "subdir");
		лФС.ОбеспечитьКаталог(Подкаталог);
		СоздатьФайлЗаглушку(Подкаталог, "1.txt");
		СоздатьФайлЗаглушку(Подкаталог, "1.doc");

		лФС.УдалитьФайлы(РабочийКаталог, ПолучитьМаскуВсеФайлы(), Истина);

		ОставшиесяФайлы = НайтиФайлы(РабочийКаталог, ПолучитьМаскуВсеФайлы(), Истина);
		
		Ожидаем.Что(ОставшиесяФайлы.Количество()).Равно(0);
		
	Исключение
		ВременныеФайлы.Удалить();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

Процедура СоздатьФайлЗаглушку(Каталог, ИмяФайла)
	ПолныйПуть = ОбъединитьПути(Каталог, ИмяФайла);
	Текст = Новый ЗаписьТекста(ПолныйПуть);
	Текст.ЗаписатьСтроку("УДАЛИ МЕНЯ");
	Текст.Закрыть();
КонецПроцедуры
