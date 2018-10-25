#Использовать cli
#Использовать fs
#Использовать "../core"
#Использовать "."

Перем Лог;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Приложение = Новый КонсольноеПриложение(ПараметрыПриложения.ИмяПриложения(),
											"Приложение для обновления файла логов изменения по истории коммитов");
	Приложение.Версия("version", ПараметрыПриложения.Версия());

	Приложение.Опция("v verbose", Ложь, "вывод отладочной информация в процессе выполнении")
					.Флаговый()
					.ВОкружении("CHANGELOG_GENERATOR_VERSOBE");

   	Приложение.Опция("breakline", 		"# CHANGELOG",	"После какой надписи выводить новые записи");
	Приложение.Опция("release",			"X.X.X",		"Номер релиза");
	Приложение.Опция("s settings",		Неопределено,	"Путь к YML файлу настроек структуры лога.");
	Приложение.Опция("filename",		"CHANGELOG.MD",	"Файл для вывода лога изменений");

	Приложение.Аргумент("FROM",			"",		"SHA или TAG откуда начинать парсить логи");
	Приложение.Аргумент("TO",			"",		"SHA или TAG откуда начинать парсить логи")
						.Обязательный(Ложь);		   

	Приложение.УстановитьОсновноеДействие(ЭтотОбъект);
	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()

Процедура ВывестиВФайлЛога(ИмяФайла, ТекстЛога, Разделитель)


	Если ФС.ФайлСуществует(ИмяФайла) Тогда

		ТекстРедактирования = ПрочитатьСодержимоеФайла(ИмяФайла);

	Иначе

		ТекстРедактирования = Разделитель;

	КонецЕсли;

	ПозицияВывода = Найти(ТекстРедактирования, Разделитель) + СтрДлина(Разделитель);

	ТекстКВыводу = Лев(ТекстРедактирования, ПозицияВывода) 
						+ Символы.ПС 
						+ Символы.ПС
						+ ТекстЛога 
						+ Сред(ТекстРедактирования, ПозицияВывода + 1);

	ВывестиВФайл(ИмяФайла, ТекстКВыводу);

КонецПроцедуры

Функция ПрочитатьСодержимоеФайла(ПутьКФайлу)

	ЧтениеФайла = Новый ЧтениеТекста;
	ЧтениеФайла.Открыть(ПутьКФайлу, КодировкаТекста.UTF8);

	Текст = ЧтениеФайла.Прочитать();

	ЧтениеФайла.Закрыть();

	Возврат Текст;

КонецФункции

Процедура ВывестиВФайл(ПутьКФайлу, Содержимое)

	ЗаписьФайла = Новый ЗаписьТекста;
	ЗаписьФайла.Открыть(ПутьКФайлу, КодировкаТекста.UTF8);
	ЗаписьФайла.Записать(Содержимое);
	ЗаписьФайла.Закрыть();

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	ХешМеткаОт    				= КомандаПриложения.ЗначениеАргумента("FROM");
	ХешМеткаДо					= КомандаПриложения.ЗначениеАргумента("TO");
	
	ФайлНастроек				= КомандаПриложения.ЗначениеОпции("settings");
	НастрокиИзФайла				= ПарсерНастроек.ПрочитатьНастройки(ФайлНастроек);

	НадписьПрерывания			= КомандаПриложения.ЗначениеОпции("breakline");
	НомерРелиза 				= КомандаПриложения.ЗначениеОпции("release");
	ФайлДляВывода				= КомандаПриложения.ЗначениеОпции("filename");

	ЛогИзменений 				= ПарсерГит.ПолучитьМассивКоммитов(ХешМеткаОт, ХешМеткаДо);
	
	СтруктураВывода				= Новый СтруктураЛога;
	СтруктураВывода.ИспользоватьНастройки(НастрокиИзФайла["massage_groups"]);

	ДеревоВывода				= СтруктураВывода.ПолучитьСтруктуруЛога();

	Генератор					= Новый ГенераторЛога(НомерРелиза);
	Генератор.ИспользоватьСтруктуруЛога(ДеревоВывода);

	ТекстЛога					= Генератор.СформироватьТекстовоеПредставлениеИсторииКоммитов(ЛогИзменений);

	ВывестиВФайлЛога(ФайлДляВывода, ТекстЛога, НадписьПрерывания);

	Лог.Информация("Файл %1 обновлен", ФайлДляВывода);

КонецПроцедуры // ВыполнитьКоманду

///////////////////////////////////////////////////////
Лог = ПараметрыПриложения.Лог();

Попытка

	ВыполнитьПриложение();

Исключение

	Лог.КритичнаяОшибка(ОписаниеОшибки());

	ЗавершитьРаботу(1);

КонецПопытки;