/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  zouhairhajji
 * Created: 9 mai 2016
 */

DROP TABLE IF EXISTS `Account`;
DROP TABLE IF EXISTS `Client`;
DROP TABLE IF EXISTS `Employe`;
DROP TABLE IF EXISTS `Info_Personnelle`;

DROP TABLE IF EXISTS `Agence`;
DROP TABLE IF EXISTS `Region`;
DROP TABLE IF EXISTS `Departement`;
DROP TABLE IF EXISTS `Pays`;
DROP TABLE IF EXISTS `Type_Pret`;

DROP TABLE IF EXISTS `Taux_Directeur`;
DROP TABLE IF EXISTS `calcPret`;
DROP TABLE IF EXISTS `Simul_Pret`;
DROP TABLE IF EXISTS `Dem_pret`;
DROP TABLE IF EXISTS `Pret`;
DROP TABLE IF EXISTS `matriceTauxFixe`;



-- Constraints Done
CREATE TABLE IF NOT EXISTS `Account`(
    
    id_account INT NOT NULL AUTO_INCREMENT,
    
    ndc VARCHAR(20) NOT NULL UNIQUE,
    psw VARCHAR(20) NOT NULL ,
    questionSecrete VARCHAR(20) NOT NULL,
    reponseSecrete VARCHAR(20) NOT NULL,
    
    role enum('User', 'Cons', 'DirAge', 'DirBnk') NOT NULL,

    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY key (id_account)
);




-- Constraints Done
CREATE TABLE IF NOT EXISTS `Client` (
    id_client INT NOT NULL AUTO_INCREMENT,
    
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    dateNaissance TIMESTAMP NOT NULL,
    adresse VARCHAR(20) NOT NULL,
    sexe enum('M', 'F', ' '),
    codePostale varchar(6) NOT NULL,

    id_pays INT NOT NULL, 
    id_departement INT NOT NULL, 
    id_pays_Naissance INT NOT NULL, 
    id_info_perso INT NOT NULL, 
    id_account INT NOT NULL,
    id_conseiller INT NOT NULL, -- ID 
    id_domiciliation INT NOT NULL, -- ID agence
    PRIMARY KEY (id_client)
);



-- Constraints Done
CREATE TABLE IF NOT EXISTS `employe` (
    `id_employe` int NOT NULL AUTO_INCREMENT,
    
    `nom` VARCHAR(20) NOT NULL,
    `prenom` VARCHAR(20) NOT NULL,
    `dateNaissance` TIMESTAMP NOT NULL,
    `adresse` VARCHAR(20) NOT NULL,
    `sexe` enum('M', 'F', ' '),
    `codePostale` varchar(6) NOT NULL,

    `matricule` varchar(20),

    `id_pays` INT NOT NULL, 
    `id_departement` INT NOT NULL, 
    `id_pays_Naissance` INT NOT NULL, 
    `id_info_perso` INT, 
    `id_account` INT NOT NULL, 
    `id_agence` INT,  
    PRIMARY KEY (`id_employe`)
);



-- Constraints Done
CREATE TABLE IF NOT EXISTS `Info_Personnelle` (
    id_info_perso INT NOT NULL AUTO_INCREMENT,

    profession VARCHAR(20),
    mt_Revenus_mensuels DOUBLE NOT NULL,
    mt_Revenus_conjoint DOUBLE,
    mt_apport_perso DOUBLE NOT NULL,
    mt_autre DOUBLE NOT NULL,
    situation enum('Marie', 'Celibataire' , 'Autres'),
    lastUpdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id_info_perso)
);







-- Constraints Done
CREATE TABLE IF NOT EXISTS `Agence` (
  `id_agence` int NOT NULL AUTO_INCREMENT,
  `description` varchar(2) NOT NULL,
  `dateDebutService` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `adresse` VARCHAR(40) NOT NULL,
  `codePostale` varchar(6) NOT NULL,

  `id_pays` int NOT NULL,
  `id_departement` int NOT NULL,
    UNIQUE KEY `code_unique` (`id_agence`)
);






-- Constraints Done
CREATE TABLE IF NOT EXISTS `Region` (
  `id_region`   INT   NOT NULL   auto_increment,
  `region`      varchar(50)   NOT NULL  ,
  PRIMARY KEY  (`id_region`)
);


-- Constraints Done
CREATE TABLE IF NOT EXISTS `Departement` (
  `id_departement`   varchar(3)   NOT NULL,
  `departement`      varchar(50)   NOT NULL ,
  `id_region`      INT   NOT NULL,
   PRIMARY KEY  (`id_departement`) 
);

-- Constraints Done
CREATE TABLE IF NOT EXISTS `Pays` (
  `id_pays` int NOT NULL AUTO_INCREMENT,
  `code` int(3) NOT NULL,
  `alpha2` varchar(2) NOT NULL,
  `alpha3` varchar(3) NOT NULL,
  `nom_en_gb` varchar(45) NOT NULL,
  `nom_fr_fr` varchar(45) NOT NULL,
  PRIMARY KEY (`id_pays`),
  UNIQUE KEY `alpha2` (`alpha2`),
  UNIQUE KEY `alpha3` (`alpha3`),
  UNIQUE KEY `code_unique` (`code`)
);



CREATE TABLE IF NOT EXISTS `Type_Pret` (
    `id_type_pret` int NOT NULL AUTO_INCREMENT,

    `libelle` varchar(40) NOT NULL,
    PRIMARY KEY (`id_type_pret`)
);


CREATE TABLE matriceTauxFixe 
(
	id_enregistrement integer PRIMARY KEY,
	ageMin integer NOT NULL,
	ageMax integer NOT NULL,
	typeContrat enum ( 'cdd', 'cdi', 'NON' ) NOT NULL,
	revenuMin double NOT NULL,
	revenuMax double NOT NULL,
	isClient boolean NOT NULL,
       taux float NOT NULL,
	idTypePret integer NOT NULL
);




CREATE TABLE IF NOT EXISTS `Taux_Directeur` (
    `id_tauxDirecteur` int NOT NULL AUTO_INCREMENT,
    `valeur` double NOT NULL,
    `dateInserted` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_tauxDirecteur`)
);


CREATE TABLE IF NOT EXISTS `calcPret` (
    `id_calcPret` int NOT NULL AUTO_INCREMENT,
    `coef_assurance` double NOT NULL, -- exemple 0.001 pour 1 euro 
    `t_marge` double NOT NULL, -- exempl 0.02
    `f_dossier` DOUBLE NOT NULL,
    `id_tauxDirecteur` INT not null,
    `dateInserted` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_calcPret`)
);






