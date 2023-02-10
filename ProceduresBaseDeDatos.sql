USE proyecto_final_base_datos;
DROP TABLE IF EXISTS movie;
CREATE TABLE movie AS SELECT id, budget, original_title, original_language, title, vote_count, vote_average, popularity, overview, runtime, keywords, revenue, release_date, director
FROM movie_dataset.movie_dataset;

ALTER TABLE movie
ADD PRIMARY KEY (id);

-- ------------------------------------------- Normalización de Status -------------------------------------------
DROP TABLE IF EXISTS status;
CREATE TABLE status (status VARCHAR(100)) AS SELECT DISTINCT status
FROM movie_dataset.movie_dataset;

ALTER TABLE status
ADD PRIMARY KEY (status);

-- Creación de la relación movie-status
CREATE TABLE status_movie (id INT NOT NULL,
                            status VARCHAR(100))AS SELECT id, st.status AS status
FROM movie_dataset.movie_dataset movie_status, status st
WHERE movie_status.status = st.status;

ALTER TABLE status_movie
ADD FOREIGN KEY (id) REFERENCES movie(id),
    ADD FOREIGN KEY (status) REFERENCES status(status);


--  ------------------------------------------- Normalización de Genres -------------------------------------------
CREATE TABLE genres(genres VARCHAR(100)) AS
    SELECT DISTINCT (
    SUBSTRING_INDEX(SUBSTRING_INDEX(genres,' ', 5), ' ', -1)) AS genres
FROM movie_dataset.movie_dataset;

DELETE
FROM genres
WHERE genres IS NULL;

ALTER TABLE genres
    ADD PRIMARY KEY (genres);

CREATE TABLE genres_movie AS
    SELECT tg.genres, id
    FROM genres tg, movie_dataset.movie_dataset mv
    WHERE INSTR(mv.genres, tg.genres )>0;

ALTER TABLE genres_movie
ADD FOREIGN KEY (id)
    REFERENCES movie(id),
    ADD FOREIGN KEY (genres)
        REFERENCES genres(genres);

-- ------------------------------------------- Normalización de Homepage -------------------------------------------
DROP TABLE IF EXISTS homepage;
CREATE TABLE homepage(homepage VARCHAR(200)) AS
    SELECT DISTINCT homepage
    FROM movie_dataset.movie_dataset;

DELETE
FROM homepage
WHERE homepage IS NULL;

ALTER TABLE homepage
    ADD PRIMARY KEY (homepage);


CREATE TABLE relacion_homepage (id INT NOT NULL PRIMARY KEY, homepage VARCHAR(200)) AS
    SELECT DISTINCT id, homepage
    FROM movie_dataset.movie_dataset
    WHERE homepage != '' OR homepage IS NOT NULL;
-- Agregamos las claves foráneas de la relacion_homepage a movie y a homepage según corresponda.
ALTER TABLE relacion_homepage
    ADD FOREIGN KEY (id)
        REFERENCES movie(id),
    ADD FOREIGN KEY (homepage)
        REFERENCES homepage(homepage);

-- ------------------------------------------- Normalización de Tagline -------------------------------------------

DROP TABLE IF EXISTS tagline;
CREATE TABLE tagline(tagline VARCHAR(300)) AS
    SELECT DISTINCT tagline
    FROM movie_dataset.movie_dataset;

DELETE
FROM tagline
WHERE tagline IS NULL;

ALTER TABLE tagline
    ADD PRIMARY KEY (tagline);

DROP TABLE IF EXISTS relacion_tagline;
CREATE TABLE relacion_tagline (id INT NOT NULL PRIMARY KEY, tagline VARCHAR(300)) AS
    SELECT DISTINCT id, tagline
    FROM movie_dataset.movie_dataset
    WHERE movie_dataset.movie_dataset.tagline != '' OR movie_dataset.movie_dataset.tagline IS NOT NULL;

ALTER TABLE relacion_tagline
    ADD FOREIGN KEY (id)
        REFERENCES movie(id);

ALTER TABLE relacion_tagline
    ADD FOREIGN KEY (tagline)
        REFERENCES tagline(tagline);

-- ------------------------------------------- Normalización de Director -------------------------------------------

DROP TABLE IF EXISTS director;
CREATE TABLE director (director VARCHAR(100)) AS
    SELECT DISTINCT director
FROM movie_dataset.movie_dataset;

DELETE
FROM director
WHERE director IS NULL OR director = '';

ALTER TABLE director
    ADD PRIMARY KEY (director);

-- Creación de la relación director_movie

DROP TABLE IF EXISTS director_movie;
CREATE TABLE director_movie AS
    SELECT id, dir.director
    FROM movie_dataset.movie_dataset mv, director dir
    WHERE mv.director = dir.director;
