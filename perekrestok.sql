/*Требования к курсовому проекту:
1.	Составить общее текстовое описание БД и решаемых ею задач;
Планирую реализовать БД для интернет магазина сети Перекресток. Будут выделены таблицы под хранение продуктов, промо акций, 
пользователей.
Также планируются запросы по работе с БД.
*/

/*
Создание таблиц и структуры БД
-----------------------------------------------------------------------------
*/
DROP DATABASE IF EXISTS perekrestok;
CREATE DATABASE perekrestok;
USE perekrestok;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50) DEFAULT 'скромный' NOT NULL,
    lastname VARCHAR(50) DEFAULT 'незнакомец' NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone BIGINT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW()
) COMMENT 'Таблица пользователей';

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE, 
    gender CHAR(1),
    birthday DATE,
	address VARCHAR(255),
    cardnumber BIGINT UNSIGNED NOT NULL UNIQUE,
    credits INT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'Профиль пользователей';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    users_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (users_id) REFERENCES users(id),
	KEY index_of_users_id (users_id)
) COMMENT 'Список заказов';

DROP TABLE IF EXISTS first_lvl_catalog;
CREATE TABLE first_lvl_catalog (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) UNIQUE,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW(),
    KEY index_of_name_id (name)
) COMMENT 'Каталог 1го уровня';

DROP TABLE IF EXISTS second_lvl_catalog;
CREATE TABLE second_lvl_catalog (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) UNIQUE,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW(),
    KEY index_of_name_id (name)
) COMMENT 'Каталог 2го уровня';

DROP TABLE IF EXISTS products_picture;
CREATE TABLE products_picture (
	id SERIAL PRIMARY KEY,
	filepath VARCHAR(255),
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW()
) COMMENT 'Фото товара';

DROP TABLE IF EXISTS feedback;
CREATE TABLE feedback (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	score TINYINT NOT NULL,
	description TEXT(65535),
	KEY index_of_score_id (score)
) COMMENT 'Отзывы и рейтинг товара';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	description TEXT(65535),
	price FLOAT UNSIGNED NOT NULL,
	quantity INT UNSIGNED NOT NULL,
	products_picture_id BIGINT UNSIGNED NOT NULL,
	first_lvl_catalog_id BIGINT UNSIGNED NOT NULL,
	second_lvl_catalog_id BIGINT UNSIGNED NOT NULL,
	brand VARCHAR(255),
	country	VARCHAR(100),
	feedback_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (first_lvl_catalog_id) REFERENCES first_lvl_catalog(id),
    FOREIGN KEY (second_lvl_catalog_id) REFERENCES second_lvl_catalog(id),
    FOREIGN KEY (products_picture_id) REFERENCES products_picture(id),
    FOREIGN KEY (feedback_id) REFERENCES feedback(id),
    KEY index_of_name_id (name),
    KEY index_of_price_id (price),
    KEY index_of_brand_id (brand),
    KEY index_of_country_id (country)
) COMMENT 'Список товаров';

DROP TABLE IF EXISTS list_of_order;
CREATE TABLE list_of_order (
	id SERIAL PRIMARY KEY,
	order_id BIGINT UNSIGNED NOT NULL,
	products_id BIGINT UNSIGNED NOT NULL,
	quantity TINYINT UNSIGNED NOT NULL,
	amount FLOAT UNSIGNED,
	FOREIGN KEY (order_id) REFERENCES orders(id),
	FOREIGN KEY (products_id) REFERENCES products(id)
) COMMENT 'Содержание заказов';

DROP TABLE IF EXISTS promo;
CREATE TABLE promo (
	id SERIAL PRIMARY KEY,
	products_id BIGINT UNSIGNED NOT NULL,
	discount FLOAT UNSIGNED,
	started_at DATE,
	finished_at DATE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (products_id) REFERENCES products(id)
) COMMENT 'Список акций';


