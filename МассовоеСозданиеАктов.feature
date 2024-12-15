﻿#language: ru

@tree

Функционал: Массовое создание Актов

Как Бухгалтер я запускаю обработку по Массовому созданию актов

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Массовое создание актов

	И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Массовое создание актов'
Тогда открылось окно 'Массовое создание актов'
И в поле с именем 'Период' я ввожу текст '12.2024'
И я нажимаю на кнопку с именем 'Сформировать'
Тогда открылось окно '1С:Предприятие'
И я нажимаю на кнопку с именем 'Button0'
И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Анализ выставленных актов'
Тогда открылось окно 'Основной'
И я нажимаю кнопку выбора у поля с именем "Период1ДатаНачала"
И в поле с именем 'Период1ДатаНачала' я ввожу текст '01.12.2024'
И я нажимаю кнопку выбора у поля с именем "Период1ДатаОкончания"
И в поле с именем 'Период1ДатаОкончания' я ввожу текст '31.12.2024'
И я нажимаю на кнопку с именем 'СформироватьОтчет'