ALTER TABLE director_movie
    ADD FOREIGN KEY (id) REFERENCES movie_crew(movie_id),
    ADD FOREIGN KEY (director) REFERENCES  director(director);
ALTER TABLE movie DROP COLUMN director;

CREATE INDEX movie_crew_movie_id_idx
ON movie_crew (movie_id);

Select * from director_movie;

-- ------------------------------------------- Normalización de Cast -------------------------------------------

UPDATE movie_dataset.movie_dataset
SET cast = REPLACE(cast, 'Christopher Robin Miller', 'Christopher Robin_Miller' ),
    cast = REPLACE(cast, 'Anna Claire Sneed', 'Anna Claire_Sneed' ),
    cast = REPLACE(cast, 'Edward James Olmos', 'Edward James_Olmos' ),
    cast = REPLACE(cast, 'Motwani Santhanam VTV', 'Motwani Santhanam' ),
    cast = REPLACE(REPLACE(cast, ' de ', ' de' ), ' De ', ' De'),
    cast = REPLACE(cast, ' del ', ' del' ),
    cast = REPLACE(cast, ' M. ', ' M.' ),
    cast = REPLACE(cast, ' J. ', ' J.' ),
    cast = REPLACE(cast, ' L. ', ' L.' ),
    cast = REPLACE(cast, 'Madonna', 'Madonna Louise' ),
    cast = REPLACE(cast, 'Rihanna', 'Robyn Rihanna' ),
    cast = REPLACE(cast, ' Pink ', ' Alecia Beth ' ),
    cast = REPLACE(cast, 'Tupac Amaru Shakur', 'Tupac Amaru' ),
    cast = REPLACE(cast, 'Ludacris', 'Christopher Brian' ),
    cast = REPLACE(cast, 'Will.i.am', 'William James' ),
    cast = REPLACE(cast, 'Jennifer Jason Leigh', 'Jennifer Leigh' ),
    cast = REPLACE(cast, 'dela ', 'DeLa' ),
    cast = REPLACE(cast, ' Jr. ', 'Jr. ' ),
    cast = REPLACE(cast,'Jennifer Love Hewitt', 'Jennifer Love Hewitt'),
    cast = REPLACE(cast,'Robert Downey Jr.', 'Robert Downey-Jr.'),
    cast = REPLACE(cast,'Joe Don Baker', 'Joe Don-Baker'),
    cast = REPLACE(cast,'Anna Deavere Smith', 'Anna Deavere-Smith'),
    cast = REPLACE(cast,'Jon Bon Jovi', 'Bon Jovi'),
    cast = REPLACE(cast,'Kristin Scott Thomas', 'Kristin Scott-Thomas'),
    cast = REPLACE(cast,'Bachchan', 'Amitabh Bachchan'),
    cast = REPLACE(cast,'Jamyang Jamtsho Wangchuk', 'Jamyang Jamtsho-Wangchuk'),
    cast = REPLACE(cast,'Chow Chow', 'Chow'),
    cast = REPLACE(cast,'Mary Elizabeth Mastrantonio', 'Mary Mastrantonio'),
    cast = REPLACE(cast,'LL Cool J', 'LL Cool-J'),
    cast = REPLACE(cast,'Bryce Howard ', 'Bryce Howard'),
    cast = REPLACE(cast,'Robert Sean Leonard','Robert Sean-Leonard'),
    cast = REPLACE(cast,'Lou Taylor Pucci','Lou Taylor-Pucci'),
    cast = REPLACE(cast,'Jason Scott Lee','Jason Scott-Lee'),
    cast = REPLACE(cast,'Randall Duk Kim','Randall Duk-Kim'),
    cast = REPLACE(cast,'Jada Pinkett Smith','Jada Pinkett-Smith'),
    cast = REPLACE(cast,'Jonathan Taylor Thomas','Jonathan Thomas'),
    cast = REPLACE(cast,'Tom Lister Jr.','Tom-Lister Jr.'),
    cast = REPLACE(cast,'Jessica Brooks Grant','Jessica Brooks-Grant'),
    cast = REPLACE(cast,'Dee Bradley Baker','Dee Bradley-Baker'),
    cast = REPLACE(cast,'Cedric the Entertainer','Cedric the-Entertainer'),
    cast = REPLACE(cast,'David Ogden Stiers','David Stiers'),
    cast = REPLACE(cast,'Sarah Michelle Gellar','Sarah Gellar'),
    cast = REPLACE(cast,'Marcia Gay Harden','Marcia Gay-Harden'),
    cast = REPLACE(cast,'James Earl Jones','James Earl-Jones'),
    cast = REPLACE(cast,'Haley Joel Osment','Haley Joel-Osment'),
    cast = REPLACE(cast,'Carice van Houten','Carice van-Houten'),
    cast = REPLACE(cast,'Ernie Reyes, Jr.','Ernie-Reyes, Jr.'),
    cast = REPLACE(cast,' Mary Elizabeth Winstead','Elizabeth Winstead'),
    cast = REPLACE(cast,' Matthew Gray-Gubler','Matthew Gray-Gubler'),
    cast = REPLACE(cast,'Seann William Scott','Seann Scott'),
    cast = REPLACE(cast,'Sarah Jessica Parker','Sarah Jessica-Parker'),
    cast = REPLACE(cast,'Hadley Belle Miller','Hadley Belle-Miller'),
    cast = REPLACE(cast,'David Hyde Pierce','David Hyde-Pierce'),
    cast = REPLACE(cast,'Casper Van Dien','Casper Van-Dien'),
    cast = REPLACE(cast,'Jamie Lee Curtis','Jamie Lee-Curtis'),
    cast = REPLACE(cast,'Michael Clarke Duncan','Michael Clarke-Duncan'),
    cast = REPLACE(cast,'Anika Noni Rose', 'Anika Noni-Rose'),
    cast = REPLACE(cast,'Mario Van Peebles', 'Mario Van-Peebles'),
    cast = REPLACE(cast,'Neil Patrick Harris', 'Neil Patrick-Harris'),
    cast = REPLACE(cast,'Dick Van Dyke', 'Dick Van-Dyke'),
    cast = REPLACE(cast,'Jamie Ren\u00e9e Smith', 'Jamie Smith'),
    cast = REPLACE(cast,'Will Yun Lee', 'Will Yun-Lee'),
    cast = REPLACE(cast,'Jonny Lee Miller', 'Jonny Lee-Miller'),
    cast = REPLACE(cast,'Jackie Earle Haley', 'Jackie Earle-Haley'),
    cast = REPLACE(cast,'Tim Blake Nelson', 'Tim Blake-Nelson'),
    cast = REPLACE(cast,'Jeffrey Dean Morgan', 'Jeffrey Dean-Morgan'),
    cast = REPLACE(cast,'Lara Flynn Boyle', 'Lara Flynn-Boyle'),
    cast = REPLACE(cast,'Billy Bob Thornton', 'Billy Thornton'),
    cast = REPLACE(cast,'Sacha Cohen ', 'Sacha Cohen'),
    cast = REPLACE(cast,'Philip Seymour Hoffman', 'Philip Seymour-Hoffman'),
    cast = REPLACE(cast,'Jonathan Rhys Meyers', 'Jonathan Rhys-Meyers'),
    cast = REPLACE(cast,'John Michael Higgins', 'John Higgins'),
    cast = REPLACE(cast,'James Badge Dale', 'James Dale'),
    cast = REPLACE(cast,'Thomas Haden Church', 'Thomas Church' ),
    cast = REPLACE(cast,'Tommy Lee Jones', 'Tommy Jones'),
    cast = REPLACE(cast,'Max von Sydow', 'Max VonSydow'),
    cast = REPLACE(cast,'Dakota Blue Richards', 'Dakota Richards'),
    cast = REPLACE(cast,'Bryce Dallas Howard', 'Bryce Howard'),
    cast = REPLACE(cast,'Helena Bonham Carter', 'Helena Carter'),
    cast = REPLACE(cast,'James Badge Dale', 'James Dale'),
    cast = REPLACE(cast,' Redman Hannah', ' Reginald Noble Hannah'),
    cast = REPLACE(cast,' RZA', ' Robert Diggs'),
    cast = REPLACE(cast,' DMX', ' Earl Simmons'),
    cast = REPLACE(cast,' Chao Li Chi', ' Chao-Li Chi'),
    cast = REPLACE(cast,' Xzibit', ' Alvin Joiner'),
    cast = REPLACE(cast,'Nique Paula Patton ', 'Nique Imes Paula Patton '),
    cast = REPLACE(cast,'Prabhas', 'Uppalapati Prabhas'),
    cast = REPLACE(cast,' Tautou Mathieu ', ' Tautou Zio Vittorio '),
    cast = REPLACE(cast,' T.I.', ' Clifford Harris'),
    cast = REPLACE(cast,'Eminem', ' Marshall Mathers'),
    cast = REPLACE(cast,' Litefoot', ' Gary Davis'),
    cast = REPLACE(cast,' Sinbad', ' David Adkins'),
    cast = REPLACE(cast,'Cher Christina', 'Cherilyn Sarkisian Christina'),
    cast = REPLACE(cast,' Orianthi', ' Orianthi Retta'),
    cast = REPLACE(cast,' Miyavi', ' Takamasa Ishihara'),
    cast = REPLACE(cast,' Irvin Nelly', ' Irvin Cornell Haynes'),
    cast = REPLACE(cast, ' G.W.Bailey', ' George Bailey' ),
    cast = REPLACE(cast,' Tabu', ' Fatima Hashmi'),
    cast = REPLACE(cast,' Akon ', ' Aliaune Akon '),
    cast = REPLACE(cast,' Rekha', ' Bhanurekha Ganesan'),
    cast = REPLACE(cast,'Arletty ', ' Marie Bathiat '),
    cast = REPLACE(cast,'Ching-Wan Tang', 'Lau Ching-Wan Tang'),
    cast = REPLACE(cast,'Lau Ching-Wan', 'Ching-Wan'),
    cast = REPLACE(cast,' Washington Mario', ' Washington Mario Barrett'),
    cast = REPLACE(cast,'Cher Chazz ', 'Cherilyn Sarkisian Chazz '),
    cast = REPLACE(cast,'Ne-Yo ', ' Shaffer Smith '),
    cast = REPLACE(cast,'Clayton  ', 'Clayton '),
    cast = REPLACE(cast,' K.D.Aubert', ' Karen Aubert'),
    cast = REPLACE(cast,'Silverman Eve', ' Silverman Eve Cooper'),
    cast = REPLACE(cast,'T.I. ', 'Clifford Harris '),
    cast = REPLACE(cast,' Ba Sen', ' Batdorj-in'),
    cast = REPLACE(cast,' Mako', ' Mako Iwamatsu'),
    cast = REPLACE(cast,' Yun-fat ', ' Chow Yun-fat '),
    cast = REPLACE(cast,' GQ', ' Gregory Qaiyum'),
    cast = REPLACE(cast,' Steve-O', ' Stephen Glover'),
    cast = REPLACE(cast,'Dempsey Mario', 'Dempsey Mario Barrett'),
    cast = REPLACE(cast,' Amidou ', ' Hamidou Benmessaoud '),
    cast = REPLACE(cast,' Ice-T ', ' Tracy Marrow '),
    cast = REPLACE(cast,' Li Lianjie ', 'Li Lianjie'),
    cast = REPLACE(cast,'Carlos Alberto Raphael DeLaSierra Phil Woosnam', 'Carlos Alberto Raphael DeLaSierra Phil_Woosnam'),
    cast = REPLACE(cast,'Goenaga Nacho Vigalondo Juan Inciarte', 'Goenaga Nacho Vigalondo Juan_Inciarte'),
    cast = REPLACE(cast,'Franck Khalfoun Andrei Finti', 'Franck Khalfoun Andrei_Finti'),
    cast = REPLACE(cast,'Geraldine James Reha', 'Geraldine James Shabana Raza'),
    cast = REPLACE(cast,'Taimak ', 'Taimak Guarriello '),
    cast = REPLACE(cast,'Tang Wei Qin Hailu Jing Boran ', 'Tang Wei Qin Hailu Jing_Boran '),
    cast = REPLACE(cast,'Queen Latifah Common Paula', 'Queen Latifah Common_Paula'),
    cast = REPLACE(cast,'Peter Stormare Joel Grey', 'Peter_Stormare Joel Grey'),
    cast = REPLACE(cast,'Vivica A.Fox Kevin Pollak', 'Vivica A.Fox Kevin_Pollak'),
    cast = REPLACE(cast,'Jim Belushi Cuba GoodingJr.', 'Jim Belushi Cuba_GoodingJr.'),
    cast = REPLACE(cast,'Stuart Townsend Aaliyah Marguerite', 'Stuart Townsend Aaliyah_Marguerite'),
    cast = REPLACE(cast,'Knightley Mickey Rourke', 'Knightley Mickey_Rourke'),
    cast = REPLACE(cast,'Faizon Love E-40', 'Charlie Hustle'),
    cast = REPLACE(cast,'Dick Mario Van Peebles', 'Dick Mario Van_Peebles'),
    cast = REPLACE(cast,'Jason Gray-Stanford', 'Gray-Stanford'),
    cast = REPLACE(cast,'Kyla Pratt Mandy', 'Kyla_Pratt Mandy'),
    cast = REPLACE(cast,'Clayton  Larry Mullen', 'Clayton Larry Mullen'),
    cast = REPLACE(cast,'Cher Judi Dench', 'Cherilyn Sarkisian Judi Dench'),
    cast = REPLACE(cast,'Dylan Bruno', 'Dylan'),
    cast = REPLACE(cast,'Simon Shabana Razan', 'Reha'),
    cast = REPLACE(cast,' Emma Eliza Regan', ' Emma Regan'),
    cast = REPLACE(cast,' Taylor Scott Olson', ' Taylor Olson'),
    cast = REPLACE(cast,' Audrey Lynn Tennent', ' Audrey Tennent'),
    cast = REPLACE(cast,'Mackenzie E.Danny', 'Mackenzie E. Danny'),
    cast = REPLACE(cast,' Lalaine', ' Lalaine Vergara-Paras'),
    cast = REPLACE(cast,' Mary Kate Wiles', ' Mary Wiles'),
    cast = REPLACE(cast,' Mohammad', ' Mohamad Nader'),
    cast = REPLACE(cast,' Krafft-Raschig', ' Krafft Raschig'),
    cast = REPLACE(cast,'David Hyde Pierce', 'David Pierce'),
    cast = REPLACE(cast,'Brian Keith Allen', 'Brian Keith'),
    cast = REPLACE(cast,' Neha', ' Shabana Raza'),
    cast = REPLACE(cast,' Sting', ' Gordon Sumner'),
    cast = REPLACE(cast,' RuPaul', ' RuPaul Charles'),
    cast = REPLACE(cast,' Ashanti', ' Ashanti Douglas'),
    cast = REPLACE(cast,' Revathi', ' Revathi Menon'),
    cast = REPLACE(cast,' Sarala', ' Sarala Kariyawasam '),
    cast = REPLACE(cast,' E.Kurtis Blow', ' E. Kurtis Blow'),
    cast = REPLACE(cast,'Master P ', 'Percy Robert Miller '),
    cast = REPLACE(cast,'Van Damme Bolo', 'Jean Van Damme Bolo'),
    cast = REPLACE(cast,'Jean-Claude Van Damme', 'Van Damme'),
    cast = REPLACE(cast,' Jai White', ' Jai_White'),
    cast = REPLACE(cast,' Panou', ' Panou Mowling'),
    cast = REPLACE(cast,' E-40 ', ' Charlie Hustle '),
    cast = REPLACE(cast,' Wazheir Lena ', ' Wazheir Lena Abhilash '),
    cast = REPLACE(cast,'Hughley Cedric the Entertainer', 'Hughley Cedric Kyles'),
    cast = REPLACE(cast,'D.L.Hughley', 'Darryl Hughley'),
    cast = REPLACE(cast,'Vanity', 'Denise Matthews'),
    cast = REPLACE(cast,' Craig T.Nelson', ' Craig Nelson'),
    cast = REPLACE(cast,'Jason Biggs Thomas Ian Nicholas', 'Jason_Biggs Thomas Ian Nicholas'),
    cast = REPLACE(cast,'Stig Frode Henriksen Vegar', 'Stig_Frode Henriksen Vegar'),
    cast = REPLACE(cast,'Patricia Clarkson Lawrence  Jr.', 'Patricia Clarkson Lawrence Jr.'),
    cast = REPLACE(cast,'Scott Eddie Kaye Thomas', 'Scott Eddie Kaye Thomas'),
    cast = REPLACE(cast,'James Van Der', 'James Van_Der'),
    cast = REPLACE(cast,'Cook Penelope Miller', 'Cook Penelope Ann Miller'),
    cast = REPLACE(cast,'Penelope Ann Miller', 'Penelope Miller'),
    cast = REPLACE(cast,'John Canada Terrell', 'John Terrell'),
    cast = REPLACE(cast,'van der Wal', 'van_der Wal'),
    cast = REPLACE(cast,'Sancho Gracia', 'Sancho_Gracia'),
    cast = REPLACE(cast,'Milligan Ibrahim Renno Jr.', 'Milligan Ibrahim Renno'),
    cast = REPLACE(cast,'Catalina Sandino Moreno', 'Catalina Moreno'),
    cast = REPLACE(cast,'Dewi Ni Made Megahadi Pratiwi', 'Dewi Ni_Made Megahadi Pratiwi'),
    cast = REPLACE(cast,'Clarkson Lawrence Gilliard', 'Clarkson Lawrence '),
    cast = REPLACE(cast,'Benson Miller Lee Norris', 'Benson Miller Norris'),
    cast = REPLACE(cast,'Ari Parker Crista Flanagan', 'Ari Parker Crista_Flanagan'),
    cast = REPLACE(cast,'Cool J Jonny Lee Miller', 'Cool J Jonny Miller'),
    cast = REPLACE(cast,'Scott Chris Klein Thomas', 'Scott Chris Klein Thomas Thomas'),
    cast = REPLACE(cast,'Biggs Alyson Hannigan', 'Biggs Alyson_Hannigan'),
    cast = REPLACE(cast,'Anh Le Guy Pearce', 'Anh Le_Guy Pearce'),
    cast = REPLACE(cast,'Haley Jonny Lee Miller', 'Haley Jonny Miller'),
    cast = REPLACE(cast,'Spears  Donovan Womack', 'Spears Donovan Womack');