CREATE TABLE IF NOT EXISTS `Simul_Pret` (
    `id_sim_pret` int NOT NULL AUTO_INCREMENT,
    
    `dateSimulation` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `duree_pret` int NOT NULL,  -- en mois, par exemple 12 pour un ans
    `mt_pret` DOUBLE not null, -- montant de pret souhaite
    `typeTaux` enum('_variable_', '_fixe_', '_mixt_'),


    `date_contraction` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- `res_TEG` DOUBLE,
    `locked` BOOLEAN DEFAULT 1, -- 1 pour active, 0 pour lock (pas le droit de modify)

    `id_client` int not null,
    `id_type_pret` int not null,
    `id_calcPret` int NOT NULL,


    PRIMARY KEY (`id_sim_pret`)
);




CREATE TABLE IF NOT EXISTS `Dem_pret` (
    `id_dem_pret` int NOT NULL AUTO_INCREMENT,

    `date_dem` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `date_close` TIMESTAMP NOT NULL,
    `state` enum('En attente', 'Refusé', 'Validé') default 'En attente',

    `id_sim_pret` int NOT NULL,
    PRIMARY KEY (`id_dem_pret`)
);




CREATE TABLE IF NOT EXISTS `Pret` (
    `id_pret` int NOT NULL AUTO_INCREMENT,

    `dateDebut` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `duree` int NOT NULL, -- en mois
    `mt_pret` double NOT NULL,

    `typeTaux` enum('_variable_', '_fixe_', '_mixt_'),
    -- `res_TEG` DOUBLE,

    `id_type_pret` int not null,

    `id_calcPret` int NOT NULL,

    `id_client` int NOT NULL,
    PRIMARY KEY (`id_pret`)
);























-- 
-- Contenu de la table `region`
-- 
INSERT INTO `region` VALUES 
  (1, 'Alsace')
, (2, 'Aquitaine')
, (3, 'Auvergne')
, (4, 'Basse-Normandie')
, (5, 'Bourgogne')
, (6, 'Bretagne')
, (7, 'Centre')
, (8, 'Champagne')
, (9, 'Corse')
, (10, 'Franche-Comté')
, (11, 'Haute-Normandie')
, (12, 'Île-de-France')
, (13, 'Languedoc-Roussillon')
, (14, 'Limousin')
, (15, 'Lorraine')
, (16, 'Midi-Pyrénées')
, (17, 'Nord-pas-de-Calais')
, (18, 'Pays de la Loire')
, (19, 'Picardie')
, (20, 'Poitou-Charentes')
, (21, 'Provence-Alpes-Côte-d\'Azur')
, (22, 'Rhône-Alpes')
, (23, 'Etranger');


-- 
-- Contenu de la table `departement`
-- 

INSERT INTO `departement` VALUES ('01', 'Ain', 22)
, ('02', 'Aisne', 19)
, ('03', 'Allier', 3)
, ('04', 'Alpes-de-Haute-Provence', 21)
, ('05', 'Hautes-Alpes', 21)
, ('06', 'Alpes-Maritimes', 21)
, ('07', 'Ardèche', 22)
, ('08', 'Ardennes', 8)
, ('09', 'Ariège', 16)
, ('10', 'Aube', 8)
, ('11', 'Aude', 13)
, ('12', 'Aveyron', 16)
, ('13', 'Bouches-du-Rhône', 21)
, ('14', 'Calvados', 4)
, ('15', 'Cantal', 3)
, ('16', 'Charente', 20)
, ('17', 'Charente-Maritime', 20)
, ('18', 'Cher', 7)
, ('19', 'Corrèze', 14)
, ('2A', 'Corse-du-Sud', 9)
, ('2B', 'Haute-Corse', 9)
, ('21', 'Côte-d\'Or', 5)
, ('22', 'Côtes-d\'Armor', 6)
, ('23', 'Creuse', 14)
, ('24', 'Dordogne', 2)
, ('25', 'Doubs', 10)
, ('26', 'Drôme', 22)
, ('27', 'Eure', 11)
, ('28', 'Eure-et-Loir', 7)
, ('29', 'Finistère', 6)
, ('30', 'Gard', 13)
, ('31', 'Haute-Garonne', 16)
, ('32', 'Gers', 16)
, ('33', 'Gironde', 2)
, ('34', 'Hérault', 13)
, ('35', 'Ille-et-Vilaine', 6)
, ('36', 'Indre', 7)
, ('37', 'Indre-et-Loire', 7)
, ('38', 'Isère', 22)
, ('39', 'Jura', 10)
, ('40', 'Landes', 2)
, ('41', 'Loir-et-Cher', 7)
, ('42', 'Loire', 22)
, ('43', 'Haute-Loire', 3)
, ('44', 'Loire-Atlantique', 18)
, ('45', 'Loiret', 7)
, ('46', 'Lot', 16)
, ('47', 'Lot-et-Garonne', 2)
, ('48', 'Lozère', 13)
, ('49', 'Maine-et-Loire', 18)
, ('50', 'Manche', 4)
, ('51', 'Marne', 8)
, ('52', 'Haute-Marne', 8)
, ('53', 'Mayenne', 18)
, ('54', 'Meurthe-et-Moselle', 15)
, ('55', 'Meuse', 15)
, ('56', 'Morbihan', 6)
, ('57', 'Moselle', 15)
, ('58', 'Nièvre', 5)
, ('59', 'Nord', 17)
, ('60', 'Oise', 19)
, ('61', 'Orne', 4)
, ('62', 'Pas-de-Calais', 17)
, ('63', 'Puy-de-Dôme', 3)
, ('64', 'Pyrénées-Atlantiques', 2)
, ('65', 'Hautes-Pyrénées', 16)
, ('66', 'Pyrénées-Orientales', 13)
, ('67', 'Bas-Rhin', 1)
, ('68', 'Haut-Rhin', 1)
, ('69', 'Rhône', 22)
, ('70', 'Haute-Saône', 10)
, ('71', 'Saône-et-Loire', 5)
, ('72', 'Sarthe', 18)
, ('73', 'Savoie', 22)
, ('74', 'Haute-Savoie', 22)
, ('75', 'Paris', 12)
, ('76', 'Seine-Maritime', 11)
, ('77', 'Seine-et-Marne', 12)
, ('78', 'Yvelines', 12)
, ('79', 'Deux-Sèvres', 20)
, ('80', 'Somme', 19)
, ('81', 'Tarn', 16)
, ('82', 'Tarn-et-Garonne', 16)
, ('83', 'Var', 21)
, ('84', 'Vaucluse', 21)
, ('85', 'Vendée', 18)
, ('86', 'Vienne', 20)
, ('87', 'Haute-Vienne', 14)
, ('88', 'Vosges', 15)
, ('89', 'Yonne', 5)
, ('90', 'Territoire de Belfort', 10)
, ('91', 'Essonne', 12)
, ('92', 'Hauts-de-Seine', 12)
, ('93', 'Seine-Saint-Denis', 12)
, ('94', 'Val-de-Marne', 12)
, ('95', 'Val-d\'Oise', 12)
, ('96', 'Etranger', 23);




