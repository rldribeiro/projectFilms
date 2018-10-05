-- Reset Base de Dados
CREATE DATABASE ProjectoFilmes
GO

USE ProjectoFilmes
GO

-- Tabelas Atómicas

CREATE TABLE Films (
	id				int identity(1,1)		Primary Key,
	title			nvarchar(200)			NOT NULL,
	release_date	date					NOT NULL,
	runtime 		int						NOT NULL,
    synopsis		nvarchar(1000)			NOT NULL,
    tag_line		nvarchar(300),
	imdb_code		nvarchar(50),
    img_poster		nvarchar(50) DEFAULT 'GodardNoPoster'
)

CREATE TABLE Countries (
	iso_code		char(2)					Primary Key,
	country_name	nvarchar(50)			NOT NULL UNIQUE
)

CREATE TABLE Languages (
    iso_code        char(2)                 Primary Key,
	language_name	nvarchar(50)			NOT NULL UNIQUE
)

CREATE TABLE Studios (
	id				int identity(1,1)		Primary Key,
	studio_name		nvarchar(50)			NOT NULL UNIQUE
)

CREATE TABLE Genres (
	id				int identity(1,1)		Primary Key,
	genre_name		nvarchar(50)			NOT NULL UNIQUE,
)

CREATE TABLE Roles (
	id				int identity(1,1)       Primary Key,
	role_name		nvarchar(50)			NOT NULL UNIQUE
)
GO

-- Tabelas Compostas

CREATE TABLE People (
	id				int identity(1,1)		Primary Key,
	[name]			nvarchar(100)			NOT NULL,
    photo           nvarchar(10),
	date_of_birth	date,
    date_of_death   date,
	country_id		char(2)					REFERENCES Countries(iso_code),
	gender			char(1)					CHECK (gender in ('f', 'm', 'x'))
)
GO

CREATE TABLE FilmCountries (
	film_id			int,
	country_id		char(2),
	Primary Key	(film_id, country_id),
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (country_id)				REFERENCES Countries(iso_code)
)

CREATE TABLE FilmLanguages (
	film_id			int,
	language_id		char(2),
	Primary Key (film_id, language_id),
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (language_id)				REFERENCES Languages(iso_code),
)

CREATE TABLE FilmStudios (
	film_id			int,
	studio_id		int,
	Primary Key (film_id, studio_id),
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (studio_id)					REFERENCES Studios(id)
)

CREATE TABLE FilmGenres (
	film_id			int,
	genre_id		int,
	Primary Key (film_id, genre_id),
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (genre_id)					REFERENCES Genres(id)
)

CREATE TABLE FilmCrew (
	film_id			int,
	person_id		int,
	role_id			int,
	part			nvarchar(100),			-- PREENCHER EM CASO DE SER ACTOR
	Primary Key (film_id, person_id, role_id),
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (person_id)					REFERENCES People(id),
	Foreign Key (role_id)					REFERENCES Roles(id)
)
GO

-- Tabelas Utilizadores

CREATE TABLE Users (
	id				int identity(1,1)		Primary Key,
    first_name      nvarchar(100),
    last_name       nvarchar(100),
	email			nvarchar(100)			NOT NULL UNIQUE,
    passwd          nvarchar(100)           NOT NULL,        
	user_state		bit						DEFAULT 1,
	is_admin		bit						DEFAULT 0
)
GO

CREATE TABLE Reviews (
	id				int identity(1,1)		Primary Key,
	film_id			int,
	user_id			int,
	review			nvarchar(2000),
	rating			int						CHECK (rating > 0 AND rating < 6),
	time_stamp		datetime
	Foreign Key (film_id)					REFERENCES Films(id),
	Foreign Key (user_id)					REFERENCES Users(id)
)
GO

-- Campos Fixos

INSERT INTO Genres (genre_name) VALUES
    ('action'),
    ('adventure'),
    ('animation'),
    ('comedy'),
    ('crime'),
    ('documentary'),
    ('drama'),
    ('family'),
    ('fantasy'),
    ('history'),
    ('horror'),
    ('music'),
    ('mystery'),
    ('romance'),
    ('science fiction'),
    ('thriller'),
    ('tv movie'),
    ('war'),
    ('western')

INSERT INTO Studios (studio_name) VALUES 
    ('20th Century Fox'),
    ('Columbia Pictures'),
    ('MGM'),
    ('Paramount Pictures'),
    ('United Artists'),
    ('Universal Studios'),
    ('Warner Bros.'),
    ('Pixar'),
    ('Sony'),
    ('Walt Disney'),
    ('Lions Gate Entertainment'),
    ('DreamWorks'),
    ('Castle Rock Entertainment'),
    ('Miramax Films'),
    ('VideoFilmes'),
    ('O2 Filmes'),
	('Toho')

INSERT INTO Roles (role_name) VALUES
    ('director'),
    ('writer'),
    ('actor'),
    ('producer'),
    ('editor'),
    ('cinematographer'),
    ('composer')
GO

-- Todos os países do mundo...

