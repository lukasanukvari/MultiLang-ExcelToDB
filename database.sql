create schema if not exists `lang_support_db` default character set utf8mb4;

-- Create table of the languages that are available:
create table if not exists `lang_support_db`.`languages_lst`(
`language_id` int not null auto_increment,
`language_desc_en` varchar(32) not null,
`language_abbr` varchar(8) not null,
primary key (`language_id`),
index `languages_lst_language_desc_en`(`language_desc_en` asc),
index `languages_lst_language_abbr`(`language_abbr` asc))
default charset = utf8mb4;

-- Create table of the elements (With unique field 'element_desc_en'):
create table if not exists `lang_support_db`.`elements_lst`(
`element_id` int not null auto_increment,
`element_desc_en` varchar(640) not null,
primary key (`element_id`),
index `elements_lst_element_desc_en`(`element_desc_en` asc),
unique index `elements_lst_element_desc_en_u`(`element_desc_en` asc))
default charset = utf8mb4;

-- Create a linking table for elements and their translations:
create table if not exists `lang_support_db`.`translations_lnk`(
`translation_id` int not null auto_increment,
`element_id` int not null,
`language_id` int not null,
`translation_desc` varchar(640) not null,
primary key (`translation_id`),
index `translations_lnk_element_id`(`element_id` asc),
index `translations_lnk_language_id`(`language_id` asc),
index `translations_lnk_combine`(`element_id` asc, `language_id` asc),
unique index `translations_lnk_combine_u`(`element_id` asc, `language_id` asc),
index `translations_lnk_translation_desc`(`translation_desc` asc))
default charset = utf8mb4;

-- Create needed stored procedures:
delimiter $$
use `lang_support_db`$$
drop procedure if exists `lang_support_db`.`ins_into_elements`$$
use `lang_support_db`$$
create procedure `lang_support_db`.`ins_into_elements`
(in in_element_desc_en varchar(640),
 out out_element_id int)
begin
    insert into lang_support_db.elements_lst(element_desc_en)
                                      values(in_element_desc_en);
	commit;

    select max(element_id)
      into out_element_id
      from lang_support_db.elements_lst
     limit 1;
end;
$$
delimiter ;

delimiter $$
use `lang_support_db`$$
drop procedure if exists `lang_support_db`.`ins_into_translations`$$
use `lang_support_db`$$
create procedure `lang_support_db`.`ins_into_translations`
(in in_element_id int,
 in in_language_id int,
 in in_translation_desc varchar(640))
begin
    insert into lang_support_db.translations_lnk(element_id,
                                                 language_id,
                                                 translation_desc)
                                          values(in_element_id,
                                                 in_language_id,
                                                 in_translation_desc);
	commit;
end;
$$
delimiter ;

-- Insert available languages:
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Arabic', 'ar');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Chinese (Simplified)', 'zh-cn');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('French', 'fr');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Georgian', 'ka');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('German', 'de');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Italian', 'it');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Japanese', 'ja');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Russian', 'ru');
insert into lang_support_db.languages_lst(language_desc_en,
                                          language_abbr)
								   values('Spanish', 'es');