INSERT INTO `pays` (`id_pays`, `code`, `alpha2`, `alpha3`, `nom_en_gb`, `nom_fr_fr`) VALUES
(1, 4, 'AF', 'AFG', 'Afghanistan', 'Afghanistan'),
(2, 8, 'AL', 'ALB', 'Albania', 'Albanie'),
(3, 10, 'AQ', 'ATA', 'Antarctica', 'Antarctique'),
(4, 12, 'DZ', 'DZA', 'Algeria', 'Algérie'),
(5, 16, 'AS', 'ASM', 'American Samoa', 'Samoa Américaines'),
(6, 20, 'AD', 'AND', 'Andorra', 'Andorre'),
(7, 24, 'AO', 'AGO', 'Angola', 'Angola'),
(8, 28, 'AG', 'ATG', 'Antigua and Barbuda', 'Antigua-et-Barbuda'),
(9, 31, 'AZ', 'AZE', 'Azerbaijan', 'Azerbaïdjan'),
(10, 32, 'AR', 'ARG', 'Argentina', 'Argentine'),
(11, 36, 'AU', 'AUS', 'Australia', 'Australie'),
(12, 40, 'AT', 'AUT', 'Austria', 'Autriche'),
(13, 44, 'BS', 'BHS', 'Bahamas', 'Bahamas'),
(14, 48, 'BH', 'BHR', 'Bahrain', 'Bahreïn'),
(15, 50, 'BD', 'BGD', 'Bangladesh', 'Bangladesh'),
(16, 51, 'AM', 'ARM', 'Armenia', 'Arménie'),
(17, 52, 'BB', 'BRB', 'Barbados', 'Barbade'),
(18, 56, 'BE', 'BEL', 'Belgium', 'Belgique'),
(19, 60, 'BM', 'BMU', 'Bermuda', 'Bermudes'),
(20, 64, 'BT', 'BTN', 'Bhutan', 'Bhoutan'),
(21, 68, 'BO', 'BOL', 'Bolivia', 'Bolivie'),
(22, 70, 'BA', 'BIH', 'Bosnia and Herzegovina', 'Bosnie-Herzégovine'),
(23, 72, 'BW', 'BWA', 'Botswana', 'Botswana'),
(24, 74, 'BV', 'BVT', 'Bouvet Island', 'Île Bouvet'),
(25, 76, 'BR', 'BRA', 'Brazil', 'Brésil'),
(26, 84, 'BZ', 'BLZ', 'Belize', 'Belize'),
(27, 86, 'IO', 'IOT', 'British Indian Ocean Territory', 'Territoire Britannique de l''Océan Indien'),
(28, 90, 'SB', 'SLB', 'Solomon Islands', 'Îles Salomon'),
(29, 92, 'VG', 'VGB', 'British Virgin Islands', 'Îles Vierges Britanniques'),
(30, 96, 'BN', 'BRN', 'Brunei Darussalam', 'Brunéi Darussalam'),
(31, 100, 'BG', 'BGR', 'Bulgaria', 'Bulgarie'),
(32, 104, 'MM', 'MMR', 'Myanmar', 'Myanmar'),
(33, 108, 'BI', 'BDI', 'Burundi', 'Burundi'),
(34, 112, 'BY', 'BLR', 'Belarus', 'Bélarus'),
(35, 116, 'KH', 'KHM', 'Cambodia', 'Cambodge'),
(36, 120, 'CM', 'CMR', 'Cameroon', 'Cameroun'),
(37, 124, 'CA', 'CAN', 'Canada', 'Canada'),
(38, 132, 'CV', 'CPV', 'Cape Verde', 'Cap-vert'),
(39, 136, 'KY', 'CYM', 'Cayman Islands', 'Îles Caïmanes'),
(40, 140, 'CF', 'CAF', 'Central African', 'République Centrafricaine'),
(41, 144, 'LK', 'LKA', 'Sri Lanka', 'Sri Lanka'),
(42, 148, 'TD', 'TCD', 'Chad', 'Tchad'),
(43, 152, 'CL', 'CHL', 'Chile', 'Chili'),
(44, 156, 'CN', 'CHN', 'China', 'Chine'),
(45, 158, 'TW', 'TWN', 'Taiwan', 'Taïwan'),
(46, 162, 'CX', 'CXR', 'Christmas Island', 'Île Christmas'),
(47, 166, 'CC', 'CCK', 'Cocos (Keeling) Islands', 'Îles Cocos (Keeling)'),
(48, 170, 'CO', 'COL', 'Colombia', 'Colombie'),
(49, 174, 'KM', 'COM', 'Comoros', 'Comores'),
(50, 175, 'YT', 'MYT', 'Mayotte', 'Mayotte'),
(51, 178, 'CG', 'COG', 'Republic of the Congo', 'République du Congo'),
(52, 180, 'CD', 'COD', 'The Democratic Republic Of The Congo', 'République Démocratique du Congo'),
(53, 184, 'CK', 'COK', 'Cook Islands', 'Îles Cook'),
(54, 188, 'CR', 'CRI', 'Costa Rica', 'Costa Rica'),
(55, 191, 'HR', 'HRV', 'Croatia', 'Croatie'),
(56, 192, 'CU', 'CUB', 'Cuba', 'Cuba'),
(57, 196, 'CY', 'CYP', 'Cyprus', 'Chypre'),
(58, 203, 'CZ', 'CZE', 'Czech Republic', 'République Tchèque'),
(59, 204, 'BJ', 'BEN', 'Benin', 'Bénin'),
(60, 208, 'DK', 'DNK', 'Denmark', 'Danemark'),
(61, 212, 'DM', 'DMA', 'Dominica', 'Dominique'),
(62, 214, 'DO', 'DOM', 'Dominican Republic', 'République Dominicaine'),
(63, 218, 'EC', 'ECU', 'Ecuador', 'Équateur'),
(64, 222, 'SV', 'SLV', 'El Salvador', 'El Salvador'),
(65, 226, 'GQ', 'GNQ', 'Equatorial Guinea', 'Guinée Équatoriale'),
(66, 231, 'ET', 'ETH', 'Ethiopia', 'Éthiopie'),
(67, 232, 'ER', 'ERI', 'Eritrea', 'Érythrée'),
(68, 233, 'EE', 'EST', 'Estonia', 'Estonie'),
(69, 234, 'FO', 'FRO', 'Faroe Islands', 'Îles Féroé'),
(70, 238, 'FK', 'FLK', 'Falkland Islands', 'Îles (malvinas) Falkland'),
(71, 239, 'GS', 'SGS', 'South Georgia and the South Sandwich Islands', 'Géorgie du Sud et les Îles Sandwich du Sud'),
(72, 242, 'FJ', 'FJI', 'Fiji', 'Fidji'),
(73, 246, 'FI', 'FIN', 'Finland', 'Finlande'),
(74, 248, 'AX', 'ALA', 'Åland Islands', 'Îles Åland'),
(75, 250, 'FR', 'FRA', 'France', 'France'),
(76, 254, 'GF', 'GUF', 'French Guiana', 'Guyane Française'),
(77, 258, 'PF', 'PYF', 'French Polynesia', 'Polynésie Française'),
(78, 260, 'TF', 'ATF', 'French Southern Territories', 'Terres Australes Françaises'),
(79, 262, 'DJ', 'DJI', 'Djibouti', 'Djibouti'),
(80, 266, 'GA', 'GAB', 'Gabon', 'Gabon'),
(81, 268, 'GE', 'GEO', 'Georgia', 'Géorgie'),
(82, 270, 'GM', 'GMB', 'Gambia', 'Gambie'),
(83, 275, 'PS', 'PSE', 'Occupied Palestinian Territory', 'Territoire Palestinien Occupé'),
(84, 276, 'DE', 'DEU', 'Germany', 'Allemagne'),
(85, 288, 'GH', 'GHA', 'Ghana', 'Ghana'),
(86, 292, 'GI', 'GIB', 'Gibraltar', 'Gibraltar'),
(87, 296, 'KI', 'KIR', 'Kiribati', 'Kiribati'),
(88, 300, 'GR', 'GRC', 'Greece', 'Grèce'),
(89, 304, 'GL', 'GRL', 'Greenland', 'Groenland'),
(90, 308, 'GD', 'GRD', 'Grenada', 'Grenade'),
(91, 312, 'GP', 'GLP', 'Guadeloupe', 'Guadeloupe'),
(92, 316, 'GU', 'GUM', 'Guam', 'Guam'),
(93, 320, 'GT', 'GTM', 'Guatemala', 'Guatemala'),
(94, 324, 'GN', 'GIN', 'Guinea', 'Guinée'),
(95, 328, 'GY', 'GUY', 'Guyana', 'Guyana'),
(96, 332, 'HT', 'HTI', 'Haiti', 'Haïti'),
(97, 334, 'HM', 'HMD', 'Heard Island and McDonald Islands', 'Îles Heard et Mcdonald'),
(98, 336, 'VA', 'VAT', 'Vatican City State', 'Saint-Siège (état de la Cité du Vatican)'),
(99, 340, 'HN', 'HND', 'Honduras', 'Honduras'),
(100, 344, 'HK', 'HKG', 'Hong Kong', 'Hong-Kong'),
(101, 348, 'HU', 'HUN', 'Hungary', 'Hongrie'),
(102, 352, 'IS', 'ISL', 'Iceland', 'Islande'),
(103, 356, 'IN', 'IND', 'India', 'Inde'),
(104, 360, 'ID', 'IDN', 'Indonesia', 'Indonésie'),
(105, 364, 'IR', 'IRN', 'Islamic Republic of Iran', 'République Islamique d''Iran'),
(106, 368, 'IQ', 'IRQ', 'Iraq', 'Iraq'),
(107, 372, 'IE', 'IRL', 'Ireland', 'Irlande'),
(108, 376, 'IL', 'ISR', 'Israel', 'Israël'),
(109, 380, 'IT', 'ITA', 'Italy', 'Italie'),
(110, 384, 'CI', 'CIV', 'Côte d''Ivoire', 'Côte d''Ivoire'),
(111, 388, 'JM', 'JAM', 'Jamaica', 'Jamaïque'),
(112, 392, 'JP', 'JPN', 'Japan', 'Japon'),
(113, 398, 'KZ', 'KAZ', 'Kazakhstan', 'Kazakhstan'),
(114, 400, 'JO', 'JOR', 'Jordan', 'Jordanie'),
(115, 404, 'KE', 'KEN', 'Kenya', 'Kenya'),
(116, 408, 'KP', 'PRK', 'Democratic People''s Republic of Korea', 'République Populaire Démocratique de Corée'),
(117, 410, 'KR', 'KOR', 'Republic of Korea', 'République de Corée'),
(118, 414, 'KW', 'KWT', 'Kuwait', 'Koweït'),
(119, 417, 'KG', 'KGZ', 'Kyrgyzstan', 'Kirghizistan'),
(120, 418, 'LA', 'LAO', 'Lao People''s Democratic Republic', 'République Démocratique Populaire Lao'),
(121, 422, 'LB', 'LBN', 'Lebanon', 'Liban'),
(122, 426, 'LS', 'LSO', 'Lesotho', 'Lesotho'),
(123, 428, 'LV', 'LVA', 'Latvia', 'Lettonie'),
(124, 430, 'LR', 'LBR', 'Liberia', 'Libéria'),
(125, 434, 'LY', 'LBY', 'Libyan Arab Jamahiriya', 'Jamahiriya Arabe Libyenne'),
(126, 438, 'LI', 'LIE', 'Liechtenstein', 'Liechtenstein'),
(127, 440, 'LT', 'LTU', 'Lithuania', 'Lituanie'),
(128, 442, 'LU', 'LUX', 'Luxembourg', 'Luxembourg'),
(129, 446, 'MO', 'MAC', 'Macao', 'Macao'),
(130, 450, 'MG', 'MDG', 'Madagascar', 'Madagascar'),
(131, 454, 'MW', 'MWI', 'Malawi', 'Malawi'),
(132, 458, 'MY', 'MYS', 'Malaysia', 'Malaisie'),
(133, 462, 'MV', 'MDV', 'Maldives', 'Maldives'),
(134, 466, 'ML', 'MLI', 'Mali', 'Mali'),
(135, 470, 'MT', 'MLT', 'Malta', 'Malte'),
(136, 474, 'MQ', 'MTQ', 'Martinique', 'Martinique'),
(137, 478, 'MR', 'MRT', 'Mauritania', 'Mauritanie'),
(138, 480, 'MU', 'MUS', 'Mauritius', 'Maurice'),
(139, 484, 'MX', 'MEX', 'Mexico', 'Mexique'),
(140, 492, 'MC', 'MCO', 'Monaco', 'Monaco'),
(141, 496, 'MN', 'MNG', 'Mongolia', 'Mongolie'),
(142, 498, 'MD', 'MDA', 'Republic of Moldova', 'République de Moldova'),
(143, 500, 'MS', 'MSR', 'Montserrat', 'Montserrat'),
(144, 504, 'MA', 'MAR', 'Morocco', 'Maroc'),
(145, 508, 'MZ', 'MOZ', 'Mozambique', 'Mozambique'),
(146, 512, 'OM', 'OMN', 'Oman', 'Oman'),
(147, 516, 'NA', 'NAM', 'Namibia', 'Namibie'),
(148, 520, 'NR', 'NRU', 'Nauru', 'Nauru'),
(149, 524, 'NP', 'NPL', 'Nepal', 'Népal'),
(150, 528, 'NL', 'NLD', 'Netherlands', 'Pays-Bas'),
(151, 530, 'AN', 'ANT', 'Netherlands Antilles', 'Antilles Néerlandaises'),
(152, 533, 'AW', 'ABW', 'Aruba', 'Aruba'),
(153, 540, 'NC', 'NCL', 'New Caledonia', 'Nouvelle-Calédonie'),
(154, 548, 'VU', 'VUT', 'Vanuatu', 'Vanuatu'),
(155, 554, 'NZ', 'NZL', 'New Zealand', 'Nouvelle-Zélande'),
(156, 558, 'NI', 'NIC', 'Nicaragua', 'Nicaragua'),
(157, 562, 'NE', 'NER', 'Niger', 'Niger'),
(158, 566, 'NG', 'NGA', 'Nigeria', 'Nigéria'),
(159, 570, 'NU', 'NIU', 'Niue', 'Niué'),
(160, 574, 'NF', 'NFK', 'Norfolk Island', 'Île Norfolk'),
(161, 578, 'NO', 'NOR', 'Norway', 'Norvège'),
(162, 580, 'MP', 'MNP', 'Northern Mariana Islands', 'Îles Mariannes du Nord'),
(163, 581, 'UM', 'UMI', 'United States Minor Outlying Islands', 'Îles Mineures Éloignées des États-Unis'),
(164, 583, 'FM', 'FSM', 'Federated States of Micronesia', 'États Fédérés de Micronésie'),
(165, 584, 'MH', 'MHL', 'Marshall Islands', 'Îles Marshall'),
(166, 585, 'PW', 'PLW', 'Palau', 'Palaos'),
(167, 586, 'PK', 'PAK', 'Pakistan', 'Pakistan'),
(168, 591, 'PA', 'PAN', 'Panama', 'Panama'),
(169, 598, 'PG', 'PNG', 'Papua New Guinea', 'Papouasie-Nouvelle-Guinée'),
(170, 600, 'PY', 'PRY', 'Paraguay', 'Paraguay'),
(171, 604, 'PE', 'PER', 'Peru', 'Pérou'),
(172, 608, 'PH', 'PHL', 'Philippines', 'Philippines'),
(173, 612, 'PN', 'PCN', 'Pitcairn', 'Pitcairn'),
(174, 616, 'PL', 'POL', 'Poland', 'Pologne'),
(175, 620, 'PT', 'PRT', 'Portugal', 'Portugal'),
(176, 624, 'GW', 'GNB', 'Guinea-Bissau', 'Guinée-Bissau'),
(177, 626, 'TL', 'TLS', 'Timor-Leste', 'Timor-Leste'),
(178, 630, 'PR', 'PRI', 'Puerto Rico', 'Porto Rico'),
(179, 634, 'QA', 'QAT', 'Qatar', 'Qatar'),
(180, 638, 'RE', 'REU', 'Réunion', 'Réunion'),
(181, 642, 'RO', 'ROU', 'Romania', 'Roumanie'),
(182, 643, 'RU', 'RUS', 'Russian Federation', 'Fédération de Russie'),
(183, 646, 'RW', 'RWA', 'Rwanda', 'Rwanda'),
(184, 654, 'SH', 'SHN', 'Saint Helena', 'Sainte-Hélène'),
(185, 659, 'KN', 'KNA', 'Saint Kitts and Nevis', 'Saint-Kitts-et-Nevis'),
(186, 660, 'AI', 'AIA', 'Anguilla', 'Anguilla'),
(187, 662, 'LC', 'LCA', 'Saint Lucia', 'Sainte-Lucie'),
(188, 666, 'PM', 'SPM', 'Saint-Pierre and Miquelon', 'Saint-Pierre-et-Miquelon'),
(189, 670, 'VC', 'VCT', 'Saint Vincent and the Grenadines', 'Saint-Vincent-et-les Grenadines'),
(190, 674, 'SM', 'SMR', 'San Marino', 'Saint-Marin'),
(191, 678, 'ST', 'STP', 'Sao Tome and Principe', 'Sao Tomé-et-Principe'),
(192, 682, 'SA', 'SAU', 'Saudi Arabia', 'Arabie Saoudite'),
(193, 686, 'SN', 'SEN', 'Senegal', 'Sénégal'),
(194, 690, 'SC', 'SYC', 'Seychelles', 'Seychelles'),
(195, 694, 'SL', 'SLE', 'Sierra Leone', 'Sierra Leone'),
(196, 702, 'SG', 'SGP', 'Singapore', 'Singapour'),
(197, 703, 'SK', 'SVK', 'Slovakia', 'Slovaquie'),
(198, 704, 'VN', 'VNM', 'Vietnam', 'Viet Nam'),
(199, 705, 'SI', 'SVN', 'Slovenia', 'Slovénie'),
(200, 706, 'SO', 'SOM', 'Somalia', 'Somalie'),
(201, 710, 'ZA', 'ZAF', 'South Africa', 'Afrique du Sud'),
(202, 716, 'ZW', 'ZWE', 'Zimbabwe', 'Zimbabwe'),
(203, 724, 'ES', 'ESP', 'Spain', 'Espagne'),
(204, 732, 'EH', 'ESH', 'Western Sahara', 'Sahara Occidental'),
(205, 736, 'SD', 'SDN', 'Sudan', 'Soudan'),
(206, 740, 'SR', 'SUR', 'Suriname', 'Suriname'),
(207, 744, 'SJ', 'SJM', 'Svalbard and Jan Mayen', 'Svalbard etÎle Jan Mayen'),
(208, 748, 'SZ', 'SWZ', 'Swaziland', 'Swaziland'),
(209, 752, 'SE', 'SWE', 'Sweden', 'Suède'),
(210, 756, 'CH', 'CHE', 'Switzerland', 'Suisse'),
(211, 760, 'SY', 'SYR', 'Syrian Arab Republic', 'République Arabe Syrienne'),
(212, 762, 'TJ', 'TJK', 'Tajikistan', 'Tadjikistan'),
(213, 764, 'TH', 'THA', 'Thailand', 'Thaïlande'),
(214, 768, 'TG', 'TGO', 'Togo', 'Togo'),
(215, 772, 'TK', 'TKL', 'Tokelau', 'Tokelau'),
(216, 776, 'TO', 'TON', 'Tonga', 'Tonga'),
(217, 780, 'TT', 'TTO', 'Trinidad and Tobago', 'Trinité-et-Tobago'),
(218, 784, 'AE', 'ARE', 'United Arab Emirates', 'Émirats Arabes Unis'),
(219, 788, 'TN', 'TUN', 'Tunisia', 'Tunisie'),
(220, 792, 'TR', 'TUR', 'Turkey', 'Turquie'),
(221, 795, 'TM', 'TKM', 'Turkmenistan', 'Turkménistan'),
(222, 796, 'TC', 'TCA', 'Turks and Caicos Islands', 'Îles Turks et Caïques'),
(223, 798, 'TV', 'TUV', 'Tuvalu', 'Tuvalu'),
(224, 800, 'UG', 'UGA', 'Uganda', 'Ouganda'),
(225, 804, 'UA', 'UKR', 'Ukraine', 'Ukraine'),
(226, 807, 'MK', 'MKD', 'The Former Yugoslav Republic of Macedonia', 'L''ex-République Yougoslave de Macédoine'),
(227, 818, 'EG', 'EGY', 'Egypt', 'Égypte'),
(228, 826, 'GB', 'GBR', 'United Kingdom', 'Royaume-Uni'),
(229, 833, 'IM', 'IMN', 'Isle of Man', 'Île de Man'),
(230, 834, 'TZ', 'TZA', 'United Republic Of Tanzania', 'République-Unie de Tanzanie'),
(231, 840, 'US', 'USA', 'United States', 'États-Unis'),
(232, 850, 'VI', 'VIR', 'U.S. Virgin Islands', 'Îles Vierges des États-Unis'),
(233, 854, 'BF', 'BFA', 'Burkina Faso', 'Burkina Faso'),
(234, 858, 'UY', 'URY', 'Uruguay', 'Uruguay'),
(235, 860, 'UZ', 'UZB', 'Uzbekistan', 'Ouzbékistan'),
(236, 862, 'VE', 'VEN', 'Venezuela', 'Venezuela'),
(237, 876, 'WF', 'WLF', 'Wallis and Futuna', 'Wallis et Futuna'),
(238, 882, 'WS', 'WSM', 'Samoa', 'Samoa'),
(239, 887, 'YE', 'YEM', 'Yemen', 'Yémen'),
(240, 891, 'CS', 'SCG', 'Serbia and Montenegro', 'Serbie-et-Monténégro'),
(241, 894, 'ZM', 'ZMB', 'Zambia', 'Zambie');