SELECT id, cast, length(cast) as longitud,
length(REPLACE(cast, ' ', '')) as longitudSinEspacios,
length(cast) - length(REPLACE(cast, ' ', '')) as CantidadEspacios,
length(cast) - length(REPLACE(cast, ' ', '')) + 1 as CantidaDePalabras
FROM movie_dataset.movie_dataset
WHERE ((length(cast) - length(REPLACE(cast, ' ', '')) + 1) % 2) = 0;



-- ------------------------------------------- Normalización de production_companies -------------------------------------------

DROP PROCEDURE IF EXISTS production_companies;
DELIMITER $$
CREATE PROCEDURE production_companies ()
BEGIN
DECLARE done INT DEFAULT FALSE ;
DECLARE jsonData json ;
DECLARE movie_id INT;
DECLARE jsonId varchar(250) ;
DECLARE jsonLabel varchar(250) ;
DECLARE resultSTR LONGTEXT DEFAULT '';
DECLARE i INT;

-- Declarar el cursor
DECLARE myCursor
CURSOR FOR
SELECT id, JSON_EXTRACT(CONVERT(production_companies USING UTF8MB4), '$[*]')
FROM movie_dataset.movie_dataset ;
-- Declarar el handler para NOT FOUND

DECLARE CONTINUE HANDLER
FOR NOT FOUND SET done = TRUE ;