INSERT INTO Countries(iso_code,country_name) VALUES ('AD','Andorra');
INSERT INTO Countries(iso_code,country_name) VALUES ('AE','United Arab Emirates');
INSERT INTO Countries(iso_code,country_name) VALUES ('AF','Afghanistan');
INSERT INTO Countries(iso_code,country_name) VALUES ('AG','Antigua & Barbuda');
INSERT INTO Countries(iso_code,country_name) VALUES ('AI','Anguilla');
INSERT INTO Countries(iso_code,country_name) VALUES ('AL','Albania');
INSERT INTO Countries(iso_code,country_name) VALUES ('AM','Armenia');
INSERT INTO Countries(iso_code,country_name) VALUES ('AO','Angola');
INSERT INTO Countries(iso_code,country_name) VALUES ('AQ','Antarctica');
INSERT INTO Countries(iso_code,country_name) VALUES ('AR','Argentina');
INSERT INTO Countries(iso_code,country_name) VALUES ('AS','American Samoa');
INSERT INTO Countries(iso_code,country_name) VALUES ('AT','Austria');
INSERT INTO Countries(iso_code,country_name) VALUES ('AU','Australia');
INSERT INTO Countries(iso_code,country_name) VALUES ('AW','Aruba');
INSERT INTO Countries(iso_code,country_name) VALUES ('AX','Åland Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('AZ','Azerbaijan');
INSERT INTO Countries(iso_code,country_name) VALUES ('BA','Bosnia & Herzegovina');
INSERT INTO Countries(iso_code,country_name) VALUES ('BB','Barbados');
INSERT INTO Countries(iso_code,country_name) VALUES ('BD','Bangladesh');
INSERT INTO Countries(iso_code,country_name) VALUES ('BE','Belgium');
INSERT INTO Countries(iso_code,country_name) VALUES ('BF','Burkina Faso');
INSERT INTO Countries(iso_code,country_name) VALUES ('BG','Bulgaria');
INSERT INTO Countries(iso_code,country_name) VALUES ('BH','Bahrain');
INSERT INTO Countries(iso_code,country_name) VALUES ('BI','Burundi');
INSERT INTO Countries(iso_code,country_name) VALUES ('BJ','Benin');
INSERT INTO Countries(iso_code,country_name) VALUES ('BL','St. Barthélemy');
INSERT INTO Countries(iso_code,country_name) VALUES ('BM','Bermuda');
INSERT INTO Countries(iso_code,country_name) VALUES ('BN','Brunei');
INSERT INTO Countries(iso_code,country_name) VALUES ('BO','Bolivia');
INSERT INTO Countries(iso_code,country_name) VALUES ('BQ','Caribbean Netherlands');
INSERT INTO Countries(iso_code,country_name) VALUES ('BR','Brazil');
INSERT INTO Countries(iso_code,country_name) VALUES ('BS','Bahamas');
INSERT INTO Countries(iso_code,country_name) VALUES ('BT','Bhutan');
INSERT INTO Countries(iso_code,country_name) VALUES ('BW','Botswana');
INSERT INTO Countries(iso_code,country_name) VALUES ('BY','Belarus');
INSERT INTO Countries(iso_code,country_name) VALUES ('BZ','Belize');
INSERT INTO Countries(iso_code,country_name) VALUES ('CA','Canada');
INSERT INTO Countries(iso_code,country_name) VALUES ('CC','Cocos (Keeling) Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('CD','Congo - Kinshasa');
INSERT INTO Countries(iso_code,country_name) VALUES ('CF','Central African Republic');
INSERT INTO Countries(iso_code,country_name) VALUES ('CG','Congo - Brazzaville');
INSERT INTO Countries(iso_code,country_name) VALUES ('CH','Switzerland');
INSERT INTO Countries(iso_code,country_name) VALUES ('CI','Côte d’Ivoire');
INSERT INTO Countries(iso_code,country_name) VALUES ('CK','Cook Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('CL','Chile');
INSERT INTO Countries(iso_code,country_name) VALUES ('CM','Cameroon');
INSERT INTO Countries(iso_code,country_name) VALUES ('CN','China');
INSERT INTO Countries(iso_code,country_name) VALUES ('CO','Colombia');
INSERT INTO Countries(iso_code,country_name) VALUES ('CR','Costa Rica');
INSERT INTO Countries(iso_code,country_name) VALUES ('CU','Cuba');
INSERT INTO Countries(iso_code,country_name) VALUES ('CV','Cape Verde');
INSERT INTO Countries(iso_code,country_name) VALUES ('CW','Curaçao');
INSERT INTO Countries(iso_code,country_name) VALUES ('CX','Christmas Island');
INSERT INTO Countries(iso_code,country_name) VALUES ('CY','Cyprus');
INSERT INTO Countries(iso_code,country_name) VALUES ('CZ','Czechia');
INSERT INTO Countries(iso_code,country_name) VALUES ('DE','Germany');
INSERT INTO Countries(iso_code,country_name) VALUES ('DG','Diego Garcia');
INSERT INTO Countries(iso_code,country_name) VALUES ('DJ','Djibouti');
INSERT INTO Countries(iso_code,country_name) VALUES ('DK','Denmark');
INSERT INTO Countries(iso_code,country_name) VALUES ('DM','Dominica');
INSERT INTO Countries(iso_code,country_name) VALUES ('DO','Dominican Republic');
INSERT INTO Countries(iso_code,country_name) VALUES ('DZ','Algeria');
INSERT INTO Countries(iso_code,country_name) VALUES ('EA','Ceuta & Melilla');
INSERT INTO Countries(iso_code,country_name) VALUES ('EC','Ecuador');
INSERT INTO Countries(iso_code,country_name) VALUES ('EE','Estonia');
INSERT INTO Countries(iso_code,country_name) VALUES ('EG','Egypt');
INSERT INTO Countries(iso_code,country_name) VALUES ('EH','Western Sahara');
INSERT INTO Countries(iso_code,country_name) VALUES ('ER','Eritrea');
INSERT INTO Countries(iso_code,country_name) VALUES ('ES','Spain');
INSERT INTO Countries(iso_code,country_name) VALUES ('ET','Ethiopia');
INSERT INTO Countries(iso_code,country_name) VALUES ('EZ','Eurozone');
INSERT INTO Countries(iso_code,country_name) VALUES ('FI','Finland');
INSERT INTO Countries(iso_code,country_name) VALUES ('FJ','Fiji');
INSERT INTO Countries(iso_code,country_name) VALUES ('FK','Falkland Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('FM','Micronesia');
INSERT INTO Countries(iso_code,country_name) VALUES ('FO','Faroe Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('FR','France');
INSERT INTO Countries(iso_code,country_name) VALUES ('GA','Gabon');
INSERT INTO Countries(iso_code,country_name) VALUES ('GB','United Kingdom');
INSERT INTO Countries(iso_code,country_name) VALUES ('GD','Grenada');
INSERT INTO Countries(iso_code,country_name) VALUES ('GE','Georgia');
INSERT INTO Countries(iso_code,country_name) VALUES ('GF','French Guiana');
INSERT INTO Countries(iso_code,country_name) VALUES ('GG','Guernsey');
INSERT INTO Countries(iso_code,country_name) VALUES ('GH','Ghana');
INSERT INTO Countries(iso_code,country_name) VALUES ('GI','Gibraltar');
INSERT INTO Countries(iso_code,country_name) VALUES ('GL','Greenland');
INSERT INTO Countries(iso_code,country_name) VALUES ('GM','Gambia');
INSERT INTO Countries(iso_code,country_name) VALUES ('GN','Guinea');
INSERT INTO Countries(iso_code,country_name) VALUES ('GP','Guadeloupe');
INSERT INTO Countries(iso_code,country_name) VALUES ('GQ','Equatorial Guinea');
INSERT INTO Countries(iso_code,country_name) VALUES ('GR','Greece');
INSERT INTO Countries(iso_code,country_name) VALUES ('GS','South Georgia & South Sandwich Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('GT','Guatemala');
INSERT INTO Countries(iso_code,country_name) VALUES ('GU','Guam');
INSERT INTO Countries(iso_code,country_name) VALUES ('GW','Guinea-Bissau');
INSERT INTO Countries(iso_code,country_name) VALUES ('GY','Guyana');
INSERT INTO Countries(iso_code,country_name) VALUES ('HK','Hong Kong SAR China');
INSERT INTO Countries(iso_code,country_name) VALUES ('HN','Honduras');
INSERT INTO Countries(iso_code,country_name) VALUES ('HR','Croatia');
INSERT INTO Countries(iso_code,country_name) VALUES ('HT','Haiti');
INSERT INTO Countries(iso_code,country_name) VALUES ('HU','Hungary');
INSERT INTO Countries(iso_code,country_name) VALUES ('IC','Canary Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('ID','Indonesia');
INSERT INTO Countries(iso_code,country_name) VALUES ('IE','Ireland');
INSERT INTO Countries(iso_code,country_name) VALUES ('IL','Israel');
INSERT INTO Countries(iso_code,country_name) VALUES ('IM','Isle of Man');
INSERT INTO Countries(iso_code,country_name) VALUES ('IN','India');
INSERT INTO Countries(iso_code,country_name) VALUES ('IO','British Indian Ocean Territory');
INSERT INTO Countries(iso_code,country_name) VALUES ('IQ','Iraq');
INSERT INTO Countries(iso_code,country_name) VALUES ('IR','Iran');
INSERT INTO Countries(iso_code,country_name) VALUES ('IS','Iceland');
INSERT INTO Countries(iso_code,country_name) VALUES ('IT','Italy');
INSERT INTO Countries(iso_code,country_name) VALUES ('JE','Jersey');
INSERT INTO Countries(iso_code,country_name) VALUES ('JM','Jamaica');
INSERT INTO Countries(iso_code,country_name) VALUES ('JO','Jordan');
INSERT INTO Countries(iso_code,country_name) VALUES ('JP','Japan');
INSERT INTO Countries(iso_code,country_name) VALUES ('KE','Kenya');
INSERT INTO Countries(iso_code,country_name) VALUES ('KG','Kyrgyzstan');
INSERT INTO Countries(iso_code,country_name) VALUES ('KH','Cambodia');
INSERT INTO Countries(iso_code,country_name) VALUES ('KI','Kiribati');
INSERT INTO Countries(iso_code,country_name) VALUES ('KM','Comoros');
INSERT INTO Countries(iso_code,country_name) VALUES ('KN','St. Kitts & Nevis');
INSERT INTO Countries(iso_code,country_name) VALUES ('KP','North Korea');
INSERT INTO Countries(iso_code,country_name) VALUES ('KR','South Korea');
INSERT INTO Countries(iso_code,country_name) VALUES ('KW','Kuwait');
INSERT INTO Countries(iso_code,country_name) VALUES ('KY','Cayman Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('KZ','Kazakhstan');
INSERT INTO Countries(iso_code,country_name) VALUES ('LA','Laos');
INSERT INTO Countries(iso_code,country_name) VALUES ('LB','Lebanon');
INSERT INTO Countries(iso_code,country_name) VALUES ('LC','St. Lucia');
INSERT INTO Countries(iso_code,country_name) VALUES ('LI','Liechtenstein');
INSERT INTO Countries(iso_code,country_name) VALUES ('LK','Sri Lanka');
INSERT INTO Countries(iso_code,country_name) VALUES ('LR','Liberia');
INSERT INTO Countries(iso_code,country_name) VALUES ('LS','Lesotho');
INSERT INTO Countries(iso_code,country_name) VALUES ('LT','Lithuania');
INSERT INTO Countries(iso_code,country_name) VALUES ('LU','Luxembourg');
INSERT INTO Countries(iso_code,country_name) VALUES ('LV','Latvia');
INSERT INTO Countries(iso_code,country_name) VALUES ('LY','Libya');
INSERT INTO Countries(iso_code,country_name) VALUES ('MA','Morocco');
INSERT INTO Countries(iso_code,country_name) VALUES ('MC','Monaco');
INSERT INTO Countries(iso_code,country_name) VALUES ('MD','Moldova');
INSERT INTO Countries(iso_code,country_name) VALUES ('ME','Montenegro');
INSERT INTO Countries(iso_code,country_name) VALUES ('MF','St. Martin');
INSERT INTO Countries(iso_code,country_name) VALUES ('MG','Madagascar');
INSERT INTO Countries(iso_code,country_name) VALUES ('MH','Marshall Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('MK','Macedonia');
INSERT INTO Countries(iso_code,country_name) VALUES ('ML','Mali');
INSERT INTO Countries(iso_code,country_name) VALUES ('MM','Myanmar (Burma)');
INSERT INTO Countries(iso_code,country_name) VALUES ('MN','Mongolia');
INSERT INTO Countries(iso_code,country_name) VALUES ('MO','Macau SAR China');
INSERT INTO Countries(iso_code,country_name) VALUES ('MP','Northern Mariana Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('MQ','Martinique');
INSERT INTO Countries(iso_code,country_name) VALUES ('MR','Mauritania');
INSERT INTO Countries(iso_code,country_name) VALUES ('MS','Montserrat');
INSERT INTO Countries(iso_code,country_name) VALUES ('MT','Malta');
INSERT INTO Countries(iso_code,country_name) VALUES ('MU','Mauritius');
INSERT INTO Countries(iso_code,country_name) VALUES ('MV','Maldives');
INSERT INTO Countries(iso_code,country_name) VALUES ('MW','Malawi');
INSERT INTO Countries(iso_code,country_name) VALUES ('MX','Mexico');
INSERT INTO Countries(iso_code,country_name) VALUES ('MY','Malaysia');
INSERT INTO Countries(iso_code,country_name) VALUES ('MZ','Mozambique');
INSERT INTO Countries(iso_code,country_name) VALUES ('NA','Namibia');
INSERT INTO Countries(iso_code,country_name) VALUES ('NC','New Caledonia');
INSERT INTO Countries(iso_code,country_name) VALUES ('NE','Niger');
INSERT INTO Countries(iso_code,country_name) VALUES ('NF','Norfolk Island');
INSERT INTO Countries(iso_code,country_name) VALUES ('NG','Nigeria');
INSERT INTO Countries(iso_code,country_name) VALUES ('NI','Nicaragua');
INSERT INTO Countries(iso_code,country_name) VALUES ('NL','Netherlands');
INSERT INTO Countries(iso_code,country_name) VALUES ('NO','Norway');
INSERT INTO Countries(iso_code,country_name) VALUES ('NP','Nepal');
INSERT INTO Countries(iso_code,country_name) VALUES ('NR','Nauru');
INSERT INTO Countries(iso_code,country_name) VALUES ('NU','Niue');
INSERT INTO Countries(iso_code,country_name) VALUES ('NZ','New Zealand');
INSERT INTO Countries(iso_code,country_name) VALUES ('OM','Oman');
INSERT INTO Countries(iso_code,country_name) VALUES ('PA','Panama');
INSERT INTO Countries(iso_code,country_name) VALUES ('PE','Peru');
INSERT INTO Countries(iso_code,country_name) VALUES ('PF','French Polynesia');
INSERT INTO Countries(iso_code,country_name) VALUES ('PG','Papua New Guinea');
INSERT INTO Countries(iso_code,country_name) VALUES ('PH','Philippines');
INSERT INTO Countries(iso_code,country_name) VALUES ('PK','Pakistan');
INSERT INTO Countries(iso_code,country_name) VALUES ('PL','Poland');
INSERT INTO Countries(iso_code,country_name) VALUES ('PM','St. Pierre & Miquelon');
INSERT INTO Countries(iso_code,country_name) VALUES ('PN','Pitcairn Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('PR','Puerto Rico');
INSERT INTO Countries(iso_code,country_name) VALUES ('PS','Palestinian Territories');
INSERT INTO Countries(iso_code,country_name) VALUES ('PT','Portugal');
INSERT INTO Countries(iso_code,country_name) VALUES ('PW','Palau');
INSERT INTO Countries(iso_code,country_name) VALUES ('PY','Paraguay');
INSERT INTO Countries(iso_code,country_name) VALUES ('QA','Qatar');
INSERT INTO Countries(iso_code,country_name) VALUES ('RE','Réunion');
INSERT INTO Countries(iso_code,country_name) VALUES ('RO','Romania');
INSERT INTO Countries(iso_code,country_name) VALUES ('RS','Serbia');
INSERT INTO Countries(iso_code,country_name) VALUES ('RU','Russia');
INSERT INTO Countries(iso_code,country_name) VALUES ('RW','Rwanda');
INSERT INTO Countries(iso_code,country_name) VALUES ('SA','Saudi Arabia');
INSERT INTO Countries(iso_code,country_name) VALUES ('SB','Solomon Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('SC','Seychelles');
INSERT INTO Countries(iso_code,country_name) VALUES ('SD','Sudan');
INSERT INTO Countries(iso_code,country_name) VALUES ('SE','Sweden');
INSERT INTO Countries(iso_code,country_name) VALUES ('SG','Singapore');
INSERT INTO Countries(iso_code,country_name) VALUES ('SH','St. Helena');
INSERT INTO Countries(iso_code,country_name) VALUES ('SI','Slovenia');
INSERT INTO Countries(iso_code,country_name) VALUES ('SJ','Svalbard & Jan Mayen');
INSERT INTO Countries(iso_code,country_name) VALUES ('SK','Slovakia');
INSERT INTO Countries(iso_code,country_name) VALUES ('SL','Sierra Leone');
INSERT INTO Countries(iso_code,country_name) VALUES ('SM','San Marino');
INSERT INTO Countries(iso_code,country_name) VALUES ('SN','Senegal');
INSERT INTO Countries(iso_code,country_name) VALUES ('SO','Somalia');
INSERT INTO Countries(iso_code,country_name) VALUES ('SR','Suriname');
INSERT INTO Countries(iso_code,country_name) VALUES ('SS','South Sudan');
INSERT INTO Countries(iso_code,country_name) VALUES ('ST','São Tomé & Príncipe');
INSERT INTO Countries(iso_code,country_name) VALUES ('SV','El Salvador');
INSERT INTO Countries(iso_code,country_name) VALUES ('SX','Sint Maarten');
INSERT INTO Countries(iso_code,country_name) VALUES ('SY','Syria');
INSERT INTO Countries(iso_code,country_name) VALUES ('SZ','Swaziland');
INSERT INTO Countries(iso_code,country_name) VALUES ('TA','Tristan da Cunha');
INSERT INTO Countries(iso_code,country_name) VALUES ('TC','Turks & Caicos Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('TD','Chad');
INSERT INTO Countries(iso_code,country_name) VALUES ('TF','French Southern Territories');
INSERT INTO Countries(iso_code,country_name) VALUES ('TG','Togo');
INSERT INTO Countries(iso_code,country_name) VALUES ('TH','Thailand');
INSERT INTO Countries(iso_code,country_name) VALUES ('TJ','Tajikistan');
INSERT INTO Countries(iso_code,country_name) VALUES ('TK','Tokelau');
INSERT INTO Countries(iso_code,country_name) VALUES ('TL','Timor-Leste');
INSERT INTO Countries(iso_code,country_name) VALUES ('TM','Turkmenistan');
INSERT INTO Countries(iso_code,country_name) VALUES ('TN','Tunisia');
INSERT INTO Countries(iso_code,country_name) VALUES ('TO','Tonga');
INSERT INTO Countries(iso_code,country_name) VALUES ('TR','Turkey');
INSERT INTO Countries(iso_code,country_name) VALUES ('TT','Trinidad & Tobago');
INSERT INTO Countries(iso_code,country_name) VALUES ('TV','Tuvalu');
INSERT INTO Countries(iso_code,country_name) VALUES ('TW','Taiwan');
INSERT INTO Countries(iso_code,country_name) VALUES ('TZ','Tanzania');
INSERT INTO Countries(iso_code,country_name) VALUES ('UA','Ukraine');
INSERT INTO Countries(iso_code,country_name) VALUES ('UG','Uganda');
INSERT INTO Countries(iso_code,country_name) VALUES ('UM','U.S. Outlying Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('UN','United Nations');
INSERT INTO Countries(iso_code,country_name) VALUES ('US','United States');
INSERT INTO Countries(iso_code,country_name) VALUES ('UY','Uruguay');
INSERT INTO Countries(iso_code,country_name) VALUES ('UZ','Uzbekistan');
INSERT INTO Countries(iso_code,country_name) VALUES ('VA','Vatican City');
INSERT INTO Countries(iso_code,country_name) VALUES ('VC','St. Vincent & Grenadines');
INSERT INTO Countries(iso_code,country_name) VALUES ('VE','Venezuela');
INSERT INTO Countries(iso_code,country_name) VALUES ('VG','British Virgin Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('VI','U.S. Virgin Islands');
INSERT INTO Countries(iso_code,country_name) VALUES ('VN','Vietnam');
INSERT INTO Countries(iso_code,country_name) VALUES ('VU','Vanuatu');
INSERT INTO Countries(iso_code,country_name) VALUES ('WF','Wallis & Futuna');
INSERT INTO Countries(iso_code,country_name) VALUES ('WS','Samoa');
INSERT INTO Countries(iso_code,country_name) VALUES ('XK','Kosovo');
INSERT INTO Countries(iso_code,country_name) VALUES ('YE','Yemen');
INSERT INTO Countries(iso_code,country_name) VALUES ('YT','Mayotte');
INSERT INTO Countries(iso_code,country_name) VALUES ('ZA','South Africa');
INSERT INTO Countries(iso_code,country_name) VALUES ('ZM','Zambia');
INSERT INTO Countries(iso_code,country_name) VALUES ('ZW','Zimbabwe');

-- Todos os idiomas do mundo:

INSERT INTO Languages(iso_code,language_name) VALUES ('ab','Abkhaz');
INSERT INTO Languages(iso_code,language_name) VALUES ('ae','Avestan');
INSERT INTO Languages(iso_code,language_name) VALUES ('af','Afrikaans');
INSERT INTO Languages(iso_code,language_name) VALUES ('ak','Akan');
INSERT INTO Languages(iso_code,language_name) VALUES ('am','Amharic');
INSERT INTO Languages(iso_code,language_name) VALUES ('an','Aragonese');
INSERT INTO Languages(iso_code,language_name) VALUES ('ar','Arabic');
INSERT INTO Languages(iso_code,language_name) VALUES ('as','Assamese');
INSERT INTO Languages(iso_code,language_name) VALUES ('av','Avaric');
INSERT INTO Languages(iso_code,language_name) VALUES ('ay','Aymara');
INSERT INTO Languages(iso_code,language_name) VALUES ('az','Azerbaijani');
INSERT INTO Languages(iso_code,language_name) VALUES ('ba','Bashkir');
INSERT INTO Languages(iso_code,language_name) VALUES ('be','Belarusian');
INSERT INTO Languages(iso_code,language_name) VALUES ('bg','Bulgarian');
INSERT INTO Languages(iso_code,language_name) VALUES ('bh','Bihari');
INSERT INTO Languages(iso_code,language_name) VALUES ('bi','Bislama');
INSERT INTO Languages(iso_code,language_name) VALUES ('bm','Bambara');
INSERT INTO Languages(iso_code,language_name) VALUES ('bn','Bengali');
INSERT INTO Languages(iso_code,language_name) VALUES ('bo','Tibetan Standard, Tibetan, Central');
INSERT INTO Languages(iso_code,language_name) VALUES ('br','Breton');
INSERT INTO Languages(iso_code,language_name) VALUES ('bs','Bosnian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ca','Catalan');
INSERT INTO Languages(iso_code,language_name) VALUES ('ce','Chechen');
INSERT INTO Languages(iso_code,language_name) VALUES ('ch','Chamorro');
INSERT INTO Languages(iso_code,language_name) VALUES ('co','Corsican');
INSERT INTO Languages(iso_code,language_name) VALUES ('cr','Cree');
INSERT INTO Languages(iso_code,language_name) VALUES ('cs','Czech');
INSERT INTO Languages(iso_code,language_name) VALUES ('cu','Church Slavonic, Old Bulgarian');
INSERT INTO Languages(iso_code,language_name) VALUES ('cv','Chuvash');
INSERT INTO Languages(iso_code,language_name) VALUES ('cy','Welsh');
INSERT INTO Languages(iso_code,language_name) VALUES ('da','Danish');
INSERT INTO Languages(iso_code,language_name) VALUES ('de','German');
INSERT INTO Languages(iso_code,language_name) VALUES ('dv','Divehi');
INSERT INTO Languages(iso_code,language_name) VALUES ('dz','Dzongkha');
INSERT INTO Languages(iso_code,language_name) VALUES ('ee','Ewe');
INSERT INTO Languages(iso_code,language_name) VALUES ('el','Greek, Modern');
INSERT INTO Languages(iso_code,language_name) VALUES ('en','English');
INSERT INTO Languages(iso_code,language_name) VALUES ('eo','Esperanto');
INSERT INTO Languages(iso_code,language_name) VALUES ('es','Spanish');
INSERT INTO Languages(iso_code,language_name) VALUES ('et','Estonian');
INSERT INTO Languages(iso_code,language_name) VALUES ('eu','Basque');
INSERT INTO Languages(iso_code,language_name) VALUES ('fa','Persian (Farsi)');
INSERT INTO Languages(iso_code,language_name) VALUES ('ff','Fula');
INSERT INTO Languages(iso_code,language_name) VALUES ('fi','Finnish');
INSERT INTO Languages(iso_code,language_name) VALUES ('fj','Fijian');
INSERT INTO Languages(iso_code,language_name) VALUES ('fo','Faroese');
INSERT INTO Languages(iso_code,language_name) VALUES ('fr','French');
INSERT INTO Languages(iso_code,language_name) VALUES ('fy','Western Frisian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ga','Irish');
INSERT INTO Languages(iso_code,language_name) VALUES ('gd','Scottish Gaelic');
INSERT INTO Languages(iso_code,language_name) VALUES ('gl','Galician');
INSERT INTO Languages(iso_code,language_name) VALUES ('gn','Guaraní');
INSERT INTO Languages(iso_code,language_name) VALUES ('gu','Gujarati');
INSERT INTO Languages(iso_code,language_name) VALUES ('gv','Manx');
INSERT INTO Languages(iso_code,language_name) VALUES ('ha','Hausa');
INSERT INTO Languages(iso_code,language_name) VALUES ('he','Hebrew (modern)');
INSERT INTO Languages(iso_code,language_name) VALUES ('hi','Hindi');
INSERT INTO Languages(iso_code,language_name) VALUES ('ho','Hiri Motu');
INSERT INTO Languages(iso_code,language_name) VALUES ('hr','Croatian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ht','Haitian');
INSERT INTO Languages(iso_code,language_name) VALUES ('hu','Hungarian');
INSERT INTO Languages(iso_code,language_name) VALUES ('hy','Armenian');
INSERT INTO Languages(iso_code,language_name) VALUES ('hz','Herero');
INSERT INTO Languages(iso_code,language_name) VALUES ('ia','Interlingua');
INSERT INTO Languages(iso_code,language_name) VALUES ('id','Indonesian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ie','Interlingue');
INSERT INTO Languages(iso_code,language_name) VALUES ('ig','Igbo');
INSERT INTO Languages(iso_code,language_name) VALUES ('ii','Nuosu');
INSERT INTO Languages(iso_code,language_name) VALUES ('ik','Inupiaq');
INSERT INTO Languages(iso_code,language_name) VALUES ('io','Ido');
INSERT INTO Languages(iso_code,language_name) VALUES ('is','Icelandic');
INSERT INTO Languages(iso_code,language_name) VALUES ('it','Italian');
INSERT INTO Languages(iso_code,language_name) VALUES ('iu','Inuktitut');
INSERT INTO Languages(iso_code,language_name) VALUES ('ja','Japanese');
INSERT INTO Languages(iso_code,language_name) VALUES ('jv','Javanese');
INSERT INTO Languages(iso_code,language_name) VALUES ('ka','Georgian');
INSERT INTO Languages(iso_code,language_name) VALUES ('kg','Kongo');
INSERT INTO Languages(iso_code,language_name) VALUES ('ki','Kikuyu, Gikuyu');
INSERT INTO Languages(iso_code,language_name) VALUES ('kj','Kwanyama, Kuanyama');
INSERT INTO Languages(iso_code,language_name) VALUES ('kk','Kazakh');
INSERT INTO Languages(iso_code,language_name) VALUES ('kl','Kalaallisut, Greenlandic');
INSERT INTO Languages(iso_code,language_name) VALUES ('km','Khmer');
INSERT INTO Languages(iso_code,language_name) VALUES ('kn','Kannada');
INSERT INTO Languages(iso_code,language_name) VALUES ('ko','Korean');
INSERT INTO Languages(iso_code,language_name) VALUES ('kr','Kanuri');
INSERT INTO Languages(iso_code,language_name) VALUES ('ks','Kashmiri');
INSERT INTO Languages(iso_code,language_name) VALUES ('ku','Kurdish');
INSERT INTO Languages(iso_code,language_name) VALUES ('kv','Komi');
INSERT INTO Languages(iso_code,language_name) VALUES ('kw','Cornish');
INSERT INTO Languages(iso_code,language_name) VALUES ('ky','Kyrgyz');
INSERT INTO Languages(iso_code,language_name) VALUES ('la','Latin');
INSERT INTO Languages(iso_code,language_name) VALUES ('lb','Luxembourgish, Letzeburgesch');
INSERT INTO Languages(iso_code,language_name) VALUES ('lg','Ganda');
INSERT INTO Languages(iso_code,language_name) VALUES ('li','Limburgish, Limburgan, Limburger');
INSERT INTO Languages(iso_code,language_name) VALUES ('ln','Lingala');
INSERT INTO Languages(iso_code,language_name) VALUES ('lo','Lao');
INSERT INTO Languages(iso_code,language_name) VALUES ('lt','Lithuanian');
INSERT INTO Languages(iso_code,language_name) VALUES ('lu','Luba-Katanga');
INSERT INTO Languages(iso_code,language_name) VALUES ('lv','Latvian');
INSERT INTO Languages(iso_code,language_name) VALUES ('mg','Malagasy');
INSERT INTO Languages(iso_code,language_name) VALUES ('mh','Marshallese');
INSERT INTO Languages(iso_code,language_name) VALUES ('mi','Māori');
INSERT INTO Languages(iso_code,language_name) VALUES ('mk','Macedonian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ml','Malayalam');
INSERT INTO Languages(iso_code,language_name) VALUES ('mn','Mongolian');
INSERT INTO Languages(iso_code,language_name) VALUES ('mr','Marathi (Marāṭhī)');
INSERT INTO Languages(iso_code,language_name) VALUES ('ms','Malay');
INSERT INTO Languages(iso_code,language_name) VALUES ('mt','Maltese');
INSERT INTO Languages(iso_code,language_name) VALUES ('my','Burmese');
INSERT INTO Languages(iso_code,language_name) VALUES ('na','Nauru');
INSERT INTO Languages(iso_code,language_name) VALUES ('nb','Norwegian Bokmål');
INSERT INTO Languages(iso_code,language_name) VALUES ('nd','North Ndebele');
INSERT INTO Languages(iso_code,language_name) VALUES ('ne','Nepali');
INSERT INTO Languages(iso_code,language_name) VALUES ('ng','Ndonga');
INSERT INTO Languages(iso_code,language_name) VALUES ('nl','Dutch');
INSERT INTO Languages(iso_code,language_name) VALUES ('nn','Norwegian Nynorsk');
INSERT INTO Languages(iso_code,language_name) VALUES ('no','Norwegian');
INSERT INTO Languages(iso_code,language_name) VALUES ('nr','South Ndebele');
INSERT INTO Languages(iso_code,language_name) VALUES ('nv','Navajo, Navaho');
INSERT INTO Languages(iso_code,language_name) VALUES ('ny','Chichewa');
INSERT INTO Languages(iso_code,language_name) VALUES ('oc','Occitan');
INSERT INTO Languages(iso_code,language_name) VALUES ('oj','Ojibwe, Ojibwa');
INSERT INTO Languages(iso_code,language_name) VALUES ('om','Oromo');
INSERT INTO Languages(iso_code,language_name) VALUES ('or','Oriya');
INSERT INTO Languages(iso_code,language_name) VALUES ('os','Ossetian, Ossetic');
INSERT INTO Languages(iso_code,language_name) VALUES ('pa','Panjabi, Punjabi');
INSERT INTO Languages(iso_code,language_name) VALUES ('pi','Pāli');
INSERT INTO Languages(iso_code,language_name) VALUES ('pl','Polish');
INSERT INTO Languages(iso_code,language_name) VALUES ('ps','Pashto, Pushto');
INSERT INTO Languages(iso_code,language_name) VALUES ('pt','Portuguese');
INSERT INTO Languages(iso_code,language_name) VALUES ('qu','Quechua');
INSERT INTO Languages(iso_code,language_name) VALUES ('rm','Romansh');
INSERT INTO Languages(iso_code,language_name) VALUES ('rn','Kirundi');
INSERT INTO Languages(iso_code,language_name) VALUES ('ro','Romanian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ru','Russian');
INSERT INTO Languages(iso_code,language_name) VALUES ('rw','Kinyarwanda');
INSERT INTO Languages(iso_code,language_name) VALUES ('sa','Sanskrit (Saṁskṛta)');
INSERT INTO Languages(iso_code,language_name) VALUES ('sc','Sardinian');
INSERT INTO Languages(iso_code,language_name) VALUES ('sd','Sindhi');
INSERT INTO Languages(iso_code,language_name) VALUES ('se','Northern Sami');
INSERT INTO Languages(iso_code,language_name) VALUES ('sg','Sango');
INSERT INTO Languages(iso_code,language_name) VALUES ('si','Sinhala, Sinhalese');
INSERT INTO Languages(iso_code,language_name) VALUES ('sk','Slovak');
INSERT INTO Languages(iso_code,language_name) VALUES ('sl','Slovene');
INSERT INTO Languages(iso_code,language_name) VALUES ('sm','Samoan');
INSERT INTO Languages(iso_code,language_name) VALUES ('sn','Shona');
INSERT INTO Languages(iso_code,language_name) VALUES ('so','Somali');
INSERT INTO Languages(iso_code,language_name) VALUES ('sq','Albanian');
INSERT INTO Languages(iso_code,language_name) VALUES ('sr','Serbian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ss','Swati');
INSERT INTO Languages(iso_code,language_name) VALUES ('st','Southern Sotho');
INSERT INTO Languages(iso_code,language_name) VALUES ('su','Sundanese');
INSERT INTO Languages(iso_code,language_name) VALUES ('sv','Swedish');
INSERT INTO Languages(iso_code,language_name) VALUES ('sw','Swahili');
INSERT INTO Languages(iso_code,language_name) VALUES ('ta','Tamil');
INSERT INTO Languages(iso_code,language_name) VALUES ('te','Telugu');
INSERT INTO Languages(iso_code,language_name) VALUES ('tg','Tajik');
INSERT INTO Languages(iso_code,language_name) VALUES ('th','Thai');
INSERT INTO Languages(iso_code,language_name) VALUES ('ti','Tigrinya');
INSERT INTO Languages(iso_code,language_name) VALUES ('tk','Turkmen');
INSERT INTO Languages(iso_code,language_name) VALUES ('tl','Tagalog');
INSERT INTO Languages(iso_code,language_name) VALUES ('tn','Tswana');
INSERT INTO Languages(iso_code,language_name) VALUES ('to','Tonga (Tonga Islands)');
INSERT INTO Languages(iso_code,language_name) VALUES ('tr','Turkish');
INSERT INTO Languages(iso_code,language_name) VALUES ('ts','Tsonga');
INSERT INTO Languages(iso_code,language_name) VALUES ('tt','Tatar');
INSERT INTO Languages(iso_code,language_name) VALUES ('tw','Twi');
INSERT INTO Languages(iso_code,language_name) VALUES ('ty','Tahitian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ug','Uyghur, Uighur');
INSERT INTO Languages(iso_code,language_name) VALUES ('uk','Ukrainian');
INSERT INTO Languages(iso_code,language_name) VALUES ('ur','Urdu');
INSERT INTO Languages(iso_code,language_name) VALUES ('uz','Uzbek');
INSERT INTO Languages(iso_code,language_name) VALUES ('ve','Venda');
INSERT INTO Languages(iso_code,language_name) VALUES ('vi','Vietnamese');
INSERT INTO Languages(iso_code,language_name) VALUES ('vo','Volapük');
INSERT INTO Languages(iso_code,language_name) VALUES ('wa','Walloon');
INSERT INTO Languages(iso_code,language_name) VALUES ('wo','Wolof');
INSERT INTO Languages(iso_code,language_name) VALUES ('xh','Xhosa');
INSERT INTO Languages(iso_code,language_name) VALUES ('yi','Yiddish');
INSERT INTO Languages(iso_code,language_name) VALUES ('yo','Yoruba');
INSERT INTO Languages(iso_code,language_name) VALUES ('za','Zhuang, Chuang');
INSERT INTO Languages(iso_code,language_name) VALUES ('zh','Chinese');
INSERT INTO Languages(iso_code,language_name) VALUES ('zu','Zulu');

-- Alguns Filmes/Cineastas

-- CINEASTAS

INSERT INTO People ([name], gender, country_id) VALUES 
    ('Frank Darabont', 'm', 'FR'),
    ('Stephen King', 'm', 'US'),
    ('Tim Robbins', 'm', 'US'),
    ('Morgan Freeman', 'm', 'US'),
	('Francis Ford Coppola', 'm', 'US'),
	('Mario Puzo', 'm', 'US'),
	('Marlon Brando', 'm', 'US'),
	('David Fincher', 'm', 'US'),
	('Al Pacino', 'm', 'US'),
	('Chuck Palahniuk', 'm', 'US'),
	('Edward Norton', 'm', 'US'),
	('Brad Pitt', 'm', 'US'),
	('Quentin Tarantino', 'm', 'US'),
	('Uma Thurman', 'f', 'US'),
	('Samuel L. Jackson', 'm', 'FR')

-- FILMES

-- THE SHAWSHANK REDEMPTION
    
INSERT INTO Films (title, release_date, runtime, tag_line, synopsis, imdb_code, img_poster)
	VALUES
    ('The Shawshank Redemption',
     '14 October 1994',
     142,
     'Fear can hold you prisoner. Hope can set you free.',
     'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
	 'tt0111161',
	 'tt0111161_ip')
GO

INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (1, 1, (SELECT id FROM Roles WHERE role_name LIKE 'director')),          -- Frank Darabont, Director
    (1, 1, (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            -- Frank Darabont, Writer
    (1, 2, (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            -- Stephen King, Writer
    (1, 3, (SELECT id FROM Roles WHERE role_name LIKE 'actor')),             -- Tim Robbins, Actor
    (1, 4, (SELECT id FROM Roles WHERE role_name LIKE 'actor'))              -- Morgan Freeman, Actor

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (1, (SELECT id FROM Genres WHERE genre_name LIKE 'drama')),
    (1, (SELECT id FROM Genres WHERE genre_name LIKE 'crime'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (1, 'US')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (1, 'en')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (1, (SELECT id FROM Studios WHERE studio_name LIKE 'Castle Rock Entertainment'))
GO

-- THE GODFATHER

INSERT INTO Films (title, release_date, runtime, tag_line, synopsis, imdb_code, img_poster)
	VALUES
    ('The Godfather',
     '24 March 1972',
     175,
     'An offer you can''t refuse.',
     'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
	 'tt0068646',
	 'tt0068646_ip')
GO

INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (2, (SELECT id FROM People WHERE name like 'Francis Ford Coppola'), (SELECT id FROM Roles WHERE role_name LIKE 'director')),         
    (2, (SELECT id FROM People WHERE name like 'Francis Ford Coppola'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            
    (2, (SELECT id FROM People WHERE name like 'Mario Puzo'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),           
    (2, (SELECT id FROM People WHERE name like 'Marlon Brando'), (SELECT id FROM Roles WHERE role_name LIKE 'actor')),             
    (2, (SELECT id FROM People WHERE name like 'Al Pacino'), (SELECT id FROM Roles WHERE role_name LIKE 'actor'))              

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (2, (SELECT id FROM Genres WHERE genre_name LIKE 'drama')),
	(2, (SELECT id FROM Genres WHERE genre_name LIKE 'crime'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (2, 'US')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (2, 'en'),
	(2, 'it')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (2, (SELECT id FROM Studios WHERE studio_name LIKE '%Paramount%'))

GO

-- FIGHT CLUB

INSERT INTO Films (title, release_date, runtime, tag_line, synopsis, imdb_code, img_poster)
	VALUES
    ('Fight Club',
     '15 October 1999',
     139,
     'MISCHIEF. MAYHEM. SOAP.',
     'An insomniac office worker, looking for a way to change his life, crosses paths with a devil-may-care soapmaker, forming an underground fight club that evolves into something much, much more.',
	 'tt0137523',
	 'tt0137523_ip')
GO

INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (3, (SELECT id FROM People WHERE name like 'David Fincher'), (SELECT id FROM Roles WHERE role_name LIKE 'director')),         
    (3, (SELECT id FROM People WHERE name like 'Chuck Palahniuk'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),         
    (3, (SELECT id FROM People WHERE name like 'Edward Norton'), (SELECT id FROM Roles WHERE role_name LIKE 'actor')),           
    (3, (SELECT id FROM People WHERE name like 'Brad Pitt'), (SELECT id FROM Roles WHERE role_name LIKE 'actor'))        

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (3, (SELECT id FROM Genres WHERE genre_name LIKE 'drama'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (3, 'US')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (3, 'en')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (3, (SELECT id FROM Studios WHERE studio_name LIKE '%20th Century%'))

GO

-- PULP FICTION

INSERT INTO Films (title, release_date, runtime, tag_line, synopsis, imdb_code, img_poster)
	VALUES
    ('Pulp Fiction',
     '14 October 1994',
     154,
     'JUST BECAUSE YOU ARE A CHARACTER DOESN’T MEAN YOU HAVE CHARACTER.',
     'A burger-loving hit man, his philosophical partner, a drug-addled gangster’s moll and a washed-up boxer converge in this sprawling, comedic crime caper. Their adventures unfurl in three stories that ingeniously trip back and forth in time..',
	 'tt0110912',
	 'tt0110912_ip')
GO

INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (4, (SELECT id FROM People WHERE name like 'Quentin Tarantino'), (SELECT id FROM Roles WHERE role_name LIKE 'director')),         
    (4, (SELECT id FROM People WHERE name like 'Quentin Tarantino'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),         
    (4, (SELECT id FROM People WHERE name like 'Uma Thurman'), (SELECT id FROM Roles WHERE role_name LIKE 'actor')),           
    (4, (SELECT id FROM People WHERE name like 'Samuel L. Jackson'), (SELECT id FROM Roles WHERE role_name LIKE 'actor'))        

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (4, (SELECT id FROM Genres WHERE genre_name LIKE 'crime')),
	(4, (SELECT id FROM Genres WHERE genre_name LIKE 'thriller'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (4, 'US')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (4, 'en')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (4, (SELECT id FROM Studios WHERE studio_name LIKE '%Miramax%'))
GO

-- SEVEN SAMURAI

INSERT INTO People ([name], date_of_birth, date_of_death, gender, country_id) VALUES 
    ('Akira Kurosawa', '23 March 1910', '6 September 1998', 'm', 'JP'),
    ('Shinobu Hashimoto', '18 April 1918', '', 'm', 'JP'),
    ('Toshirô Mifune', '1 April 1920', '24 December 1997', 'm', 'CN'),
    ('Takashi Shimura', '12 March 1905', '11 February 1982', 'm', 'JP')

INSERT INTO Films (title, release_date, runtime, synopsis, tag_line, imdb_code, img_poster) VALUES
    ('Seven Samurai',
     '19 November 1956',
     207,
     'A veteran samurai, who has fallen on hard times, answers a village request for protection from bandits. He gathers 6 other samurai to help him, and they teach the townspeople how to defend themselves, and they supply the samurai with three small meals a day. The film culminates in a giant battle when 40 bandits attack the village.',
     'Unmatched for suspense and spectacle!',
	 'tt0047478',
	 'tt0047478_ip'
	 )
GO
INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (5, (SELECT id FROM People WHERE name like 'Akira Kurosawa'), (SELECT id FROM Roles WHERE role_name LIKE 'director')),          -- Akira Kurosawa, Director
    (5, (SELECT id FROM People WHERE name like 'Akira Kurosawa'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            -- Akira Kurosawa, Writer
    (5, (SELECT id FROM People WHERE name like 'Shinobu Hashimoto'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            -- Shinobu Hashimoto, Writer
    (5, (SELECT id FROM People WHERE name like 'Toshirô Mifune'), (SELECT id FROM Roles WHERE role_name LIKE 'actor')),             -- Toshirô Mifune, Actor
    (5, (SELECT id FROM People WHERE name like 'Takashi Shimura'), (SELECT id FROM Roles WHERE role_name LIKE 'actor'))              -- Takashi Shimura, Actor

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (5, (SELECT id FROM Genres WHERE genre_name LIKE 'drama')),
    (5, (SELECT id FROM Genres WHERE genre_name LIKE 'adventure'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (5, 'JP')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (5, 'ja')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (5, (SELECT id FROM Studios WHERE studio_name LIKE 'Toho'))
GO

-- CITY OF GOD

INSERT INTO People ([name], date_of_birth, date_of_death, gender, country_id) VALUES 
    ('Fernando Meirelles', '9 November 1955', '', 'm', 'BR'),
    ('Paulo Lins', '11 June 1958', '', 'm', 'BR'),
	('Alexandre Rodrigues', '21 May 1983', '', 'm', 'BR'),
	('Leandro Firmino', '23 June 1978', '', 'm', 'BR')

INSERT INTO Films (title, release_date, runtime, synopsis, tag_line, imdb_code, img_poster) VALUES
    ('City of God',
     '13 February 2004',
     130,
     'Brazil, 1960s, City of God. The Tender Trio robs motels and gas trucks. Younger kids watch and learn well...too well. 1980s: Things are out of control between the last two remaining gangs...will it ever end? Welcome to the City of God.',
     'Based on a true story.',
	 'tt0317248',
	 'tt0317248_ip'
	 )
GO
INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES
    (6, (SELECT id FROM People WHERE name like 'Fernando Meirelles'), (SELECT id FROM Roles WHERE role_name LIKE 'director')),          -- Fernando Meirelles, Director
    (6, (SELECT id FROM People WHERE name like 'Paulo Lins'), (SELECT id FROM Roles WHERE role_name LIKE 'writer')),            -- Paulo Lins, Writer
    (6, (SELECT id FROM People WHERE name like 'Alexandre Rodrigues'), (SELECT id FROM Roles WHERE role_name LIKE 'actor')),             -- Alexandre Rodrigues, Actor
    (6, (SELECT id FROM People WHERE name like 'Leandro Firmino'), (SELECT id FROM Roles WHERE role_name LIKE 'actor'))              -- Leandro Firmino, Actor

INSERT INTO FilmGenres (film_id, genre_id) VALUES
    (6, (SELECT id FROM Genres WHERE genre_name LIKE 'drama')),
    (6, (SELECT id FROM Genres WHERE genre_name LIKE 'crime'))

INSERT INTO FilmCountries (film_id, country_id) VALUES
    (6, 'BR')

INSERT INTO FilmLanguages (film_id, language_id) VALUES
    (6, 'pt')

INSERT INTO FilmStudios (film_id, studio_id) VALUES
    (6, (SELECT id FROM Studios WHERE studio_name LIKE 'O2 Filmes')),
    (6, (SELECT id FROM Studios WHERE studio_name LIKE 'VideoFilmes'))
GO


-- Alguns Utilizadores

INSERT INTO Users (first_name, last_name, email, passwd, user_state, is_admin) VALUES
    ('admin', 'admin', 'admin@motafilms.org', 'atec+2018', 1, 1), -- ADMIN
	('Jane', 'Doe','janedoe@motafilms.org', 'atec+2018', 1, 0), -- USER Normal
    ('John', 'Doe', 'johndoe@motafilms.org', 'atec+2018', 0, 0)  -- USER Bloqueado
GO

-- Reviews

SET IDENTITY_INSERT [dbo].[Reviews] ON 
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (1, 1, 2, N'I have never seen such an amazing film since I saw The Shawshank Redemption. Shawshank encompasses friendships, hardships, hopes, and dreams. And what is so great about the movie is that it moves you, it gives you hope. Even though the circumstances between the characters and the viewers are quite different, you don''t feel that far removed from what the characters are going through.', 5, CAST(N'2018-06-08T10:30:20.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (2, 1, 3, N'It is a simple film, yet it has an everlasting message. Frank Darabont didn''t need to put any kind of outlandish special effects to get us to love this film, the narration and the acting does that for him. Why this movie didn''t win all seven Oscars is beyond me, but don''t let that sway you to not see this film, let its ranking on the IMDb''s top 250 list sway you, let your friends recommendation about the movie sway you.', 4, CAST(N'2018-06-08T12:15:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (3, 2, 2, N'An important place in American history is the period when several thousand Sicilian emigrants went to the United States in search of a new, better life, in which there would be no tyranny of the Palermo and Messinxich dons. Who knew at that time that this "bunch of Sicilian emigrants" would occupy a high place in the United States and in the history of this country.', 4, CAST(N'2018-06-01T09:30:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (4, 2, 3, N'"Godfather" is a masterpiece, an ideal gangster movie. The film without minuses, blunders and cliches, which pulls to review, even if you know it by heart. This is a classic, a gangster epic, a bible for cinephiles, giving answers to all the questions. A movie that teems with crown phrases that have long since become part of everyday life. A worthy picture, without exaggeration, is the best in its kind.', 5, CAST(N'2018-06-02T08:45:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (5, 3, 2, N'Let''s ignore the advice and talk about "Fight Club". This film was a milestone; although it bombed at the box office, Fincher''s cinematic language left a mark that can still be felt now, 14 years later, on many current releases. Despite the risky ''cutting edge'' nature of the film, Fincher got a huge budget for this and it shows: the camera effects and the whole production design are amazing.', 4, CAST(N'2018-06-03T02:02:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (6, 3, 3, N'This movie has a raw energy that grips me every time I watch it. What a crazy, fun ride! Whether it is a very clever satire or pure testosterone going on a rampage - both are fine by me. A film so visually stunning and sexy, with career best performances by all involved - welcome to movie heaven.

My vote: 5 out of 5', 5, CAST(N'2018-06-03T11:05:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (7, 4, 2, N'If you''re a bit of a film geek, you realize how much knowledge about film and love for the work of other greats – and inspiration from them - went into this (Leone, DePalma, Scorsese and, of course, dozens of hyper-stylized Asian gangster flicks), but to those accusing Tarantino of copying or even "stealing" from other film-makers I can only say: There has never been an artist who adored his kind of art that was NOT inspired or influenced by his favorite artists. ', 4, CAST(N'2018-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (8, 4, 3, N'If you watch Tarantino''s masterpiece today, it''s impossible not to recognize just what a breath of fresh air it was (still is, actually). Somehow, movies - especially gangster films - never looked quite the same after ''Pulp Fiction''. Probably the most influential film of the last 20 years, it''s got simply everything: amazing performances (especially Sam Jackson);', 5, CAST(N'2018-06-04T15:35:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (9, 5, 2, N'Having seen Kurosawa''s Seven Samurai at least 10 times, I still see something new every time I watch it. I don''t see how anyone, especially a non-Japanese, could possibly absorb this movie in less than 2 or 3 viewings. I''ve always been surprised at how each of the 7 samurai can make such an individual impression on you even if you can''t understand Japanese.', 4, CAST(N'2018-06-04T16:04:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (10, 5, 3, N'I can only say that your patience with this film will probably be well rewarded if you take the time to give it multiple viewings. You will also have the pleasure of seeing many of the samurai and villagers pop up in other Kurosawa films and films of other Japanese directors. If you like Mifune and Shimura in this one, catch them in Stray Dog and Drunken Angel in very different settings and parts. 

This one is 5 out of 5 without a doubt.', 5, CAST(N'2018-06-04T16:30:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (11, 6, 2, N'This also is one of those "based on a true story" films which makes it even more shocking, if its mostly true. The story is of the many young (pre and early-teen) criminals inhabiting an area just outside the big city of Rio de Janeiro in Brazil. It has the feel of a documentary with real-life street kids but is upgraded considerably by fantastic camera-work, some very innovative cinematography. In other words: stylish.
', 4, CAST(N'2018-06-10T10:01:00.000' AS DateTime))
GO
INSERT [dbo].[Reviews] ([id], [film_id], [user_id], [review], [rating], [time_stamp]) VALUES (12, 6, 3, N'Make no mistake: without that stylish look, the film might be too much of a downer. The street kids are interesting but really brutal, so be prepared. I mean, how often do you see 12-year-old killers portrayed on film? The violence, language and drug use are rough in here and what a sad comment on this social problem in Brazil, a country with a huge problem with these street gangs. Overall, a very tough but fascinating film.', 4, CAST(N'2018-06-10T20:20:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO

