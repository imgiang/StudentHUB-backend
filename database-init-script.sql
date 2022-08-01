--NOTE: The changes I made are just in my local database
DROP DATABASE IF EXISTS `student_hub`;
CREATE DATABASE `student_hub`;
use `student_hub`;

SET @anonymous = 'anonymous';

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
	`uid` varchar(255) NOT NULL,
	`reputation` int NOT NULL DEFAULT 0,
	`description` TEXT,
	`joiningDate` DATE NOT NULL DEFAULT (CURRENT_DATE),
	`displayName` VARCHAR(255) NOT NULL ,
	`photoURL` TEXT,
	`phoneNumber` varchar(20),
	`email` varchar(255) NOT NULL UNIQUE,
	FULLTEXT (`displayName`, `email`),
	PRIMARY KEY (`uid`)
);

INSERT INTO `User` (`uid`, `description`, `displayName`, `email`) VALUES (@anonymous, 'This is an anonymous user created by this application', 'Anonymous', 'anonymous@student-hub.com');

DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question` (
	`id` int NOT NULL AUTO_INCREMENT,
	`userId` varchar(255) NOT NULL,
	`title` VARCHAR(255) NOT NULL,
	`content` TEXT NOT NULL,
	`score` int NOT NULL DEFAULT 0,
	`deleted` BOOLEAN NOT NULL DEFAULT FALSE, -- FALSE for not deleted, TRUE for soft deleted
	`createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`facebookId` VARCHAR(31) UNIQUE,
	FULLTEXT (`title`, `content`),
	PRIMARY KEY(`id`)
);
DROP TABLE IF EXISTS `Answer`;

CREATE TABLE `Answer` (
	`id` int NOT NULL AUTO_INCREMENT,
	`questionId` int NOT NULL,
	`userId` varchar(255) NOT NULL,
	`content` TEXT NOT NULL,
	`score` int NOT NULL DEFAULT 0,
	`deleted` BOOLEAN NOT NULL DEFAULT FALSE, -- FALSE for not deleted, TRUE for soft deleted 
	`verify` BOOLEAN NOT NULL DEFAULT FALSE,
	`createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`facebookId` VARCHAR(31) UNIQUE,
	PRIMARY KEY (`id`)
);
DROP TABLE IF EXISTS `QuestionVoter`;
CREATE TABLE `QuestionVoter` (
	`id` int NOT NULL AUTO_INCREMENT,
	`questionId` int NOT NULL,
	`userId` varchar(255) NOT NULL,
	`state` int NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY `questionId_userID` (`questionId`, `userId`)
);
DROP TABLE IF EXISTS `AnswerVoter`;
CREATE TABLE `AnswerVoter` (
	`id` int NOT NULL AUTO_INCREMENT,
	`userId` varchar(255) NOT NULL,
	`answerId` int NOT NULL,
	`state` int NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY `answerId_userId` (`answerId`, `userId`)
);
DROP TABLE IF EXISTS `Tag`;
CREATE TABLE `Tag` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY(`id`)
);
DROP TABLE IF EXISTS `QuestionComment`;
CREATE TABLE `QuestionComment` (
	`id` int NOT NULL AUTO_INCREMENT,
	`questionId` int NOT NULL,
	`userId` varchar(255) NOT NULL,
	`content` TEXT NOT NULL,
	`createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	`facebookId` VARCHAR(31) UNIQUE,
	PRIMARY KEY (`id`)
);
DROP TABLE IF EXISTS `AnswerComment`;
CREATE TABLE `AnswerComment` (
	`id` int NOT NULL AUTO_INCREMENT,
	`answerId` int NOT NULL,
	`userId` varchar(255) NOT NULL,
	`content` TEXT NOT NULL,
	`createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	`facebookId` VARCHAR(31) UNIQUE,
	PRIMARY KEY (`id`)
);
DROP TABLE IF EXISTS `TagsOnQuestions`;
CREATE TABLE `TagsOnQuestions` (
	`questionId` int NOT NULL,
	`tagId` int NOT NULL,
	PRIMARY KEY (`questionId`,`tagId`)
);
DROP TABLE IF EXISTS `TagsOnUsers`;
CREATE TABLE `TagsOnUsers` (
	`tagId` int NOT NULL,
	`userId` varchar(255) NOT NULL,
	PRIMARY KEY (`tagId`,`userId`)
);
DROP TABLE IF EXISTS `Document`;
CREATE TABLE `Document` (
	`id` int NOT NULL AUTO_INCREMENT,
	`title` TEXT NOT NULL,
	`url` TEXT NOT NULL,
	PRIMARY KEY (`id`)
);

--- Set to anonymous
ALTER TABLE `Question` ADD CONSTRAINT `Question_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`);

ALTER TABLE `Answer` ADD CONSTRAINT `Answer_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`);

ALTER TABLE `QuestionComment` ADD CONSTRAINT `QuestionComment_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ;

ALTER TABLE `AnswerComment` ADD CONSTRAINT `AnswerComment_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`);
--- end set to anonymous