/*
Заполнение таблиц данными
-----------------------------------------------------------------------------
*/

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`, `created_at`, `updated_at`) VALUES 
	('1', 'Lauretta', 'Ernser', 'little.seamus@example.net', '89884947580', '2005-01-04 02:05:23', '1980-09-03 11:08:47'),
	('2', 'Carmine', 'Strosin', 'ledner.joey@example.org', '89215847361', '1980-11-12 06:31:51', '2010-11-26 02:59:22'),
	('3', 'Alejandra', 'Sporer', 'albina13@example.com', '89871102146', '1984-06-22 14:39:41', '1973-11-27 18:58:38'),
	('4', 'Velma', 'Greenholt', 'lambert.effertz@example.net', '89043129062', '1978-05-07 21:41:22', '1983-05-14 22:42:25'),
	('5', 'Benedict', 'Hudson', 'bmoen@example.com', '89288350528', '1970-07-10 02:29:17', '1989-10-23 05:25:09'),
	('6', 'Colton', 'Kunde', 'shania.padberg@example.net', '89633574932', '2016-12-02 14:05:19', '1973-02-18 09:44:22'),
	('7', 'Sydney', 'Cole', 'golden.pouros@example.org', '89556271739', '1993-02-24 15:56:43', '1974-10-18 08:48:12'),
	('8', 'Frank', 'Mueller', 'skoss@example.com', '89619549455', '1985-06-22 16:42:14', '2015-05-16 03:46:27'),
	('9', 'Lizeth', 'Pfeffer', 'cbergnaum@example.net', '89236103566', '2008-10-20 22:52:44', '1987-02-27 00:29:31'),
	('10', 'Sabrina', 'Rath', 'margaret89@example.org', '89318489055', '2004-10-07 17:30:37', '1989-09-20 17:41:13'),
	('11', 'Vivien', 'Dicki', 'ardith.mckenzie@example.org', '89458335338', '1978-11-08 09:38:52', '2004-07-29 01:13:35'),
	('12', 'Cheyenne', 'Willms', 'aidan.bayer@example.com', '89223921491', '1971-07-19 07:07:32', '2006-09-14 21:54:35'),
	('13', 'Alena', 'Moore', 'marcelina.goyette@example.net', '89241191463', '1974-01-29 21:47:20', '2012-07-31 16:15:33'),
	('14', 'Frida', 'Towne', 'ruecker.wava@example.org', '89437918759', '1991-12-11 20:33:37', '2010-03-10 06:24:44'),
	('15', 'Kaitlyn', 'Gislason', 'van40@example.com', '89464594488', '2019-12-07 10:05:09', '1979-04-19 18:53:57'),
	('16', 'Trever', 'Grant', 'stark.leila@example.com', '89321760262', '1990-10-02 16:52:49', '1981-07-21 12:28:29'),
	('17', 'Shany', 'Sauer', 'conor.willms@example.org', '89105004097', '1988-03-22 05:53:09', '1993-11-24 10:33:51'),
	('18', 'Gunner', 'Fahey', 'icollins@example.com', '89352995279', '1971-08-06 02:08:27', '2001-07-15 21:55:15'),
	('19', 'Corbin', 'Zieme', 'johnson.madilyn@example.org', '89644139467', '1992-06-11 16:15:57', '1974-03-21 13:00:52'),
	('20', 'Dayna', 'Welch', 'ihyatt@example.com', '89696344938', '1997-08-21 07:52:44', '2003-05-03 16:34:19');

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `address`, `cardnumber`, `credits`, `created_at`, `updated_at`) VALUES 
	('1', 'F', '2016-01-01', '5464 Wiegand Shoals\nLake Emily, CO 29019-9298', '8636345168109984', NULL, '1973-04-27 04:33:01', '1995-01-25 05:52:11'),
	('2', 'M', '1988-05-16', '828 Heaney Underpass\nRempelhaven, OH 17278-4449', '6778076551854611', NULL, '1995-04-10 09:54:18', '2016-12-05 03:44:52'),
	('3', 'M', '2011-09-05', '7008 Loyce Mall\nNorth Johann, NV 90917-5055', '8426553067751230', NULL, '2000-09-14 17:21:54', '1996-08-14 09:00:20'),
	('4', 'M', '1997-04-18', '087 Spinka Creek Suite 707\nJacquesmouth, MD 52489', '3333012906368822', NULL, '1991-05-16 16:41:07', '1976-01-05 06:22:10'),
	('5', 'M', '2013-08-30', '218 Raul Ports Suite 958\nYostport, WV 64602-1197', '3924669260159135', NULL, '2015-04-06 02:16:33', '1994-09-01 14:43:09'),
	('6', 'F', '1994-10-19', '7113 Felipe Circle\nLake Haylee, AR 05595-3235', '8315538280643524', NULL, '1990-06-24 09:17:45', '1998-12-09 10:47:33'),
	('7', 'F', '2008-05-11', '40940 Herman Estates\nSouth Vernaland, VA 26161', '9082784487865866', NULL, '2007-08-04 16:39:50', '1974-09-12 05:13:02'),
	('8', 'M', '1993-03-06', '6536 Franecki Locks Apt. 937\nBoganhaven, ID 07516-3234', '9850045032333584', NULL, '1998-07-28 00:28:40', '2016-02-08 04:30:23'),
	('9', 'M', '1987-03-19', '0510 Rice Orchard\nKuhicside, NV 20707-6817', '1660390507895499', NULL, '2019-10-08 22:40:06', '1975-05-01 11:13:58'),
	('10', 'F', '2012-02-09', '9261 Friedrich Passage\nEast Keara, NE 72283', '8227551272138954', NULL, '1977-07-27 14:12:30', '1997-06-29 05:19:14'),
	('11', 'M', '1991-07-27', '0917 Louisa Skyway Suite 170\nDaxville, IA 90651-9012', '1621844528242945', NULL, '2010-02-19 20:49:03', '2013-04-23 07:51:27'),
	('12', 'F', '2001-08-28', '757 Walsh Underpass\nNorth Nils, NM 66218', '7739574572071434', NULL, '1999-07-06 05:13:08', '1976-02-21 09:25:08'),
	('13', 'F', '1986-03-27', '82224 Heidenreich Roads Suite 593\nWest Claudine, ID 00709', '1645315981935709', NULL, '1985-05-29 22:01:12', '2010-09-29 07:11:28'),
	('14', 'F', '1979-11-29', '011 Brooklyn Village Suite 004\nNorth Dariana, NJ 90258', '7853615456726403', NULL, '2016-03-27 14:23:51', '1973-09-04 21:36:28'),
	('15', 'F', '1975-10-23', '61808 Kohler Trace\nJacobsonville, MO 06275', '9278697929345072', NULL, '2007-08-23 00:14:12', '2002-10-21 01:54:45'),
	('16', 'F', '1997-10-25', '06375 Marco River\nLeannonhaven, NJ 68048-9509', '9327655137982220', NULL, '1984-09-28 13:00:52', '1983-08-07 09:30:05'),
	('17', 'M', '1973-09-01', '10633 Schuppe Fort\nViviannemouth, AK 60994-8810', '7342183769214899', NULL, '2002-10-11 00:59:52', '1999-02-15 11:26:09'),
	('18', 'F', '2001-03-12', '2081 Trycia Brooks\nWest Nona, KS 53478', '2749812639784068', NULL, '2015-06-30 21:09:58', '1978-02-17 19:39:20'),
	('19', 'F', '2001-08-26', '3333 Mante Course Apt. 738\nLake Stanton, SD 22834-6191', '1461141747888177', NULL, '2001-03-07 12:48:52', '2007-04-26 11:26:19'),
	('20', 'F', '2009-01-30', '78652 Karl Loaf\nLake Derickville, NH 69669-1723', '5259035920258612', NULL, '2011-05-01 00:31:22', '2004-12-02 20:25:59');

INSERT INTO `feedback` (`id`, `user_id`, `score`, `description`) VALUES 
	('1', '1', 3, 'Ut ut molestias autem et. Nostrum perferendis eveniet laboriosam aspernatur. Earum voluptatibus odio illum beatae. Ut eligendi ullam ullam qui nemo cupiditate. Eos reiciendis quia veniam illum vel et et.'),
	('2', '2', 4, 'Repudiandae nihil odit nam molestiae temporibus architecto maxime est. Dolorem et fuga ad recusandae quasi nulla voluptatum qui. Temporibus magnam ullam impedit aspernatur est omnis dignissimos.'),
	('3', '3', 5, 'Quos et maiores et nemo ab temporibus reprehenderit. Necessitatibus molestias accusantium et aperiam. Rem voluptatem vero reiciendis perspiciatis dicta recusandae quia. Ex similique ducimus omnis facere dignissimos. Repellendus quia eaque sint ipsa dicta.'),
	('4', '4', 5, 'Est quis qui itaque. Fugit nobis et qui repellat in. Nostrum ad nihil exercitationem blanditiis illo mollitia.'),
	('5', '5', 3, 'Recusandae omnis pariatur autem ipsa incidunt a et. Consequuntur possimus maiores et ipsam. Animi aliquam quaerat id quibusdam aut et. Minima rerum voluptas inventore eum dolores maxime.'),
	('6', '6', 5, 'Error esse id cumque quas natus aspernatur. Placeat ut quo non sapiente optio repellendus delectus. Excepturi soluta voluptas voluptas qui rerum.'),
	('7', '7', 3, 'Illum et odio eligendi temporibus. Veritatis consequatur modi quod libero minus. Excepturi praesentium nam ipsam quo necessitatibus hic quos accusantium.'),
	('8', '8', 4, 'Et aut assumenda nisi sed tempora sunt eveniet. Sit dolor ab fugit quasi sit. Est asperiores cumque reiciendis et. Impedit omnis qui dolor voluptatibus voluptates doloremque delectus.'),
	('9', '9', 5, 'Nisi veniam ex doloribus totam ea quidem perferendis. Labore delectus odit aliquam. Sint nihil maiores incidunt et a sit ipsam.'),
	('10', '10', 1, 'Tenetur sit a minus tenetur occaecati dolor. Sit eius qui non adipisci eum tempora qui. Velit autem nobis voluptas rem.'),
	('11', '11', 4, 'Sapiente fuga aut harum rerum natus facere omnis. Occaecati doloremque distinctio dolores qui nihil. Ea rerum sunt pariatur qui dolores fuga consequatur sunt.'),
	('12', '12', 3, 'Quis similique possimus et voluptate necessitatibus. Sed eaque distinctio non rerum ea voluptatem. Et et suscipit qui. Earum quibusdam omnis nisi doloribus distinctio voluptates. Autem mollitia minima accusamus quae ut aliquid.'),
	('13', '13', 1, 'Harum vitae nemo eum laboriosam beatae. Qui nemo rem et officiis ut repudiandae alias. Modi non similique nisi. Minima aut ullam distinctio in beatae.'),
	('14', '14', 2, 'Quidem sint accusantium qui consequatur. Distinctio accusantium ratione aut quis. Debitis reiciendis aut consectetur qui voluptate.'),
	('15', '15', 4, 'Esse fuga voluptatem temporibus fuga molestiae nesciunt eum. Odio atque maxime natus quo vel aperiam nihil. Esse atque velit aliquid eos.'),
	('16', '16', 2, 'Facilis veritatis quasi atque est voluptatem nulla excepturi dolores. Facilis similique non dignissimos quidem nulla quidem quas. Vero dignissimos pariatur rerum consequuntur dignissimos eligendi. Id labore animi ut architecto ut vitae iste.'),
	('17', '17', 5, 'Eius ab aliquam nulla molestiae pariatur tempora. Laboriosam architecto aliquam odit voluptatem. Ipsam in aut consequuntur beatae soluta quia.'),
	('18', '18', 1, 'Qui explicabo porro nihil sit rerum sint hic. Consectetur qui debitis officiis. Ut ipsum occaecati eveniet voluptatem voluptate. Enim consequatur eum dolores consequatur omnis necessitatibus. Doloribus quia quas in.'),
	('19', '19', 4, 'Doloremque rerum et exercitationem et qui non. Perferendis incidunt culpa minima omnis odit sint. In ipsa aliquid mollitia expedita.'),
	('20', '20', 5, 'Possimus sed et ab quo. Sint est sit culpa delectus eos quia autem minus. Aliquid inventore autem blanditiis est soluta enim ab.'),
	('21', '1', 2, 'Nulla sint debitis commodi suscipit quia. Non omnis vel dolor facere delectus et. Quidem ea similique perspiciatis ab quis molestiae. Voluptates nulla aspernatur expedita illo ut qui.'),
	('22', '2', 3, 'Ducimus aut iure aspernatur quia laboriosam aut ex molestiae. Qui neque excepturi est. Id numquam aliquid debitis deleniti deserunt enim consequatur.'),
	('23', '3', 5, 'Similique qui id ipsam quo omnis qui et. Ratione temporibus libero reiciendis nemo cum.'),
	('24', '4', 4, 'Provident sed voluptatum voluptas deserunt ut inventore consequatur. Aut ea quasi accusamus dolores dolore. A magni occaecati quis et eaque odio. Commodi totam adipisci assumenda dolorem.'),
	('25', '5', 3, 'Quod at ipsum ipsam qui. Distinctio ex voluptatibus sed omnis sapiente. Expedita adipisci odit necessitatibus distinctio.'),
	('26', '6', 4, 'Atque officia qui temporibus esse deserunt quisquam. Omnis excepturi in consectetur cumque. Vel saepe porro fugit iusto dolor esse unde.'),
	('27', '7', 3, 'Similique itaque dolor illum. Veritatis praesentium optio dolores laudantium excepturi eos fugit. Debitis qui doloribus cupiditate quo delectus eveniet. Repellat eaque blanditiis modi quis sint reprehenderit.'),
	('28', '8', 1, 'Voluptatibus quo repudiandae enim tempora error tempore. Et mollitia placeat veritatis odio. Ratione expedita similique exercitationem est. Fugiat fuga error in aliquam praesentium voluptatem.'),
	('29', '9', 2, 'Dolor autem consectetur consequatur voluptas quam distinctio inventore molestiae. Qui cum omnis aut eum aut ut. Optio est et ipsam enim.'),
	('30', '10', 5, 'Quae et recusandae aut commodi voluptas hic et. Hic quam saepe deleniti voluptas. Totam non pariatur nihil occaecati quibusdam eos. Explicabo tempora distinctio non dolor minima.'),
	('31', '11', 2, 'Autem exercitationem tempore esse quis quasi sed id. Ut quia est voluptatem animi porro. Eum amet eaque est qui.'),
	('32', '12', 3, 'Voluptatem minima sunt alias voluptas. Necessitatibus distinctio maxime vel. Possimus non omnis velit explicabo nemo eaque. Dolor sed aut asperiores eaque reprehenderit inventore distinctio id.'),
	('33', '13', 5, 'Nihil cupiditate vel esse occaecati cum quia suscipit dolorum. Necessitatibus quia quidem temporibus deleniti quia aut sit. Et sunt et quia quas. Culpa officiis ullam incidunt.'),
	('34', '14', 2, 'Officia nemo est expedita numquam nostrum at omnis. Ipsa quisquam labore ut adipisci autem pariatur vero. Qui voluptatem voluptatem sed. Possimus amet similique ab doloremque.'),
	('35', '15', 3, 'Et veritatis totam est minima. Fugit laboriosam non incidunt quod ipsam officiis itaque. Dolorem aliquid sint pariatur aut rerum necessitatibus.'),
	('36', '16', 4, 'Molestiae nam consequatur vel sint perspiciatis rerum. Numquam at quia praesentium quis dignissimos. Neque ut quibusdam in exercitationem saepe optio ut non.'),
	('37', '17', 4, 'Blanditiis laborum et quasi voluptatem eum veritatis velit et. Dolorem saepe ut neque qui. Ut placeat officia quia laboriosam quas laboriosam.'),
	('38', '18', 4, 'Est provident quidem quo. Molestiae quis quae et et et. Officiis ipsa et dolorem soluta et. Facere sed qui est enim et aut a maxime. Autem voluptatibus culpa dolorem eum perferendis beatae accusantium.'),
	('39', '19', 5, 'Culpa blanditiis laboriosam rerum voluptatum minima. Sit reiciendis id dolorem veniam ut voluptatibus quasi. Accusamus molestiae ipsum distinctio fugit quia.'),
	('40', '20', 3, 'Distinctio eum dolorum sed eum. Dolores et velit aut officia occaecati voluptatem. Unde aliquid et aut culpa est ipsa. Omnis qui inventore qui atque aspernatur neque.'),
	('41', '1', 5, 'Modi ipsum iure est quas. Veniam asperiores explicabo et. Provident hic sint cupiditate officiis reprehenderit in dolorum.'),
	('42', '2', 1, 'Ea quis quod consectetur quia veniam nobis. Soluta et consequatur dolores accusamus deleniti dicta ut. Accusamus quasi similique et eum. Nulla aspernatur error dolor est iste.'),
	('43', '3', 1, 'Blanditiis earum non voluptatem consequatur magni aut nostrum. Ipsum quas veniam et et sit tempore. Sunt cumque possimus ut sapiente assumenda eum.'),
	('44', '4', 5, 'Doloribus iure qui aperiam voluptatem. Quia quibusdam consequatur quae aut vel ab molestias molestias. Est odio ut itaque sit quis.'),
	('45', '5', 5, 'Doloremque rem minus laudantium quasi qui. Sed reiciendis doloremque vitae. Eligendi ut omnis dolorum porro sit perspiciatis qui. Iusto qui consequatur sunt eaque aut ab consectetur impedit. Laboriosam dolor explicabo voluptas est magni.'),
	('46', '6', 1, 'Ab non laudantium perferendis sequi aperiam et dolorem. Nam animi tenetur quis nostrum atque. Nisi et est et ut.'),
	('47', '7', 1, 'Est porro maiores mollitia quia atque natus commodi. Ut ut beatae odit. Placeat ipsum placeat veniam quas laudantium. Expedita quisquam quibusdam numquam harum et eum non.'),
	('48', '8', 3, 'Doloribus laboriosam distinctio omnis sit voluptatum sit rerum. Dicta illum et facilis expedita hic recusandae. Quia inventore perferendis blanditiis in praesentium. Sint et possimus doloremque totam.'),
	('49', '9', 3, 'Perspiciatis nemo autem incidunt. Corrupti ratione velit similique id quibusdam voluptatem. Necessitatibus voluptatibus itaque omnis quibusdam soluta similique. Recusandae voluptatibus esse et minima qui alias facere voluptas.'),
	('50', '10', 3, 'Beatae cupiditate corporis quia et sapiente. Ipsa eos velit nihil molestiae reprehenderit illo enim. Hic quia voluptas omnis quas facere. Id sit est aut vitae alias et.'),
	('51', '11', 4, 'Iusto sit in qui omnis. Non reiciendis qui doloremque dicta praesentium. Doloremque possimus ipsum et in optio. Reprehenderit ea voluptatem ducimus.'),
	('52', '12', 1, 'Aut optio culpa tempore vel alias. At laboriosam qui enim temporibus et eveniet. Dolore enim debitis rerum iste quibusdam.'),
	('53', '13', 5, 'Repudiandae sed laboriosam enim velit et. Iste vel doloribus quae aut doloribus optio. Et quia et et consequatur sapiente saepe sed.'),
	('54', '14', 4, 'Maxime voluptates saepe id excepturi adipisci et aut. Numquam explicabo quia ut quam qui. Eveniet sit quam aperiam consectetur dolorem. Dolorem ut corrupti eius voluptate rerum.'),
	('55', '15', 2, 'Qui veniam quia quibusdam velit et soluta consequatur. Quisquam a occaecati asperiores. Necessitatibus voluptas qui iste et exercitationem nulla laboriosam.'),
	('56', '16', 3, 'Aperiam voluptas iste numquam. Occaecati sint qui ut aut dolores officiis necessitatibus. Velit nemo consequatur dolores cupiditate vitae. Non harum maiores non aut.'),
	('57', '17', 3, 'Blanditiis nemo earum quisquam soluta omnis. Quibusdam tempore accusantium quae quo. Ea aut ut qui illo dolor veritatis. Quia quia totam dolor.'),
	('58', '18', 5, 'Eum dolor voluptas consequatur est. Ipsa eveniet quam perspiciatis doloribus. Sed placeat error voluptas saepe nobis labore. Ut quo vitae exercitationem. Omnis sit quibusdam id nobis.'),
	('59', '19', 3, 'Natus eaque facilis error nulla facilis. Et commodi quo sed et fugiat ad voluptatem sed.'),
	('60', '20', 4, 'Qui odio dolores assumenda. Maiores mollitia et perferendis dolorum sapiente iste. Incidunt ratione in qui fugit quod fugit.'),
	('61', '1', 2, 'Et consequuntur quam vero maiores hic quibusdam quam. Cupiditate facilis aut impedit quia distinctio accusamus.'),
	('62', '2', 4, 'Veniam aut ducimus illum voluptate repellendus. Totam rerum eveniet et omnis distinctio esse autem. Eligendi temporibus totam sint quisquam praesentium aut vero. Ullam officia corporis officiis cum modi. Eos molestiae rem nemo officiis minus et porro nemo.'),
	('63', '3', 3, 'Aut omnis repellat temporibus fugiat. Magnam commodi dolore nam iste qui. Id eaque incidunt et ducimus.'),
	('64', '4', 1, 'Dolor et voluptas reiciendis et ut sunt atque. Placeat qui alias sunt eveniet. Autem assumenda aut vitae consectetur aperiam commodi ut. Voluptatem earum officia eum eveniet voluptatum.'),
	('65', '5', 2, 'Veniam rerum aperiam id ea. Nihil soluta rerum delectus voluptatem nemo praesentium voluptatem. Et accusantium velit sed sed eos accusantium.'),
	('66', '6', 1, 'Autem dolore impedit odit. Voluptas est similique et dolores officiis. Voluptates omnis dolor est quisquam vel quas. Odit dolorem vitae delectus sint iste.'),
	('67', '7', 1, 'Eum nihil sed qui temporibus eius assumenda. Omnis corporis eligendi quam quam. Eaque sint vel excepturi similique. Eum aut saepe veniam illo dolorem.'),
	('68', '8', 4, 'Maiores perspiciatis sed rerum aut eum. Odit in voluptatum reiciendis quia harum aspernatur temporibus occaecati. Corporis eveniet id quis et quibusdam sed repellendus.'),
	('69', '9', 1, 'Sint non voluptatem eaque quas beatae non tempore. Quo asperiores qui architecto repellendus odit. Esse velit et culpa consectetur architecto quam.'),
	('70', '10', 5, 'Molestiae alias amet sed ducimus ea rem veniam. Qui aut sed et et. Libero voluptate et iusto itaque voluptatem eos.'),
	('71', '11', 3, 'Ut rerum repellendus iusto hic quia. Occaecati qui praesentium aut tempore nam. Aut et enim quia atque. Unde reiciendis odit sunt magnam aut.'),
	('72', '12', 2, 'Unde aut mollitia et commodi. Eos tempora distinctio molestias distinctio ipsam quo. Et et reprehenderit non architecto est assumenda maiores. Qui cum assumenda accusamus est.'),
	('73', '13', 4, 'Doloribus reprehenderit soluta soluta error aliquid at rerum. Dignissimos nisi dolore sed corrupti voluptas eum. Ipsam culpa est nobis incidunt.'),
	('74', '14', 4, 'Aperiam eius laborum optio modi et. Id vel rerum earum asperiores corrupti. Consequatur ut fuga quo. Sit officiis neque nam repellendus iste.'),
	('75', '15', 1, 'Quia incidunt quaerat non totam eum ea voluptates. Libero quod quia tempore quod temporibus molestias accusantium et. Rem sit unde porro qui nulla. Autem aut quia id tempore aut.'),
	('76', '16', 2, 'Exercitationem commodi eius mollitia et. Officia mollitia minus nihil. Ut beatae aliquid autem fuga ut quo.'),
	('77', '17', 5, 'Nisi laborum quo error a. Dolor a exercitationem illo quidem dolore. In itaque odio aliquid doloremque velit consectetur nisi. Qui dolorem sint ab est reiciendis illum.'),
	('78', '18', 4, 'Reprehenderit autem ex sint et laudantium magnam perferendis. Placeat debitis reprehenderit libero est nihil quaerat quos. Eius laudantium et alias odit ut. Laudantium enim necessitatibus hic est voluptatem.'),
	('79', '19', 1, 'Quo ducimus ea id veritatis eos et. Vel quis error sed pariatur excepturi dolorum eos reiciendis. Qui debitis possimus quos quidem laborum et quo. Atque sequi consequuntur quia aspernatur veritatis odit et vel.'),
	('80', '20', 5, 'Non rerum recusandae voluptas excepturi architecto quidem rem. Pariatur laudantium quis non velit. Voluptatem fuga vel eaque et deserunt. Et et nihil ut illo quia accusamus nulla.'),
	('81', '1', 1, 'Minima numquam impedit aut harum veniam qui commodi. Quia impedit similique officia nihil nobis.'),
	('82', '2', 1, 'Quia voluptatibus expedita animi. Quaerat eos dolorem consequatur beatae modi pariatur. Ea blanditiis adipisci sint autem alias.'),
	('83', '3', 5, 'Voluptatem officia corrupti commodi impedit est qui. Ut incidunt numquam perspiciatis facilis.'),
	('84', '4', 3, 'Atque deleniti quis suscipit eligendi voluptas fugit ut. Est voluptatem rerum ad repellat et. Magni reprehenderit et repellendus.'),
	('85', '5', 3, 'Iste veniam et eos natus expedita praesentium labore quo. Dolores fugit voluptatem qui est animi dolore. Dolores ut corrupti reiciendis aperiam voluptatem dolores asperiores. Et voluptas et accusamus enim rerum.'),
	('86', '6', 3, 'Aut rem sit et ea dolorem. Enim praesentium iste doloribus at. Delectus rem doloremque aut aliquam repellat suscipit deserunt expedita. Voluptatem dignissimos impedit illum sapiente esse sit pariatur.'),
	('87', '7', 3, 'Similique ratione in minima magni. Ipsa repellendus nobis fugit. Eos similique incidunt ullam enim impedit minus rem.'),
	('88', '8', 1, 'Vel quis doloribus et sunt ullam molestias inventore. Sed rerum similique repellendus sit debitis nostrum delectus architecto. Qui error est repudiandae provident. Qui totam qui id.'),
	('89', '9', 3, 'Sit asperiores qui et veniam veniam rerum qui exercitationem. Nemo dolor ut similique molestiae. Inventore omnis modi incidunt unde dolore inventore iusto. Earum alias dignissimos vitae accusamus earum. Et eius beatae doloribus illum est.'),
	('90', '10', 5, 'Vel est sed rerum omnis quasi voluptatem suscipit et. Ipsum fugit omnis in in quod similique aliquid. Aut inventore id necessitatibus quod velit perferendis quo.'),
	('91', '11', 4, 'Est voluptatem dolorum inventore reiciendis aut sed. Vitae ex nam repudiandae aut. Quasi omnis sint quia odio. Soluta iure qui ea cumque distinctio asperiores.'),
	('92', '12', 3, 'Molestiae adipisci repellendus dolor est qui impedit mollitia nesciunt. Aliquam esse accusantium numquam quod fugiat ut eius molestiae. Aut sunt expedita adipisci vitae omnis beatae voluptatum.'),
	('93', '13', 5, 'Doloremque vero nam quaerat. Quo voluptatem deleniti ea.'),
	('94', '14', 5, 'Debitis ut rerum autem assumenda. Est inventore facilis voluptates repellendus quia vel laudantium. Neque consectetur ab error voluptatem fugit commodi veniam.'),
	('95', '15', 3, 'Autem eum velit aut iste nihil delectus sunt dolores. Iure vel id totam voluptatem velit. Impedit velit omnis numquam perspiciatis voluptatem quae.'),
	('96', '16', 4, 'Vel ratione voluptas optio corrupti error. Dicta provident alias odit non est magnam. Et ipsum sed atque tempore. Ut architecto atque suscipit doloremque.'),
	('97', '17', 1, 'Inventore magni sit amet perferendis nostrum pariatur. Est et minus ut quam. Earum repellendus aspernatur veritatis est magnam et dolor doloribus. Doloremque nemo similique ducimus ab modi corrupti.'),
	('98', '18', 3, 'Qui ut quas ad dolorum quasi architecto fugit. Id modi aspernatur dolores deleniti aperiam consectetur id nam. Facere eius est inventore ducimus quo. Architecto ullam et vel cupiditate ratione.'),
	('99', '19', 5, 'Sint occaecati voluptate cumque non aut minima non. In facere deleniti molestiae doloribus iusto quo. Quia omnis fugit architecto non consequatur.'),
	('100', '20', 3, 'Aliquam cum ut iste molestiae. Est facere autem in modi aut vitae. Itaque sed placeat perferendis facere magni error alias expedita.');

INSERT INTO `first_lvl_catalog` (`id`, `name`, `created_at`, `updated_at`) VALUES 
	('1', 'id', '2020-02-29 17:21:22', '2017-12-05 18:43:15'),
	('2', 'ipsum', '2011-03-02 02:07:32', '1988-11-24 05:58:00'),
	('3', 'dicta', '2004-07-07 00:48:29', '1980-01-01 02:57:22'),
	('4', 'voluptatem', '1974-09-17 23:49:19', '1974-12-16 16:39:30'),
	('5', 'commodi', '1986-03-04 10:24:31', '1979-09-02 20:27:13'),
	('6', 'a', '1980-11-05 00:54:53', '1970-02-20 12:25:21'),
	('7', 'et', '1975-06-28 11:56:28', '2012-04-08 10:36:22'),
	('8', 'ut', '2017-02-13 07:30:23', '2002-02-15 03:39:36'),
	('9', 'cum', '1997-08-08 18:21:50', '2019-12-07 07:59:00'),
	('10', 'nihil', '1971-03-28 20:18:44', '2015-01-24 00:23:20');

INSERT INTO `second_lvl_catalog` (`id`, `name`, `created_at`, `updated_at`) VALUES 
	('1', 'quas', '2016-12-25 20:20:44', '1988-11-14 05:21:28'),
	('2', 'id', '1970-04-07 09:52:45', '1987-11-05 16:01:17'),
	('3', 'soluta', '2011-03-18 18:29:19', '2006-08-29 20:34:30'),
	('4', 'rem', '2011-09-21 22:39:09', '1998-05-04 19:55:19'),
	('5', 'voluptatem', '1975-09-13 03:26:09', '2005-10-25 07:49:43'),
	('6', 'animi', '1980-03-30 01:15:43', '1977-12-17 18:09:31'),
	('7', 'incidunt', '1982-10-14 12:47:33', '1976-09-30 23:54:37'),
	('8', 'dolores', '1986-12-29 16:18:55', '2018-08-23 18:50:49'),
	('9', 'ea', '2020-07-13 02:12:44', '2006-09-22 02:25:18'),
	('10', 'perspiciatis', '1988-06-10 02:29:06', '1970-04-15 12:50:22');

INSERT INTO `products_picture` (`id`, `filepath`, `created_at`, `updated_at`) VALUES 
	('1', 'Natus et provident fugit et.', '2002-03-24 09:32:48', '1989-02-26 18:55:05'),
	('2', 'Quia qui culpa quibusdam mollitia rerum.', '1990-12-31 19:22:11', '1986-03-27 00:35:43'),
	('3', 'Sed perspiciatis nostrum ducimus quia.', '1986-07-17 00:27:19', '1977-07-25 06:59:39'),
	('4', 'Deserunt dolor minima voluptatibus a unde veritatis voluptates eos.', '2018-12-15 08:05:30', '1976-06-26 04:50:47'),
	('5', 'Eius mollitia architecto cupiditate dolorum voluptate similique.', '1994-04-10 05:52:52', '1974-06-26 12:21:24'),
	('6', 'Atque facilis ullam dignissimos non ut.', '2020-01-19 21:19:42', '2003-02-01 16:20:20'),
	('7', 'Labore voluptatum quae culpa.', '2015-07-31 23:50:58', '1980-01-09 01:47:03'),
	('8', 'At voluptas recusandae illo sunt vel.', '2000-04-25 14:32:58', '1980-02-16 08:41:33'),
	('9', 'Minima rerum aut sunt et dolorum.', '1993-11-11 11:34:11', '2009-12-31 18:23:30'),
	('10', 'At sint accusantium eius et quis et expedita tempore.', '1980-04-12 16:57:25', '1996-04-19 19:18:32'),
	('11', 'Delectus et expedita ab voluptatem sed est.', '1982-07-29 04:53:27', '2013-02-18 08:34:48'),
	('12', 'Quos voluptatum illum omnis dolores cupiditate harum.', '1982-01-07 21:56:41', '1979-06-20 06:23:13'),
	('13', 'Ut ducimus sit ratione nostrum quis eum hic.', '2011-12-07 00:34:52', '1999-12-13 08:30:11'),
	('14', 'Et cumque distinctio voluptatem aut eveniet laudantium voluptatibus beatae.', '1986-04-01 05:08:21', '1974-07-24 11:32:19'),
	('15', 'Aliquam voluptate eaque sint est.', '1986-04-19 17:31:28', '2003-07-30 02:42:27'),
	('16', 'Consequatur quos delectus magnam.', '1987-09-09 22:22:04', '2012-04-26 22:46:24'),
	('17', 'Consequuntur nemo id non.', '2017-05-31 02:21:42', '1985-12-04 09:17:44'),
	('18', 'Culpa reprehenderit et quos quasi inventore laudantium similique.', '2016-03-24 23:20:46', '2014-09-09 01:32:46'),
	('19', 'Iste soluta laboriosam debitis inventore.', '1992-01-08 23:58:32', '2016-02-02 05:01:21'),
	('20', 'Consequatur quam reiciendis eum repudiandae.', '1998-08-02 11:46:35', '1992-12-21 16:20:29'),
	('21', 'Quis velit est officia tenetur.', '2017-12-10 05:56:54', '2010-09-21 13:41:49'),
	('22', 'Voluptatem facere voluptatem repudiandae.', '1995-12-10 08:43:26', '1989-05-04 12:26:03'),
	('23', 'Sapiente nostrum in dolore natus sapiente facilis quasi cupiditate.', '1990-12-11 06:37:23', '2010-10-27 16:46:11'),
	('24', 'Repudiandae consectetur non fuga sint quasi reiciendis molestiae.', '1997-11-18 16:39:55', '1995-01-28 06:06:10'),
	('25', 'Sapiente reiciendis quisquam omnis impedit modi eveniet porro.', '1977-10-11 13:14:45', '2018-01-10 21:20:33'),
	('26', 'Architecto error voluptatem non consectetur quasi est eligendi voluptatem.', '1994-09-09 11:16:23', '1996-02-08 16:42:45'),
	('27', 'Autem iste nisi voluptatem iure dolorum.', '1981-04-22 22:39:51', '2019-05-10 10:14:30'),
	('28', 'Pariatur qui eos mollitia laboriosam impedit earum.', '1989-07-14 22:25:35', '2011-01-02 00:39:59'),
	('29', 'Repudiandae odit ipsam quibusdam odit.', '2009-01-20 02:51:49', '1995-08-30 16:12:52'),
	('30', 'Qui ullam optio aspernatur officia.', '1997-04-30 11:38:44', '1982-12-07 07:14:04'),
	('31', 'Ab ipsam mollitia nulla cumque.', '1981-03-23 09:52:21', '2017-11-09 09:39:07'),
	('32', 'Quia et sunt nesciunt qui sit.', '1994-10-14 10:18:02', '1984-01-26 11:42:39'),
	('33', 'Saepe et iusto facere ut.', '2003-06-18 05:02:54', '1978-10-19 21:10:41'),
	('34', 'Nobis cumque rerum qui et sequi.', '1998-12-15 21:49:05', '2014-12-30 02:36:53'),
	('35', 'Culpa et culpa placeat perspiciatis architecto velit.', '2000-02-24 20:26:00', '1986-12-08 06:31:03'),
	('36', 'Accusantium eaque suscipit porro nesciunt aut totam animi.', '2020-02-29 23:33:22', '1993-02-28 02:16:22'),
	('37', 'Facilis voluptate aut illum et qui aut quia.', '1989-02-23 12:38:25', '1998-09-19 02:02:54'),
	('38', 'Esse reiciendis ipsum voluptas aut dicta.', '1970-08-13 22:16:35', '2012-06-30 08:58:11'),
	('39', 'Eos earum debitis corrupti earum natus soluta deserunt.', '2018-10-29 13:30:26', '2013-12-24 00:57:07'),
	('40', 'Est rerum magni quae sint velit aperiam voluptatem.', '1986-02-26 15:58:55', '2005-11-08 16:23:15'),
	('41', 'Maxime harum blanditiis ipsa quia.', '1991-12-07 15:20:38', '2015-03-21 14:37:32'),
	('42', 'Fugiat voluptatem mollitia alias.', '1980-07-26 09:44:12', '1980-05-24 00:13:18'),
	('43', 'Sequi praesentium et ratione sed.', '1999-04-28 04:53:55', '1993-12-25 00:55:54'),
	('44', 'Qui consequatur nihil error exercitationem aut.', '1992-10-02 07:33:43', '2017-12-10 04:06:19'),
	('45', 'Doloremque aliquid quia eaque consequatur.', '2002-01-14 08:52:11', '1984-11-01 00:02:03'),
	('46', 'Asperiores illum tenetur ipsam expedita qui.', '1993-01-18 03:37:41', '2003-12-30 18:00:00'),
	('47', 'Omnis quia qui explicabo sunt reiciendis in.', '1977-04-29 18:58:31', '1995-08-01 20:00:36'),
	('48', 'Numquam quae illum dolor aliquid ipsum.', '2012-11-19 20:02:07', '1994-11-24 16:57:01'),
	('49', 'Repellat consequuntur nostrum sunt qui facere dolore.', '1987-08-22 07:36:15', '2018-02-01 18:44:08'),
	('50', 'Qui quis aut libero quod hic aut qui neque.', '2009-05-10 11:00:37', '2013-12-21 10:40:31'),
	('51', 'Deserunt sunt praesentium quis magni qui.', '1975-09-07 11:33:40', '2015-05-28 05:57:02'),
	('52', 'Est quisquam dolore autem tempora ea quam sed.', '2010-11-23 13:00:28', '2008-12-19 12:27:03'),
	('53', 'Earum numquam et molestiae sit voluptatibus autem nisi natus.', '1975-08-06 08:03:05', '1982-09-01 21:53:01'),
	('54', 'Amet velit eveniet atque ipsa occaecati non fugit quia.', '1985-07-20 04:50:05', '1983-10-02 10:45:11'),
	('55', 'Eius distinctio quos omnis quo optio.', '1989-06-25 17:48:26', '1997-10-31 12:21:01'),
	('56', 'Magni quia corporis esse aperiam porro.', '2015-08-25 02:54:19', '2017-04-10 01:54:13'),
	('57', 'Omnis qui sed qui amet sit nihil dolor.', '1973-03-14 08:26:51', '1981-03-16 03:50:52'),
	('58', 'Et dolor et corporis amet aut quo.', '1997-05-21 03:39:52', '1981-07-12 06:22:56'),
	('59', 'Dolorem omnis molestias qui quod eveniet sunt.', '1974-09-27 02:21:24', '1987-02-16 03:11:18'),
	('60', 'Dolores sunt deleniti quo modi.', '2017-07-12 03:03:15', '2019-02-06 23:57:44'),
	('61', 'Sequi odit et distinctio voluptas distinctio non.', '1987-04-28 14:34:03', '1984-11-11 02:42:21'),
	('62', 'Sunt consequatur doloribus et porro pariatur necessitatibus consequatur.', '2004-10-27 16:55:54', '1996-04-07 07:47:38'),
	('63', 'Modi quidem dolores libero corporis magni.', '1987-10-19 00:10:18', '1978-06-29 15:08:43'),
	('64', 'Reiciendis et deserunt voluptas explicabo alias rerum.', '1992-02-26 19:19:00', '1985-09-26 01:24:03'),
	('65', 'Beatae omnis vitae voluptas delectus.', '2019-09-08 14:49:36', '1992-06-23 08:45:01'),
	('66', 'Odio veritatis maxime officiis qui explicabo eum.', '1986-01-08 04:54:46', '1995-02-03 21:03:18'),
	('67', 'Voluptas exercitationem ut autem et porro ipsum tempore.', '1974-08-04 21:43:33', '1997-06-28 18:28:01'),
	('68', 'Exercitationem suscipit maxime esse perspiciatis minima ratione.', '2000-04-24 07:11:48', '2000-11-08 00:13:09'),
	('69', 'Consequatur ipsa distinctio quam aperiam aut.', '1976-10-18 23:24:35', '2002-12-08 06:26:26'),
	('70', 'Reiciendis nihil quas amet et aut perferendis consequatur.', '2005-08-28 12:58:41', '1970-05-26 10:57:41'),
	('71', 'Quia ipsum animi vel ab temporibus.', '1978-04-25 13:17:04', '1985-04-28 02:19:11'),
	('72', 'Tenetur iusto ducimus voluptas corporis quod consequuntur aut.', '1998-09-25 03:19:42', '1995-02-10 23:29:16'),
	('73', 'Sit et labore odit voluptas.', '1989-11-01 03:55:30', '1985-12-28 05:23:48'),
	('74', 'Assumenda et est quaerat porro sunt vel.', '1975-06-28 22:33:54', '2016-05-22 03:48:17'),
	('75', 'Ipsam culpa magnam aperiam.', '2019-08-04 11:20:43', '1979-12-06 18:38:54'),
	('76', 'Aut est et rerum unde fugit dolorum.', '1995-04-14 09:41:45', '2014-01-12 22:56:50'),
	('77', 'Corrupti voluptate repudiandae veritatis.', '2008-03-26 11:38:26', '2014-09-12 01:21:43'),
	('78', 'Eos molestiae eveniet perspiciatis ipsa qui sapiente odio.', '1985-03-14 04:24:55', '1985-08-27 02:22:33'),
	('79', 'Quis vero sit vel optio.', '2011-08-01 15:14:40', '2020-06-18 14:49:13'),
	('80', 'Libero iusto hic est sed quaerat distinctio sunt.', '1999-03-21 04:34:17', '1993-05-09 03:41:04'),
	('81', 'Voluptatibus maiores dolores qui voluptatum.', '1984-07-28 20:59:06', '1990-07-15 04:57:49'),
	('82', 'Sed ducimus consequatur et non aut maxime temporibus.', '2015-04-27 11:26:01', '2015-05-06 20:45:04'),
	('83', 'Enim sint nam dignissimos ad accusantium nostrum.', '2011-08-10 23:29:53', '2018-04-17 19:48:34'),
	('84', 'Recusandae autem consectetur placeat corporis quis consequatur veritatis.', '1990-09-24 02:05:25', '1984-05-09 15:03:30'),
	('85', 'Nisi quas eum quidem officiis.', '1970-02-15 22:48:34', '2016-10-23 16:07:05'),
	('86', 'Adipisci mollitia iusto assumenda et fugit accusamus sit voluptates.', '2011-10-12 18:40:30', '1974-01-21 05:51:38'),
	('87', 'Ipsum possimus libero eos quod ab sed sed.', '1993-01-31 04:39:51', '2017-05-30 00:12:22'),
	('88', 'Magni quidem qui perferendis non.', '1998-04-06 07:19:02', '1993-08-11 04:40:45'),
	('89', 'Corporis aut accusamus ratione ut neque minus repudiandae laudantium.', '2011-04-13 11:29:40', '1973-01-18 19:45:26'),
	('90', 'Voluptate quisquam iure et occaecati.', '1976-02-13 03:00:09', '1996-12-21 16:09:19'),
	('91', 'Dolor atque provident velit ex.', '2004-01-08 11:53:06', '2020-03-12 21:18:13'),
	('92', 'Velit eum consequatur excepturi eligendi animi molestias magni perspiciatis.', '1998-07-06 20:41:25', '1991-02-06 07:16:20'),
	('93', 'Aut debitis aut odit et fugit.', '2012-11-17 20:32:30', '2002-11-17 00:41:47'),
	('94', 'Maxime necessitatibus aut soluta veritatis.', '2004-06-08 19:40:02', '1972-06-10 06:06:55'),
	('95', 'Quia quia ipsa quos quae ad consequatur praesentium placeat.', '2012-05-27 23:26:17', '2020-05-13 01:44:37'),
	('96', 'In quia labore eum saepe.', '1994-07-23 06:04:39', '2015-04-21 00:28:17'),
	('97', 'Amet quia dolores expedita.', '1988-04-19 03:17:02', '2015-01-24 03:08:43'),
	('98', 'Aut voluptas et ullam sint nesciunt rerum ad.', '2002-10-02 06:00:02', '1986-12-12 16:21:33'),
	('99', 'Voluptatum voluptas optio aut repudiandae cum molestiae.', '2000-02-18 03:33:32', '2012-10-30 12:25:01'),
	('100', 'Ipsum nam eligendi nemo nulla aut cumque.', '1991-06-08 07:17:06', '1997-02-19 17:58:52');

INSERT INTO `products` (`id`, `name`, `description`, `price`, `quantity`, `products_picture_id`, `first_lvl_catalog_id`, `second_lvl_catalog_id`, `brand`, `country`, `feedback_id`, `created_at`, `updated_at`) VALUES 
	('1', 'velit', 'Vel ut quibusdam necessitatibus sint assumenda enim et. Qui sed libero possimus repellendus voluptatibus ut eum quod.', '5394.73', 20, '1', '1', '1', 'Kilback, Greenholt and Jacobi', 'United States Virgin Islands', '1', '1981-12-22 13:27:20', '1999-03-31 01:01:27'),
	('2', 'ut', 'Qui adipisci itaque voluptatem alias molestias in perferendis placeat. Et consequatur dignissimos recusandae quod assumenda molestiae reiciendis.', '5640.16', 83, '2', '2', '2', 'Shanahan and Sons', 'Qatar', '2', '1988-01-29 13:20:57', '1998-02-15 16:54:14'),
	('3', 'itaque', 'Blanditiis illo beatae quam sit velit odit. Sit veniam vero aut reprehenderit. Itaque quia laborum beatae. Ut dolorum numquam sint velit sunt modi.', '2749.5', 91, '3', '3', '3', 'Kohler-Schowalter', 'Guam', '3', '2009-12-23 13:57:08', '2008-12-27 10:58:34'),
	('4', 'itaque', 'Voluptate quis in quia pariatur. Vitae voluptatem autem aut hic. Veniam natus rem laudantium nisi. Odit animi aut exercitationem nostrum eos cupiditate vero.', '5669.4', 58, '4', '4', '4', 'Hand Group', 'Tunisia', '4', '1974-02-06 05:12:10', '1978-05-31 14:34:15'),
	('5', 'excepturi', 'Error eveniet quia rerum qui. Magni in et id doloribus at est. Ut dignissimos doloribus aut id est molestiae in. Aliquid quia nihil et rerum sint voluptatem.', '446', 19, '5', '5', '5', 'Schumm, Cartwright and Mraz', 'Central African Republic', '5', '1971-04-26 02:52:41', '2017-08-14 16:20:39'),
	('6', 'aliquam', 'Similique exercitationem ratione amet voluptatem. Atque minus illo placeat.', '8640.95', 64, '6', '6', '6', 'Koch Inc', 'Bhutan', '6', '2002-06-21 00:55:18', '1990-03-23 19:51:55'),
	('7', 'dolorum', 'Adipisci et et officiis recusandae id qui. Ut nihil eos eum et voluptatibus rem id voluptatem. Quasi rerum vel cum nemo. Explicabo et dolorem aliquam minima consequatur voluptatem.', '7872.18', 81, '7', '7', '7', 'Lind-Grimes', 'Heard Island and McDonald Islands', '7', '2000-10-27 11:43:46', '2013-02-16 05:19:48'),
	('8', 'dignissimos', 'Et optio magnam id et praesentium ullam sed. Quo fuga molestias vero necessitatibus. Corporis distinctio magni quam deleniti doloremque.', '648.46', 18, '8', '8', '8', 'Waelchi Inc', 'Greenland', '8', '1997-04-16 03:05:11', '2004-02-22 04:09:44'),
	('9', 'deserunt', 'Minus minus deserunt iusto aut est repudiandae consequatur. Quas delectus dolor voluptas quia rerum. Officia deleniti quis eius ut.', '6469', 12, '9', '9', '9', 'Donnelly, Mayert and Tillman', 'Honduras', '9', '1986-03-05 22:19:44', '2017-11-10 12:25:03'),
	('10', 'suscipit', 'Dolorem harum officia qui ullam animi deserunt. Dignissimos voluptatem ullam molestias praesentium. Ipsa et ullam adipisci distinctio et. Culpa et quam itaque eum.', '210.38', 62, '10', '10', '10', 'Weimann-Bruen', 'Guinea', '10', '1997-06-25 21:00:23', '1971-04-25 20:36:19'),
	('11', 'aspernatur', 'Libero nihil earum nobis a aliquid. Quod saepe laborum a modi dolor magnam. Qui ut tempora itaque sed id maiores quam. Quam ad a nobis illum.', '7734.23', 44, '11', '1', '1', 'Harber, Mante and Weissnat', 'Christmas Island', '11', '2019-01-21 11:39:20', '1991-03-23 21:30:48'),
	('12', 'sunt', 'Et eos quia velit modi possimus sunt. Similique reiciendis aut voluptates totam iure distinctio et. Facere eligendi quia suscipit quidem qui vero mollitia.', '4667.46', 75, '12', '2', '2', 'Beatty-Reynolds', 'Slovenia', '12', '2017-12-07 06:43:31', '1993-04-09 08:57:51'),
	('13', 'quasi', 'Ipsum minus architecto ea corporis accusantium suscipit placeat quos. Totam molestiae ducimus laborum error est. Temporibus sapiente pariatur est possimus tempore cum.', '2593.78', 5, '13', '3', '3', 'Ernser LLC', 'United States of America', '13', '1996-06-16 19:23:58', '1973-05-31 21:06:30'),
	('14', 'nesciunt', 'Animi soluta fugit optio in qui. Molestiae minus sint et dolore voluptate id. Quas reiciendis quia magni beatae aut. Deserunt voluptas ipsa aut vitae sed eius.', '5379', 73, '14', '4', '4', 'Davis-Hilpert', 'Hong Kong', '14', '1970-10-06 21:36:34', '1984-02-08 04:31:09'),
	('15', 'assumenda', 'Dolore sunt in quo et commodi eum. Dolorem eveniet enim est minima aut distinctio asperiores repudiandae. Ex excepturi accusantium aut suscipit. Voluptatem occaecati id aut nesciunt aperiam.', '808.792', 96, '15', '5', '5', 'Kuhic-Muller', 'Christmas Island', '15', '2013-06-10 02:02:56', '2004-08-08 00:48:05'),
	('16', 'delectus', 'Tenetur perferendis dolore aliquam ducimus unde ea adipisci. Asperiores sed sed eos eos sequi deserunt. Sint distinctio et rerum sit. Minima aut ratione sunt ut voluptate ipsum.', '7808', 3, '16', '6', '6', 'Steuber, Ziemann and Ward', 'Tokelau', '16', '2014-01-18 07:12:42', '2000-02-06 10:34:45'),
	('17', 'et', 'Suscipit consequatur labore tenetur consequuntur illo. Et et vel ducimus nihil earum quia. Laborum eligendi incidunt quis et porro. Culpa non ut libero quibusdam.', '5070.89', 73, '17', '7', '7', 'Corkery, Wilkinson and Herman', 'El Salvador', '17', '1986-12-27 19:36:33', '2011-03-01 02:48:22'),
	('18', 'quasi', 'Corporis vel ad architecto et. Atque velit expedita natus quia occaecati tempora. Vitae illum non labore aliquam officia. Numquam omnis ut quisquam at.', '2580.86', 90, '18', '8', '8', 'Kirlin Ltd', 'Barbados', '18', '1988-10-02 21:34:59', '1985-01-05 19:33:52'),
	('19', 'amet', 'Facilis doloremque sint nemo sit saepe quia ut. Et quod aspernatur ipsam illum nam illo. Ipsum ut eius eum unde eum aperiam alias autem. Unde vel debitis repellat autem quaerat dolorem modi similique.', '4118.44', 33, '19', '9', '9', 'Durgan-Mosciski', 'Mauritania', '19', '1998-12-18 20:41:11', '2005-09-29 23:18:40'),
	('20', 'voluptates', 'Enim cumque ducimus dignissimos neque et dolores aut doloremque. Rerum sunt cumque dolores exercitationem commodi officiis voluptatum. Harum vero asperiores magnam nisi et non voluptas. Voluptatem facilis cum est odio qui.', '1435.38', 35, '20', '10', '10', 'Cummerata and Sons', 'Cape Verde', '20', '1995-11-27 19:13:40', '1987-08-18 16:13:31'),
	('21', 'tempore', 'Est magnam laudantium aut necessitatibus et nihil vel. Provident molestiae delectus inventore et eum. Minus aspernatur non nam provident amet animi consequuntur vel.', '2984.8', 59, '21', '1', '1', 'Upton PLC', 'New Caledonia', '21', '2000-04-19 06:12:02', '2011-05-06 13:14:31'),
	('22', 'quia', 'Et fuga qui ipsa architecto autem. Cum numquam recusandae officia eum quo hic cupiditate. Facere illum omnis hic adipisci neque laborum aperiam.', '1383.91', 91, '22', '2', '2', 'Bashirian-Senger', 'Saudi Arabia', '22', '1982-09-08 02:21:17', '1975-09-04 21:41:57'),
	('23', 'rerum', 'Unde qui itaque esse cumque autem sint. Aut dolore tenetur voluptas et odit a quis repudiandae. Sed consequatur incidunt eaque eum. Voluptas voluptatibus facilis optio et qui.', '5354.16', 12, '23', '3', '3', 'Maggio-Gleichner', 'Gabon', '23', '2006-07-13 05:30:54', '2008-11-04 01:50:23'),
	('24', 'molestiae', 'Ex dolor voluptatibus excepturi. Tempore voluptatibus sint nobis assumenda voluptatem quia.', '5719.39', 52, '24', '4', '4', 'Terry, Lynch and Dicki', 'El Salvador', '24', '2010-09-14 14:19:33', '1974-11-07 11:08:45'),
	('25', 'temporibus', 'Perspiciatis error est sequi beatae. Illo quia ut molestiae qui inventore. Accusamus commodi eum facilis eveniet fuga reprehenderit. Est porro officia dolorem quos quaerat assumenda labore.', '8020.43', 85, '25', '5', '5', 'Leannon Ltd', 'Marshall Islands', '25', '1972-12-29 02:42:38', '2017-09-25 18:16:40'),
	('26', 'libero', 'Ut et aut et consequatur impedit ipsum rerum quidem. Perferendis sit quis ut aut in. Natus aut labore cumque eaque quo.', '3801.88', 30, '26', '6', '6', 'McCullough and Sons', 'Spain', '26', '1990-01-27 19:32:05', '2004-01-03 00:58:19'),
	('27', 'exercitationem', 'Ullam rerum consequatur sapiente rerum voluptatem dolorum voluptas. Rerum dolores quis similique ut amet.', '1888.5', 34, '27', '7', '7', 'Herman-Schneider', 'Central African Republic', '27', '1997-03-02 02:43:08', '1979-12-09 05:42:26'),
	('28', 'reprehenderit', 'Perspiciatis accusantium est in non. Est accusantium harum laboriosam natus facere eum repellat assumenda. Qui sit eum quia. Vero accusamus deleniti et voluptatem at a tenetur.', '8378.88', 37, '28', '8', '8', 'Yundt-Kozey', 'Jamaica', '28', '2020-09-06 00:08:55', '2018-07-26 21:54:43'),
	('29', 'modi', 'At laudantium quo temporibus porro in suscipit. Similique eum in in qui. Dolore ut vero atque pariatur est quam et.', '2340.05', 68, '29', '9', '9', 'Hahn, Ebert and Hoppe', 'Zimbabwe', '29', '1986-12-29 17:20:07', '2015-08-20 01:42:07'),
	('30', 'veniam', 'Aut a aut quia vel et. Id error vel voluptas eum nam aut. Et facere officiis sit molestiae eum. Nulla mollitia quos nobis vero.', '5287.04', 48, '30', '10', '10', 'Farrell-Jacobi', 'Niue', '30', '2004-01-24 18:44:47', '1987-09-12 04:33:39'),
	('31', 'minus', 'Cumque illo ipsum exercitationem a alias ipsam quis velit. Illum ut nihil minus iusto enim cum eaque. Quod sit earum omnis vero. Rerum delectus vel ut excepturi sed similique pariatur.', '9990.73', 29, '31', '1', '1', 'Hoeger, Adams and Will', 'Wallis and Futuna', '31', '2013-05-22 02:49:45', '1970-10-17 05:28:42'),
	('32', 'reiciendis', 'Aperiam laudantium omnis ullam et. Eum culpa nihil voluptas dolores neque laboriosam nesciunt. Soluta reiciendis blanditiis voluptatem aut doloremque id ipsa.', '8818.29', 97, '32', '2', '2', 'Barrows-Mitchell', 'Barbados', '32', '1991-03-28 13:08:47', '1991-04-19 01:44:41'),
	('33', 'consequatur', 'Omnis ullam velit sit doloribus aspernatur nostrum natus. Qui voluptatem atque qui rerum. Ullam qui velit dolorum quis excepturi nihil tenetur pariatur. Reprehenderit vero atque veritatis deserunt qui in est. Odio placeat est sed rerum ut dignissimos.', '7783.69', 95, '33', '3', '3', 'Hahn-Walter', 'Luxembourg', '33', '1999-04-14 13:35:19', '2006-04-19 09:19:20'),
	('34', 'qui', 'Placeat aspernatur aut quidem voluptatem. Maxime dolore veniam eos cupiditate. Illo necessitatibus sapiente non magnam illo quam debitis. Dolore sapiente eaque quia sunt.', '8226.43', 74, '34', '4', '4', 'Cremin-Sporer', 'Myanmar', '34', '1998-06-07 22:39:19', '2000-04-03 10:10:19'),
	('35', 'nisi', 'Illo accusantium sunt et eos cumque et cupiditate. Alias repellat modi rerum non dolor. Eum sed nesciunt et fuga dolor. Quod asperiores inventore sint qui aut.', '8650.02', 90, '35', '5', '5', 'Zemlak LLC', 'Czech Republic', '35', '1970-09-16 06:59:13', '1975-12-15 16:11:54'),
	('36', 'esse', 'Voluptatum fuga expedita optio consequuntur rerum et quo. Beatae nemo nesciunt minus voluptates fugiat sed in. Repudiandae aut qui quaerat voluptates qui harum velit sed. Eum et nam ipsum quibusdam eos.', '7209.51', 81, '36', '6', '6', 'Marquardt, Barton and Parisian', 'Barbados', '36', '2018-05-20 13:44:54', '1992-06-07 22:35:44'),
	('37', 'omnis', 'Laborum at maiores soluta sapiente qui. Laudantium dolores pariatur molestiae sapiente aut commodi. Officia saepe et vero dolorem ut voluptas quia in. Ab eveniet quos omnis sapiente aut in aut sunt.', '1083.39', 41, '37', '7', '7', 'Leannon-Ryan', 'Australia', '37', '2015-09-02 14:38:49', '2014-08-25 08:18:59'),
	('38', 'delectus', 'Facere fugit neque voluptas mollitia neque beatae rerum. Sit eligendi qui qui quis sit quis ab ut.', '7802.98', 32, '38', '8', '8', 'Zieme, Carter and Stanton', 'Hong Kong', '38', '2018-03-05 09:49:28', '1970-08-05 21:07:30'),
	('39', 'eos', 'Cum rem vel fuga debitis quia ea. Molestias numquam et fugit fuga et minima dolor officia. Natus accusamus qui ut temporibus qui.', '3779.07', 54, '39', '9', '9', 'O\'Conner, O\'Conner and Jenkins', 'South Georgia and the South Sandwich Islands', '39', '1970-11-04 02:52:40', '2020-07-09 20:51:45'),
	('40', 'inventore', 'Blanditiis aut dolore dolores adipisci quasi dolores nihil. Tenetur quo enim nisi esse voluptate. Harum ducimus illum alias cupiditate dolores voluptatibus doloremque. Quia molestiae velit beatae nobis.', '1090.63', 3, '40', '10', '10', 'Pfannerstill-Veum', 'Egypt', '40', '2005-04-13 06:52:34', '1988-05-04 13:17:16'),
	('41', 'nobis', 'Placeat delectus iusto ratione in debitis et id magni. Fugiat pariatur incidunt expedita incidunt quam aut laboriosam. Nihil labore nihil et consequatur dolores quisquam magnam. Eligendi distinctio nihil consectetur sequi et.', '1718.37', 84, '41', '1', '1', 'Buckridge, Douglas and Nitzsche', 'Philippines', '41', '2011-09-26 16:53:55', '1991-09-22 00:03:18'),
	('42', 'perspiciatis', 'Dolorem magni voluptas voluptas excepturi facere. Quaerat repudiandae dolor ab quia dolores. Optio quisquam nostrum molestias quos officiis. In velit ratione qui qui aut sit doloremque.', '1858', 74, '42', '2', '2', 'Gaylord Ltd', 'Nigeria', '42', '2001-04-03 14:55:03', '1979-10-05 18:03:38'),
	('43', 'quisquam', 'Quasi neque impedit sit blanditiis harum optio. Cumque dolores ratione qui quasi recusandae. Et quaerat dolorum qui consequuntur aspernatur et consequatur. Deserunt et tenetur magnam sed quos omnis dolor blanditiis.', '2594.26', 25, '43', '3', '3', 'Watsica Group', 'Netherlands', '43', '2005-04-21 19:07:47', '1996-07-20 05:28:40'),
	('44', 'eum', 'Ex consequatur perferendis odio consequuntur. Delectus repellat quibusdam sed ut.', '7928.86', 45, '44', '4', '4', 'King, Pfannerstill and Wisoky', 'Serbia', '44', '2013-01-06 15:46:09', '2015-12-03 11:01:55'),
	('45', 'aut', 'Qui et natus ut ullam beatae excepturi est. Incidunt suscipit quis qui voluptate repudiandae. Sapiente nisi quam sunt sed.', '9743.8', 4, '45', '5', '5', 'Collier-Johns', 'Moldova', '45', '2007-01-29 12:26:15', '1998-08-26 07:27:20'),
	('46', 'sit', 'Deleniti enim nobis qui modi molestiae id non maiores. Occaecati tempore eius voluptatem ipsa nemo est. Eius voluptatem quas provident sint tempore exercitationem. Aut et sapiente voluptatum.', '8622.94', 1, '46', '6', '6', 'Moen-Becker', 'Malaysia', '46', '1981-01-16 01:28:56', '1974-12-17 08:45:47'),
	('47', 'iusto', 'Recusandae non sit minus est optio praesentium id. Iusto et tempora ut rem.', '3353.81', 94, '47', '7', '7', 'Jones, Fadel and Nikolaus', 'Switzerland', '47', '1980-04-16 17:54:50', '2003-05-01 18:13:16'),
	('48', 'porro', 'Labore facere ut ut vel saepe doloribus. Nemo sit quam voluptas hic ipsam error sunt beatae. Ut sed dolores occaecati maxime vel. Totam numquam velit eum blanditiis.', '7429.48', 49, '48', '8', '8', 'Boehm PLC', 'Angola', '48', '1970-12-11 15:39:11', '1992-08-22 07:49:13'),
	('49', 'corporis', 'Repudiandae quibusdam debitis asperiores dolorem explicabo aliquam. Dignissimos minus ullam autem sit. Facilis sequi ut eos nisi dolorum.', '3338.4', 63, '49', '9', '9', 'Blanda-Okuneva', 'Nepal', '49', '2013-03-14 09:10:32', '1977-04-10 15:42:49'),
	('50', 'aut', 'Dolores quo laborum ad voluptatem. Cupiditate non omnis maiores nam eos. Tempora et id sint ea eius delectus aperiam iure. Fugiat voluptas illo a necessitatibus placeat rem iste quo.', '7488.04', 90, '50', '10', '10', 'Stehr-Schiller', 'Morocco', '50', '1987-07-16 10:54:18', '2000-09-24 08:28:54'),
	('51', 'incidunt', 'Excepturi doloremque deserunt ex quo mollitia occaecati consequatur. Veritatis optio ut minima dolorem excepturi voluptatem. Eum incidunt sit quasi et quae aliquam.', '2512', 41, '51', '1', '1', 'Lueilwitz, Russel and Bailey', 'Cayman Islands', '51', '2017-01-14 16:45:26', '1978-04-14 04:19:33'),
	('52', 'nesciunt', 'Itaque consequatur quo nemo. Aliquid provident porro reiciendis quia. Ut eum natus maiores voluptatem. Ex aperiam ullam voluptatem itaque dolore. Incidunt dolor et ipsam maxime aut eos.', '5935.87', 76, '52', '2', '2', 'Swift, Bayer and Schulist', 'Mauritania', '52', '2009-04-05 08:25:32', '1993-02-24 02:08:21'),
	('53', 'hic', 'Aut est velit exercitationem facere quia odit. Doloremque possimus temporibus qui labore laborum molestiae cum. Voluptatem qui quas nostrum est ipsum quia.', '9483.73', 13, '53', '3', '3', 'Walker-Lynch', 'Svalbard & Jan Mayen Islands', '53', '2012-06-27 05:08:01', '2006-06-21 16:24:46'),
	('54', 'optio', 'Illo quia deserunt quia aut id accusamus. Ut consequatur et enim enim aut. Ratione alias cum sunt deserunt placeat itaque et.', '7058.77', 45, '54', '4', '4', 'Lowe, Lakin and Thompson', 'France', '54', '1975-11-17 02:58:06', '2002-03-10 03:22:16'),
	('55', 'nam', 'Distinctio asperiores quo laudantium eos ab occaecati dolor. Et sequi sint animi sit dolor. Possimus odit quia voluptas quaerat illo consectetur ut.', '9336.9', 65, '55', '5', '5', 'Bartoletti-Hilll', 'Solomon Islands', '55', '1989-12-21 19:20:55', '1995-04-21 03:18:50'),
	('56', 'eveniet', 'Officia quia unde magnam vitae eaque. Omnis perferendis et aut dolorem voluptatem est adipisci. Qui quia illum quam ut assumenda omnis harum.', '1482.26', 93, '56', '6', '6', 'Mosciski, Ziemann and Pouros', 'Cocos (Keeling) Islands', '56', '2011-04-01 17:12:50', '2015-02-15 12:55:01'),
	('57', 'voluptatem', 'Molestiae quasi voluptatibus sed porro itaque molestiae. Rerum magnam qui perspiciatis sint ut. Atque sed id accusamus sed.', '4661.67', 47, '57', '7', '7', 'Hackett-Botsford', 'Cambodia', '57', '2018-11-22 08:04:46', '1996-10-06 00:55:35'),
	('58', 'aliquam', 'Veritatis id ab quos quas porro. Aut repellat laudantium minus repudiandae aut porro temporibus. Aliquid ab voluptates culpa enim. Perferendis veniam aut iste perferendis dolorem. Et et et qui quos voluptatum.', '397', 37, '58', '8', '8', 'Marquardt, Kilback and Becker', 'Botswana', '58', '1994-09-10 16:52:32', '2003-12-01 07:35:56'),
	('59', 'rerum', 'Rerum et nihil accusantium et quidem. Quo error aliquid dolorem. Fugiat incidunt enim commodi tempora quis.', '6906.35', 82, '59', '9', '9', 'Weissnat-Mertz', 'Mayotte', '59', '1998-12-29 06:06:40', '2001-02-17 02:26:49'),
	('60', 'neque', 'Nobis expedita placeat dolor. Est totam quae aperiam eius voluptatum et. Et eius corrupti cum pariatur odio reprehenderit.', '5109.05', 10, '60', '10', '10', 'Beier Inc', 'Somalia', '60', '2005-01-03 05:31:58', '1979-07-14 05:53:49'),
	('61', 'consequuntur', 'Atque in illo aut fugit ullam. Architecto omnis expedita natus et praesentium. Minima tempora placeat et fugiat sequi alias quasi quis. Quae rerum iusto vero sed. Totam veritatis laboriosam aspernatur sed voluptas.', '8122.6', 15, '61', '1', '1', 'Jones, Feest and Berge', 'Haiti', '61', '1999-02-06 01:57:49', '1990-04-14 23:34:15'),
	('62', 'fugiat', 'Non quia molestiae dolore sed velit omnis. Sapiente similique magnam omnis voluptas.', '2867.45', 67, '62', '2', '2', 'Koss, Murazik and Sporer', 'India', '62', '1995-02-13 19:02:57', '1971-03-17 21:31:39'),
	('63', 'nulla', 'Rerum ut in consequatur. Libero ut suscipit debitis dicta magni. Quis aspernatur aliquid hic voluptas natus eos et illo. Alias dolorum consectetur dicta.', '9055.99', 17, '63', '3', '3', 'Champlin Inc', 'Mayotte', '63', '2003-06-15 19:41:22', '1998-01-30 15:00:56'),
	('64', 'sint', 'Inventore qui expedita explicabo est omnis et quam. Quas alias magnam temporibus ullam qui id dicta. Rerum labore est enim cumque laudantium aliquid. Dolorem iure aperiam consectetur quasi voluptas possimus modi.', '4186.6', 62, '64', '4', '4', 'Jones, Will and Armstrong', 'Guernsey', '64', '2006-04-22 08:57:07', '2016-12-03 19:23:01'),
	('65', 'velit', 'Veritatis et quaerat sunt sit. Voluptas repudiandae est velit quam ad recusandae. Minus et aut qui consequatur. Ducimus iste modi tempore non deleniti.', '7615.47', 6, '65', '5', '5', 'Gleichner, Hirthe and Ullrich', 'Malaysia', '65', '1993-08-31 03:37:21', '1980-03-08 22:03:21'),
	('66', 'quia', 'Quos et velit ad velit dicta at. Quidem modi quam eum. Dolorem alias et inventore et ducimus rerum doloribus.', '3447', 77, '66', '6', '6', 'Jacobs, Davis and Nitzsche', 'Venezuela', '66', '1976-09-21 17:41:29', '1983-03-10 00:53:55'),
	('67', 'libero', 'Dolores ullam dolorem explicabo aliquam aspernatur. Et non eveniet voluptatem in sit. Ab quia ut dignissimos nesciunt.', '30.3354', 81, '67', '7', '7', 'Donnelly LLC', 'Cocos (Keeling) Islands', '67', '1984-03-03 08:03:00', '2011-01-31 00:23:03'),
	('68', 'dolorum', 'Qui voluptatem ipsa voluptas alias nostrum cum. Itaque sed rerum voluptas debitis amet provident id. Et quae qui tempore ex dolorem eveniet possimus.', '2898.9', 54, '68', '8', '8', 'Kunde-Hansen', 'Panama', '68', '1995-05-20 09:42:57', '2006-09-23 05:28:23'),
	('69', 'voluptate', 'Laborum eum sunt veritatis. Commodi beatae sit ea enim.', '2430.1', 31, '69', '9', '9', 'Beatty PLC', 'Mali', '69', '1980-12-23 11:10:44', '1976-06-15 00:42:07'),
	('70', 'rerum', 'Rerum quidem esse aut repellendus vitae delectus vel. Perspiciatis sunt voluptas nam eum rem fugiat tenetur ut. Hic eum sit natus cumque deleniti nam.', '7604.5', 86, '70', '10', '10', 'Bradtke-Farrell', 'Afghanistan', '70', '2018-04-29 16:48:54', '1971-08-06 15:14:48'),
	('71', 'doloribus', 'Atque maiores quas illo consequatur repellendus distinctio excepturi. Eveniet maiores odit est perspiciatis quae. Unde cum eaque incidunt omnis vel. Dolorem sint iste ea quos quam.', '3803.73', 16, '71', '1', '1', 'D\'Amore, Schuppe and Farrell', 'New Caledonia', '71', '1980-03-13 06:06:47', '1993-07-04 22:26:57'),
	('72', 'aut', 'Minima vel itaque enim nihil aut. Sit in delectus quisquam sequi ut consectetur ea. Quo animi ipsum iusto incidunt enim.', '7244.18', 58, '72', '2', '2', 'Conn, Schulist and Reilly', 'Costa Rica', '72', '1991-10-12 21:34:35', '2015-06-24 07:41:39'),
	('73', 'inventore', 'Ipsa consequatur officiis cupiditate et necessitatibus eum dolor. Dolorem consectetur ad laudantium ab autem. Modi deleniti et consequuntur dignissimos sit dolores harum.', '732.2', 13, '73', '3', '3', 'Goyette, Rogahn and Green', 'India', '73', '2009-09-04 22:58:48', '2019-12-16 18:59:44'),
	('74', 'assumenda', 'Sit aut pariatur cumque modi iste. Sapiente eum molestias dolores voluptatem. Ad dolor sit eaque voluptates ut reprehenderit. Incidunt aliquid recusandae necessitatibus itaque.', '6964.69', 57, '74', '4', '4', 'Koelpin, Raynor and Koss', 'Denmark', '74', '1970-05-05 04:26:15', '2010-12-14 08:19:05'),
	('75', 'eveniet', 'Quod aut vero sint sed hic. Facilis voluptas hic magnam officiis sunt voluptas sint. Vel vel et aut sit omnis.', '6838.6', 16, '75', '5', '5', 'Mohr-Schmitt', 'Guernsey', '75', '2000-05-24 23:47:50', '2008-02-28 08:20:24'),
	('76', 'ex', 'Illum id sequi dolor quos voluptas harum. Modi ut exercitationem doloremque fugit enim. Excepturi tempore harum hic omnis. Consequatur est aut eligendi odit mollitia qui non.', '6357.17', 60, '76', '6', '6', 'Schroeder-Auer', 'Djibouti', '76', '2008-04-30 10:17:33', '1972-03-20 02:42:53'),
	('77', 'quod', 'Voluptatem quidem non aliquid et. Architecto repellendus cupiditate rerum ullam.', '6381.14', 63, '77', '7', '7', 'Wiegand, Dooley and Zulauf', 'Denmark', '77', '2018-08-11 19:10:47', '1987-06-13 13:56:59'),
	('78', 'autem', 'Numquam architecto quia ratione fugiat illo repellat quaerat. Nihil et provident commodi blanditiis dolores. Exercitationem molestiae consequatur optio eos natus.', '695.568', 63, '78', '8', '8', 'Stokes, Rempel and Casper', 'Guinea', '78', '1970-03-17 11:29:44', '2011-01-21 20:48:50'),
	('79', 'voluptas', 'Est sit sed quaerat quaerat sit unde consectetur pariatur. Doloribus enim provident omnis. Hic aperiam id optio iste. Eaque quas quia dolores cupiditate.', '8452.37', 76, '79', '9', '9', 'Glover Ltd', 'Congo', '79', '1979-03-25 11:12:54', '1972-12-24 09:04:02'),
	('80', 'totam', 'Laboriosam cumque expedita ex cumque. Magni ut beatae tenetur nam amet sint quas. Quia asperiores ab sunt nulla. Assumenda et molestias error sed eum ipsam.', '2174.18', 65, '80', '10', '10', 'Greenfelder-Lubowitz', 'Mauritania', '80', '1993-01-23 18:19:58', '1991-10-11 15:21:53'),
	('81', 'ipsum', 'Ea dicta in rerum. Aut voluptatem et quae. Laboriosam tenetur ut nemo iure itaque qui.', '6659.23', 57, '81', '1', '1', 'Batz, Langworth and Mueller', 'Bahrain', '81', '2009-02-07 01:35:41', '2016-11-27 13:59:25'),
	('82', 'voluptas', 'Architecto et dolore aliquid consequatur. Exercitationem corporis eius tenetur est quidem voluptas blanditiis. In ut possimus et.', '3753.64', 93, '82', '2', '2', 'Rohan, Muller and Gibson', 'Guadeloupe', '82', '1974-10-19 07:51:23', '1984-12-11 21:45:24'),
	('83', 'velit', 'Alias quas necessitatibus veniam magnam modi illo. Error ad qui temporibus qui ratione. Sapiente et repudiandae reiciendis et iure vel. Maxime quas aperiam vel molestias beatae. Voluptates voluptas tempora beatae ipsa et rem.', '7692.69', 58, '83', '3', '3', 'Halvorson PLC', 'Yemen', '83', '2003-04-01 05:26:58', '2002-06-24 16:30:45'),
	('84', 'expedita', 'Illo molestiae in quibusdam voluptate consequatur sit. Voluptatem quis expedita dolor est laboriosam est deserunt eveniet. Ut consequatur veniam amet iusto alias hic impedit molestiae. Voluptatem inventore sint incidunt aperiam suscipit nesciunt eveniet.', '9800.1', 9, '84', '4', '4', 'Nolan, Strosin and Beier', 'Indonesia', '84', '1982-12-28 13:57:52', '2014-04-24 09:05:34'),
	('85', 'magni', 'Quaerat et repellendus amet harum iste. Nisi cumque a magnam qui. Dignissimos eligendi omnis voluptate quas nisi corrupti aliquam. Voluptas voluptas unde illo ut in.', '8603.32', 45, '85', '5', '5', 'Runolfsson, Jenkins and Stokes', 'Haiti', '85', '1981-04-10 13:02:04', '2020-09-09 14:09:16'),
	('86', 'asperiores', 'Qui porro quasi doloremque dolore possimus. Ex sunt eum totam et adipisci blanditiis recusandae. Consectetur ut saepe temporibus aut eveniet. Sint sit quos esse.', '8930.4', 9, '86', '6', '6', 'Cummerata-Murray', 'Timor-Leste', '86', '1979-04-23 11:08:51', '1996-03-08 07:01:52'),
	('87', 'nulla', 'Laborum repudiandae architecto nihil. Rem maxime aut distinctio porro. Consequatur qui aut natus aut. Quia culpa nihil cupiditate sapiente porro sit.', '4297.8', 2, '87', '7', '7', 'Crist Group', 'Peru', '87', '1992-05-25 22:48:07', '2019-06-19 22:29:03'),
	('88', 'quis', 'Omnis magnam nesciunt impedit. Nihil fuga laudantium velit. Quisquam distinctio eligendi sit quia velit.', '6323.96', 50, '88', '8', '8', 'Hoppe-Heller', 'Palestinian Territory', '88', '2010-03-22 21:48:07', '2014-01-18 18:59:57'),
	('89', 'nisi', 'Voluptas excepturi asperiores nostrum velit. Aut facilis quasi sed nulla. Hic aut non pariatur culpa rem.', '9601.93', 58, '89', '9', '9', 'White, McCullough and Anderson', 'French Guiana', '89', '1988-03-12 06:00:51', '1996-06-03 09:35:42'),
	('90', 'aut', 'Et aut alias doloremque ipsa corporis est. Id totam repellat architecto delectus odit. Ut quia et voluptatem at praesentium enim. Aperiam tempora suscipit consequuntur delectus voluptas consequatur.', '2644.43', 15, '90', '10', '10', 'O\'Hara, Bruen and Zieme', 'Niger', '90', '1972-08-18 22:32:54', '1976-11-02 14:23:50'),
	('91', 'sit', 'Sunt nam architecto quas ut et. Est voluptatum aut magni. Ratione dolor aut fuga. Fuga laborum vitae voluptatibus illo.', '1095.19', 56, '91', '1', '1', 'Smith, Bode and Bayer', 'Mayotte', '91', '1979-10-25 06:17:43', '2006-05-22 23:35:01'),
	('92', 'laboriosam', 'Aut accusantium voluptas amet voluptatum sequi iusto molestiae. Dolores dolorem ex voluptatem consequatur voluptas. Voluptas nostrum culpa tempore doloribus. Quo est laudantium veritatis explicabo non rerum ratione.', '2868.1', 70, '92', '2', '2', 'Johnson, Dicki and Williamson', 'Djibouti', '92', '1974-12-12 01:49:16', '1994-09-05 07:05:36'),
	('93', 'ut', 'Reiciendis placeat aut iste similique hic est. Sequi facilis dolores ut.', '7827.3', 5, '93', '3', '3', 'Upton and Sons', 'Samoa', '93', '1973-07-17 07:24:31', '2008-10-05 07:30:49'),
	('94', 'dignissimos', 'Enim voluptatum sint at voluptates et doloremque. Doloremque repellendus fugit beatae recusandae veniam. Tempora facilis quos sint quae reiciendis facilis sunt. Et itaque reprehenderit quaerat nisi quidem dolore.', '5190', 8, '94', '4', '4', 'Dicki, Fritsch and Hermann', 'Norway', '94', '2009-05-31 03:45:18', '1970-06-03 19:31:31'),
	('95', 'eveniet', 'Voluptatem similique non rem voluptatibus qui. Quod explicabo ullam expedita quisquam molestias ab eum. Eum eligendi est ut nostrum beatae in qui.', '1432.9', 83, '95', '5', '5', 'Gislason-Douglas', 'Swaziland', '95', '2019-04-24 04:33:56', '2005-05-12 15:55:27'),
	('96', 'reprehenderit', 'Sapiente expedita sit adipisci quo. Aut commodi qui ea.', '2577.7', 53, '96', '6', '6', 'Wisozk Ltd', 'Papua New Guinea', '96', '1973-06-29 22:35:15', '1983-07-07 01:35:02'),
	('97', 'sed', 'Et atque eius molestiae est. Repellendus beatae consequatur sequi nemo quisquam magnam. Corporis rem molestiae officiis cum. Eos consequatur atque quia eum. Qui dolores architecto alias ut.', '7639.86', 32, '97', '7', '7', 'Cronin, Denesik and Green', 'Bhutan', '97', '2015-01-16 05:25:44', '1990-09-26 13:38:49'),
	('98', 'aut', 'Et totam cupiditate optio voluptas eaque tempora rerum. Quibusdam ea distinctio dolor enim possimus quis aut. Eum aliquid dicta fugit deserunt ipsa repudiandae.', '1140.26', 36, '98', '8', '8', 'Bailey Group', 'Guernsey', '98', '2011-10-31 16:56:23', '1978-04-21 00:52:05'),
	('99', 'velit', 'Fugit ut et cum impedit aspernatur impedit dolores. Aperiam alias fugiat et et accusantium reiciendis. Iste velit minus aut omnis cupiditate.', '2698.19', 78, '99', '9', '9', 'Wehner, Larkin and Walter', 'Kenya', '99', '1981-11-05 09:31:53', '1982-12-06 10:49:23'),
	('100', 'facere', 'Aut debitis quas repellendus repellat facilis aut et harum. Qui adipisci voluptatibus hic est vel qui. Veniam autem placeat sint consequuntur ipsum. Asperiores iste voluptatum et esse et sunt numquam dolores. Dolores sit nostrum ratione vel.', '2591.36', 93, '100', '10', '10', 'Collier, Hegmann and Collins', 'Ireland', '100', '2019-03-21 20:48:52', '2016-01-03 19:06:22');

INSERT INTO `orders` (`id`, `users_id`, `created_at`) VALUES 
	('1', '1', '1972-10-17 18:10:32'),
	('2', '2', '2020-04-16 15:48:54'),
	('3', '3', '1986-08-02 20:02:44'),
	('4', '4', '2003-10-17 22:01:42'),
	('5', '5', '2006-02-23 00:24:08'),
	('6', '6', '1997-06-18 09:39:21'),
	('7', '7', '1983-10-30 02:02:59'),
	('8', '8', '2000-05-28 07:56:27'),
	('9', '9', '2002-04-22 21:06:37'),
	('10', '10', '2008-02-28 03:36:34'),
	('11', '11', '1973-11-15 19:07:51'),
	('12', '12', '1989-08-24 11:48:40'),
	('13', '13', '2017-06-24 09:30:09'),
	('14', '14', '2007-08-16 23:13:12'),
	('15', '15', '1975-09-12 01:01:38'),
	('16', '16', '2000-06-03 16:53:29'),
	('17', '17', '2012-01-15 07:29:12'),
	('18', '18', '2018-02-19 06:48:51'),
	('19', '19', '1974-06-25 23:30:35'),
	('20', '20', '2005-11-03 00:56:03'),
	('21', '1', '2006-08-06 01:04:07'),
	('22', '2', '1989-02-23 00:18:38'),
	('23', '3', '1975-06-19 16:12:39'),
	('24', '4', '1996-05-21 07:23:07'),
	('25', '5', '1984-02-09 02:21:01'),
	('26', '6', '1993-09-29 21:14:58'),
	('27', '7', '1978-05-08 18:49:08'),
	('28', '8', '2020-04-10 08:08:19'),
	('29', '9', '1970-01-05 22:55:05'),
	('30', '10', '1996-05-17 21:09:11');

INSERT INTO `list_of_order` (`id`, `order_id`, `products_id`, `quantity`) VALUES 
	('1','1','1',2),
	('2','2','2',2),
	('3','3','3',2),
	('4','4','4',5),
	('5','5','5',4),
	('6','6','6',7),
	('7','7','7',2),
	('8','8','8',5),
	('9','9','9',1),
	('10','10','10',2),
	('11','11','11',5),
	('12','12','12',6),
	('13','13','13',5),
	('14','14','14',3),
	('15','15','15',3),
	('16','16','16',6),
	('17','17','17',6),
	('18','18','18',3),
	('19','19','19',4),
	('20','20','20',3),
	('21','21','21',2),
	('22','22','22',4),
	('23','23','23',3),
	('24','24','24',7),
	('25','25','25',6),
	('26','26','26',1),
	('27','27','27',3),
	('28','28','28',6),
	('29','29','29',4),
	('30','30','30',4),
	('31','1','31',6),
	('32','2','32',5),
	('33','3','33',6),
	('34','4','34',4),
	('35','5','35',3),
	('36','6','36',6),
	('37','7','37',7),
	('38','8','38',1),
	('39','9','39',3),
	('40','10','40',6),
	('41','11','41',3),
	('42','12','42',6),
	('43','13','43',6),
	('44','14','44',7),
	('45','15','45',1),
	('46','16','46',1),
	('47','17','47',3),
	('48','18','48',4),
	('49','19','49',2),
	('50','20','50',5),
	('51','21','51',4),
	('52','22','52',1),
	('53','23','53',6),
	('54','24','54',4),
	('55','25','55',2),
	('56','26','56',5),
	('57','27','57',7),
	('58','28','58',6),
	('59','29','59',1),
	('60','30','60',7),
	('61','1','61',5),
	('62','2','62',3),
	('63','3','63',3),
	('64','4','64',2),
	('65','5','65',5),
	('66','6','66',2),
	('67','7','67',3),
	('68','8','68',1),
	('69','9','69',1),
	('70','10','70',4),
	('71','11','71',4),
	('72','12','72',5),
	('73','13','73',6),
	('74','14','74',1),
	('75','15','75',7),
	('76','16','76',5),
	('77','17','77',1),
	('78','18','78',1),
	('79','19','79',1),
	('80','20','80',1),
	('81','21','81',1),
	('82','22','82',6),
	('83','23','83',1),
	('84','24','84',7),
	('85','25','85',1),
	('86','26','86',5),
	('87','27','87',5),
	('88','28','88',3),
	('89','29','89',3),
	('90','30','90',2),
	('91','1','91',7),
	('92','2','92',3),
	('93','3','93',2),
	('94','4','94',3),
	('95','5','95',7),
	('96','6','96',1),
	('97','7','97',3),
	('98','8','98',5),
	('99','9','99',5),
	('100','10','100',5);

INSERT INTO `promo` (`id`, `products_id`, `discount`, `started_at`, `finished_at`, `created_at`, `updated_at`) VALUES 
	('1', '1', '47', '2015-05-20', CURDATE(), '2005-07-29 22:21:50', '1986-09-29 21:41:27'),
	('2', '2', '38', '2011-03-02', CURDATE(), '1980-11-12 12:24:20', '2003-01-13 02:10:24'),
	('3', '3', '23', '1987-10-26', CURDATE(), '2000-05-20 11:31:28', '2003-01-04 15:44:52'),
	('4', '4', '5', '1998-04-11', CURDATE(), '1999-02-08 19:40:17', '1987-09-17 14:35:25'),
	('5', '5', '47', '1980-11-07', CURDATE(), '1990-02-19 13:42:26', '1995-01-29 19:00:20'),
	('6', '6', '31', '1971-01-28', CURDATE(), '1996-05-03 12:22:53', '2020-10-23 19:29:21'),
	('7', '7', '32', '2015-11-22', CURDATE(), '1995-06-11 08:58:29', '1984-06-19 07:28:57'),
	('8', '8', '40', '1984-10-31', CURDATE(), '1993-07-19 15:32:00', '1987-12-18 12:00:10'),
	('9', '9', '42', '2014-05-04', CURDATE(), '1992-05-02 10:23:16', '1989-05-02 18:04:49'),
	('10', '10', '7', '2009-09-22', CURDATE(), '1986-11-25 22:42:00', '1979-12-18 20:55:01');

UPDATE list_of_order SET 
    amount = ROUND(((SELECT price FROM products WHERE id = products_id) * quantity), 2); 

   
/*
Скрипты по работе с БД
-----------------------------------------------------------------------------
*/

-- Скрипт, для проверки остатков товара меньше определенного количества
SELECT name, quantity, brand FROM products WHERE quantity < 5 ORDER BY quantity;

-- Выборка товаров, учавствующих в акции (в виде представления)
CREATE OR REPLACE VIEW show_promo AS 
	SELECT p1.id, p1.name, p1.price 'старая цена', ROUND((p1.price * (1 - p2.discount/100)), 2) 'новая цена', p2.started_at, p2.finished_at
	FROM 
	  products p1
	JOIN
	  promo p2
	ON
	  p1.id = p2.products_id;

-- Выборка товаров catalog 1s lvl (в виде представления)
CREATE OR REPLACE VIEW catalog_first_lvl AS 
	SELECT p1.id, p1.name, f1.name '1st lvl catalog'
	FROM 
		products p1
	JOIN
		first_lvl_catalog f1
	ON 
		p1.first_lvl_catalog_id = f1.id;
		
-- Выборка товаров, когда-либо учавствовавших в акции
SELECT * FROM show_promo;

-- Групировка товаров, учавствующих в акции, по дате окончания
SELECT finished_at, COUNT(name) FROM show_promo GROUP BY finished_at;

-- Выборка товаров из каталога 1го уровня
SELECT * FROM catalog_first_lvl;

-- Проверка, сколько акционных товаров было продано в период действия акции
SELECT s1.id 'номер заказа', s1.name, l1.quantity, amount 
FROM 
    show_promo s1
JOIN
    orders o1
JOIN
    list_of_order l1
ON 
    (s1.id IN (l1.products_id)) AND ((l1.order_id = o1.id) AND (o1.created_at BETWEEN s1.started_at AND s1.finished_at));

-- Процедура запуска акции
DROP PROCEDURE IF EXISTS promo_start;
DELIMITER //
CREATE PROCEDURE promo_start(IN product_id BIGINT, discount INT, start_date DATE, end_date DATE)
BEGIN
	INSERT INTO promo (id, `products_id`, `discount`, `started_at`, `finished_at`) VALUES
		(id, product_id, discount, start_date, end_date);
	UPDATE products SET
	    price = ROUND((price * (1 - discount / 100)), 2)
	WHERE 
	    id = product_id;
END//
DELIMITER ;

CALL promo_start(20, 30, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY)); 

-- Процедура подсчета продаж за заданный промежуток времени
DROP PROCEDURE IF EXISTS revenue;
DELIMITER //
CREATE PROCEDURE revenue(IN start_date DATE, end_date DATE)
BEGIN
	SELECT SUM(amount) FROM list_of_order l1
	JOIN
    	orders o1
	ON (created_at BETWEEN start_date AND end_date) AND (o1.id = l1.order_id);
END//
DELIMITER ;

CALL revenue('2020-01-01', '2020-12-31'); 