INSERT INTO matriceTauxFixe  (id_enregistrement, ageMin, ageMax, typeContrat, revenuMin, revenuMax, isClient, idTypePret, taux) 
VALUES ('1', '18', '26', 'NON', '0', '2000', false, '0', '11.34'),
       ('2', '18', '26', 'NON', '0', '2000', false, '1', '10.47'),
       ('3', '81', '999', 'NON', '0', '2000', false, '0', '14.85'),
       ('4', '27', '60', 'NON', '0', '2000', false, '0', '9.76'),
       ('5', '27', '60', 'NON', '0', '2000', false, '1', '9.79'),
       ('6', '81', '999', 'NON', '0', '2000', false, '1', '14.9'),
       ('7', '61', '80', 'NON', '0', '2000', false, '0', '9.47'),
       ('8', '61', '80', 'NON', '0', '2000', false, '1', '9.52'),    
       ('10', '18', '26', 'cdd', '0', '2000', false, '0', '6.8'),
       ('11', '18', '26', 'cdd', '0', '2000', false, '1', '6.61'),
       ('12', '81', '999', 'cdd', '0', '2000', false, '0', '9.95'),
       ('13', '27', '60', 'cdd', '0', '2000', false, '0', '7.5'),
       ('14', '27', '60', 'cdd', '0', '2000', false, '1', '7.55'),
       ('15', '81', '999', 'cdd', '0', '2000', false, '1', '13.6'),
       ('16', '61', '80', 'cdd', '0', '2000', false, '0', '8'),
       ('17', '61', '80', 'cdd', '0', '2000', false, '1', '8.4'),
       ('19', '18', '26', 'cdi', '0', '2000', false, '0', '7.4'),
       ('20', '18', '26', 'cdi', '0', '2000', false, '1', '7.91'),
       ('21', '81', '999', 'cdi', '0', '2000', false, '0', '13.06'),
       ('22', '27', '60', 'cdi', '0', '2000', false, '0', '7.75'),
       ('23', '27', '60', 'cdi', '0', '2000', false, '1', '7.99'),
       ('24', '81', '999', 'cdi', '0', '2000', false, '1', '13.19'),
       ('25', '61', '80', 'cdi', '0', '2000', false, '0', '8.44'),
       ('26', '61', '80', 'cdi', '0', '2000', false, '1', '6.73'),
       ('28', '18', '26', 'NON', '0', '2000', true, '0', '5.54'),
       ('29', '18', '26', 'NON', '0', '2000', true, '1', '5.74'),
       ('30', '81', '999', 'NON', '0', '2000', true, '0', '9.88'),
       ('31', '27', '60', 'NON', '0', '2000', true, '0', '4.64'),
       ('32', '27', '60', 'NON', '0', '2000', true, '1', '4.84'),
       ('33', '81', '999', 'NON', '0', '2000', true, '1', '9.99'),
       ('34', '61', '80', 'NON', '0', '2000', true, '0', '5.75'),
       ('35', '61', '80', 'NON', '0', '2000', true, '1', '5.84'),
       ('37', '18', '26', 'cdd', '0', '2000', true, '0', '5.04'),
       ('38', '18', '26', 'cdd', '0', '2000', true, '1', '5.14'),
       ('39', '81', '999', 'cdd', '0', '2000', true, '0', '9.91'),
       ('40', '27', '60', 'cdd', '0', '2000', true, '0', '5.34'),
       ('41', '27', '60', 'cdd', '0', '2000', true, '1', '5.54'),
       ('42', '81', '999', 'cdd', '0', '2000', true, '1', '10.04'),
       ('43', '61', '80', 'cdd', '0', '2000', true, '0', '5.34'),
       ('44', '61', '80', 'cdd', '0', '2000', true, '1', '5.53'),
       ('46', '18', '26', 'cdi', '0', '2000', true, '0', '5.23'),
       ('47', '18', '26', 'cdi', '0', '2000', true, '1', '5.24'),
       ('48', '81', '999', 'cdi', '0', '2000', true, '0', '10.4'),
       ('49', '27', '60', 'cdi', '0', '2000', true, '0', '6.04'),
       ('50', '27', '60', 'cdi', '0', '2000', true, '1', '5.94'),
       ('51', '81', '999', 'cdi', '0', '2000', true, '1', '10.45'),
       ('52', '61', '80', 'cdi', '0', '2000', true, '0', '5.334'),
       ('53', '61', '80', 'cdi', '0', '2000', true, '1', '5.43'),

       ('55', '18', '26', 'NON', '2000', '999999', false, '0', '6.94'),
       ('56', '18', '26', 'NON', '2000', '999999', false, '1', '7.02'),
       ('57', '81', '999', 'NON', '2000', '999999', false, '0', '13.33'),
       ('58', '27', '60', 'NON', '2000', '999999', false, '0', '7.04'),
       ('59', '27', '60', 'NON', '2000', '999999', false, '1', '7.24'),
       ('60', '81', '999', 'NON', '2000', '999999', false, '1', '14.39'),
       ('61', '61', '80', 'NON', '2000', '999999', false, '0', '7.14'),
       ('62', '61', '80', 'NON', '2000', '999999', false, '1', '7.45'),
       
       ('64', '18', '26', 'cdd', '2000', '999999', false, '0', '7.4'),
       ('65', '18', '26', 'cdd', '2000', '999999', false, '1', '7.74'),
       ('66', '81', '999', 'cdd', '2000', '999999', false, '0', '13.91'),
       ('67', '27', '60', 'cdd', '2000', '999999', false, '0', '7.77'),
       ('68', '27', '60', 'cdd', '2000', '999999', false, '1', '7.81'),
       ('69', '81', '999', 'cdd', '2000', '999999', false, '1', '14.94'),
       ('70', '61', '80', 'cdd', '2000', '999999', false, '0', '7.30'),
       ('71', '61', '80', 'cdd', '2000', '999999', false, '1', '7.64'),
  
       ('73', '18', '26', 'cdi', '2000', '999999', false, '0', '7.40'),
       ('74', '18', '26', 'cdi', '2000', '999999', false, '1', '7.54'),
       ('75', '81', '999', 'cdi', '2000', '999999', false, '0', '13.71'),
       ('76', '27', '60', 'cdi', '2000', '999999', false, '0', '7.5'),
       ('77', '27', '60', 'cdi', '2000', '999999', false, '1', '7.64'),
       ('78', '81', '999', 'cdi', '2000', '999999', false, '1', '14.94'),
       ('79', '61', '80', 'cdi', '2000', '999999', false, '0', '7.42'),
       ('80', '61', '80', 'cdi', '2000', '999999', false, '1', '7.54'),
 
       ('82', '18', '26', 'NON', '2000', '999999', true, '0', '5.04'),
       ('83', '18', '26', 'NON', '2000', '999999', true, '1', '5.14'),
       ('84', '81', '999', 'NON', '2000', '999999', true, '0', '12.4'),
       ('85', '27', '60', 'NON', '2000', '999999', true, '0', '5.31'),
       ('86', '27', '60', 'NON', '2000', '999999', true, '1', '5.41'),
       ('87', '81', '999', 'NON', '2000', '999999', true, '1', '12.54'),
       ('88', '61', '80', 'NON', '2000', '999999', true, '0', '5.48'),
       ('89', '61', '80', 'NON', '2000', '999999', true, '1', '5.50'),

       ('91', '18', '26', 'cdd', '2000', '999999', true, '0', '5.15'),
       ('92', '18', '26', 'cdd', '2000', '999999', true, '1', '5.24'),
       ('93', '81', '999', 'cdd', '2000', '999999', true, '0', '12.56'),
       ('94', '27', '60', 'cdd', '2000', '999999', true, '0', '5.64'),
       ('95', '27', '60', 'cdd', '2000', '999999', true, '1', '5.4'),
       ('96', '81', '999', 'cdd', '2000', '999999', true, '1', '12.88'),
       ('97', '61', '80', 'cdd', '2000', '999999', true, '0', '5.23'),
       ('98', '61', '80', 'cdd', '2000', '999999', true, '1', '5.38'),

       ('100', '18', '26', 'cdi', '2000', '999999', true, '0', '5.51'),
       ('101', '18', '26', 'cdi', '2000', '999999', true, '1', '5.53'),
       ('102', '81', '999', 'cdi', '2000', '999999', true, '0', '12.6'),
       ('103', '27', '60', 'cdi', '2000', '999999', true, '0', '5.34'),
       ('104', '27', '60', 'cdi', '2000', '999999', true, '1', '5.42'),
       ('105', '81', '999', 'cdi', '2000', '999999', true, '1', '12.56'),
       ('106', '61', '80', 'cdi', '2000', '999999', true, '0', '5.5'),
       ('107', '61', '80', 'cdi', '2000', '999999', true, '1', '5.65');