-- Abrir el cursor
OPEN myCursor ;
cursorLoop: LOOP
FETCH myCursor INTO movie_id, jsonData;
SET i = 0;
IF done THEN
LEAVE cursorLoop ;
END IF ;

WHILE(JSON_EXTRACT(jsonData, CONCAT('$[', i, ']')) IS NOT NULL) DO
SET jsonId = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].id')), '') ;
SET jsonLabel = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i,'].name')), '') ;
SET @sql_text = CONCAT('INSERT INTO production_companies VALUES (', movie_id, ', ', REPLACE(jsonId,'\'',''), ', ', jsonLabel, '); ');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET i = i + 1;
END WHILE;

END LOOP ;
CLOSE myCursor ;
END$$
DELIMITER ;

DROP TABLE IF EXISTS production_companies;
CREATE TABLE production_companies (
movie_id INT,
id INT,
nameCom VARCHAR(100));


CALL production_companies();

CREATE TABLE company (id INT NOT NULL PRIMARY KEY, nameCom VARCHAR(150)) AS
    SELECT DISTINCT id, nameCom FROM production_companies;

ALTER TABLE production_companies
    ADD FOREIGN KEY (movie_id) REFERENCES movie(id),
    ADD FOREIGN KEY (id) REFERENCES  company(id);

-- ------------------------------------------- Normalización de spoken Languages -------------------------------------------

 # [{"iso_639_1": "en", "name": "English"}]

DROP PROCEDURE IF EXISTS spoken_languages;
DELIMITER $$
CREATE PROCEDURE spoken_languages()
BEGIN
 DECLARE done INT DEFAULT FALSE ;
 DECLARE jsonData json ;
 DECLARE jsonId varchar(250) ;
 DECLARE jsonLabel varchar(250) ;
 DECLARE movieId INT;
 DECLARE i INT;

 -- Declarar el cursor
DECLARE myCursor
  CURSOR FOR
   SELECT id, JSON_EXTRACT(CONVERT(spoken_languages USING UTF8MB4), '$[*]')
   FROM movie_dataset.movie_dataset;
 -- Declarar el handler para NOT FOUND

 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;
 cursorLoop: LOOP

  FETCH myCursor INTO movieId, jsonData;
    SET i = 0;
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(jsonData, CONCAT('$[', i, ']')) IS NOT NULL) DO
    SET jsonId = IFNULL(JSON_EXTRACT(jsonData,  CONCAT('$[', i, '].iso_639_1')), '') ;
    SET jsonLabel = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i,'].name')), '') ;
    SET @sql_text = CONCAT('INSERT INTO spoken_languages VALUES (', movieId, ', ', REPLACE(jsonId,'\'',''), ', ', jsonLabel, '); ');

    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET i = i + 1;
  END WHILE;

 END LOOP ;

 CLOSE myCursor ;

