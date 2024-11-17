Процедура РассчитатьОсновныеНачисления(Регистратор, Движения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
	|	ОсновныеНачисленияДанныеГрафика.Параметр КАК Параметр,
	|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ВКМ_ДниФактическийПериодДействия, 0) КАК ДнейФакт,
	|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ВКМ_ДниПериодДействия, 0) КАК ДнейПлан,
	|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ВКМ_ЧасыПериодДействия, 0) КАК ЧасовПлан,
	|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ВКМ_ЧасыФактическийПериодДействия, 0) КАК ЧасовФакт
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(Регистратор = &Регистратор
	|	И ВидРасчета = &ВидРасчетаОклад) КАК ОсновныеНачисленияДанныеГрафика";
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("ВидРасчетаОклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("НомерСтроки", 0);
	Выборка = Запрос.Выполнить().Выбрать();
	Для Каждого Запись Из Движения Цикл
		СтруктураПоиска.НомерСтроки = Запись.НомерСтроки;
		Если Выборка.НайтиСледующий(СтруктураПоиска) Тогда
			Запись.Результат = ?(Выборка.ЧасовПлан = 0, 0, Выборка.Параметр / Выборка.ЧасовПлан * Выборка.ЧасовФакт);
			Запись.ОтработаноЧасов = Выборка.ЧасовФакт;
		КонецЕсли;
		Выборка.Сбросить();
	КонецЦикла;
	
	Движения.Записать(, Истина); // Необходимо записать до расчета командировки, так как сторно записи могут попасть в базу командировки
	
КонецПроцедуры