INSERT INTO `Type_Pret` (`libelle`) 
VALUES 
('_Credit_IMMO_'), 
('_CREDIT_CONSO_');

INSERT INTO `Taux_Directeur`(`valeur`) 
VALUES 
('2.01'),
('1.98'),
('2.12');



INSERT INTO `Agence`( `description`, `adresse`, `codePostale`, `id_pays`, `id_departement`) 
VALUES 
('Agence Créteil !! ', '9, Rue des méches', '94000', '75', '94'),
('Agence de Boulogne Billancourt ', '10, rue des éclaires', '92100', '75', '92');





-- Creation d'un nouveau Client
    INSERT INTO `Account`( `ndc`, `psw`, `questionSecrete`, `reponseSecrete`, `role`) 
    VALUES
    ('Zouhair', '12345', 'je m\'appelle comment ? Zouhair', 'Zouhair', 'user');

    INSERT INTO `Info_Personnelle`(`profession`, `mt_Revenus_mensuels`, `mt_Revenus_conjoint`, `mt_apport_perso`, `mt_autre`, `situation`) 
    VALUES 
    ('Ing Info ', '4000', '3200', '10000', '1000', 'Marie');

   INSERT INTO `Client`(`nom`, `prenom`, `dateNaissance`, `adresse`, `sexe`, `codePostale`, `id_pays`, `id_departement`, `id_pays_Naissance`, `id_info_perso`, `id_account`, `id_conseiller`, `id_domiciliation`) 
   SELECT 'Zouhair', 'HAJJI', '1994-10-09', '56 rue Gallieni', 'M', '92100', '75', '92', '75', MAX(id_info_perso), MAX(id_account), 1, 1 FROM Account, Info_Personnelle;



     # Simulation Pret id 2 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('0.9', '3.4', '1.02', '2' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '12', '11000', '_fixe_', '2018-01-01', max(id_client), '2', max(id_calcPret)  from    calcPret, Client;



  # Simulation Pret id 1 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('1.1', '3.5', '0.21', '1' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '36', '11000', '_fixe_', '2017-01-04', max(id_client), '1', max(id_calcPret)  from    calcPret, Client;




  
  
  # Simulation Pret id 2 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('1.7', '3.6', '0.05', '3' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '24', '11000', '_fixe_', '2017-05-21', max(id_client), '2', max(id_calcPret)  from    calcPret, Client;
















