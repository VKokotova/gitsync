﻿///////////////////////////////////////////////////////////////////
//
// Выполняет синхронизацию хранилища 1С с Git 
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать cmdline
#Использовать logos

#Использовать "core"

///////////////////////////////////////////////////////////////////

Перем Лог;

///////////////////////////////////////////////////////////////////

Процедура ВывестиВерсию()
	
	Сообщить("GitSync v" + ПараметрыСистемы.ВерсияПродукта());
	
КонецПроцедуры // ВывестиВерсию()

Функция РазобратьАргументыКоманднойСтроки()
	
	Парсер = ПолучитьПарсерКоманднойСтроки();
	Возврат Парсер.Разобрать(АргументыКоманднойСтроки);
	
КонецФункции // РазобратьАргументыКоманднойСтроки

Функция ПолучитьПарсерКоманднойСтроки()
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();    
	МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);
	
	Возврат Парсер;
	
КонецФункции // ПолучитьПарсерКоманднойСтроки

Функция ВыполнениеКоманды()
	
	ВывестиВерсию();
	ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();
	
	Если ПараметрыЗапуска = Неопределено ИЛИ ПараметрыЗапуска.Количество() = 0 Тогда
		
		Лог.Ошибка("Некорректные аргументы командной строки");
		МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
		Возврат МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения;
		
	КонецЕсли;
	
	Команда = "";
	ЗначенияПараметров = Неопределено;
	
	Если ТипЗнч(ПараметрыЗапуска) = Тип("Структура") Тогда
		
		// это команда
		Команда				= ПараметрыЗапуска.Команда;
		ЗначенияПараметров	= ПараметрыЗапуска.ЗначенияПараметров;
		
	ИначеЕсли ЗначениеЗаполнено(ПараметрыСистемы.ИмяКомандыПоУмолчанию()) Тогда
		
		// это команда по-умолчанию
		Команда				= ПараметрыСистемы.ИмяКомандыПоУмолчанию();
		ЗначенияПараметров	= ПараметрыЗапуска;
		
	Иначе
		
		ВызватьИсключение "Некорректно настроено имя команды по-умолчанию.";
		
	КонецЕсли;
	
	Возврат МенеджерКомандПриложения.ВыполнитьКоманду(Команда, ЗначенияПараметров);
	
КонецФункции // ВыполнениеКоманды()

///////////////////////////////////////////////////////////////////

Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
МенеджерКомандПриложения.РегистраторКоманд(ПараметрыСистемы);

Попытка
		
	ЗавершитьРаботу(ВыполнениеКоманды());
		
Исключение
		
	Лог.КритичнаяОшибка(ОписаниеОшибки());
	ЗавершитьРаботу(МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения);
		
КонецПопытки;