END$$
DELIMITER ;

DROP TABLE IF EXISTS spoken_languages;
CREATE TABLE spoken_languages (
     id_movie INT,
     iso_639_1 VARCHAR(5),
     language VARCHAR(100));

CALL spoken_languages();


CREATE TABLE language (
    iso_639_1 VARCHAR(5)NOT NULL PRIMARY KEY,
    language VARCHAR(150)) AS
    SELECT DISTINCT iso_639_1, language FROM spoken_languages;

SELECT * from language WHERE language = '';

ALTER TABLE spoken_languages
    ADD FOREIGN KEY (id_movie) REFERENCES movie(id),
    ADD FOREIGN KEY (iso_639_1) REFERENCES language(iso_639_1);

SELECT * from language;
select distinct language from spoken_languages WHERE iso_639_1 != '';

select distinct original_language from movie;


-- ------------------------------------------- Normalización de production_country -------------------------------------------

DROP PROCEDURE IF EXISTS production_countries;
DELIMITER $$
CREATE PROCEDURE production_countries()
BEGIN
 DECLARE done INT DEFAULT FALSE ;
 DECLARE jsonData json ;
 DECLARE jsonId varchar(250) ;
 DECLARE jsonLabel varchar(250) ;
 DECLARE movieId INT;
 DECLARE i INT;

 -- Declarar el cursor
