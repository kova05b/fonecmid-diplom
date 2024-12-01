Процедура ОбработкаПроведения(Отказ,Режим)

	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина;
	Для Каждого ТекущаяСтрока Из ВКМ_СписокСотрудников Цикл
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия;
		Движение.ПериодРегистрации = Дата;
		Движение.ВКМ_Сотрудник = ТекущаяСтрока.ВКМ_Сотрудник;
		Движение.ВКМ_Результат = ТекущаяСтрока.ВКМ_СуммаПремии;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		Движение.ВКМ_ОтработаноЧасов = 0;
	
	//Удержание
		ДвижениеНДФЛ = Движения.ВКМ_Удержания.Добавить();
		ДвижениеНДФЛ.ПериодРегистрации = Дата;
		ДвижениеНДФЛ.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		ДвижениеНДФЛ.ВКМ_Сотрудник = Движение.ВКМ_Сотрудник;
		ДвижениеНДФЛ.ВКМ_Результат = Движение.ВКМ_Результат * 13 / 100;	
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВКМ_ОсновныеНачисления.ВКМ_Сотрудник,
	|	ВКМ_ОсновныеНачисления.ВКМ_Результат КАК ОсновныеНачисления,
	|	0 КАК ДополнительныеНачисления,
	|	0 КАК Удержание,
	|	ВКМ_ОсновныеНачисления.Регистратор
	|ПОМЕСТИТЬ ВТ_ДвижениеПоРегистру
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	|ГДЕ
	|	ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВКМ_ДополнительныеНачисления.ВКМ_Сотрудник,
	|	0,
	|	ВКМ_ДополнительныеНачисления.ВКМ_Результат,
	|	0,
	|	ВКМ_ДополнительныеНачисления.Регистратор
	|ИЗ
	|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	|ГДЕ
	|	ВКМ_ДополнительныеНачисления.Регистратор = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВКМ_Удержания.Сотрудник,
	|	СУММА(0),
	|	СУММА(0),
	|	СУММА(ВКМ_Удержания.Результат),
	|	ВКМ_Удержания.Регистратор
	|ИЗ
	|	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	|ГДЕ
	|	ВКМ_Удержания.Регистратор = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_Удержания.ВКМ_Сотрудник,
	|	ВКМ_Удержания.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДвижениеПоРегистру.Регистратор,
	|	ВТ_ДвижениеПоРегистру.ВКМ_Сотрудник,
	|	СУММА(ВТ_ДвижениеПоРегистру.ОсновныеНачисления) КАК ОсновныеНачисления,
	|	СУММА(ВТ_ДвижениеПоРегистру.ДополнительныеНачисления) КАК ДополнительныеНачисления,
	|	СУММА(ВТ_ДвижениеПоРегистру.Удержание) КАК Удержание
	|ИЗ
	|	ВТ_ДвижениеПоРегистру КАК ВТ_ДвижениеПоРегистру
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ДвижениеПоРегистру.Регистратор,
	|	ВТ_ДвижениеПоРегистру.ВКМ_Сотрудник";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	НаборЗаписейВзаиморасчетыССотрудниками = РегистрыНакопления.ВКМ_ВзаиморасчетыССотрудниками.СоздатьНаборЗаписей();
	НаборЗаписейВзаиморасчетыССотрудниками.Отбор.Регистратор.Установить(Ссылка);
	НаборЗаписейВзаиморасчетыССотрудниками.Прочитать();
	НаборЗаписейВзаиморасчетыССотрудниками.Очистить();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Запись = НаборЗаписейВзаиморасчетыССотрудниками.ДобавитьПриход();
		ЗаполнитьЗначенияСвойств(Запись, ВыборкаДетальныеЗаписи);
		Запись.Период = Дата;
		Запись.ВКМ_Сумма = ВыборкаДетальныеЗаписи.ОсновныеНачисления + ВыборкаДетальныеЗаписи.ДополнительныеНачисления
			- ВыборкаДетальныеЗаписи.Удержание;

	КонецЦикла;
	НаборЗаписейВзаиморасчетыССотрудниками.Записать();
	
КонецПроцедуры