--  Client id 2
    INSERT INTO `Account`( `ndc`, `psw`, `questionSecrete`, `reponseSecrete`, `role`) 
    VALUES
    ('Zouhair3', '12345', 'je m\'appelle comment ? Zouhair', 'Zouhair', 'user');

    INSERT INTO `Info_Personnelle`(`profession`, `mt_Revenus_mensuels`, `mt_Revenus_conjoint`, `mt_apport_perso`, `mt_autre`, `situation`) 
    VALUES 
    ('Ing Info ', '4000', '3200', '10000', '1000', 'Marie');

   INSERT INTO `Client`(`nom`, `prenom`, `dateNaissance`, `adresse`, `sexe`, `codePostale`, `id_pays`, `id_departement`, `id_pays_Naissance`, `id_info_perso`, `id_account`, `id_conseiller`, `id_domiciliation`) 
   SELECT 'Gregory', 'LHUILLIER', '1995-11-10', 'Rue de Rue', 'F', '92100', '75', '92', '75', MAX(id_info_perso), MAX(id_account), 1, 1 FROM Account, Info_Personnelle;


  






  INSERT INTO `Account`( `ndc`, `psw`, `questionSecrete`, `reponseSecrete`, `role`) 
    VALUES
    ('Zouhair2', '12345', 'je m\'appelle comment ? Zouhair', 'Zouhair', 'Cons');

  INSERT INTO `Info_Personnelle`(`profession`, `mt_Revenus_mensuels`, `mt_Revenus_conjoint`, `mt_apport_perso`, `mt_autre`, `situation`) 
    VALUES 
    ('Ing Info ', '4000', '3200', '10000', '1000', 'Marie');

  INSERT INTO `employe`(`nom`, `prenom`, `dateNaissance`, `adresse`, `sexe`, `codePostale`, `matricule`, `id_pays`, `id_departement`, `id_pays_Naissance`, `id_info_perso`, `id_account`, `id_agence`) 
    SELECT 'Zouhair', "HAJJI", "1994-10-09", 'Ton Adresse', 'M', '92100', '1JK3BN334', '75', '92', '75', MAX(id_info_perso), MAX(id_account), 2 FROM Account, Info_Personnelle;






    # Simulation Pret id 1 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('0.12', '1.02', '0.21', '1' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '24', '11000', '_fixe_', '2017-01-04', max(id_client), '1', max(id_calcPret)  from    calcPret, Client;




    # Simulation Pret id 2 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('0.12', '3.4', '1.02', '2' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '12', '708000', '_fixe_', '2018-01-01', max(id_client), '2', max(id_calcPret)  from    calcPret, Client;

  
  # Simulation Pret id 2 pour le client 1
    INSERT INTO `calcPret`( `coef_assurance`, `t_marge`, `f_dossier`, `id_tauxDirecteur`) 
    VALUES 
    ('0.12', '1.92', '0.05', '3' );
    INSERT INTO `Simul_Pret` 
    (`duree_pret`, `mt_pret`, `typeTaux`, `date_contraction`, `id_client`, `id_type_pret`, `id_calcPret`) 
    SELECT '6', '8219232', '_fixe_', '2017-05-21', max(id_client), '2', max(id_calcPret)  from    calcPret, Client;