DECLARE myCursor
  CURSOR FOR
   SELECT id, JSON_EXTRACT(CONVERT(production_countries USING UTF8MB4), '$[*]')
   FROM movie_dataset.movie_dataset;
 -- Declarar el handler para NOT FOUND

 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;
 cursorLoop: LOOP

  FETCH myCursor INTO movieId, jsonData;
    SET i = 0;
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(jsonData, CONCAT('$[', i, ']')) IS NOT NULL) DO
    SET jsonId = IFNULL(JSON_EXTRACT(jsonData,  CONCAT('$[', i, '].iso_3166_1')), '') ;
    SET jsonLabel = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i,'].name')), '') ;
    SET @sql_text = CONCAT('INSERT INTO production_country VALUES (', movieId, ', ', REPLACE(jsonId,'\'',''), ', ', jsonLabel, '); ');

    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET i = i + 1;
  END WHILE;

 END LOOP ;

 CLOSE myCursor ;

END$$
DELIMITER ;
DROP TABLE IF EXISTS production_country;
CREATE TABLE production_country (
     id_movie INT,
     iso_3166_1 VARCHAR(5),
     country VARCHAR(100));

CALL production_countries();


CREATE TABLE country (iso_3166_1 VARCHAR(5)NOT NULL PRIMARY KEY, country VARCHAR(150)) AS
    SELECT DISTINCT iso_3166_1, country FROM production_country;
ALTER TABLE production_country
    ADD FOREIGN KEY (id_movie) REFERENCES movie(id),
    ADD FOREIGN KEY (iso_3166_1) REFERENCES country(iso_3166_1);


-- ------------------------------------------------- Normalizacion Crew ------------------------------------------------
UPDATE movie_dataset.movie_dataset SET crew = CONVERT (
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(crew,
'"', '\''),
'{\'', '{"'),
'\': \'', '": "'),
'\', \'', '", "'),
'\': ', '": '),
', \'', ', "')
USING UTF8mb4 );

-- [{"name": "Stephen E. Rivkin", "gender": 0, "department": "Editing", "job": "Editor", "credit_id": "52fe48009251416c750aca23", "id": 1721}
DROP PROCEDURE IF EXISTS crew;
DELIMITER $$
CREATE PROCEDURE crew()
BEGIN
 DECLARE done INT DEFAULT FALSE ;
 DECLARE jsonData json ;
 DECLARE jsonName varchar(250);
 DECLARE jsonGender INT;
 DECLARE jsonDepartment VARCHAR(250);
 DECLARE jsonJob VARCHAR(250);
 DECLARE jsonCredit_id VARCHAR(250);
 DECLARE jsonId INT;
 DECLARE movieId INT;
 DECLARE i INT;

 -- Declarar el cursor
DECLARE myCursor
  CURSOR FOR
   SELECT id, JSON_EXTRACT(CONVERT(crew USING UTF8MB4), '$[*]')
   FROM movie_dataset.movie_dataset;
 -- Declarar el handler para NOT FOUND

 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;
 cursorLoop: LOOP

  FETCH myCursor INTO movieId, jsonData;
    SET i = 0;
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(jsonData, CONCAT('$[', i, ']')) IS NOT NULL) DO
    SET jsonId = IFNULL(JSON_EXTRACT(jsonData,  CONCAT('$[', i, '].id')), '') ;
    SET jsonName = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].name')), '') ;
    SET jsonGender = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].gender')),'');
    SET jsonDepartment = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].department')),'');
    SET jsonJob = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].job')),'');
    SET jsonCredit_id = IFNULL(JSON_EXTRACT(jsonData, CONCAT('$[', i, '].credit_id')),'');
    SET @sql_text = CONCAT('INSERT INTO movie_crew VALUES (', movieId, ', ',
        jsonName, ', ', jsonGender, ',', jsonDepartment, ',', jsonJob, ',', jsonCredit_id,
        ',', jsonId, '); ');

    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET i = i + 1;
  END WHILE;

 END LOOP ;

 CLOSE myCursor ;

