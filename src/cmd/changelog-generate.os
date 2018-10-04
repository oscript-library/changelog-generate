#Использовать cli
#Использовать "../core"
#Использовать "."

Перем Лог;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Приложение = Новый КонсольноеПриложение(ПараметрыПриложения.ИмяПриложения(),
											"Приложение для пакетного обновления информационных баз 1С");
	Приложение.Версия("version", ПараметрыПриложения.Версия());

	Приложение.Опция("v verbose", Ложь, "вывод отладочной информация в процессе выполнении")
					.Флаговый()
					.ВОкружении("CHANGELOG_GENERATOR_VERSOBE");

   	Приложение.Опция("a add-authors", 	Ложь,	"Добавить в описание релиза автора коммита").Флаговый();
   	Приложение.Опция("break", 			"",		"После какой надписи выводить новые записи");
   	Приложение.Опция("release",			"",		"Номер релиза");

	Приложение.Аргумент("FROM",			"",		"SHA или TAG откуда начинать парсить логи");
	Приложение.Аргумент("TO",			"",		"SHA или TAG откуда начинать парсить логи")
						.Обязательный(Ложь);		   

	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	ХешМеткаОт    				= КомандаПриложения.ЗначениеАргумента("FROM");
	ХешМеткаДо					= КомандаПриложения.ЗначениеАргумента("TO");
	
	НадписьПрерывания			= КомандаПриложения.ЗначениеОпции("break");
	НомерРелиза 				= КомандаПриложения.ЗначениеОпции("release");

	ВывестиВЛогПользователей	= КомандаПриложения.ЗначениеОпции("add-authors");
	
	Лог = ПараметрыПриложения.ПолучитьЛог();

	ПарсерГит 		= Новый ПарсерГит;
	ЛогИзменений 	= ПарсерГит.ПолучитьМассивКоммитов(ХешМеткаОт, ХешМеткаДо);


КонецПроцедуры // ВыполнитьКоманду


///////////////////////////////////////////////////////

Лог = ПараметрыПриложения.Лог();

Попытка

	ВыполнитьПриложение();

Исключение

	Лог.КритичнаяОшибка(ОписаниеОшибки());

	ЗавершитьРаботу(1);

КонецПопытки;