--- delete Interested tag and revoke votes
ALTER TABLE `TagsOnUsers` ADD CONSTRAINT `TagsOnUsers_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE;

ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE;

ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE;
--- end delete Interested tag and revoke votes

--- question will be hiden so they don't matter
ALTER TABLE `Answer` ADD CONSTRAINT `Answer_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE;

ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE;

ALTER TABLE `TagsOnQuestions` ADD CONSTRAINT `TagsOnQuestions_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE;

ALTER TABLE `QuestionComment` ADD CONSTRAINT `QuestionComment_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE;
--- end question will be hiden so they don't matter

--- answer will be hiden so they don't matter
ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk1` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE CASCADE;

            
ALTER TABLE `AnswerComment` ADD CONSTRAINT `AnswerComment_fk0` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE CASCADE;
--- end answer will be hiden so they don't matter

ALTER TABLE `TagsOnQuestions` ADD CONSTRAINT `TagsOnQuestions_fk1` FOREIGN KEY (`tagId`) REFERENCES `Tag`(`id`);

ALTER TABLE `TagsOnUsers` ADD CONSTRAINT `TagsOnUsers_fk0` FOREIGN KEY (`tagId`) REFERENCES `Tag`(`id`); 


SELECT Concat('DROP TRIGGER IF EXISTS ', Trigger_Name, ';') FROM  information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'student_hub';

DROP TRIGGER IF EXISTS update_qs_score_and_reputation_after_insert_qs_voter;
drop TRIGGER IF EXISTS update_reputation_after_verify_answer;

DROP TRIGGER IF EXISTS update_qs_score_and_reputation_after_update_qs_voter;

DROP TRIGGER IF EXISTS update_qs_score_and_reputation_after_delete_qs_voter;

DROP TRIGGER IF EXISTS update_ans_score_and_reputation_after_insert_ans_voter;

DROP TRIGGER IF EXISTS update_ans_score_and_reputation_after_update_ans_voter;

DROP TRIGGER IF EXISTS update_ans_score_and_reputation_after_delete_ans_voter;

DROP TRIGGER IF EXISTS update_qs_ans_qs_comment_ans_commment_after_delete_user;

               
---- TRIGGER ON `QuestionVoter`
CREATE TRIGGER `update_qs_score_and_reputation_after_insert_qs_voter` AFTER INSERT ON `QuestionVoter`
FOR EACH ROW 
BEGIN
	UPDATE `Question` 
	SET `score` = (SELECT SUM(`state`) FROM `QuestionVoter` WHERE `questionId` = NEW.`questionId`) WHERE `id` = NEW.`questionId`;

	IF NEW.`state` = 1 THEN 
		UPDATE `User` SET `reputation` = `reputation` + 10 WHERE `uid` = (
			SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
		);
	ELSEIF NEW.`state` = -1 THEN
		UPDATE `User` SET `reputation` = `reputation` - 2 WHERE `uid` = (
			SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
		);
	END IF;	
END;

CREATE TRIGGER `update_qs_score_and_reputation_after_update_qs_voter` AFTER UPDATE ON `QuestionVoter`
FOR EACH ROW 
BEGIN
	UPDATE `Question` SET `score` = (
		SELECT SUM(`state`) FROM `QuestionVoter` WHERE `questionId` = NEW.`questionId`) WHERE `id` = NEW.`questionId`; 

	IF NEW.`state` = 1 AND OLD.state != 1 THEN 
		BEGIN
			IF OLD.`state` = 0 THEN
				UPDATE `User` SET `reputation` = `reputation` + 10 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			ELSEIF OLD.`state` = -1 THEN
				UPDATE `User` SET `reputation` = `reputation` + 2 + 10 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			END IF;
		END;
	ELSEIF NEW.`state` = 0 AND OLD.state != 0 THEN
		BEGIN
			IF OLD.`state` = 1 THEN
				UPDATE `User` SET `reputation` = `reputation` - 10 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			ELSEIF OLD.`state` = -1 THEN
				UPDATE `User` SET `reputation` = `reputation` + 2 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			END IF;
		END;
	ELSEIF NEW.`state` = -1 AND OLD.state != -1 THEN
		BEGIN
			IF OLD.`state` = 0 THEN
				UPDATE `User` SET `reputation` = `reputation` -2 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			ELSEIF OLD.`state` = 1 THEN
				UPDATE `User` SET `reputation` = `reputation` -10 -2 WHERE `uid` = (
					SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
				);
			END IF;
		END;
	END IF;	
END;

--- ONLY HAPPEN WHEN DROP A USER (REVOKE VOTE)
CREATE TRIGGER `update_qs_score_and_reputation_after_delete_qs_voter` AFTER DELETE ON `QuestionVoter`
FOR EACH ROW 
BEGIN
	UPDATE `Question` SET `score` = (
		SELECT SUM(`score`) FROM `QuestionVoter` WHERE `questionId` = OLD.`questionId`
		) WHERE `id` = OLD.`questionId`;

	IF OLD.`state` = 1 THEN 
		UPDATE `User` SET `reputation` = `reputation` - 10 WHERE `uid` = (
			SELECT `userId` FROM `Question` WHERE `id` = OLD.`questionId`
		);
	ELSEIF OLD.`state` = -1 THEN
		UPDATE `User` SET `reputation` = `reputation` + 2 WHERE `uid` = (
			SELECT `userId` FROM `Question` WHERE `id` = OLD.`questionId`
		);
	END IF;	
END;
--- END ONLY HAPPEN WHEN DROP A USER (REVOKE VOTE)

---- END TRIGGER ON `QuestionVoter`

---- TRIGGER ON `AnswerVoter`
CREATE TRIGGER  `update_ans_score_and_reputation_after_insert_ans_voter` AFTER INSERT ON `AnswerVoter`
FOR EACH ROW
BEGIN 
	UPDATE `Answer` SET `score` = (
		SELECT SUM(`state`) FROM `AnswerVoter` WHERE `answerId` = NEW.`answerId`
		) WHERE `id` = NEW.`answerId`;
	
	IF NEW.`state` = 1 THEN 
		UPDATE `User` SET `reputation` = `reputation` + 10 WHERE `uid` = (
			SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
		);
	ELSEIF NEW.`state` = -1 THEN
		BEGIN
			UPDATE User SET reputation = reputation - 1 WHERE uid = NEW.userId;
			UPDATE `User` SET `reputation` = `reputation` - 2 WHERE `uid` = (
				SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
			);
		END;
	END IF;	
END;

CREATE TRIGGER  `update_ans_score_and_reputation_after_update_ans_voter` AFTER UPDATE ON `AnswerVoter`
FOR EACH ROW
BEGIN 
	UPDATE `Answer` SET `score` = (
		SELECT SUM(`state`) FROM `AnswerVoter` WHERE `answerId` = NEW.`answerId`) WHERE `id` = NEW.`answerId`;

	IF NEW.`state` = 1 AND OLD.state != 1 THEN 
		BEGIN
			IF OLD.`state` = -1 THEN
				BEGIN
					UPDATE User SET reputation = reputation + 1 WHERE uid = NEW.userId;
					
					UPDATE `User` SET `reputation` = `reputation` + 2 + 10 WHERE `uid` = (
						SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
					);
				END;
			ELSEIF OLD.`state` = 0 THEN
				UPDATE `User` SET `reputation` = `reputation` + 10 WHERE `uid` = (
					SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
				);
			END IF;
		END;
	ELSEIF NEW.`state` = 0 AND OLD.state != 0 THEN
		BEGIN
			IF OLD.`state` = -1 THEN
				BEGIN
					UPDATE User SET reputation = reputation + 1 WHERE uid = NEW.userId;

					UPDATE `User` SET `reputation` = `reputation` + 2 WHERE `uid` = (
						SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
					);
				END;
			ELSEIF OLD.`state` = 1 THEN
				UPDATE `User` SET `reputation` = `reputation` - 10 WHERE `uid` = (
					SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
				);
			END IF;
		END;
	ELSEIF NEW.`state` = -1 AND OLD.state != -1 THEN
		BEGIN
			IF OLD.`state` = 0 THEN
				UPDATE `User` SET `reputation` = `reputation` - 2 WHERE `uid` = (
					SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
				);
			ELSEIF OLD.`state` = 1 THEN
				UPDATE `User` SET `reputation` = `reputation` - 10 - 2 WHERE `uid` = (
					SELECT `userId` FROM `Answer` WHERE `id` = NEW.`answerId`
				);
			END IF;
		END;

		UPDATE User SET reputation = reputation -1 WHERE uid = NEW.userId;
	END IF;	
END;

--- ONLY HAPPEN WHEN DROP A USER (REVOKE VOTE)
CREATE TRIGGER  `update_ans_score_and_reputation_after_delete_ans_voter` AFTER DELETE ON `AnswerVoter`
FOR EACH ROW
BEGIN 
	UPDATE `Answer` SET `score` = (
		SELECT SUM(`state`) FROM `AnswerVoter` WHERE `answerId` = OLD.`answerId`) WHERE `id` = OLD.`answerId`;

	IF OLD.`state` = 1 THEN 
		UPDATE `User` SET `reputation` = `reputation` - 10 WHERE `uid` = (
			SELECT `userId` FROM `Answer` WHERE `id` = OLD.`answerId`
		);
	ELSEIF OLD.`state` = -1 THEN
		BEGIN
			UPDATE User SET reputation = reputation + 1 WHERE uid = OLD.userId;
			UPDATE `User` SET `reputation` = `reputation` + 2 WHERE `uid` = (
				SELECT `userId` FROM `Answer` WHERE `id` = OLD.`answerId`
			);
		END;
	END IF;	
END;
--- END ONLY HAPPEN WHEN DROP A USER (REVOKE VOTE)

---- END TRIGGER ON `AnswerVoter`

---- TRIGGER ON `Answer`

CREATE TRIGGER `update_reputation_after_verify_answer` AFTER UPDATE ON `Answer`
FOR EACH ROW
BEGIN
	IF NEW.`verify` = TRUE AND OLD.verify = FALSE THEN
		BEGIN
			UPDATE `User` SET `reputation` = `reputation` + 15 WHERE `uid` = NEW.`userId`;
			UPDATE `User` SET `reputation` = `reputation` + 2 WHERE `uid` = (
				SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
			);
		END;
	ELSEIF NEW.`verify` = FALSE AND OLD.verify = TRUE THEN
		BEGIN
			UPDATE `User` SET `reputation` = `reputation` - 15 WHERE `uid` = NEW.`userId`;
			UPDATE `User` SET `reputation` = `reputation` - 2 WHERE `uid` = (
				SELECT `userId` FROM `Question` WHERE `id` = NEW.`questionId`
			);
		END;
	END IF;
END;  
---- END TRIGGER ON `Answer`

--- TRIGGER ON `User`
CREATE TRIGGER `update_qs_ans_qs_comment_ans_commment_after_delete_user` AFTER DELETE ON `User`
FOR EACH ROW
BEGIN
	UPDATE `Question` SET `userId` = @anonymous WHERE `userId` = OLD.`uid`;
	UPDATE `Answer` SET `userId` = @anonymous WHERE `userId` = OLD.`uid`;
	UPDATE `QuestionComment` SET `userId` = @anonymous WHERE `userId` = OLD.`uid`;
	UPDATE `AnswerComment` SET `userId` = @anonymous WHERE `userId` = OLD.`uid`;
END;
--- END TRIGGER ON `User`