-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

--db : platforms
-- password : ceggaway

docker container run \
--name mysql \
-p 3306:3306 \
-v /workspaces/$RepositoryName:/mdocker ps -ant \
-e MYSQL_ROOT_PASSWORD=ceggaway \
-d mysql

CREATE TABLE tempdata (
    `index` INT,
    Random INT,
    course_id VARCHAR(255),
    userid_DI VARCHAR(255),
    registered INT,
    viewed INT,
    explored INT,
    certified INT,
    final_cc_cname_DI VARCHAR(100),
    LoE_DI VARCHAR(100),
    YoB INT,
    gender VARCHAR(10),
    grade VARCHAR(10),
    start_time_DI DATE,
    last_event_DI DATE,
    nevents INT,
    ndays_act INT,
    nplay_video INT,
    nchapters INT,
    nforum_posts INT,
    roles VARCHAR(50),
    incomplete_flag BOOLEAN
);


create table user (
    user_id INT Unsigned AUTO_INCREMENT primary key,
    country varchar (255), --final_cc_cname_DI
    username varchar (255)-- user id DI
);

create table courses(
    course_id INT Unsigned AUTO_INCREMENT primary key,
    title varchar(255) --course id
);

create table engagement (
    user_id int unsigned,
    course_id int unsigned,
    num_event float,
    num_days float,
    num_video float,
    num_chap float,
    num_post float,
    primary key (user_id,course_id),
    foreign key (user_id) references user (user_id),
    foreign key (course_id) references courses (course_id)
);

create table enrollment (
    user_id int unsigned ,
    course_id int unsigned ,
    start_day date,
    last_login date,
    registered boolean,
    viewed boolean,
    explored boolean,
    certified boolean,
    dropout float,
    grade float,
    primary key (user_id,course_id),
    foreign key (user_id) references user (user_id),
    foreign key (course_id) references courses (course_id)
);

CREATE TABLE dropout_flags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED,
    course_id INT UNSIGNED,
    flagged_on DATE,
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);




insert into user (username, country)
select distinct userid_DI, final_cc_cname_DI
from tempdata
where userid_DI is not null and final_cc_cname_DI is not null ;




insert into courses (title)
select distinct course_id
from tempdata
where course_id is not null;




INSERT INTO engagement (
    user_id, course_id, num_event, num_days, num_video, num_chap, num_post
)
SELECT
    u.user_id,
    c.course_id,
    t.nevents,
    t.ndays_act,
    t.nplay_video,
    t.nchapters,
    t.nforum_posts
FROM tempdata AS t
JOIN user AS u ON t.userid_DI = u.username
JOIN courses AS c ON t.course_id = c.title;



INSERT IGNORE INTO enrollment (
    user_id, course_id, start_day, last_login,
    registered, viewed, explored, certified, dropout, grade
)
SELECT
    u.user_id,
    c.course_id,
    t.start_time_DI,
    t.last_event_DI,
    t.registered,
    t.viewed,
    t.explored,
    t.certified,
    t.incomplete_flag,
    NULLIF(t.grade, '')
FROM tempdata AS t
JOIN user AS u ON t.userid_DI = u.username
JOIN courses AS c ON t.course_id = c.title;















