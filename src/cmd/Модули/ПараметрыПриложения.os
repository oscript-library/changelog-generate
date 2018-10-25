///////////////////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором служебных параметров приложения
//
// При создании нового приложения обязательно внести изменение 
// в ф-ии ИмяПриложения, указав имя вашего приложения.
//
// При выпуске новой версии обязательно изменить ее значение
// в ф-ии ВерсияПродукта
//
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// СВОЙСТВА ПРОДУКТА

// Версия
//	Возвращает текущую версию продукта
//
// Возвращаемое значение:
//   Строка   - Значение текущей версии продукта
//
Функция Версия() Экспорт
	
	Возврат "1.0.0";
	
КонецФункции // Версия

// ИмяПриложения
//	Возвращает имя продукта
//
// Возвращаемое значение:
//   Строка   - Значение имени продукта
//
Функция ИмяПриложения() Экспорт
	
	Возврат "changelog-generate";
	
КонецФункции // ИмяПриложения

///////////////////////////////////////////////////////////////////////////////
// ЛОГИРОВАНИЕ

//	Форматирование логов
//   См. описание метода "УстановитьРаскладку" библиотеки logos
//
Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции
	
// ИмяЛогаСистемы
//	Возвращает идентификатор лога приложения
//
// Возвращаемое значение:
//   Строка   - Значение идентификатора лога приложения
//
Функция ИмяЛога() Экспорт
	
	Возврат "oscript.app." + ИмяПриложения();
	
КонецФункции // ИмяЛогаСистемы

Функция Лог() Экспорт
	Возврат Логирование.ПолучитьЛог(ИмяЛога());
КонецФункции