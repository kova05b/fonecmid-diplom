#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ,Режим)
	Если ВКМ_Договор.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание Тогда
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!
	
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СУММА(ВКМ_ОбслуживаниеКлиентаВКМ_ВыполненныеРаботы.ВКМ_ЧасыКОплатеКлиенту) КАК ВКМ_ЧасыКОплатеКлиенту,
			|	ДоговорыКонтрагентов.ВКМ_ЧасоваяСтавкаСпециалиста
			|ИЗ
			|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВКМ_ОбслуживаниеКлиента.ВКМ_ВыполненныеРаботы КАК
			|			ВКМ_ОбслуживаниеКлиентаВКМ_ВыполненныеРаботы
			|		ПО ВКМ_ОбслуживаниеКлиентаВКМ_ВыполненныеРаботы.Ссылка.ВКМ_Договор = ДоговорыКонтрагентов.Ссылка
			|ГДЕ
			|	ВКМ_ОбслуживаниеКлиентаВКМ_ВыполненныеРаботы.Ссылка.Ссылка = &Ссылка
			|	И ВКМ_ОбслуживаниеКлиентаВКМ_ВыполненныеРаботы.Ссылка.Дата
			|		МЕЖДУ ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействия И ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействия
			|СГРУППИРОВАТЬ ПО
			|	ДоговорыКонтрагентов.ВКМ_ЧасоваяСтавкаСпециалиста";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;
		Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
				Движение.Период = Дата;
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.ВКМ_Клиент = ВКМ_Клиент;
				Движение.ВКМ_Договор = ВКМ_Договор;
				Движение.ВКМ_КоличествоЧасов = ВыборкаДетальныеЗаписи.ВКМ_ЧасыКОплатеКлиенту;
				Движение.ВКМ_СуммаКОплате = ВыборкаДетальныеЗаписи.ВКМ_ЧасыКОплатеКлиенту * ВыборкаДетальныеЗаписи.ВКМ_ЧасоваяСтавкаСпециалиста;
			КонецЦикла;
		Иначе Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Дата документа не соответствует сроку действия договора.";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	
	Иначе Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Необходимо выбрать договор Абонентского обслуживания. Проведение документа отменено.";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти