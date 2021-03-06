#Использовать asserts

Перем СтруктураЛога;

Перем ПрефиксБлоков;
Перем ПрефиксСписка;
Перем Версия;
Перем ДатаФормирования;

Функция СообщениеСоответствуетПаттернам(СообщениеКоммита, Паттерны)

	Результат = Ложь;

	Для Каждого КлючевоеСлово из Паттерны Цикл

		Если СтрНачинаетсяС(СообщениеКоммита, КлючевоеСлово.СловоОпределение) Тогда

			Результат = Истина;
			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Процедура ДобавитьКГруппе(ОбъектГруппировки, Сообщение, Блок)

	Группа = ОбъектГруппировки.Строки.Найти(Блок, "Блок");
	НоваяСтрока = Группа.Строки.Добавить();
	НоваяСтрока.Сообщение = Сообщение;

КонецПроцедуры

Функция ИнициализироватьДеревоРезультат(СтруктураЛога)

	Результат = Новый ДеревоЗначений;

	Результат.Колонки.Добавить("Блок",		Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Сообщение", Новый ОписаниеТипов("Строка"));

	Для Каждого ОписаниеБлоков из СтруктураЛога.Строки Цикл

		Строка = Результат.Строки.Добавить();
		Строка.Блок = ОписаниеБлоков.Блок;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Процедура ПереносСтроки(Текст)

	Текст = Текст + Символы.ПС;

КонецПроцедуры


//Интерфейс модуля

Процедура ИспользоватьСтруктуруЛога(ВхЗначение) Экспорт

	Ожидаем.Что(ВхЗначение, "Настройки должны быть заданы в виде ДереваЗначений").ИмеетТип("ДеревоЗначений");
	Ожидаем.Что(ВхЗначение.Строки.Количество(), "Должны быть указаны блоки").Больше(0);

	СтруктураЛога = ВхЗначение;

КонецПроцедуры

Функция ПодготовитьТекстЛога(РазобраннаяИстория)

	Результат = "## " + Версия;
	ПереносСтроки(Результат);
	ПереносСтроки(Результат);

	Результат = Результат + Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd");
	ПереносСтроки(Результат);

	Для Каждого Раздел Из РазобраннаяИстория.Строки Цикл

		Если Раздел.Строки.Количество() = 0 Тогда

			Продолжить;

		КонецЕсли;

		ПереносСтроки(Результат);
		Результат = Результат + ПрефиксБлоков + Раздел.Блок;
		ПереносСтроки(Результат);
		ПереносСтроки(Результат);

		Для Каждого СообщениеКоммита Из Раздел.Строки Цикл

			Результат = Результат + ПрефиксСписка + СообщениеКоммита.Сообщение;
			ПереносСтроки(Результат);

		КонецЦикла;

	КонецЦикла;

	Возврат Результат;

КонецФункции

// Возвращает текстовое представление лога изменений
//
// Параметры:
//  ИсторияКоммитов		- Массив			- полученная история коммитов
//  СтруктураЛога		- ДеревоЗначений	- описание структуры к выводу
//
// Возвращаемое значение:
//   Строка   - разобранная история
//
Функция СформироватьТекстовоеПредставлениеИсторииКоммитов(ИсторияКоммитов) Экспорт

	Результат	= "";

	Разбор = РазложитьИсториюПоДереву(ИсторияКоммитов);

	Возврат ПодготовитьТекстЛога(Разбор);
	
КонецФункции

Функция РазложитьИсториюПоДереву(ИсторияКоммитов)

	Результат = ИнициализироватьДеревоРезультат(СтруктураЛога);

	Для Каждого СообщениеКоммита из ИсторияКоммитов Цикл

		Для Каждого Паттерн из СтруктураЛога.Строки Цикл

			Если СообщениеСоответствуетПаттернам(СообщениеКоммита, Паттерн.Строки) Тогда

				ДобавитьКГруппе(Результат, СообщениеКоммита, Паттерн.Блок);
				Прервать;
			
			КонецЕсли

		КонецЦикла;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Процедура ПриСозданииОбъекта(НомерРелиза = Неопределено)

	ПрефиксБлоков	= "### ";
	ПрефиксСписка	= "* ";
	
	Если НомерРелиза = Неопределено Тогда
		Версия		= "X.X.X";
	Иначе
		Версия		= НомерРелиза;
	КонецЕсли;

КонецПроцедуры