END$$
DELIMITER ;

DROP TABLE IF EXISTS movie_crew;
CREATE TABLE movie_crew(
    movie_id INT,
    name VARCHAR(250),
    gender INT,
    department VARCHAR(250),
    job VARCHAR(250),
    credit_id VARCHAR(250),
    id INT
);
CALL crew();
SELECT *
FROM movie_crew;

SELECT DISTINCT credit_id
FROM movie_crew;
SELECT DISTINCT id
FROM movie_crew;


SELECT credit_id, job, MAX(numero_trabajadores)
FROM (SELECT credit_id, job, COUNT(job) as numero_trabajadores
FROM job_department_crew GROUP BY job
ORDER BY numero_trabajadores DESC) AS numero_trabajadores;

-- *************************************** Normalizacion 2 ***************************************************
ALTER table movie_crew
ADD PRIMARY KEY (credit_id);


-- --------------------------------- Persona y Generos ------------------------------------------------
DROP TABLE IF EXISTS persona;
CREATE table persona AS
SELECT DISTINCT id, name
FROM movie_crew;
ALTER TABLE persona
ADD PRIMARY KEY (id);

SELECT *
FROM persona;

-- Generos
DROP TABLE IF EXISTS generos;
CREATE TABLE generos AS
    SELECT DISTINCT gender
    FROM movie_crew;
ALTER TABLE generos
ADD PRIMARY KEY (gender);
SELECT * FROM generos;

-- RELACION PERSONA-GENEROS
DROP TABLE IF EXISTS informacion_persona;
CREATE TABLE informacion_persona AS
    SELECT DISTINCT id, gender, credit_id
    FROM movie_crew;

ALTER TABLE informacion_persona
ADD FOREIGN KEY (id) REFERENCES persona(id),
    ADD FOREIGN KEY (gender) REFERENCES generos(gender),
    ADD PRIMARY KEY (credit_id),
    ADD FOREIGN KEY (credit_id) REFERENCES movie_crew(credit_id);

DROP TABLE IF EXISTS department;
CREATE TABLE department (department VARCHAR(50) PRIMARY KEY )AS
    SELECT DISTINCT department
    FROM movie_crew;

-- DROP TABLE IF EXISTS department_crew;
-- CREATE TABLE department_crew AS SELECT dp.department, credit_id
-- FROM movie_crew, department dp
-- WHERE movie_crew.department = dp.department;

-- ALTER TABLE department_crew
--     ADD FOREIGN KEY (credit_id) REFERENCES movie_crew(credit_id),
--     ADD FOREIGN KEY (department) REFERENCES department(department);



-- NormalizaciÃ³n de Job
DROP TABLE IF EXISTS job;
CREATE TABLE job (job VARCHAR(100) PRIMARY KEY) AS
    SELECT DISTINCT job
FROM movie_crew;

-- DROP TABLE IF EXISTS job_crew;
-- CREATE TABLE job_crew AS SELECT jb.job, credit_id
-- FROM movie_crew, job jb
-- WHERE movie_crew.job = jb.job;

-- ALTER TABLE job_crew
--     ADD FOREIGN KEY (credit_id) REFERENCES movie_crew(credit_id),
--    ADD FOREIGN KEY (job) REFERENCES job(job);

DROP TABLE IF EXISTS job_department_crew;
CREATE TABLE job_department_crew AS
SELECT DISTINCT job, department, credit_id
FROM movie_crew;

-- ALTER TABLE job_department
--     ADD FOREIGN KEY (credit_id) REFERENCES department_crew(credit_id),
--     ADD FOREIGN KEY (credit_id) REFERENCES job_crew(credit_id);


ALTER TABLE job_department_crew
    ADD FOREIGN KEY (job) REFERENCES job(job),
    ADD FOREIGN KEY (department) REFERENCES department(department),
    ADD FOREIGN KEY (credit_id) REFERENCES informacion_persona(credit_id);



-- ------------------------------------------------------------------------------------------