-- Taux Fixe
SELECT *  FROM matriceTauxFixe 
WHERE 
       ('25' BETWEEN ageMin and ageMax) 
       AND ('3031' BETWEEN revenuMin AND revenuMax) 
       AND (typeContrat = 'cdd')
       AND idTypePret = 0
       AND isClient = true;



   SELECT * FROM Client c, Info_Personnelle i, Account a where i.id_info_perso = c.id_info_perso and c.id_account = a.id_account; 

   SELECT * FROM Simul_Pret sp, calcPret cp, Taux_Directeur td  WHERE cp.id_calcPret = sp.id_calcPret and cp.id_tauxDirecteur = td.id_tauxDirecteur AND sp.id_client=1


  -- Pour un employe 
   SELECT * FROM employe e
   LEFT JOIN Pays  p ON (e.id_pays = p.id_pays)
   LEFT JOIN Info_Personnelle i on (i.id_info_perso = e.id_info_perso)
   LEFT JOIN Account a ON (a.id_account = e.id_account)
   LEFT JOIN Departement d ON (d.id_departement = e.id_departement)
   LEFT JOIN Pays pn ON (e.id_pays_Naissance = pn.id_pays)
   LEFT JOIN Region r ON (r.id_region = d.id_region)
   WHERE e.id_account = 2




  Delete FROM `Info_Personnelle` ;
  Delete FROM `Account` ;
  Delete FROM `Client` ;


  Delete FROM `Info_Personnelle` where  id_info_perso = (SELECT id_info_perso FROM Client where id_client=3 );
  Delete FROM `Account` where  id_account = (SELECT id_account FROM Client where id_client=3 );
  Delete FROM `Client` where  id_client =  3













SELECT * FROM Taux_Directeur WHERE id_tauxDirecteur = (SELECT MAX(id_tauxDirecteur) FROM Taux_Directeur t)
SELECT * FROM Client c, Simul_Pret sp , calcPret cp , Taux_Directeur td, Type_Pret tp where sp.id_client = c.id_client AND cp.id_calcPret = sp.id_calcPret AND cp.id_tauxDirecteur = td.id_tauxDirecteur and tp.id_type_pret = sp.id_type_pret


<rootElement>
<id_employe>1</id_employe>
<nom>Zouhair</nom>
<prenom>HAJJI</prenom>
<dateNaissance>1994-10-09 00:00:00.0</dateNaissance>
<adresse>Ton Adresse</adresse>
<sexe>M</sexe>
<codePostale>92100</codePostale>
<matricule>1JK3BN334</matricule>
<id_pays>75</id_pays>
<id_departement>92</id_departement>
<id_pays_Naissance>75</id_pays_Naissance>
<id_info_perso>2</id_info_perso>
<id_account>2</id_account>
<id_account>2</id_account>
<id_agence>2</id_agence>
<id_pays>75</id_pays>
<id_pays>75</id_pays>
<code>250</code>
<alpha2>FR</alpha2>
<alpha3>FRA</alpha3>
<nom_en_gb>France</nom_en_gb>
<nom_fr_fr>France</nom_fr_fr>
<id_info_perso>2</id_info_perso>
<profession>Ing Info </profession>
<mt_Revenus_mensuels>4000</mt_Revenus_mensuels>
<mt_Revenus_conjoint>3200</mt_Revenus_conjoint>
<mt_apport_perso>10000</mt_apport_perso>
<mt_autre>1000</mt_autre>
<situation>Marie</situation><
lastUpdate>2016-04-18 13:34:13.0</lastUpdate>
<id_account>2</id_account>
<ndc>Zouhair2</ndc>
<psw>12345</psw>
<questionSecrete>je m appelle comment</questionSecrete>
<reponseSecrete>Zouhair</reponseSecrete>
<role>Cons</role>
<dateCreation>2016-04-18 13:34:13.0</dateCreation>
<id_departement>92</id_departement>
<departement>Hauts-de-Seine</departement>
<id_region>12</id_region>
<id_pays>75</id_pays>
<code>250</code>
<alpha2>FR</alpha2>
<alpha3>FRA</alpha3>
<nom_en_gb>France</nom_en_gb>
<nom_fr_fr>France</nom_fr_fr>
<id_region>12</id_region>
<region>Île-de-France</region>
</rootElement>


